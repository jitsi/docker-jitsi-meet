# Basic configuration to use with the traefik reverse proxy

Tested with traefik 2.2.0.

### in `docker-compose.yml`

- Rename the external network `web` to match the Docker network shared by your traefik reverse proxy container.
- Amend the router `rule` labels to match your desired hostname.
- Look for any other comments starting with **#traefik:** to see where this `docker-compose.yml` file should be modified to match your system’s configuration.
- The port binds for the `web` service have been removed, since the idea is to expose the service through traefik’s reverse proxy instead.

### in `traefik.toml`

- Create a new traefik entry point for the `jvb` service:

  ```toml
  [entryPoints]
    [entryPoints.video]
      address = ":10000/udp"
  ```

- Create a [certificates resolver for Let’s Encrypt](https://docs.traefik.io/https/acme/) to have traefik obtain certificates automatically:

  ```toml
  [certificatesResolvers.le.acme]
    # ...
  ```

### in `.env`

- Uncomment and define `DOCKER_HOST_ADDRESS`. (This appears to be mandatory, and should be clearer in the original README. Could be the proxying, didn't investigate further.)

  ```env
  DOCKER_HOST_ADDRESS=1.2.3.4
  ```

## TODO

Add or rewrite the example with docker-compose extends
