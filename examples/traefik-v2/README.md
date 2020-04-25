# Basic configuration to use with the traefik reverse proxy

Note: Tested with traefik 2.2.0

- When running behind traefik, it's a better practice to remove the port-binds for the web service.
- The provided example uses an external network with the name "web". This is the network which moste likely was created while setting up traefik.
- Look for comments starting with **#traefik:** to see the changes made in docker-compose.yml.
- Traefik obtains Let's Encrypt certificates automatically.

Uncomment and set DOCKER_HOST_ADDRESS in .env. I'm pretty sure, that this is mandatory for the docker-setup and should be clearer in the original README. Could be the proxying, didn't investigate further.

## TODO

Add or rewrite the example with docker-compose extends

````env
DOCKER_HOST_ADDRESS=1.2.3.4
````
