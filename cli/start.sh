#!/usr/bin/env bash
. ./cli/show.sh

while getopts f:s: OPT; do
 case ${OPT} in
  f) l1rpc=${OPTARG}
    ;;
  s) l2rpc=${OPTARG}
    ;;
  \?)
    printf "[Usage] `date '+%F %T'` -l1 <L1_RPC_URL> -l2 <L2_RPC_URL>\n" >&2
    exit 1
 esac
done 

if [ "${l1rpc}" == "" ]
then
  echo "please input l1 rpc url ( -l1 http://ip:port)"
  exit 1
fi

if [ "${l2rpc}" == "" ]
then
  echo "please input l2 rpc url ( -l2 http://ip:port)"
  exit 1
fi

setlogfile

cd op


#################################################################################################

echo export L1_RPC_URL=$l1rpc >> ~/.bashrc
echo export L2_RPC_URL=$l2rpc >> ~/.bashrc

./cmd/envs.sh

eval "$(cat ~/.bashrc | tail -n +10)"
source ~/.bashrc

#################################################################################################

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

/bin/bash