##################################################
#                 Getting Started                #
##################################################


# Admin account
echo export GS_ADMIN_ADDRESS=0xd5355603c407B6688fd0F995D8c4F98DD3a91aF5 >> ~/.bashrc
echo export GS_ADMIN_PRIVATE_KEY=0x29ca9bc036a8f88c2aa3d57969b508189094f4814e01f4969c49250fecfe3e04 >> ~/.bashrc

# Batcher account
echo export GS_BATCHER_ADDRESS=0xdA97064cF66aF12dB62FEf7d713C4B8e546c4F1A >> ~/.bashrc
echo export GS_BATCHER_PRIVATE_KEY=0x33d3f3d2901c352676dc5ff20e47504ee2887f9f3861e3b4d867f1624df25d15 >> ~/.bashrc

# Proposer account
echo export GS_PROPOSER_ADDRESS=0xD78e8f9BD1298685058CDf5855A3196cfd78e3E1 >> ~/.bashrc
echo export GS_PROPOSER_PRIVATE_KEY=0x9e3eced2d5f21136c6caa556597d92d204c1d4fceb57f3f82e2aa02b8dcf8459 >> ~/.bashrc

# Sequencer account
echo export GS_SEQUENCER_ADDRESS=0x9FB59A1Ece686F251b18C9E683ed3B5A2CEF3352 >> ~/.bashrc
echo export GS_SEQUENCER_PRIVATE_KEY=0x13cb25b1ef0e5e60c434d15b51d0e566f8778a53772f1028dc0445c7d222ce33 >> ~/.bashrc

##################################################
#                Chain Information               #
##################################################

# L1 chain information
echo export L1_CHAIN_ID=100 >> ~/.bashrc
echo export L1_BLOCK_TIME=12 >> ~/.bashrc

# L2 chain information
echo export L2_CHAIN_ID=118 >> ~/.bashrc
echo export L2_BLOCK_TIME=2 >> ~/.bashrc


##################################################
#              op-node Configuration             #
##################################################

# The kind of RPC provider, used to inform optimal transactions receipts
# fetching. Valid options: alchemy, quicknode, infura, parity, nethermind,
# debug_geth, erigon, basic, any.
echo export L1_RPC_KIND=basic >> ~/.bashrc

##################################################
#               Contract Deployment              #
##################################################

# RPC URL for the L1 network to interact with
#export L1_RPC_URL=http://192.168.230.137:7545

# Salt used via CREATE2 to determine implementation addresses
# NOTE: If you want to deploy contracts from scratch you MUST reload this
#       variable to ensure the salt is regenerated and the contracts are
#       deployed to new addresses (otherwise deployment will fail)
echo export IMPL_SALT=$(openssl rand -hex 32) >> ~/.bashrc

# Name for the deployed network
echo export DEPLOYMENT_CONTEXT=getting-started >> ~/.bashrc

# Optional Tenderly details for simulation link during deployment
#export TENDERLY_PROJECT=
#export TENDERLY_USERNAME=

# Optional Etherscan API key for contract verification
#export ETHERSCAN_API_KEY=

# Private key to use for contract deployments, you don't need to worry about
# this for the Getting Started guide.
#export PRIVATE_KEY=

#addtional

echo export DEPLOY_CONFIG_PATH=./deploy-config/getting-started.json >> ~/.bashrc

#export L1_BEACON_URL=http://192.168.230.128:3500