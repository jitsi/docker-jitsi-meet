# JITSI MEET LOG ANALYSER - Grafana Loki and OpenTelemetry Integration

Welcome to the Grafana Loki and OpenTelemetry integration project! This repository provides a simple and effective setup for log management and analysis using Docker, Grafana Loki, and OpenTelemetry.
Currently this is an in-progress GSoC Summer of Code project and so the instructions may change before being finalized.  Please treat all this as alpha code.

## Overview

This project demonstrates how to configure and use Grafana Loki with OpenTelemetry to collect, parse, and visualize log data from Jitsi Meet components. It includes:

- A Docker Compose setup (`log-analyser.yml`) for Loki and OpenTelemetry Collector.
- A Docker Compose setup (`grafana.yml`) for Grafana.
- A unified Docker Compose command to start all services.
- Instructions to set up and access Grafana with Loki as a data source.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Setup

1. **Clone the repository:**

```bash
git clone https://github.com/jitsi/docker-jitsi-meet.git
```

2. **Update Jitsi Meet Docker Compose Configuration:**

To enable log collection and analysis, you need to modify the `docker-compose.yml` file for Jitsi Meet components. Add the following configuration to each Jitsi service within the `docker-compose.yml` file:

```yaml
    logging:
      driver: "json-file"
      options:
        labels: "service"
```

This configuration ensures that logs are collected in JSON format and tagged with service labels, which is essential for Loki to properly ingest and index the logs.

3. **Start the Docker containers:**

   To start all necessary services, including Jitsi Meet components, Grafana, Loki, and OpenTelemetry, run:

    ```bash
    docker-compose -f docker-compose.yml -f log-analyser.yml -f grafana.yml up -d
    ```

   - This command will start the Jitsi Meet components from `docker-compose.yml`, the log analysis tools from `log-analyser.yml`, and Grafana from `grafana.yml`. The logs from Jitsi Meet components will automatically be sent to Grafana through Loki.
   - **Note:** To use only Grafana for visualization without log analysis, you can use just `grafana.yml` alone. However, for the complete log analysis project, you need both `log-analyser.yml` and `grafana.yml`.

### Access Grafana

1. **Open your web browser and navigate to [http://localhost:3000](http://localhost:3000).**

2. **Log in to Grafana:**

   Use the default credentials:

    ```
    Username: admin
    Password: admin
    ```

3. **Dashboard Setup:**

   The dashboards for Jitsi Meet components are pre-configured and will be automatically available in Grafana. You can explore these dashboards to view and analyze logs.

## Usage

- **Log Parsing and Visualization:** After setting up, use Grafana to explore and visualize your logs. Check the pre-configured dashboards and panels to monitor and analyze log data from Jitsi Meet components effectively.

## Acknowledgements

Thank you for exploring this project!
For detailed documentation, follow the [Jitsi Handbook](https://jitsi.github.io/handbook/docs/intro), you can follow the Docker and Log-Analyser guides under Self-Hosting Guide > Deployment guide.

If you have any questions or need further assistance, please feel free to reach out.
