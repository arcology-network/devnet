#!/usr/bin/env bash
. ../cli/show.sh

text "Create Configuration File genesis.json and rollup.json ...   "
bin/op-node genesis l2 --deploy-config deploy-config/getting-started.json \
	--deployment-dir deployments/getting-started/ \
	--outfile.l2 genesis.json --outfile.rollup rollup.json --l1-rpc $L1_RPC_URL  >> ${logfile}_config 2>&1
text "Ok" 1

text "Create Configuration File jwt.txt ...   "
openssl rand -hex 32 > jwt.txt 
text "Ok" 1

confpath=../arcology/configs

cp jwt.txt $confpath/jwt.txt
cp genesis.json $confpath/genesis.json