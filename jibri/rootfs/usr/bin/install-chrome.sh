#!/bin/bash

set -o pipefail -xeu

dpkgArch="$(dpkg --print-architecture)"

case "${dpkgArch##*-}" in
    "amd64")
        CFT_ARCH=linux64
        ;;
    "arm64")
        CFT_ARCH=linux-arm64
        ;;
    *)
        echo "unsupported architecture"
        exit 1
        ;;
esac

# Chrome and chromedriver both come from the same chrome-for-testing (CfT)
# build, which guarantees an exact chrome<->chromedriver match and keeps
# pinned versions addressable (unlike the .deb pool, which prunes old
# builds). CfT ships plain zips with no dependency metadata, so Chrome's
# runtime libraries are installed explicitly in the Dockerfile.
CFT_BASE_URL="https://storage.googleapis.com/chrome-for-testing-public/${CHROME_RELEASE}/${CFT_ARCH}"

CHROME_ZIP="/tmp/chrome.zip"
curl -4Lso ${CHROME_ZIP} "${CFT_BASE_URL}/chrome-${CFT_ARCH}.zip"
unzip ${CHROME_ZIP} -d /tmp/
mkdir -p /opt/chrome
mv /tmp/chrome-${CFT_ARCH}/* /opt/chrome/
ln -sf /opt/chrome/chrome /usr/bin/google-chrome
rm -rf ${CHROME_ZIP} /tmp/chrome-${CFT_ARCH}

google-chrome --version

CHROMEDRIVER_ZIP="/tmp/chromedriver.zip"
curl -4Lso ${CHROMEDRIVER_ZIP} "${CFT_BASE_URL}/chromedriver-${CFT_ARCH}.zip"
unzip ${CHROMEDRIVER_ZIP} -d /tmp/
mv /tmp/chromedriver-${CFT_ARCH}/chromedriver /usr/bin/
chmod +x /usr/bin/chromedriver
rm -rf ${CHROMEDRIVER_ZIP} /tmp/chromedriver-${CFT_ARCH}

chromedriver --version
