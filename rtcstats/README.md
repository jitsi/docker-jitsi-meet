# Meeting stats with rtcstats

## Overview

This project demonstrates how to use rtcstats with Jitsi Meet to gather detailed information about meeting quality and logs.

## Getting Started

### Setup

1. **Update Jitsi Meet Docker Compose Configuration**

	Edit `.env` in your `docker-jitsi-meet` directory to enable rtcstats.
	```
	#
	# rtcstats integration
	#

	# Enable rtcstats analytics (uncomment to enable)
	RTCSTATS_ENABLED=true

	# Send the console logs to the rtcstats server
	RTCSTATS_STORE_LOGS=false

	# The interval at which rtcstats will poll getStats, defaults to 10000ms.
	RTCSTATS_POLL_INTERVAL=10000

	# Send the SDP to the rtcstats server
	RTCSTATS_SEND_SDP=true

	```

2. **Configure rtcstats**

	Copy the example environment files and edit them according to your environment.
	```shell
	docker-jitsi-meet/rtcstats$ cp env.example .env
	docker-jitsi-meet/rtcstats$ cp ./rtcstats-server/env.example ./rtcstats-server/.env
	docker-jitsi-meet/rtcstats$ cp ./rtc-visualizer/env.example ./rtc-visualizer/.env
	```

	Next, edit `rtc-visualizer/.data/users.json` to add your users. The default credential is `admin:admin`.
	```json
	{
		"Alice": "XXX",
		"Bob": "YYY"
	}
	```

4. **Run Docker Compose**

	From your `docker-jitsi-meet` directory, run the following command to start all services.
	```shell
	docker compose -f docker-compose.yml -f rtcstats.yml up -d
	```


## Usage

1. **View RTC Visualizer**

	Open [https://localhost:8443/rtc-visualizer](https://localhost:8443/rtc-visualizer) (or `PUBLIC_URL/rtc-visualizer`) in your browser.

