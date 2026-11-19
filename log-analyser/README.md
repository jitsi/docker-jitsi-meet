# Jitsi Meet Log Analyser – Grafana Loki and OpenTelemetry Integration

This optional observability stack collects Jitsi Meet container logs with the OpenTelemetry Collector, stores them in Grafana Loki, and makes them available through Grafana dashboards. The configuration is part of an in-progress GSoC project; interfaces and instructions may change.

## Overview

The stack consists of:

- `log-analyser.yml`: Docker Compose services for Loki and the OpenTelemetry Collector, including volume mounts and restart policies.
- `log-analyser/loki/conf/loki-config.yaml`: Loki storage, TSDB schema, and OTLP-related configuration.
- `log-analyser/otel-collector-config.yaml`: Docker JSON log collection, OTLP ingestion, and OTLP/HTTP export to Loki.
- `grafana.yml`: Optional Grafana deployment with provisioned data sources and dashboards.
- `log-analyser/grafana-provisioning/datasources/datasource_loki.yml`: Loki data source provisioning for the bundled Grafana instance.
- `log-analyser/grafana-provisioning/dashboards/`: Dashboard provisioning and JSON definitions for bundled and external Grafana instances.
- `log-analyser/docker-compose.override.yml.example`: Optional Docker logging settings for the Jitsi services.

The Collector reads Docker `json-file` records for `web`, `prosody`, `jicofo`, and `jvb`. It uses the Docker `service` label to identify each component, preserves the original message body and Docker timestamp, and exports logs to Loki through OTLP/HTTP. Jitsi-specific text extraction for dashboards is performed in LogQL rather than by service-specific Collector regex parsers.

### Configuration loading and persistence

Docker Compose loads `log-analyser.yml` only when explicitly included with `-f`.

The Loki service mounts `./log-analyser/loki/conf` at `/conf` and starts Loki with `-config.file=/conf/loki-config.yaml`. The Collector mounts `./log-analyser/otel-collector-config.yaml` at `/etc/otelcol-contrib/config.yaml`.

Loki stores persistent data under `/data/loki`, backed by the host directory `./log-analyser/loki/data`. Collector file offsets are stored separately under `./log-analyser/jitsi-logs`.

Both Loki and the Collector use `restart: unless-stopped` to restart after unexpected termination or Docker daemon restarts, subject to Docker's restart-policy semantics.

## Prerequisites

- Docker Engine and Docker Compose v2 (`docker compose`).
- A configured Jitsi Meet deployment, including its required environment variables and `.env` file.
- Access to Docker container log files and the Docker daemon on the host running the Collector.
- An existing Grafana instance, or the optional bundled Grafana deployment.

The Collector configuration targets the Docker `json-file` logging driver. It is not a generic configuration for other Docker logging drivers.

## Setup

### 1. Obtain and configure Jitsi Meet

Follow the [Jitsi Meet Docker deployment guide](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/) to prepare the repository and environment before starting the stack.

### 2. Enable Docker service labels in log records

The Collector filters records using `attrs.service`. Docker's `json-file` driver includes the container's `service` label in each record only when the logging option `labels: "service"` is enabled.

If no `docker-compose.override.yml` exists, the repository provides an example for the four Jitsi services:

```bash
cp -n log-analyser/docker-compose.override.yml.example \
  docker-compose.override.yml
```

**Do not overwrite an existing override file.** The `cp -n` command skips an existing destination; verify the result and merge the following settings into each of `web`, `prosody`, `jicofo`, and `jvb` instead:

```yaml
logging:
  driver: json-file
  options:
    labels: "service"
```

The main `docker-compose.yml` does not need to be edited. Logging options take effect when containers are created; existing Jitsi containers must be recreated for the new settings to apply. Existing log records do not gain labels retroactively.

### 3. Prepare Loki storage permissions

Loki stores its data persistently in `./log-analyser/loki/data`, which is bind-mounted to `/data` inside the container.

For the supplied `grafana/loki:3.0.0` image, prepare the directory with UID/GID `10001:10001` and permissions `0750`:

```bash
sudo install -d -o 10001 -g 10001 -m 0750 log-analyser/loki/data
```

For an existing deployment, verify ownership and permissions before starting Loki:

```bash
sudo ls -ldn log-analyser/loki/data
```

If Loki cannot write to this directory, startup may fail with `mkdir /data/loki: permission denied`. Do not make the directory world-writable or run Loki as root to work around filesystem permission errors.

### 4. Validate the effective Compose configuration

When selecting Compose files explicitly with `-f`, include the override explicitly as well. Docker Compose does not automatically append the default override file to an explicit file list.

With bundled Grafana:

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f log-analyser.yml \
  -f grafana.yml \
  config
```

For an external Grafana installation, omit `-f grafana.yml`. If you do not use an override file, also omit `-f docker-compose.override.yml`; ensure the required logging settings are supplied by your selected Compose configuration.

Verify that each Jitsi service has its expected `service` container label (`jitsi-web`, `jitsi-prosody`, `jitsi-jicofo`, or `jitsi-jvb`) and `logging.options.labels: service`. Resolve missing environment variables before deploying.

### 5. Start the stack

With bundled Grafana:

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f log-analyser.yml \
  -f grafana.yml \
  up -d
```

For external Grafana, omit `-f grafana.yml`. The external Grafana instance must have network access to the Loki HTTP endpoint; `http://loki:3100` is a Docker-internal service address and is not necessarily reachable from outside the Compose network.

Starting the stack creates or recreates services according to the selected Compose configuration. For existing deployments, review the effective configuration and planned changes before applying them.

### 6. Verify Loki readiness

If Loki's HTTP port is published on the host at `127.0.0.1:3100`, run:

```bash
curl -fsS http://127.0.0.1:3100/ready
```

A successful response contains `ready`. Loki may temporarily return HTTP 503 during initialization. If this persists, inspect the Loki container status and startup logs before changing the configuration.

## How log collection works

The Collector's `filelog/jitsi-containers` receiver reads `/var/lib/docker/containers/*/*-json.log` and accepts only records with the expected Jitsi `attrs.service` values. The Docker timestamp is parsed using a Go time layout that supports nanosecond precision. The `service` value becomes the OTLP resource attribute `service.name`, which Loki exposes as `service_name` in LogQL.

The Collector exports logs using `otlphttp/loki` at `http://loki:3100/otlp` (the OTLP/HTTP logs endpoint resolves to `/otlp/v1/logs`). Loki must be configured to accept OTLP ingestion and structured metadata, as provided by the accompanying Loki configuration.

The Collector also exposes a `docker_stats` receiver configured with Docker API version `1.40` for compatibility with Docker Engine versions that reject older client API versions.

### File offsets and historical logs

The filelog receiver uses `start_at: end` for previously unseen log files. On first collection it therefore reads new log entries rather than importing all existing historical records. It stores file offsets using the `file_storage` extension at `/tmp/jitsi-logs/filelog-state`.

`log-analyser.yml` bind-mounts `./log-analyser/jitsi-logs/` at `/tmp/jitsi-logs/`, so offsets persist when the Collector container is recreated, provided that host directory is retained. Removing that directory discards the stored offsets and changes how subsequent collection starts.

### Docker access and security

The Collector runs as root in the supplied Compose configuration to read Docker container log files. It also mounts `/var/run/docker.sock` for the `docker_stats` receiver. Access to the Docker socket is security-sensitive and can provide control over the host Docker daemon; mounting the socket read-only does not make Docker API access read-only. Restrict access to the Collector and its host accordingly.

## Grafana dashboards

The repository provides two dashboard variants with different data source binding mechanisms. **Use the variant appropriate to the target Grafana instance; do not import both variants into the same instance without reviewing dashboard identifiers.**

### Bundled Grafana: `internal/`

The bundled Grafana deployment provisions dashboards from:

```text
log-analyser/grafana-provisioning/dashboards/internal/
```

The dashboard provider is configured in `log-analyser/grafana-provisioning/dashboards/dashboards.yml`. Loki dashboard definitions in this directory reference the fixed Loki data source UID provisioned by `log-analyser/grafana-provisioning/datasources/datasource_loki.yml`:

```text
a4bdfb3e-762a-46e5-a79f-2e7bbe88d444
```

The `internal/` directory also contains dashboards that use other data sources, including Prometheus or Tempo. Those dashboards require their respective data sources and are not part of the Loki-only external import set.

### Existing Grafana: `external-grafana/`

For a separately managed Grafana installation, use:

```text
log-analyser/grafana-provisioning/dashboards/external-grafana/
```

These are **manual import** variants of the Loki dashboards. Each uses Grafana's import-time `__inputs` mechanism with the `DS_LOKI` input. When importing a JSON file through the Grafana dashboard import interface, select the Loki data source configured in the target Grafana instance.

The selected data source is resolved during import. `DS_LOKI` is **not** a dashboard template variable and does not add a data source selector to the dashboard.

Do not place the `external-grafana/` files in the bundled dashboard provisioning directory. The `__inputs` mechanism is intended for the dashboard import workflow, not as a replacement for provisioning a data source UID.

### Dashboard inventory

The Loki dashboard set includes:

| File | Purpose |
| --- | --- |
| `overview-all.json` | Combined Jitsi log overview, events, error analysis, service logs, and raw logs. |
| `jitsi-all.json` | Cross-service Jitsi logs. |
| `jicofo.json` | Jicofo logs and analysis. |
| `jvb.json` | Jitsi Videobridge logs and analysis. |
| `prosody.json` | Prosody logs and analysis. |
| `jitsi-web.json` | Jitsi web logs and analysis. |

These six Loki dashboards are provided in both `internal/` and `external-grafana/`. Additional dashboards in `internal/` are `docker-statistics.json`, `Prosody-Dashboard.json`, `rtcstats.json`, and `tracing.json`; their data source requirements are separate from the Loki import mechanism.

The `overview-all.json` dashboard includes a service filter for the four Jitsi components. Its LogQL queries use the Loki `service_name` label; panels using severity grouping rely on the `level` label where present. The service filter is independent of the import-time Loki data source selection.

## Access and verify Grafana

For the bundled deployment, open [http://localhost:3000](http://localhost:3000) on the Docker host, or use the appropriate hostname and published port for your deployment. Existing Grafana installations may use a different URL and authentication method.

For a new Grafana instance, the default initial credentials may be `admin` / `admin`; change the administrator password immediately and follow your deployment's configured authentication settings.

Use Grafana Explore to inspect the collected streams, for example:

```logql
{service_name=~"jitsi-(web|prosody|jicofo|jvb)"}
```

For a specific service:

```logql
{service_name="jitsi-jicofo"}
```

To inspect log counts by severity over seven days:

```logql
sum by (level) (count_over_time({service_name=~"jitsi-.+"}[7d]))
```

Not all records necessarily have a `level` label. If no entries appear immediately, generate a new log event after the logging options have taken effect and check the Collector logs. Because `start_at: end` is enabled, absence of historical entries alone does not indicate a collection failure.

## Troubleshooting

| Symptom | Checks |
| --- | --- |
| Loki does not start | Inspect Loki container logs and verify ownership of `log-analyser/loki/data`. |
| Loki returns HTTP 503 on `/ready` | Allow initialization; if persistent, inspect Loki startup logs. |
| No Jitsi log streams | Confirm the `json-file` driver, `logging.options.labels: service`, recreated containers, Collector access to log files, and new log events. |
| Collector cannot access Docker | Check Docker socket and container log mounts, and the effective container permissions. |
| Bundled dashboards cannot query Loki | Check Loki readiness, Grafana data source provisioning, and the fixed Loki UID in `internal/` dashboards. |
| External dashboard cannot query Loki | Verify Loki network reachability and select the correct Loki data source during JSON import. |
| Missing historical entries | Check the time range and the `start_at: end` behavior; do not delete persisted file offsets as a routine troubleshooting step. |

## Validation status and limitations

The following were validated in an isolated test environment using OpenTelemetry Collector Contrib 0.130.0 and Loki 3.0.0:

- Docker API compatibility for the `docker_stats` receiver.
- Collector-to-Loki OTLP/HTTP log delivery.
- Docker JSON log ingestion with `labels: "service"` and service identification.
- Nanosecond-precision Docker timestamp parsing and preservation of log bodies.
- Loki severity detection on synthetic Jitsi-style error records.
- Jicofo source-location extraction and LogQL aggregation using a synthetic Jicofo-format error record.
- JSON validity and provisioned Loki data source UIDs for 21 migrated LogQL targets across five dashboards.

The logging pipeline was also tested against a running Jitsi Meet deployment with all four components (`web`, `prosody`, `jicofo`, and `jvb`). The five original Loki dashboards were tested against the resulting Loki data; their external installation initially required manual data source reassignment.

The external import approach using `__inputs` has been tested for the Jicofo dashboard. The classic-schema `overview-all.json` conversion preserves 22 visualization panels, 24 LogQL queries, and five dashboard sections, but runtime behavior and rendering of all converted panels still require verification in Grafana.

Loki persistent storage and startup using corrected filesystem permissions have been validated. End-to-end log ingestion following the latest deployment changes, import behavior of the remaining external dashboards, and full runtime validation of the overview dashboard remain outstanding.

## Further information

For deployment changes and migration considerations, see [CHANGELOG.md](CHANGELOG.md).

See the [Jitsi Handbook](https://jitsi.github.io/handbook/docs/intro) for the broader self-hosting and deployment documentation.
