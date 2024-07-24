#!/bin/bash
. ../cli/show.sh

text "Stop arcology ..."
pkill -9 arcology  >> ${logfile}_stop 2>&1
text "OK" 1
#pkill -9 frontend-svc
text "Clear arcology Run Environment..."
rm -Rf ./arcology/* ~/arcology/main/log  >> ${logfile}_stop 2>&1
text "OK" 1

text "Stop kafka..."
sleep 3

./kafka/kafka/stop.sh  >> ${logfile}_stop 2>&1

sleep 3

./kafka/kafka/stop.sh  >> ${logfile}_stop 2>&1
text "OK" 1
