## Docker Deployment

It is recommended to use docker containers to deploy the development network for Arcology. This document guides you through the process of setting up an Arcology devNet using docker containers.

### Ethereum L1

 First we need to start the Ethereum L1 container, then move on to the Optimism bridge and Arcology parallel execution node.
 
 ``` shell
	 devnet> cd ethereum
	 ethereum> docker build -t eth:v1 .
	 ethereum> docker run -itd --name ethv1 -p 7545:7545 eth:v1
 ```
 
 - --name specifies the container ID
 - -f indicates the RPC URL of the L1 node
 - -s specify the RPC URL of the L2 node
   
 Feel free to customize the container name as needed.
 
 ### Arcology L2 Rollup
 
 Now the L1 is up and running, move on to the **second machine** to start the Arcology rollup.
 Assuming your L1 docker container will be running on 192.168.1.108.
 
 ``` shell
	 devnet> docker build -t arcology-dev:v1 .
	 devnet> docker run -itd --name l2 -p 8545:8545 arcology-dev:v1 -f http://192.168.1.108:7545 -s http://192.168.1.108:8545 
 ```
 >> The whole process will take a few minutes to complete. So please be patient.


## Check Network Status

Log in to the docker container running the L2 network. 

```shell
    devnet> docker exec -it l2 /bin/bash
```

On the machine, run the following command to check the network status:

```shell
    cd op/sdk/node_modules/@arcologynetwork/frontend-tools
    nodejs tools/network-monitor.js http://192.168.1.108:8545 
```

