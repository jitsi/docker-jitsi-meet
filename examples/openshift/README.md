# Install guide for OpenShift / OKD

## Configuration
Adjust the .env file in the root dir to match your needs.

Some configurations are required:
```bash
# The base for all domains used in the template
DOMAIN=example.com

# The REST API has to be activated because it's used by the liveness and readiness probes
JVB_ENABLE_APIS=rest

# The JVB ports have to be 30000 or higher because NodePort is used for them
JVB_PORT=30000
JVB_TCP_PORT=30000
```

## Deployment
```console
make build
oc process -f jitsi.yaml --ignore-unknown-parameters --param-file ../../.env | oc apply -f -
```

## Currently not working
- Let's Encrypt
- Set amount of replicas via .env file

## Untested
- Jibri
- Jigasi
- Etherpad
