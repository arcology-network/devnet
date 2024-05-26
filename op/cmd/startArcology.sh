#!/usr/bin/env bash

confpath=../arcology/configs

cp jwt.txt $confpath/jwt.txt
cp genesis.json $confpath/genesis.json

cd ../arcology
./bin/start.sh $1
