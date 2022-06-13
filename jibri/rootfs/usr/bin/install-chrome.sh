#!/bin/bash

set -o pipefail -xeu

if [ "${USE_CHROMIUM}" = 1 -o "${TARGETPLATFORM}" = "linux/arm64" ]; then
    echo "Using Debian's Chromium"
    apt-dpkg-wrap apt-get install -y chromium chromium-driver chromium-sandbox
    chromium --version
else
    if  [ "${CHROME_RELEASE}" = "latest" ]; then
        wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmour > /etc/apt/trusted.gpg.d/google.gpg
        echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
        apt-dpkg-wrap apt-get update
        apt-dpkg-wrap apt-get install -y google-chrome-stable
    else
        curl -4so "/tmp/google-chrome-stable_${CHROME_RELEASE}-1_amd64.deb" "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_RELEASE}-1_amd64.deb"
        apt-dpkg-wrap apt-get install -y "/tmp/google-chrome-stable_${CHROME_RELEASE}-1_amd64.deb"
    fi

    google-chrome --version

    if [ "${CHROMEDRIVER_MAJOR_RELEASE}" = "latest" ]; then
        CHROMEDRIVER_RELEASE="$(curl -4Ls https://chromedriver.storage.googleapis.com/LATEST_RELEASE)"
    else
        CHROMEDRIVER_RELEASE="$(curl -4Ls https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROMEDRIVER_MAJOR_RELEASE})"
    fi

    curl -4Ls "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_RELEASE}/chromedriver_linux64.zip"  | zcat >> /usr/bin/chromedriver
    chmod +x /usr/bin/chromedriver
fi

chromedriver --version
