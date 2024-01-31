#!/usr/bin/env bash

confile=deploy-config/getting-started.json

jq --argjson l1ChainId $L1_ChainId '.l1ChainID = $l1ChainId' $confile > tmp.json && mv tmp.json $confile
jq --argjson l2ChainId $L2_ChainId '.l2ChainID = $l2ChainId' $confile > tmp.json && mv tmp.json $confile
