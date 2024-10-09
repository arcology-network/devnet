#!/usr/bin/env bash
. ../cli/show.sh

text "Create Configuration File genesis.json and rollup.json ...   "

forge script scripts/L2Genesis.s.sol:L2Genesis --sig 'runWithStateDump()' --rpc-url $L1_RPC_URL

bin/op-node genesis l2 --deploy-config deploy-config/getting-started.json \
    --l1-deployments deployments/getting-started/.deploy --l2-allocs state-dump-118.json \
	--outfile.l2 genesis.json --outfile.rollup rollup.json --l1-rpc $L1_RPC_URL 
text "Ok" 1

text "Create Configuration File jwt.txt ...   "
openssl rand -hex 32 > jwt.txt 
text "Ok" 1

confpath=../arcology/configs

cp jwt.txt $confpath/jwt.txt
cp genesis.json $confpath/genesis.json