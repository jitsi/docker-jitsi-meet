# Install guide for kubernetes with helm

This guide will deploy jitsi with jibri on kubernetes


## For each node in the cluster do the following:

### Install generic kernel image
```
sudo apt-get update
sudo apt-get install linux-image-generic
```
#### Change grub to start node VM with generic kernel

```
# GKE Node
sudo vim /etc/default/grub.d/50-cloudimg-settings.cfg

# Other Setup
sudo vim /etc/default/grub
```

Replace #GRUB_DEFAULT=0 with
```
# Make the latest generic kernel the default
release=$(linux-version list | grep -e '-generic$' | sort -V | tail -n1)
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux $release"
```
```
sudo update-grub
```
#### Reboot VM
```
sudo reboot
```

### Setup virtual sound device in the node
#### install the module
```
sudo apt update && sudo apt install linux-image-extra-virtual
```

#### configure 5 capture/playback interfaces
```
sudo su
echo "options snd-aloop enable=1,1,1,1,1 index=0,1,2,3,4" > /etc/modprobe.d/alsa-loopback.conf
```
#### setup autoload the module
```
echo "snd-aloop" >> /etc/modules
```
#### Reboot
```
sudo reboot
```
#### check that the module is loaded
```
lsmod | grep snd_aloop
```

## Run helm command:

```
helm upgrade --install --force example.com ./jitsi-meet --set prosody.jwt.id=CHANGEME,prosody.jwt.secret=CHANGEME,ingress.enabled=true,ingress.hosts[0].host=example.com,ingress.hosts[0].paths={/},ingress.tls[0].secretName=CHANGEME,ingress.tls[0].hosts={example.com} 
```