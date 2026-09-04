#!/bin/bash

set -o pipefail -xeu

dpkgArch="$(dpkg --print-architecture)"

case "${dpkgArch##*-}" in
    "amd64")
        CHROMEDRIVER_ARCH=linux64
        ;;
    "arm64")
        CHROMEDRIVER_ARCH=linux-arm64
        ;;
    *)
        echo "unsupported architecture"
        exit 1
        ;;
esac

if [ "${USE_CHROMIUM}" = 1 ]; then
    echo "Using Debian's Chromium"
    apt-dpkg-wrap apt-get install -y chromium chromium-driver chromium-sandbox
    chromium --version
else
    CHROME_BASE_URL="https://dl.google.com/linux/chrome/deb/pool/main/g"
    CHROME_DEB="/tmp/google-chrome.deb"
    if [ "${USE_CHROME_CANARY}" = 1 ]; then
        CHROME_PKG="google-chrome-canary"
    else
        CHROME_PKG="google-chrome-stable"
    fi
    curl -4so ${CHROME_DEB} "${CHROME_BASE_URL}/${CHROME_PKG}/${CHROME_PKG}_${CHROME_RELEASE}-1_${dpkgArch}.deb"
    apt-dpkg-wrap apt-get install -y ${CHROME_DEB}
    rm -f ${CHROME_DEB}

    google-chrome --version

    BASE_URL=https://googlechromelabs.github.io/chrome-for-testing

    CHROMEDRIVER_MAJOR_RELEASE=$(echo $CHROME_RELEASE | cut -d. -f1)
    CHROMEDRIVER_RELEASE="$(curl -4Ls ${BASE_URL}/LATEST_RELEASE_${CHROMEDRIVER_MAJOR_RELEASE})"

    CHROMEDRIVER_ZIP="/tmp/chromedriver.zip"
    curl -4Lso ${CHROMEDRIVER_ZIP} "https://storage.googleapis.com/chrome-for-testing-public/${CHROMEDRIVER_RELEASE}/${CHROMEDRIVER_ARCH}/chromedriver-${CHROMEDRIVER_ARCH}.zip"
    unzip ${CHROMEDRIVER_ZIP} -d /tmp/
    mv /tmp/chromedriver-${CHROMEDRIVER_ARCH}/chromedriver /usr/bin/
    chmod +x /usr/bin/chromedriver
    rm -rf /tmp/chromedriver*
fi

chromedriver --version

