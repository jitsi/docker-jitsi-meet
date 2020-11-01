# Basic configuration to use with the traefik reverse proxy

Note: Tested with traefik 2.3.1

- When running behind traefik, it's a better practice to remove the port-binds for the web service.
- The provided example uses two external networks with the name `jitsi` for `jitsi-setup` and `proxy` for `Traefik`. Both of these networks need to be created externally using the below commands.

  **`docker network create --driver=bridge jitsi`**

  **`docker network create --driver=bridge proxy`**

- Look for comments starting with **#traefik:** to see the changes made in docker-compose.yml.
- Traefik obtains Let's Encrypt certificates automatically. This example uses `TLS-challenge` for obtaining certificate. 
- Please change `traefik.example.in` to your `subdomain` for accessing Traefik dashboard and replace `meet.example.in` to access the `Jitsi-setup` on https. 
