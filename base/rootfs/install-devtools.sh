#!/bin/bash

if [[ "$JITSI_RELEASE" == "unstable" ]]; then
	apt-dpkg-wrap apt-get update;
	apt-dpkg-wrap apt-get install -y jq procps curl vim iputils-ping net-tools;
	apt-cleanup;
fi

# File should delete itself
rm -- "$0"
