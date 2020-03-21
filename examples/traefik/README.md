# Basic configuration to use with the traefik reverse proxy

Note: Tested with traefik 1.7

- Remove the port-binds for the web service
- The provided example assumes an external network with the name "web"
- I've added comments where to adjust the docker-compose.yml, but I assume that you know your stuff, if you're running traefik.

Uncomment and set DOCKER_HOST_ADDRESS in .env  
Im pretty sure, that this is mandatory for the docker-setup and should be clearer in the original README. Could be the proxying, didn't investigate further.

````env
DOCKER_HOST_ADDRESS=136.243.57.154
````
