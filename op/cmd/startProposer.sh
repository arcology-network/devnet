#!/usr/bin/env bash

./bin/op-proposer \
        --poll-interval=12s \
        --rpc.port=8560 \
        --rollup-rpc=http://localhost:9545 \
        --l2oo-address=$(cat ./deployments/getting-started/.deploy | jq -r .L2OutputOracleProxy) \
        --private-key=$GS_PROPOSER_PRIVATE_KEY \
        --l1-eth-rpc=$L1_RPC_URL \
        --allow-non-finalized=true \
        --log.level=debug

