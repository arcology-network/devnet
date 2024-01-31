#!/usr/bin/env bash
. ./cli/show.sh

setlogfile

cd op
./cmd/main.sh


title "[ Start L2 Node ]"


./cmd/startArcology.sh

sleep 20


title "[ Start OP Bridge ]"


text "Starting OpNode ..."
./cmd/startNode.sh  >> ${logfile}_opNode 2>&1 & 
sleep 10
text "OK" 1



text "Starting opBatcher ..."
./cmd/startBatcher.sh  >> ${logfile}_opBatcher 2>&1 & 
sleep 10
text "OK" 1



text "Starting opProposer ..."
./cmd/startProposer.sh  >> ${logfile}_opProposer 2>&1 & 
sleep 10
text "OK" 1

title "[ System Started ]"
text "Refer to the log file( ${logfile}_config,${logfile}_arcology,${logfile}_opNode,${logfile}_opBatcher,${logfile}_opProposer ) for details" 1
echo

