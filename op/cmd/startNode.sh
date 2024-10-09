#!/usr/bin/env bash


./bin/op-node \
        --l1.beacon=$L1_BEACON_URL \
        --l2=http://localhost:8551 \
        --l2.jwt-secret=./jwt.txt \
        --sequencer.enabled \
        --sequencer.l1-confs=5 \
        --verifier.l1-confs=4 \
        --rollup.config=./rollup.json \
        --rpc.addr=0.0.0.0 \
        --p2p.disable \
        --rpc.enable-admin \
        --p2p.sequencer.key=$GS_SEQUENCER_PRIVATE_KEY \
        --l1=$L1_RPC_URL \
        --l1.rpckind=$L1_RPC_KIND