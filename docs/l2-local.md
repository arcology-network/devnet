## Local Deployment

You will also need to have **two machines**, either physical or virtual, to run a local development network. One machine will be used to run the L1 and the other will be used to run the Arcology parallel execution node and Optimism bridge,. The two machines must be able to communicate with each other over the network.

- **Machine 1:** Ethereum L1  
- **Machine 2:** Optimism bridge and Arcology parallel execution node

## 3. Install Ethereum L1

The Ethereum L1 needs to be set up first. The package comes with a script with the necessary commands to install the L1. The installation script does the following things:

- Install Environment for the L1
- Start the the Ethereum L1 node
- Deploy a proxy contract for the Optimism bridge

 Please execute the following command to call the script. The following steps are performed on the **machine** where the L1 is installed.

```shell
  L1>./start.sh
```
Now the L1 is ready to be used and produces empty blocks.

##  4. Install L2

Now move on to the second machine to install the L2 related files. The L2 includes:
- A standard Optimism bridge 
- An Arcology parallel execution node 

### 4.1. Install Environment

The following steps are performed on the machine where the L1 is located. 

```shell
  devnet>install.sh -p X.X.X.X    # Your local IP
```
>> Please make sure to close the current terminal window once the installation is completed.

### 4.2. Set Environment Variables

The environment file `.envrc` is located in the root directory of the package. It contains the environment configuration for the L1 and L2. Please modify the following parameters in the configuration file:

- **L1_RPC_URL** should be set to the IP address of the L1 machine

### 4.3. Load the Variables

The environment variables are loaded using [direnv](https://direnv.net/). If you don't have direnv installed, please install it first.

```shell
  > cd devnet
  devnet> direnv allow
```

You should see output that looks something like the following (the exact output will vary depending on the variables you've set, don't worry if it doesn't look exactly like this):

```shell
  direnv: loading ~/optimism/.envrc                                                            
  
  direnv: export +DEPLOYMENT_CONTEXT +ETHERSCAN_API_KEY +GS_ADMIN_ADDRESS +GS_ADMIN_PRIVATE_KEY +GS_BATCHER_ADDRESS +GS_BATCHER_PRIVATE_KEY +GS_PROPOSER_ADDRESS +GS_PROPOSER_PRIVATE_KEY +GS_SEQUENCER_ADDRESS +GS_SEQUENCER_PRIVATE_KEY +IMPL_SALT +L1_RPC_KIND +L1_RPC_URL +PRIVATE_KEY +TENDERLY_PROJECT +TENDERLY_USERNAME
```

### 4.4. Configure Installation

Generate a default OP configuration file containing the default values for the OP components. The script will generate a file named `getting-started.json`.

```shell
  devnet> ./cmd/config.sh
```

The default configuration file only contains the default values. The following command updates the chain ID fields in the file:

```shell
  devnet> ./cmd/chainID.sh
```

### 4.5. Deploy Contracts to L1

It is time to deploy the OP bridge contract to the Ethereum L1. The following command will deploy the L1 contracts to the L1 machine **from the L2 machine.**

```shell
  devnet> ./cmd/l1contracts.sh
```

### 4.6. Generate Installation Configuration Files

The following command will generate the configuration files base on the deployment context. 

```shell
  devnet> ./cmd/50-generateConfig.sh
```
The following files will be generated:

- `rollup.json` contains the configuration for the OP components
- `genesis.json` contains the genesis block for the Arcology parallel execution node
- `jwt.txt` contains the private key for the Arcology to authenticate the transactions received from the OP Node. 

## 5. Start L2

You are now ready to start the L2 network. **Start a new terminal**, and load the system variables by executing the following instructions on the **machine** for L2. 

### 5.1. Start Arcology Node

The final step is to start the Arcology node. The following steps are performed on the **machine** where the Arcology is installed.

```shell
  devnet> ./start.sh
```

### 5.2. Start op-node

```shell
  devnet> ./cmd/02-startNode.sh
```

###  5.3. Start op-batcher

```shell
  devnet> ./cmd/03-startBatcher.sh
```

###  5.4. Start op-proposer

```shell
  devnet> ./cmd/04-startProposer.sh
```