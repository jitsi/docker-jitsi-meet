# Jitsi Video Organizer

This script is designed to help administrators and users of Jitsi who are running the service in Docker to easily manage and access recorded conference videos. The script automatically organizes the videos by renaming folders that are created for each video into more descriptive names and moving them to a structured directory.

## Features

- Renames videos to descriptive names based on conference names and timestamps.
- Moves recorded videos to a more accessible directory structure.
- Logs the actions performed for easy tracking and troubleshooting.

## Prerequisites

- A directory where you can mount it to your Docker.
- Jitsi installed and running in Docker.
- Access to the file system where Jitsi stores recorded videos.
- Access to backup directory where you need to move your recorded videos.
- A CronJob for executing script in case you need to have a frequent execution process.


## Configuration

Open the script "main.go" and configure the following variables:

- srcDir: The directory where Jitsi stores recorded videos. This should be the directory mounted on your Docker container.
- dstDir: The destination directory where you want to move the organized videos.
- videoLog: The file path where the script will log its actions.

**Variables available to change:**
   ```bash
   srcDir = "/path/to/your/mounted/jitsi/recordings"

   dstDir = "/path/to/your/organized/videos"

   videoLog = "/path/to/your/log/file.log"
   ```

## Setup

**Clone the Repository:**

   ```bash
   git clone git@github.com:jitsi/docker-jitsi-meet.git 

   cd docker-jitsi-meet/backup

   go build -o "Name Your Script Here" .
   ```

## Running the Script Manually

**After you've built the script, you can run the script manually to organize your videos:**
   ```bash
   go build -o "Name Your Script Here" .

   ./"Your Executable Script"
   ```
This will rename the videos and move them from folders to the destination directory.

## Automation with CronJob
To automate the process of organizing recorded videos, you can set up a cron job on your server. This allows the script to run at defined intervals, ensuring that your videos are always organized.

**Open your crontab:**

```bash
crontab -e

Add the following line to schedule the script to run at a specific time. For example, to run the script every day at midnight:

0 0 * * * user /path/to/your/script/organize_videos
```
Make sure to replace the path with the actual path to your script.


