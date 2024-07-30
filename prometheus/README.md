# Prometheus Scraping & Grafana Dashboard for Jitsi

## Overview

This project aims to integrate **Prometheus** and **Grafana** with Jitsi to monitor and visualize performance metrics.

## Features

- **Prometheus Integration**: Collects metrics from Jitsi containers.
- **Grafana Dashboards**: Visualizes the metrics for easy analysis.

## Installation

### Prerequisites

- Docker
- Docker Compose

### Steps

1. **Setup Jitsi with Docker Compose**

   Follow the [Jitsi Docker](https://github.com/jitsi/docker-jitsi-meet) setup instructions. <br>
   Also, you could follow Self - Hosting guide of Jitsi Meet: [Jitsi handbook](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/)

2. **Configure Prometheus**

   Edit `/prometheus/prometheus.yml` with any **Port / Container name** changes are there to scrape metrics from Jitsi containers:

   ```yaml
   scrape_configs:
     - job_name: "jitsi"
       static_configs:
         - targets: ["prosody:5280", "jvb:8080", "jicofo:8888", "otel:9464"]
   ```

3. **Run Docker Compose**

   The following command turns up the Jitsi Meet:

   ```bash
   docker-compose up -d
   ```

   If you want to add the Prometheus and Grafana for monitoring purpose. Use the following command:

   ```bash
   docker-compose -f docker-compose.yml -f prometheus.yml -f grafana.yml up -d
   ```

   To monitor Docker Engine we need to enable **Open Telemetry** service, which can be turned up from `log-analyser.yml`. Use the following command:

   ```bash
   docker-compose -f docker-compose.yml -f prometheus.yml -f grafana.yml -f log-analyser.yml up -d
   ```

## Usage

1. **View the Prometheus Targets**

   Open [http://localhost:9090](http://localhost:9090) in your browser.

2. **Access Grafana Dashboard**

   Open [http://localhost:3000](http://localhost:3000) in your browser.

3. **Import Dashboard**

   Import the provided JSON file in Grafana to visualize Jitsi metrics.

## Contributer

[@24kushang](https://github.com/24kushang).
