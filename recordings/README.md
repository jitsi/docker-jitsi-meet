# Jibri recording library

This optional, read-only page lists completed Jibri MP4 recordings and provides
playback and download links. It requires the Jibri service and its default
recording storage location.

## Start it

```bash
docker compose -f docker-compose.yml -f jibri.yml -f recordings.yml up -d --build
```

The page listens only on `127.0.0.1:${RECORDINGS_PORT:-8090}`. Put it behind an
authenticated reverse proxy before making it available to users: recordings can
contain private meeting content. Do not expose the port directly to the Internet.

For a deployment where the Jitsi web service is already reverse-proxied, route a
separate protected hostname or a protected `/recordings/` path to
`http://127.0.0.1:${RECORDINGS_PORT:-8090}`. The sidecar dynamically discovers
MP4 files in `${CONFIG}/storage/jibri/recordings` and never writes to that
directory.
