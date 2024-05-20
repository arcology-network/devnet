#!/bin/bash
. ../cli/show.sh

text "Installing openjdk-8-jdk ..."
sudo apt install -y openjdk-8-jdk >> $logfile 2>&1
text "OK" 1

text "Installing kafka ..."
curpath=$(pwd)
sudo chmod 755 ./kafka/*.sh
cd $curpath/kafka
wget https://archive.apache.org/dist/kafka/2.3.0/kafka_2.12-2.3.0.tgz >> $logfile 2>&1
./installkfk1.sh $curpath/kafka 1 $1  >> $logfile 2>&1 #$1 is localIp
text "OK" 1


