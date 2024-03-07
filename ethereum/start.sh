#!/usr/bin/env bash
. ./show.sh

logfile=geth.log

title "[ Starting Ethereum ]"

text "Init Geth ..."
./geth --datadir data init genesis.json >> $logfile 2>&1
sleep 10
text "OK" 1

text "Start Geth ..."
nohup ./geth --datadir data --http --http.corsdomain="*" --rpc.allow-unprotected-txs --http.port 7545 --http.addr "0.0.0.0" --http.api web3,eth,debug,personal,net,miner,admin  --mine --miner.threads=1 --miner.etherbase="0xa75Cd05BF16BbeA1759DE2A66c0472131BC5Bd8D"  --nodiscover --verbosity 5 --allow-insecure-unlock >> $logfile 2>&1 &
sleep 10
text "OK" 1

text "Deploy Smart Contract Creator2 ..."
./creator2/deploy.sh >> $logfile 2>&1
text "OK" 1

title "[ System Started ]"
text "Refer to the log file( $logfile ) for details" 1
echo

/bin/bash