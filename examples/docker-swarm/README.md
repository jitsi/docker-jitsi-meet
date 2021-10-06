## Deploy jitsi using docker-swarm and Traefik

### NOTE: This example was tested by using a individual VM for each of the service.

### STEPS

1. Open below ports in firewall for docker-swarm configuration.

    A. TCP port 2377 for cluster management communications

    B. TCP and UDP port 7946 for communication among nodes

    C. UDP port 4789 for overlay network traffic

2. This setup assumes that you are using 2 or more nodes for deployment.
    
    A. [Initialize docker-swarm](https://docs.docker.com/engine/reference/commandline/swarm_init/) by running command `docker swarm init --advertise-addr machine_IP` on any of the node(Let's say VM1). `machine_IP` is the PUBLIC or PRIVATE IP of your node(VM1).

    B. [Join](https://docs.docker.com/engine/reference/commandline/swarm_join/) a swarm as a manager using command `docker swarm join-token manager` on node(VM1).

    C. Now join other nodes as well using command `docker swarm join --token TOKEN VM1_IP:2377 --advertise-addr current_VM_IP` where `TOKEN` is value generated in Step 2.A and `current_VM_IP` is the IP of your machine on which you are running this command.

    D. Join node3(VM3) using the same command as 2.C

    E. Verify the setup using command `docker node ls` which will show all the three nodes with role as a manager.

3. Create an Overlay network for jitsi using command `docker network create --attachable --driver overlay jitsi`

4. Now open below ports for jitsi deployment.

    A. Jicofo port `8888 TCP` for internal use only.

    B. Jvb ports `10000 UDP` for everyone, `4096 UDP` and `8080 TCP` for internal use only.

    C. Prosody ports `5222, 5347, 5280 TCP` for internal use only.

    D. Web port `80 TCP` and `443 TCP` for everyone and make sure to enable `ENABLE_HTTP_REDIRECT` in `stack-web.yml` file.

5. Now deploy the jitsi setup files using command `docker stack deploy -c stack-web.yaml -c stack-prosdy.yml -c stack-jicofo.yml -c stack-jvb1.yml jitsi`.

6. Please note that you can restrict which service you want to deploy on which node by uncommenting the `placement` in the files. Make sure you are running service web on the node for which you have added a DNS record.