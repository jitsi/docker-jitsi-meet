# Prometheus Scraping & Grafana Dashboard for Jitsi

## Overview

This project aims to integrate **Prometheus** and **Grafana** with Jitsi to monitor and visualize performance metrics. It enhances Jitsi’s operational efficiency by providing detailed insights into resource utilization, network traffic, and service availability.

## Features

- **Prometheus Integration**: Collects metrics from Jitsi containers.
- **Grafana Dashboards**: Visualizes the metrics for easy analysis.

## Installation

### Prerequisites

- Docker
- Docker Compose

### Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/prometheus-scraper-jitsi-meet.git
   cd prometheus-scraper-jitsi-meet
   ```

2. **Setup Jitsi with Docker Compose**

   Follow the [Jitsi Docker](https://github.com/jitsi/docker-jitsi-meet) setup instructions. <br>
   Also, you could follow Self - Hosting guide of Jitsi Meet: [Jitsi handbook](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/)

3. **Deploy Prometheus and Grafana**

   Adding the service in different files which allows for better user control. These files are added at root level.<br>

   Add Prometheus service to your `prometheus.yml` which turns up the container:

   ```yaml
   prometheus:
     image: prom/prometheus
     ports:
       - "9090:9090"
     volumes:
       - ./prometheus.yml:/etc/prometheus/prometheus.yml
    networks:
        meet.jitsi:
   ```

   Adding Grafana service to your `grafana.yml` which turns up the container:

   ```
   grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
   ```

4. **Configure Prometheus**

   Edit `/prometheus/prometheus.yml` to scrape metrics from Jitsi containers:

   ```yaml
   scrape_configs:
     - job_name: "jitsi"
       static_configs:
         - targets: ["prosody:5280", "jvb:8080", "jicofo:8888", "otel:9464"]
   ```

5. **Run Docker Compose**

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

   Open [http://localhost:9090](http://localhost:90990) in your browser.

2. **Access Grafana Dashboard**

   Open [http://localhost:3000](http://localhost:3000) in your browser.

3. **Import Dashboard**

   Import the provided JSON file in Grafana to visualize Jitsi metrics.

## Contributer

@24kushang.
