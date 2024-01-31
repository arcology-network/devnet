#!/usr/bin/env bash
. ./cli/show.sh

while getopts p: OPT; do
 case ${OPT} in
  p) localIp=${OPTARG}
    ;;
  \?)
    printf "[Usage] `date '+%F %T'` -p <localIp>>\n" >&2
    exit 1
 esac
done 

if [ "${localIp}" == "" ]
then
  echo "please input local IP ( -p X.X.X.X)"
  exit 1
fi

setlogfile

#echo $localIp

title "[ Starting Install Run Environment ]"

sudo chmod 755 op/bin/*
sudo chmod 755 op/cmd/*
sudo chmod 755 op/env/*
sudo chmod 755 arcology/bin/*
sudo chmod 755 ethereum/*

cd op/env
./installEnv.sh

cd ../sdk
text "Installing yarn ..."
./installEnv.sh >> $logfile 2>&1
text "OK" 1

cd ../../arcology
./bin/installEnv.sh $localIp  #$1 is localIP

title "[ Run Environment Installed ]"
text "Refer to the log file( $logfile ) for details" 1
echo
