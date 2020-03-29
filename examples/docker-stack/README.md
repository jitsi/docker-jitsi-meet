# DOCKER STACK

In order to make jitsi docker-compose config  work with docker stack  we have to take in consideration several things
1. docker doesnt handle dots (`.`) in the network names due to the internal DNS
2. docker-compose interpolates the configuration set in the `.env` file while docker itself doesn't

## 1. Fixing the network

If you examine the main `docker-compose.yml` file, yo will realize that you can set a name for docker to handle and 
another (alias) for docker to expose. Whith this _alias_ trick we can make XMPP support our network 'domain'

## 2. Interpolating the configuration

Start with the commands as stated in the main README.md. Simply copy the example config into your personal `.env`
file and customize it. Once you have it ready generate the deployment with all the interpolated values with
```
docker-compose config > deployment.yml
```
If you examine the `deployment.yml` you will realize all your variables are set already

Now you can start your docker stack like you would normaly do
```
docker stack deploy --compose-file deployment.yml jitsi
```
