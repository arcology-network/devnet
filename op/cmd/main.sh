#!/usr/bin/env bash
. ../cli/show.sh


title "[ Starting Create Configuration File ]"

text "Generate Deploy Configuration File ..."

./cmd/generateDefaultOPConfig.sh >> ${logfile}_config 2>&1

text "Ok" 1

./cmd/deployL1Contracts.sh  >> ${logfile}_config 2>&1

./cmd/generateConfigs.sh >> ${logfile}_config 2>&1

./cmd/generateAddressConfig.sh >> ${logfile}_config 2>&1
./cmd/generateNetwork.sh >> ${logfile}_config 2>&1
