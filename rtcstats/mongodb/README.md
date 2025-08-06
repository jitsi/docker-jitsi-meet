## Using MongoDB

This section describes how to use MongoDB for rtcstats.

### Setup


1. **Configure Environment Variables**

    Edit the MongoDB environment variables  in `rtcstats/.env`:
    ```
    # Set the service type. Can be "AWS" or "MongoDB".
    RTCSTATS_SERVICE_TYPE=MongoDB

    ...

    # For MongoDB
    RTCSTATS_MONGODB_URI=mongodb://root:root@mongodb.meet.jitsi:27017
    RTCSTATS_MONGODB_NAME=rtcstats-db
    RTCSTATS_METADATA_COLLECTION=rtcstats-meta-collection
    RTCSTATS_GRIDFS_BUCKET=rtcstats-dump-file-bucket
    ```

2. **Run Docker Compose with MongoDB**

    From your `docker-jitsi-meet` directory, run the following command to start all services, including Jitsi Meet, rtcstats, and Localstack.
    ```shell
    docker-compose -f docker-compose.yml -f rtcstats.yml -f ./rtcstats/mongodb/mongodb.yml up -d
    ```