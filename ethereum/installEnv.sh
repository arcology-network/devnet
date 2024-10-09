#!/usr/bin/env bash

sudo chmod 755 geth beacon-chain prysmctl validator

sudo apt install -y jq
sudo apt install -y curl
./node.sh