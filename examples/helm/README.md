# jitsi-meet

[jitsi-meet](https://jitsi.org/jitsi-meet/) Secure, Simple and Scalable Video Conferences that you use as a standalone app or embed in your web application.

## TL;DR;

```console
$ git clone https://github.com/jitsi/docker-jitsi-meet
$ helm install ./docker-jitsi-meet/examples/helm
```

## Introduction

This chart bootstraps a jitsi-meet deployment, like the official [one](https://meet.jit.si).

## Different topology

To be able to do video conferencing with other people, the jvb component should be reachable by all participants (eg: a public IP).
Thus the default behaviour of advertised the internal IP of jvb, is not really suitable in many cases.
Kubernetes offers multiple possibilities to work around the problem. Not all options are available depending on the Kubernetes cluster setup.
The chart tries to make all options available without enforcing one.

### Option 1: service of type `LoadBalancer`

This requires a cloud setup that enables a Loadbalancer attachement.
This could be enabled via values:

```yaml
jvb:
  service:
    type: LoadBalancer

  # Depending on the cloud, publicIP cannot be know in advance, so deploy first, without the next option.
  # Next: redeploy with the following option set to the public IP you retrieved from the API.
  publicIP: 1.2.3.4
```

In this case you're not allowed to change the `jvb.replicaCount` to more than `1`, UDP packets will be routed to random `jvb`, which would not allow for a working video setup.

### Option 2: NodePort and node with Public IP or external loadbalancer

```yaml
jvb:
  service:
    type: NodePort
  # It may be required to change the default port to a value allowed by Kubernetes (30000-32768)
  UDPPort: 30000
  TCPPort: 30443

  # Use public IP of one of your node, or the public IP of a loadbalancer in front of the nodes
  publicIP: 1.2.3.4
```

In this case you're not allowed to change the `jvb.replicaCount` to more than `1`, UDP packets will be routed to random `jvb`, which would not allow for a working video setup.

### Option 3: hostPort and node with Public IP

Assuming that the node knows the PublicIP it holds, you can enable this setup:

```yaml
jvb:
  useHostPort: true
  # This option requires kubernetes >= 1.17
  useNodeIP: true
```

In this case you can have more the one `jvb` but you're putting you cluster at risk by having it directly exposed on the Internet.

### Option 4: Use ingress TCP/UDP forward capabilities

In case of an ingress capable of doing tcp/udp forwarding (like nginx-ingress), it can be setup to forward the video streams.

```yaml
# Don't forget to configure the ingress properly (separate configuration)
jvb:
  # 1.2.3.4 being one of the IP of the ingress controller
  publicIP: 1.2.3.4

```

Again in this case, only one jvb will work in this case.

### Option 5: Bring your own setup

There are multiple other possibilities combining the available parameters, depending of your cluster/network setup.



## Configuration

The following table lists the configurable parameters of the jisti-meet chart and their default values.

Parameter | Description | Default
--- | --- | ---
`imagePullSecrets` | List of names of secrets resources containing private registry credentials | `[]`
`enableAuth` | Enable authentication | `false`
`enableGuests` | Enable guest access | `true`
`jicofo.replicaCount` | Number of replica of the jicofo pods | `1`
`jicofo.image.repository` | Name of the image to use for the jicofo pods | `jitsi/jicofo`
`jicofo.extraEnvs` | Map containing additional environment variables for jicofo | '{}'
`jicofo.livenessProbe` | Map that holds the liveness probe, you can add parameters such as timeout or retries following the Kubernetes spec | A livenessProbe map
`jicofo.readinessProbe` | Map that holds the liveness probe, you can add parameters such as timeout or retries following the Kubernetes spec | A readinessProbe map
`jicofo.xmpp.user` | Name of the XMPP user used by jicofo to authenticate | `focus`
`jicofo.xmpp.password` | Password used by jicofo to authenticate on the XMPP service | 10 random chars
`jicofo.xmpp.componentSecret` | Values of the secret used by jicofo for the xmpp-component | 10 random chars
`jvb.service.enabled` | Boolean to enable os disable the jvb service creation | `false` if `jvb.useHostPort` is `true` otherwise `true`
`jvb.service.type` | Type of the jvb service | `ClusterIP`
`jvb.UDPPort` | UDP port used by jvb, also affects port of service, and hostPort | `10000`
`jvb.TCPPort` | TCP port used by jvb, also affects port of service, and hostPort | `4443`
`jvb.extraEnvs` | Map containing additional environment variables to jvb | '{}'
`jvb.xmpp.user` | Name of the XMPP user used by jvb to authenticate | `jvb`
`jvb.xmpp.password` | Password used by jvb to authenticate on the XMPP service | 10 random chars
`jvb.livenessProbe` | Map that holds the liveness probe, you can add parameters such as timeout or retries following the Kubernetes spec | A livenessProbe map
`jvb.readinessProbe` | Map that holds the liveness probe, you can add parameters such as timeout or retries following the Kubernetes spec | A readinessProbe map
`web.httpsEnabled` | Boolean that enabled tls-termination on the web pods. Useful if you expose the UI via a `Loadbalancer` IP instead of an ingress | `false`
`web.httpRedirect` | Boolean that enabled http-to-https redirection. Useful for ingress that don't support this feature (ex: GKE ingress) | `false`
`web.extraEnvs` | Map containing additional environment variable to web pods | '{}'
`web.livenessProbe` | Map that holds the liveness probe, you can add parameters such as timeout or retries following the Kubernetes spec | A livenessProbe map
`web.readinessProbe` | Map that holds the liveness probe, you can add parameters such as timeout or retries following the Kubernetes spec | A readinessProbe map
`tz` | System Time Zone | `Europe/Amsterdam`
