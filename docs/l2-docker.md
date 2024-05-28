## Docker Deployment

It is recommended to use docker containers to deploy the development network for Arcology. This document guides you through the process of setting up an Arcology devNet using docker containers.

### Start Ethereum L1

 First we need to build and start the Ethereum L1 container, then move on to the Optimism bridge and Arcology parallel execution node.
 
 ``` shell
	 devnet> cd ethereum
	 ethereum> sudo docker build -t eth:v1 .
	 ethereum> sudo docker run -itd --name ethv1 -p 7545:7545 eth:v1
 ```
 >> Make sure you have the docker engine installed on your machine. If not, please install it first.

  - --name specifies the container ID
 - -f indicates the RPC URL of the L1 node
 - -s specify the RPC URL of the L2 node
   
>> Feel free to customize the container name as needed.
 
 ### Start Arcology L2 Rollup
 
 Now the L1 is up and running, move on to starting the second container for the Arcology rollup.
 Assuming your host machine address is `192.168.174.132`.  
 Under the the **devnet directory**, run the following commands:

>> Please change the IP address as needed.

 ``` shell
 	ethereum> cd ..
	devnet> sudo docker build -t arcology-dev:v1 .
	devnet> sudo docker run -itd --name l2 -p 8545:8545 arcology-dev:v1 -f http://192.168.174.132:7545 -s http://192.168.174.132:8545 -r false
	devnet> sudo docker attach l2
 ```
 >>  :warning: The whole process may take **10 ~ 20 minutes** to complete. So please be patient.
