#!/bin/bash
. ../cli/show.sh

text "Start kafka ..."
#start kafka
cd kafka/kafka
./start.sh >> ${logfile}_arcology 2>&1 & 
sleep 10
text "OK" 1

text "Create topics for  kafka ..."
./maketopic.sh >> ${logfile}_arcology 2>&1 & 
sleep 10
text "OK" 1

text "Create path for  zookeeper ..."
./createpath.sh >> ${logfile}_arcology 2>&1 & 
sleep 10
text "OK" 1


text "Start Arcology ..."
#start monco
cd ../../bin
#./import_keys.sh >> ${logfile}_arcology 2>&1 & 
#sleep 10
./arcology init >> ${logfile}_arcology 2>&1 & 
sleep 10
./arcology start --global=../configs/global.json --kafka=../configs/kafka-nil.json --app=../configs/arcology.json >> ${logfile}_arcology 2>&1 & 
sleep 10
text "OK" 1
