# devnet

This repository contains the binaries, scripts, and configuration files necessary to run a local development network for a development environment for Arcology Network. This network is intended to be used for testing and development purposes only. The network is configured to use a single node, and is not intended to be used for testing validator functionality. For more information about Arcology Network, please visit [Arcology Network](https://doc.arcology.network/).

## Package Structure

This is an **all-in-one** package for running a development network for Arcology. Once installed, the network will be running on your local machine. The installation package contains the following files and directories:

| Name         | Description                                   |
|--------------|---------------------------------------------- |
| L1           | This directory contains the files for the Ethereum L1 node.  |
| L2           | L2: This directory contains the files for the Optimism bridge and Arcology parallel execution node. |
| README.md    | Documentation file for the project.           |
| bin          | Directory for binary/executable files.        |
| cmd          | Directory for cli-related files.          |
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


## Minimum Requirements

- 16GB RAM
- 4 CPU cores
- 100GB disk space
- Ubuntu 20.04 or later
- [Docker engine](https://docs.docker.com/engine/install/ubuntu/)
- Git

## Network Setup

An Arcology DevNet can be initiated as either a Layer 1 or an Ethereum Layer 2 rollup network, depending on the requirements. 

- [L1 setup](./docs/l1.md)
- [L2 Rollup setup](./docs/l2.md)

## License

Arcology's concurrent lib is made available under the MIT License, which disclaims all warranties in relation to the project and which limits the liability of those that contribute and maintain the project. You acknowledge that you are solely responsible for any use of the Contracts and you assume all risks associated with any such use.

