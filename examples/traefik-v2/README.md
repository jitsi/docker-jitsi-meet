# Basic configuration to use with the traefik reverse proxy

Note: Tested with traefik 2.2.0

- When running behind traefik, it's a better practice to remove the port-binds for the web service.
- The provided example uses an external network with the name "traefik". This is the network which moste likely was created while setting up traefik.
- Look for comments starting with **#traefik:** to see the changes made in docker-compose.yml.
- Traefik is usually setup to get Let's Encrypt certificates automatically. But it can also use other certificate issuers or services

The file `.env` must be edited as well
```
# IP address of the Docker host (it can also be a FQDN)
# See the "Running behind NAT or on a LAN environment" section in the Handbook:
# https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker#running-behind-nat-or-on-a-lan-environment
DOCKER_HOST_ADDRESS=1.2.3.4
...
#disable letsencrypt
ENABLE_LETSENCRYPT=0
...
# Disable HTTPS: we will handle TLS connections through traefik2
DISABLE_HTTPS=1

#disable HTTP_REDIRECT, only needed when not using traefik
#ENABLE_HTTP_REDIRECT=1

```
