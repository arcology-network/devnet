#!/usr/bin/env bash
. ./cli/show.sh

while getopts m: OPT; do
 case ${OPT} in
  m) multinode=${OPTARG}
    ;;
  \?)
    printf "[Usage] stop.sh -m <Multinode>\n" >&2
    exit 1
 esac
done 

if [ "${multinode}" == "" ]
then
  echo "please input run type ( -r Multinode:true or false)"
  exit 1
fi

setlogfile

title "[ Stop OP Bridge ]"

text "Kill op-proposer ..."
pkill -9 op-proposer >> ${logfile}_stop 2>&1
text "OK" 1

text "Kill op-batcher ..."
pkill -9 op-batcher >> ${logfile}_stop 2>&1
text "OK" 1

text "Kill op-node ..."
pkill -9 op-node >> ${logfile}_stop 2>&1
text "OK" 1

text "Clear run environment ..."
rm -Rf op/jwt.txt
rm -Rf op/genesis.json
rm -Rf op/rollup.json
rm -Rf op/deploy-config/*
rm -Rf op/deployments/*
text "OK" 1

title "[ Stop Arcology ]"
cd arcology
./bin/stop.sh ${multinode}

title "[ System Stopped ]"
text "Refer to the log file( ${logfile}_stop ) for details" 1
echo
