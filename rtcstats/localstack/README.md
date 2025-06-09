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
              - localhost.localstack.cloud
              # - jitsi-micros-rtcstats-server.s3.localhost.localstack.cloud # Default example
              - YOUR_RTCSTATS_S3_BUCKET.localhost.localstack.cloud
    ```
    **Note:** Replace `YOUR_RTCSTATS_S3_BUCKET` with the actual bucket name you defined in your environment variables.


2. **Run Docker Compose with Localstack**

    From your `docker-jitsi-meet` directory, run the following command to start all services, including Jitsi Meet, rtcstats, and Localstack.
    ```shell
    docker-compose -f docker-compose.yml -f rtcstats.yml -f ./rtcstats/localstack/localstack.yml up -d
    ```