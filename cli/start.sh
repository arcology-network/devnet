#!/usr/bin/env bash
. ./cli/show.sh

while getopts f:s:r:m: OPT; do
 case ${OPT} in
  f) l1rpc=${OPTARG}
    ;;
  s) l2rpc=${OPTARG}
    ;;
  r) runasl1=${OPTARG}
    ;;
  m) multinode=${OPTARG}
    ;;
  \?)
    printf "[Usage] start.sh -f <L1_RPC_URL> -s <L2_RPC_URL> -r <RunAsL1> -m <Multinode>\n" >&2
    exit 1
 esac
done 

if [ "${l1rpc}" == "" ]
then
  echo "please input l1 rpc url ( -f http://ip:port)"
  exit 1
fi

if [ "${l2rpc}" == "" ]
then
  echo "please input l2 rpc url ( -s http://ip:port)"
  exit 1
fi

if [ "${runasl1}" == "" ]
then
  echo "please input run mode ( -r RunAsL1:true or false)"
  exit 1
fi

if [ "${multinode}" == "" ]
then
  echo "please input run type ( -r Multinode:true or false)"
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

if [ "${runasl1}" == "false" ]
then
  ./cmd/main.sh
fi

title "[ Start L2 Node ]"


./cmd/startArcology.sh ${runasl1} ${multinode}

sleep 20

if [ "${runasl1}" == "false" ]
then
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
fi
/bin/bash