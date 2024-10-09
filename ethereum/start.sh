#!/usr/bin/env bash
. ./show.sh

mkdir -p log
gethlog=log/geth.log

title "[ Starting Ethereum ]"

text "Start Geth ..."
nohup ./prysmctl testnet generate-genesis --fork capella --num-validators 3 --genesis-time-delay 10 --chain-config-file config.yml --geth-genesis-json-in genesis.json  --geth-genesis-json-out genesis.json --output-ssz genesis.ssz  >> $gethlog 2>&1 &
sleep 2
(echo "111111"; echo "111111") | nohup ./geth --datadir=gethdata account import secret.txt >> $gethlog 2>&1 &
sleep 3
nohup ./geth --datadir=gethdata init genesis.json >> $gethlog 2>&1 &
sleep 2
nohup ./geth --http --http.api eth,net,web3  --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata --nodiscover --syncmode full --allow-insecure-unlock --unlock 0x123463a4b065722e99115d6c222f267d9cabb524 --password pwd.txt --http.port 7545 --http.corsdomain="*" --http.addr "0.0.0.0"  --rpc.allow-unprotected-txs >> $gethlog 2>&1 &
sleep 5
text "OK" 1

text "Start Beacon ..."
beaconlog=log/beacon.log
nohup ./beacon-chain --datadir beacondata --grpc-gateway-host 0.0.0.0  --min-sync-peers 0 --genesis-state genesis.ssz --bootstrap-node= --interop-eth1data-votes --chain-config-file config.yml --contract-deployment-block 0 --chain-id 100 --accept-terms-of-use --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 --minimum-peers-per-subnet 0 --enable-debug-rpc-endpoints --execution-endpoint gethdata/geth.ipc >> $beaconlog 2>&1 &
sleep 10
text "OK" 1

text "Start validator ..."
validatorlog=log/validator.log
nohup ./validator --datadir validatordata --accept-terms-of-use --interop-num-validators 3 --chain-config-file config.yml >> $validatorlog 2>&1 &
sleep 5
text "OK" 1

title "[ System Started ]"
text "Refer to the log file( $gethlog, $beaconlog, $validatorlog) for details" 1
echo

/bin/bash
