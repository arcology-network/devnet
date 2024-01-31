#!/usr/bin/env bash

confile=sdk/address.json


variable=$(cat deployments/getting-started/AddressManager.json | jq -r .address); jq --arg variable "$variable" '.L1.AddressManager = $variable' $confile > tmp.json && mv tmp.json $confile
variable=$(cat deployments/getting-started/L1CrossDomainMessengerProxy.json | jq -r .address); jq --arg variable "$variable" '.L1.L1CrossDomainMessenger = $variable' $confile > tmp.json && mv tmp.json $confile
variable=$(cat deployments/getting-started/L1StandardBridgeProxy.json | jq -r .address); jq --arg variable "$variable" '.L1.L1StandardBridge = $variable' $confile > tmp.json && mv tmp.json $confile
variable=$(cat deployments/getting-started/OptimismPortalProxy.json | jq -r .address); jq --arg variable "$variable" '.L1.OptimismPortal = $variable' $confile > tmp.json && mv tmp.json $confile
variable=$(cat deployments/getting-started/L2OutputOracleProxy.json | jq -r .address); jq --arg variable "$variable" '.L1.L2OutputOracle = $variable' $confile > tmp.json && mv tmp.json $confile

