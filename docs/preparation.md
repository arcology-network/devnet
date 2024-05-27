### Clone the Repository

```shell
> git clone https://github.com/arcology-network/devnet.git
```

### Install the Dependencies

In the devnet directy run the following command to download the dependencies:

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