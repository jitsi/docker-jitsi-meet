const root = document.querySelector('#recordings');
const status = document.querySelector('#status');
const template = document.querySelector('#recording-template');

function prettyName(filename) {
  return decodeURIComponent(filename).replace(/\.mp4$/i, '').replace(/[_-]/g, ' ');
}

function bytes(value) {
  if (!Number.isFinite(value) || value <= 0) return 'MP4 recording';
  const units = ['B', 'KB', 'MB', 'GB'];
  const index = Math.min(Math.floor(Math.log(value) / Math.log(1024)), units.length - 1);
  return `${(value / 1024 ** index).toFixed(index ? 1 : 0)} ${units[index]}`;
}

function date(value) {
  const parsed = new Date(value);
  return Number.isNaN(parsed.getTime())
    ? 'Completed recording'
    : parsed.toLocaleString(undefined, { dateStyle: 'medium', timeStyle: 'short' });
}

async function metadata(url) {
  try {
    const response = await fetch(url, { method: 'HEAD' });
    return { size: Number(response.headers.get('content-length')), modified: response.headers.get('last-modified') };
  } catch {
    return { size: NaN, modified: '' };
  }
}

async function recordingFiles(url) {
  const response = await fetch(url, { cache: 'no-store' });
  if (!response.ok) return [];
  const page = new DOMParser().parseFromString(await response.text(), 'text/html');
  return [...page.querySelectorAll('a[href$=".mp4"], a[href$=".MP4"]')]
    .map((link) => new URL(link.getAttribute('href'), url));
}

async function load() {
  root.replaceChildren();
  status.textContent = 'Loading recordings…';
  try {
    const mediaRoot = new URL('./media/', location.href);
    const response = await fetch(mediaRoot, { cache: 'no-store' });
    if (!response.ok) throw new Error(`Recording index returned ${response.status}`);
    const page = new DOMParser().parseFromString(await response.text(), 'text/html');
    const links = [...page.querySelectorAll('a[href]')].map((link) => new URL(link.getAttribute('href'), mediaRoot));
    const directFiles = links.filter((url) => /\.mp4$/i.test(url.pathname));
    const folders = links.filter((url) => url.pathname.endsWith('/') && url.href !== mediaRoot.href && url.pathname.startsWith(mediaRoot.pathname));
    const nestedFiles = (await Promise.all(folders.map(recordingFiles))).flat();
    const urls = [...new Set([...directFiles, ...nestedFiles].map((url) => url.href))].sort().reverse();

    if (!urls.length) {
      root.innerHTML = '<p class="empty">No completed recordings are available yet.</p>';
      status.textContent = '0 recordings';
      return;
    }

    const recordings = await Promise.all(urls.map(async (url) => ({ url, ...(await metadata(url)) })));
    for (const recording of recordings) {
      const node = template.content.cloneNode(true);
      const filename = new URL(recording.url).pathname.split('/').pop();
      node.querySelector('.recording-name').textContent = prettyName(filename);
      node.querySelector('.recording-meta').textContent = `${date(recording.modified)} · ${bytes(recording.size)}`;
      node.querySelector('.play').href = recording.url;
      const download = node.querySelector('.download');
      download.href = recording.url;
      root.append(node);
    }
    status.textContent = `${recordings.length} recording${recordings.length === 1 ? '' : 's'}`;
  } catch (error) {
    root.innerHTML = '<p class="empty">The recording library could not be loaded. Refresh to try again.</p>';
    status.textContent = 'Unavailable';
    console.error(error);
  }
}

document.querySelector('#refresh').addEventListener('click', load);
load();
