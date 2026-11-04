# Changelog – Jitsi Meet Log Analyser

All notable changes to the optional Jitsi Meet observability stack are documented here.

## Unreleased – OpenTelemetry / Loki Integration
- Date: 2026-11-04
- Author: gebra-de
- Status: In progress

### Added
- OpenTelemetry Collector integration for Docker JSON log ingestion.
- OTLP/HTTP log export to Grafana Loki.
- Persistent Collector file offsets and Loki storage.
- Docker container statistics receiver.
- Service-specific and consolidated Grafana Loki dashboards.
- Overview dashboard with service filtering and log-level analysis.
- Separate Grafana dashboard variants for bundled and external deployments.

### Changed
- Grafana dashboard provisioning now loads dashboards from `grafana-provisioning/dashboards/internal/`.
- External Grafana dashboards use import-time Loki datasource selection through `__inputs` (`DS_LOKI`).
- Loki storage and OTLP configuration updated.
- Loki and Collector restart policies configured.
- Docker Compose override example moved to `log-analyser/`.
- README expanded with deployment, permissions, persistence, and validation instructions.

### Compatibility and migration
- Existing `docker-compose.override.yml` files must not be overwritten. Merge the required logging settings manually.
- Existing Grafana installations should import dashboards from `external-grafana/`.
- Bundled Grafana installations use dashboards from `internal/`.
- The Collector requires Docker `json-file` logging with the `service` label included in log records.
- Existing containers must be recreated for new logging options to take effect.
- Collector offsets persist across container recreation while `log-analyser/jitsi-logs/` is retained.
- New log files are read from the end by default (`start_at: end`); historical logs are not automatically imported.

### Operational considerations
- Loki requires write access to its persistent data directory.
- The Collector requires access to Docker container log files and the Docker socket.
- Docker socket access is security-sensitive, even when mounted read-only.
- External Grafana instances require a reachable Loki datasource.
- Grafana dashboard compatibility and visualization behavior should be verified after import.