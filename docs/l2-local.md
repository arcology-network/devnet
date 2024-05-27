## Local Deployment

You will also need to have **two machines**, either **physical or virtual**, to run the development network. One machine will be used to run the L1 and the other will be used to run the Arcology parallel execution node and Optimism bridge. The two machines must be able to communicate with each other over the network.

- **Machine 1:** Ethereum L1  
- **Machine 2:** Optimism bridge and Arcology parallel execution node

### 1. Preparation

On both machines, install the [the dependencies](./preparation.md) first.

### 2. Start Ethereum L1

The Ethereum L1 needs to be set up first. Execute the following commands the **first machine** where the L1 is going to run.

```shell
  devnet> cd ethereum
  ethereum> ./installEnv.sh
  ethereum> ./start.sh
```

The installation script does the following things:

- Install Environment for the L1
- Start the the Ethereum L1 node
- Deploy a proxy contract for the Optimism bridge

Now the L1 is ready to be used and produces empty blocks.

###  3. Start Arcology as L2

Now move on to the **second machine** to start the L2 network. Assuming the first machine's IP is `192.168.1.107` and the second is `192.168.1.108`.

```shell
  devnet> ./cli/install.sh -p 192.168.1.108 
  devnet> ./cli/start.sh -f http://192.168.1.107:7545 -s http://192.168.1.108:8545 -r false
```