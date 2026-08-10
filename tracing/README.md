# Tracing

This directory contains all required files to enable tracing to Jitsi.

## Components

- **Tempo**: Tracing backend.
- **Alloy**: Open Telemetry collector.
- **Grafana**: Observability frontend.

## Usage

Set the following environment variable:
```env
ENABLE_TRACING=1
```

Start the docker compose:
```sh
docker compose -f docker-compose.yml -f tracing.yml up
```

To stop all services:
```sh
docker compose -f docker-compose.yml -f tracing.yml down
```

## Visualization

Open Grafana at [http://localhost:3000](http://localhost:3000)

- The explore tab can be used to query specific traces.
- The drilldown tab can be used to explore data intuitively.

We also provide a sample dashboard for common queries, although more personalized dashboards can be created.

## Further reading

- https://opentelemetry.io/
- https://grafana.com/docs/tempo/latest/
- https://grafana.com/docs/grafana/latest/visualizations/
