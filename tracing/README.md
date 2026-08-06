# Tracing

This directory contains all required files to enable tracing to Jitsi.

## Usage

Set the following environment variable:
```env
ENABLE_TRACING=1
```

Start the docker compose:
```sh
docker compose -f docker-compose.yml -f tracing.yml up
```
