## Using Localstack

This section describes how to use Localstack to test and verify your rtcstats setup. Localstack simulates AWS cloud services (like S3) on your local machine, allowing you to confirm that statistics are being saved correctly without needing an actual AWS account.

### Setup


1. **Configure Network Alias for Custom S3 Bucket**

    If you are using a custom S3 bucket name, you must add it as a network alias in `localstack.yml`. This allows the rtcstats-server and rtc-visualizer to resolve the bucket's address to the Localstack container.

    Edit the `networks` section for the `localstack` service in `rtcstats/localstack/localstack.yml`:
    ```yml
    services:

      localstack:
        # ... (other settings)
        networks:
          meet.jitsi:
            aliases:
              # - jitsi-micros-rtcstats-server.s3.localstack # Default example
              - YOUR_RTCSTATS_S3_BUCKET.s3.localstack
    ```
    **Note:** Replace `YOUR_RTCSTATS_S3_BUCKET` with the actual bucket name you defined in your environment variables.

    To enable the AWS SDK to make Virtual-Hosted-Style requests to S3, you need to also configure the endpoints in `rtcstats/.env` as follows:
    ```
    RTCSTATS_S3_ENDPOINT=http://s3.localstack:4566
    RTCSTATS_DYNAMODB_ENDPOINT=http://localstack:4566
    ```

2. **Run Docker Compose with Localstack**

    From your `docker-jitsi-meet` directory, run the following command to start all services, including Jitsi Meet, rtcstats, and Localstack.
    ```shell
    docker compose -f docker-compose.yml -f rtcstats.yml -f ./rtcstats/localstack/localstack.yml up -d
    ```


### Troubleshooting

- **502 Bad Gateway on RTC Visualizer**

  If you encounter a `502 Bad Gateway` error when accessing the RTC Visualizer, you may need to restart the `jitsi/web` container.

  Run the following command from your docker-jitsi-meet directory to resolve the issue:
  ```shell
  docker compose restart web
  ```
