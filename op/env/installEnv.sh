#!/usr/bin/env bash
. ../../cli/show.sh

text "Installing make ..."
sudo apt install -y make >> $logfile 2>&1
text "OK" 1

text "Installing jq ..."
sudo apt install -y jq >> $logfile 2>&1
text "OK" 1

text "Installing git ..."
sudo apt install -y git >> $logfile 2>&1
text "OK" 1

text "Installing curl ..."
sudo apt install -y curl >> $logfile 2>&1
text "OK" 1

text "Installing direnv ..."
sudo apt install -y direnv >> $logfile 2>&1
text "OK" 1

text "Installing nodejs ..."
./node.sh >> $logfile 2>&1
text "OK" 1

text "Installing golanguage ..."
./go.sh >> $logfile 2>&1
text "OK" 1

text "Installing foundry ..."
./foundry.sh >> $logfile 2>&1
text "OK" 1

text "Installing pnpm ..."
./pnpm.sh >> $logfile 2>&1
text "OK" 1

eval "$(cat ~/.bashrc | tail -n +10)"

./versions.sh >> $logfile 2>&1

echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
