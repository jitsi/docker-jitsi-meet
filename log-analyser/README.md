# Jitsi Meet Log Analyser – Grafana Loki and OpenTelemetry Integration

This optional observability stack collects Jitsi Meet container logs with the OpenTelemetry Collector, stores them in Grafana Loki, and makes them available through Grafana dashboards. The configuration is part of an in-progress GSoC project; interfaces and instructions may change.

## Overview

The stack consists of:

- `log-analyser.yml`: Loki and OpenTelemetry Collector services.
- `grafana.yml`: Grafana and its provisioned data sources and dashboards.
- `log-analyser/otel-collector-config.yaml`: Docker JSON log collection, OTLP ingestion, and OTLP/HTTP export to Loki.
- `docker-compose.override.yml.example`: optional Docker logging settings for the Jitsi services.

The Collector reads Docker `json-file` records for `web`, `prosody`, `jicofo`, and `jvb`. It uses the Docker `service` label to identify each component, preserves the original message body and Docker timestamp, and exports logs to Loki through OTLP/HTTP. Jitsi-specific text extraction for dashboards is performed in LogQL rather than by service-specific Collector regex parsers.

## Prerequisites

- Docker Engine and Docker Compose v2 (`docker compose`).
- A configured Jitsi Meet deployment, including its required environment variables and `.env` file.
- Access to the Docker daemon and its container log files on the host running the Collector.

The Collector configuration targets the Docker `json-file` logging driver. It is not a generic configuration for other Docker logging drivers.

## Setup

### 1. Obtain and configure Jitsi Meet

Follow the [Jitsi Meet Docker deployment guide](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/) to prepare the repository and environment before starting the stack.

### 2. Enable Docker service labels in log records

The Collector filters records using `attrs.service`. Docker's `json-file` driver includes the container's `service` label in each record only when the logging option `labels: "service"` is enabled.

The repository provides an example for the four Jitsi services:

```bash
cp docker-compose.override.yml.example docker-compose.override.yml
```

If `docker-compose.override.yml` already exists, merge the `logging` settings into it rather than overwriting your existing configuration. The relevant setting for each of `web`, `prosody`, `jicofo`, and `jvb` is:

```yaml
logging:
  driver: json-file
  options:
    labels: "service"
```

The main `docker-compose.yml` does not need to be edited. Logging options apply when containers are created; existing Jitsi containers must be recreated for the new settings to take effect. Existing log records will not gain labels retroactively.

### 3. Validate the effective Compose configuration

When selecting Compose files explicitly with `-f`, include the override explicitly as well. Docker Compose does not automatically append the default override file to an explicit file list.

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f log-analyser.yml \
  -f grafana.yml \
  config
```

Verify that each Jitsi service has its expected `service` container label (`jitsi-web`, `jitsi-prosody`, `jitsi-jicofo`, or `jitsi-jvb`) and `logging.options.labels: service`. Resolve missing environment variables before deploying.

### 4. Start the stack

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f log-analyser.yml \
  -f grafana.yml \
  up -d
```

This creates or recreates the services according to the selected Compose configuration. For existing deployments, review the output of `docker compose config` and the planned changes before applying them.

## How log collection works

The Collector's `filelog/jitsi-containers` receiver reads `/var/lib/docker/containers/*/*-json.log` and accepts only records with the expected Jitsi `attrs.service` values. The Docker timestamp is parsed using a Go time layout that supports nanosecond precision. The `service` value becomes the OTLP resource attribute `service.name`, which Loki exposes as `service_name` in LogQL.

The Collector exports logs using `otlphttp/loki` at `http://loki:3100/otlp` (the OTLP/HTTP logs endpoint resolves to `/otlp/v1/logs`). Loki must be configured to accept OTLP ingestion and structured metadata, as provided by the accompanying Loki configuration.

The Collector also exposes a `docker_stats` receiver configured with Docker API version `1.40` for compatibility with Docker Engine versions that reject older client API versions.

### File offsets and historical logs

The filelog receiver uses `start_at: end` for previously unseen log files. On first collection it therefore reads new log entries rather than importing all existing historical records. It stores file offsets using the `file_storage` extension at `/tmp/jitsi-logs/filelog-state`.

`log-analyser.yml` bind-mounts `./log-analyser/jitsi-logs/` at `/tmp/jitsi-logs/`, so offsets persist when the Collector container is recreated, provided that host directory is retained. Removing that directory discards the stored offsets and changes how subsequent collection starts.

### Docker access and security

The Collector runs as root in the supplied Compose configuration to read Docker container log files. It also mounts `/var/run/docker.sock` for the `docker_stats` receiver. Access to the Docker socket is security-sensitive and can provide control over the host Docker daemon; mounting the socket read-only does not make Docker API access read-only. Restrict access to the Collector and its host accordingly.

## Access Grafana

Open [http://localhost:3000](http://localhost:3000) on the Docker host, or use the appropriate hostname and published port for your deployment.

For a new Grafana instance, the default initial credentials may be `admin` / `admin`; change the administrator password immediately and follow your deployment's configured authentication settings. Existing Grafana installations may use different credentials.

The provisioned Loki data source and Jitsi dashboards should be available in Grafana. Use Explore to inspect the collected streams, for example:

```logql
{service_name=~"jitsi-(web|prosody|jicofo|jvb)"}
```

For a specific service:

```logql
{service_name="jitsi-jicofo"}
```

If no entries appear immediately, generate a new log event after the logging options have taken effect and check the Collector logs. Because `start_at: end` is enabled, absence of historical entries alone does not indicate a collection failure.

## Validation status and limitations

The following have been validated in an isolated test environment using OpenTelemetry Collector Contrib 0.130.0 and Loki 3.0.0:

- Docker API compatibility for the `docker_stats` receiver.
- Collector-to-Loki OTLP/HTTP log delivery.
- Docker JSON log ingestion with `labels: "service"` and service identification.
- Nanosecond-precision Docker timestamp parsing and preservation of log bodies.
- Loki severity detection on synthetic Jitsi-style error records.
- Jicofo source-location extraction and LogQL aggregation using a synthetic Jicofo-format error record.
- JSON validity and provisioned Loki data source UIDs for 21 migrated LogQL targets across five dashboards.

Full runtime validation of every dashboard panel against real logs from all four Jitsi components remains outstanding. The isolated integration tests do not constitute a complete production deployment test.

## Further information

See the [Jitsi Handbook](https://jitsi.github.io/handbook/docs/intro) for the broader self-hosting and deployment documentation.
