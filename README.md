# devnet

This repository contains the binaries, scripts, and configuration files necessary to run a local development network for a development environment for Arcology Network. The easiest way to deploy the Arcology L2 network is to use docker images provided by the Arcology team, which can be downloaded directly from the docker hub. This document guides you through the step of building the Arcology L2 docker image. It is only intended for more advanced users who want to build the docker image themselves.

The network is configured to use a single node, and is not intended to be used for testing validator functionality. For more information about Arcology Network, please visit [Arcology Network](https://doc.arcology.network/).

## 1. Overview

This is an **all-in-one** package for running a development network for Arcology. Once installed, the network will be running on your local machine. 

### 1.1. Package Structure

The installation package contains the following files and directories:

| Name         | Description                                   |
|--------------|---------------------------------------------- |
| L1           | This directory contains the files for the Ethereum L1 node.  |
| L2           | L2: This directory contains the files for the Optimism bridge and Arcology parallel execution node. |
| README.md    | Documentation file for the project.           |
| bin          | Executable files.        |
| cmd          | Directory for cli-related files.          |
| env          | Environment files.      |
| foundry.toml | Configuration file for Foundry.               |
| install.sh   | Shell script for installing dependencies.     |
| lib          | Directory for library files.                  |
| scripts      | Directory for various scripts.                |
| sdk          | Software development kit.                     |
| src          | Source code directory.                        |
| start.sh     | Shell script for starting the project.        |
| stop.sh      | Shell script for stopping the project.        |
| test         | For testing-related files.          |

### 1.2. Minimum Requirements

- 16GB RAM
- 4 CPU cores
- 100GB disk space
- Ubuntu 24.04 or later
- [Docker engine](https://docs.docker.com/engine/install/ubuntu/)
- Git

## 2. Preparation

Before initiating the devnet setup on the host machine, first install the necessary dependencies.

### 2.1. Clone the Repository

Clone the repository to the machines where you want to run the devnet:

```shell
> git clone https://github.com/arcology-network/devnet.git
```

### 2.2. Install the Dependencies

In the devnet directy run the following command to download the dependencies for both the L1 setup and the L2 setup:

```shell
    > cd devnet
    devnet> ./cli/download.sh -v 2.0.0
```

The script will place the following files in the directory:

- devnet/arcology/bin/arcology
- devnet/ethereum/geth
- devnet/op/bin/op-batcher
- devnet/op/bin/op-proposer
- devnet/op/bin/op-node

>> You can also compile the source code yourself and place it in the specified directory.

## 3. Network Setup

An Arcology DevNet can be initiated as either an EVM equivalent Layer 1 or an Ethereum Layer 2 rollup network, depending on the requirements. In this L2 mode, Arcology's role becomes a parallel execution layer scaling Ethereum. Arcology's role becomes a parallel execution layer scaling Ethereum.

- [L1 setup](./docs/l1.md)
- [L2 Rollup setup](./docs/l2.md)

## 4. Working with the Network

Once the network is up and running, it is ready to be used. Since Arcology is fully compatible with Ethereum, you can use the standard
Ethereum tools and libraries to interact with the network. For For features unique to Arcology,like parallel programming, consider starting with the [example project](https://github.com/arcology-network/examples), which provides detailed guidance on how to engage with the network.

## License

Arcology's concurrent lib is made available under the MIT License, which disclaims all warranties in relation to the project and which limits the liability of those that contribute and maintain the project. You acknowledge that you are solely responsible for any use of the Contracts and you assume all risks associated with any such use.

