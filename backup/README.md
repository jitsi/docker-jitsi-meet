# Jitsi Recorded Video Organizer

This script is designed to help administrators and users of Jitsi, who are running the service in Docker, to easily manage and access recorded conference videos. The script automatically organizes the videos by renaming folders that are created for each video into more descriptive names and moving them to a structured directory.

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


- Reccomendation: 
   1) You can change srcDir, dstDir, and videoLog from main.go file that can match with your infrastructure needs.
   2) Before moving towards the execution, make sure you've built the script on your system with Go.

## Setup

**Clone the Repository:**

   ```bash
   git clone git@github.com:jitsi/docker-jitsi-meet.git 

   cd docker-jitsi-meet/organizing-videos

   go build -o "Name Your Script Here" .
