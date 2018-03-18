# jitsi/base

This is a base Debian image with the [S6 Overlay](https://github.com/just-containers/s6-overlay). The
image is used as the base for all the containers composing a Jitsi Meet installation.

## Usage

```
docker run -it --rm \
    -e TZ=Europe/Amsterdam \
    jitsi/base \
    /bin/bash
```

### Parameters

These can be set using environment variables:

* ``TZ``: system time zone.

