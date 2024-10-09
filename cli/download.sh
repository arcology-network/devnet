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

tag=""

if [ "${version}" == "" ]
then
  # echo "Please specify the version ( -v X.X.X)"
  # exit 1
  tag="latest"
else
  tag="v${version}"
fi



mkdir -p arcology/arcology
mkdir -p op/bin
mkdir -p op/deploy-config
mkdir -p op/deployments/getting-started
mkdir -p log


wget -O arcology/bin/arcology https://github.com/arcology-network/binary-releases/releases/download/${tag}/arcology
wget -O ethereum/geth https://github.com/arcology-network/binary-releases/releases/download/${tag}/geth
wget -O ethereum/geth https://github.com/arcology-network/binary-releases/releases/download/${tag}/beacon-chain
wget -O ethereum/geth https://github.com/arcology-network/binary-releases/releases/download/${tag}/prysmctl
wget -O ethereum/geth https://github.com/arcology-network/binary-releases/releases/download/${tag}/validator
wget -O op/bin/op-batcher https://github.com/arcology-network/binary-releases/releases/download/${tag}/op-batcher
wget -O op/bin/op-node https://github.com/arcology-network/binary-releases/releases/download/${tag}/op-node
wget -O op/bin/op-proposer https://github.com/arcology-network/binary-releases/releases/download/${tag}/op-proposer