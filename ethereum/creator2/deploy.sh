#!/bin/sh

set -x

depPath=creator2/deployment.json

# extract the variables we need from json output
TRANSACTION="0x$(cat $depPath | jq --raw-output '.transaction')"

L1_RPC_URL=http://localhost:7545

# deploy the deployer contract
curl $L1_RPC_URL -X 'POST' -H 'Content-Type: application/json' --data "{\"jsonrpc\":\"2.0\", \"id\":1, \"method\": \"eth_sendRawTransaction\", \"params\": [\"$TRANSACTION\"]}"

