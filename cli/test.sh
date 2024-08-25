#!/usr/bin/env bash


while getopts d:t: OPT; do
 case ${OPT} in
  d) docker=${OPTARG}
    ;;
  d) test=${OPTARG}
    ;;
  \?)
    printf "[Usage] test.sh -d <Docker>\n" >&2
    exit 1
 esac
done 



isdocker=true
if [ "${docker}" == "" -a "${test}" == "" ]
then
    echo false
else
    echo ${isdocker}
fi