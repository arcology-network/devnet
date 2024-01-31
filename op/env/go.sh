#!/usr/bin/env bash

gofile=go1.21.6.linux-amd64.tar.gz

wget https://golang.google.cn/dl/$gofile

tar -zxvf $gofile

mv go ~/go

mkdir -p ~/gows/bin


echo export GOPATH=~/gows >> ~/.bashrc
echo export PATH=$PATH:~/go/bin:~/gows/bin >> ~/.bashrc

rm $gofile


