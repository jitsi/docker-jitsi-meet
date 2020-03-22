# Basic configuration to use with the traefik reverse proxy

Note: Tested with traefik 1.7

- If you're running behind traefik, I consider it a better practice to remove the port-binds for the web service
- The provided example assumes an external network with the named "web". This is the network you most likely have created while setting up traefik.
- I've added comments starting with **#traefik:** where I've adjusted the docker-compose.yml

Uncomment and set DOCKER_HOST_ADDRESS in .env  
Im pretty sure, that this is mandatory for the docker-setup and should be clearer in the original README. Could be the proxying, didn't investigate further.

````env
DOCKER_HOST_ADDRESS=1.2.3.4
````
