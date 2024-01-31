#!/usr/bin/env bash

confile=deployments/getting-started/L1CrossDomainMessengerProxy.json

#jq '.args = ["0x363c9413c03901aA327d250d819237DE6b0280dd","OVM_L1CrossDomainMessenger"]' $confile > tmp.json && mv tmp.json $confile

jsonStr=$(jq '.args' $confile | sed 's/\\//g' )
jsonObj=$(echo ${jsonStr:1:-1})  ; jq --argjson arrs $jsonObj '.args = $arrs' $confile > tmp.json && mv tmp.json $confile
