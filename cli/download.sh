#!/usr/bin/env bash
# . ./cli/show.sh

while getopts v: OPT; do
 case ${OPT} in
  v) version=${OPTARG}
    ;;
  \?)
    printf "[Usage] `date '+%F %T'` -v <version>>\n" >&2
    exit 1
 esac
done 

if [ "${version}" == "" ]
then
  echo "Please specify the version ( -v X.X.X)"
  exit 1
fi

mkdir -p arcology/arcology
mkdir -p op/bin
mkdir -p op/deploy-config
mkdir -p op/deployments/getting-started
mkdir -p log


wget -O arcology/bin/arcology https://github.com/arcology-network/binary-releases/releases/download/v${version}/arcology
wget -O ethereum/geth https://github.com/arcology-network/binary-releases/releases/download/v${version}/geth 
wget -O op/bin/op-batcher https://github.com/arcology-network/binary-releases/releases/download/v${version}/op-batcher
wget -O op/bin/op-node https://github.com/arcology-network/binary-releases/releases/download/v${version}/op-node
wget -O op/bin/op-proposer https://github.com/arcology-network/binary-releases/releases/download/v${version}/op-proposer 