# devnet
- [devnet](#devnet)
  - [1. Overview](#1-overview)
    - [1.1. Quick Start](#11-quick-start)
    - [1.2. Installation Package](#12-installation-package)
    - [1.3. Internal Structure](#13-internal-structure)
  - [2. Getting Started](#2-getting-started)
    - [2.1. Requirements](#21-requirements)
    - [2.2. Workflow](#22-workflow)
    - [2.3. Download the Package](#23-download-the-package)
  - [3. Install Ethereum L1](#3-install-ethereum-l1)
  - [4. Install L2](#4-install-l2)
    - [4.1. Install Environment](#41-install-environment)
    - [4.2. Set Environment Variables](#42-set-environment-variables)
    - [4.3. Load the Variables](#43-load-the-variables)
    - [4.4. Configure Installation](#44-configure-installation)
    - [4.5. Deploy Contracts to L1](#45-deploy-contracts-to-l1)
    - [4.6. Generate Installation Configuration Files](#46-generate-installation-configuration-files)
  - [5. Start L2](#5-start-l2)
    - [5.1. Start Arcology Node](#51-start-arcology-node)
    - [5.2. Start op-node](#52-start-op-node)
    - [5.3. Start op-batcher](#53-start-op-batcher)
    - [5.4. Start op-proposer](#54-start-op-proposer)

## 1. Overview

This repository contains the binaries, scripts, and configuration files necessary to run a local development network for a development environment for Arcology Network. This network is intended to be used for testing and development purposes only. The network is configured to use a single node, and is not intended to be used for testing validator functionality. 

For more information about Arcology Network, please visit [Arcology Network](https://doc.arcology.network/).

### 1.1. Quick Start

There is a **docker image option** aviailable please check **[this document]()** for more information

### 1.2. Installation Package

This is an **all-in-one** package for running a local development network. Once installed, the network will be running on your local machine. The package contains the following major components:

- An Ethereum L1 
- An Optimism bridge
- An Arcology parallel execution node

### 1.3. Internal Structure

The installation package contains the following files and directories:

| Name         | Description                                   |
|--------------|---------------------------------------------- |
| L1           | This directory contains the files for the Ethereum L1 node.  |
| L2           | L2: This directory contains the files for the Optimism bridge and Arcology parallel execution node. |
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


## 2. Getting Started

You will also need to have **two machines**, either physical or virtual, to run the development network. One machine will be used to run the L1 and the other will be used to run the Arcology parallel execution node and Optimism bridge,. The two machines must be able to communicate with each other over the network.

- **Machine 1:** Ethereum L1  
- **Machine 2:** Optimism bridge and Arcology parallel execution node

### 2.1. Requirements

- 16GB RAM
- 4 CPU cores
- 100GB disk space
- Ubuntu 20.04 or later

### 2.2. Workflow

![](/l1-l2.png)

### 2.3. Download the Package

Download the package first then follow the steps below to install and run the development network.

```shell
  > git clone https://github.com/arcology-network/devnet.git
```

## 3. Install Ethereum L1

The Ethereum L1 needs to be set up first. The package comes with a script with the necessary commands to install the L1. The installation script does the following things:

- Install Environment for the L1
- Start the the Ethereum L1 node
- Deploy a proxy contract for the Optimism bridge

 Please execute the following command to call the script. The following steps are performed on the **machine** where the L1 is installed.

  ```shell
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

  
