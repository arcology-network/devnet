#!/usr/bin/env bash

keyfile=../configs/keys.txt
confile=../configs/genesis.json
while read line
do
	#echo $line
	cols=(${line//,/ })
	key=${cols[1]}		#address
	val=0x${cols[2]}	#balance
	jq --arg k "$key" --arg v "$val" '.alloc[ $k ] = {"balance": $v}' $confile > tmp.json && mv tmp.json $confile
done  < $keyfile

