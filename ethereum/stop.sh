#!/usr/bin/env bash
pkill -9 geth
pkill -9 beacon-chain
pkill -9 validator
rm -Rf log validatordata gethdata beacondata genesis.ssz genesis.json
cp genesis-bak.json genesis.json



