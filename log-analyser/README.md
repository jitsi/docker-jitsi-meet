# JITSI MEET LOG ANALYSER - Grafana Loki and OpenTelemetry Integration

Welcome to the Grafana Loki and OpenTelemetry integration project! This repository provides a simple and effective setup for log management and analysis using Docker, Grafana Loki, and OpenTelemetry.
Currently this is an in-progress GSoC Summer of Code project and so the instructions may change before being finalized.  Please treat all this as alpha code.

## Overview

This project demonstrates how to configure and use Grafana Loki with OpenTelemetry to collect, parse, and visualize log data. It includes:

- A Docker Compose setup (`log-analyser.yml`) for Loki and OpenTelemetry Collector.
- A Docker Compose setup (`grafana.yml`) for Grafana.
- Configuration files for log parsing and exporting.
- Instructions to set up and access Grafana with Loki as a data source.
- 
## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Setup

1. **Clone the repository:**

    ```bash
    git clone https://github.com/jitsi/docker-jitsi-meet.git
    ```

### Log Analyser

1. **Add your log files:**

   Place your log file in the `log-analyser/jitsi-logs` directory. Update the `otel-collector-config.yaml` file with the correct file path to start ingesting the logs. This setup allows OpenTelemetry to read logs from the file and forward them to Loki.

2. **Update the otel-collector-config.yaml file:**

   Update the file path to point to your log file for ingestion by OpenTelemetry.

3. **Start the Docker containers:**

   ```bash
   docker-compose -f docker-compose.yml -f log-analyser.yml up -d
    ```

### Grafana

1. **Start the Docker container:**

   ```bash
   docker-compose -f docker-compose.yml -f grafana.yml up -d
    ```

2. **Access Grafana:**

   Open your web browser and navigate to [http://localhost:3000](http://localhost:3000).

3. **Log in to Grafana:**

   Use the default credentials:

    ```
    Username: admin
    Password: admin
    ```

### Dashboard Setup

The dashboard setups are available as JSON files in the `log-analyser/grafana-dashboards` directory. You can import these JSON files into Grafana to use the pre-configured dashboards. In the future, we plan to automate this import process.


## Usage

- **Log Parsing and Visualization:** After setting up, you can use Grafana to explore and visualize your logs. Check our dashboards and panels to monitor log data effectively.


## Acknowledgements

Thanks for checking out this project! If you have any questions or need further assistance, don't hesitate to reach out.
