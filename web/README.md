# Jitsi Meet We.Team 

## Making changes to Jitsi Meet UI

### Get the Jitsi Meet source

Clone our fork of the Jitsi Meet repository:

https://github.com/otixo-inc/jitsi-meet

### Developing

Follow this guide for instuctions on how to run jitsi-meet in development mode

https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-web


### Releasing

Run the following command to create a source package:

```sh
make && make source-package
```

Unzip `jitsi-meet.tar.bz2` and copy the folder to the following location in this repository:

[web/jitsi-meet](/web/jitsi-meet)

Push your changes. 

The following action will run on GitHub and publish a new docker image to AWS ECR:

[.github/workflows/docker-image.yml](/.github/workflows/docker-image.yml)
