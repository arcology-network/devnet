#!/usr/bin/env bash

#curl -L https://foundry.paradigm.xyz | bash

#~/.foundry/bin/foundryup

cur=$(pwd)
cp f.tar.gz ~/f.tar.gz
cd ~
tar -zxvf f.tar.gz
#echo 'export curpath=$(echo ~)' >> ~/.bashrc
echo 'export PATH="$PATH:~/.foundry/bin"' >> ~/.bashrc
rm ~/f.tar.gz
cd $cur

