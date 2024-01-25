# devnet

This repository contains the binaries, scripts, and configuration files necessary to run a local development network for a development environment for Arcology Network. This network is intended to be used for testing and development purposes only. The network is configured to use a single node, and is not intended to be used for testing validator functionality. 

For more information about, please visit [Arcology Network](https://doc.arcology.network/).

## Overview

This is an all-in-one package for running a local development network. Once installed, the network will be running on your local machine. The package contains the following major components:

- An Ethereum L1 
- An Optimism bridge
- An Arcology parallel execution node

| Name         | Description                                   |
|--------------|---------------------------------------------- |
| L1           | -                                             |
| L2           | -                                             |
| README.md    | Documentation file for the project.           |
| bin          | Directory for binary/executable files.        |
| cmd          | Directory for command-related files.          |
| env          | Directory for environment-related files.      |
| foundry.toml | Configuration file for Foundry.               |
| install.sh   | Shell script for installing dependencies.     |
| lib          | Directory for library files.                  |
| scripts      | Directory for various scripts.                |
| sdk          | Software development kit.                     |
| src          | Source code directory.                        |
| start.sh     | Shell script for starting the project.        |
| stop.sh      | Shell script for stopping the project.        |
| test         | Directory for testing-related files.          |


## Requirements

Besides the hardware and software requirements listed below, you will also need to have two machines, either physical or virtual, to run the development network. One machine will be used to run the L1 and Optimism bridge, and the other will be used to run the Arcology parallel execution node. The two machines must be able to communicate with each other over the network.

- **Machine 1:** L1 and Optimism bridge
- **Machine 2:** Arcology parallel execution node

### 1. Hardware:

- 8GB RAM
- 4 CPU cores
- 100GB disk space

### 2. Software:

- Ubuntu 20.04
- Docker 20.10.7

## Getting Started

Please follow the steps below to install and run the development network.

### Download the Package

  ```shell
  > git clone https://github.com/arcology-network/devnet.git
  ```

### Install Ethereum L1

Copy package L1 to a machine and execute the following command to install the L1 run environment. The following steps are performed on the **machine** where the L1 will be installed.

  ```shell
  >cd L1
  L1>./insJq.sh
  ```

### Start the L1 

  ```shell
  L1>./start.sh
  ```

###  Install L2

On the second machine, install the L2 related files. The L2 environment includes a standard Optimism bridge and an Arcology parallel execution node. The following steps are performed on the machine where the L1 is located. Close the current terminal window once the installation is completed.

```shell
  devnet>install.sh -p X.X.X.X    # Your local IP
```

### Edit the Configuration 

There is a configuration file in the root directory of the package, which contains the configuration information of the L1 and L2. You need to modify the configuration file based on the actual situation. The following is the configuration file content:

file .envrc

  ```shell
  ##################################################
  #                 Getting Started                #
  ##################################################
  
  # Admin account   
  export GS_ADMIN_ADDRESS=0xd5355603c407B6688fd0F995D8c4F98DD3a91aF5
  export GS_ADMIN_PRIVATE_KEY=0x29ca9bc036a8f88c2aa3d57969b508189094f4814e01f4969c49250fecfe3e04
  
  # Batcher account
  export GS_BATCHER_ADDRESS=0xdA97064cF66aF12dB62FEf7d713C4B8e546c4F1A
  export GS_BATCHER_PRIVATE_KEY=0x33d3f3d2901c352676dc5ff20e47504ee2887f9f3861e3b4d867f1624df25d15
  
  # Proposer account
  export GS_PROPOSER_ADDRESS=0xD78e8f9BD1298685058CDf5855A3196cfd78e3E1
  export GS_PROPOSER_PRIVATE_KEY=0x9e3eced2d5f21136c6caa556597d92d204c1d4fceb57f3f82e2aa02b8dcf8459
  
  # Sequencer account
  export GS_SEQUENCER_ADDRESS=0x9FB59A1Ece686F251b18C9E683ed3B5A2CEF3352
  export GS_SEQUENCER_PRIVATE_KEY=0x13cb25b1ef0e5e60c434d15b51d0e566f8778a53772f1028dc0445c7d222ce33
  
  ##################################################
  #              op-node Configuration             #
  ##################################################
  
  # The kind of RPC provider, used to inform optimal transactions receipts
  # fetching. Valid options: alchemy, quicknode, infura, parity, nethermind,
  # debug_geth, erigon, basic, any.
  export L1_RPC_KIND=basic
  
  ##################################################
  #               Contract Deployment              #
  ##################################################
  
  # RPC URL for the L1 network to interact with
  export L1_RPC_URL=http://192.168.230.137:7545 
  
  # Salt used via CREATE2 to determine implementation addresses
  # NOTE: If you want to deploy contracts from scratch you MUST reload this
  #       variable to ensure the salt is regenerated and the contracts are
  #       deployed to new addresses (otherwise deployment will fail)
  export IMPL_SALT=$(openssl rand -hex 32)
  
  # Name for the deployed network
  export DEPLOYMENT_CONTEXT=getting-started
  
  # Optional Tenderly details for simulation link during deployment
  export TENDERLY_PROJECT=
  export TENDERLY_USERNAME=
  
  # Optional Etherscan API key for contract verification
  export ETHERSCAN_API_KEY=
  
  # Private key to use for contract deployments, you don't need to worry about
  # this for the Getting Started guide.
  export PRIVATE_KEY=
  
  ```

  L1_RPC_URL is changed to the L1 node IP

## Start the L2

You are now ready to start the L2. Start a new shell instance, and load the system variables by executing the following instructions. The following steps are performed on the **machine** where the L2 is installed. The network should be started in the following order:

###  Configure L2 Environment

```shell
  > cd devnet
  devnet> direnv allow
```

After running `direnv allow` you should see output that looks something like the following (the exact output will vary depending on the variables you've set, don't worry if it doesn't look exactly like this):

```shell
  direnv: loading ~/optimism/.envrc                                                            
  
  direnv: export +DEPLOYMENT_CONTEXT +ETHERSCAN_API_KEY +GS_ADMIN_ADDRESS +GS_ADMIN_PRIVATE_KEY +GS_BATCHER_ADDRESS +GS_BATCHER_PRIVATE_KEY +GS_PROPOSER_ADDRESS +GS_PROPOSER_PRIVATE_KEY +GS_SEQUENCER_ADDRESS +GS_SEQUENCER_PRIVATE_KEY +IMPL_SALT +L1_RPC_KIND +L1_RPC_URL +PRIVATE_KEY +TENDERLY_PROJECT +TENDERLY_USERNAME
```

### Start Arcology Node

The final step is to start the Arcology node. The following steps are performed on the **machine** where the Arcology is installed.

```shell
  devnet> ./start.sh
```

### Start op-node

```shell
  devnet> ./cmd/02-startNode.sh
```

###  Start op-batcher

```shell
  devnet> ./cmd/03-startBatcher.sh
```

###  Start op-proposer

```shell
  devnet> ./cmd/04-startProposer.sh
```

  
