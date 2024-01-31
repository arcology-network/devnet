#!/usr/bin/env bash


$basepath/bin/kafka-server-stop.sh

$basepath/bin/zookeeper-server-stop.sh

sleep 10

rm -Rf $basepath/klogs-1/*
rm -Rf /tmp/zookeeper/
rm -Rf $basepath/kafkadata/*
rm -Rf $basepath/zoodata/*
rm -Rf $basepath/zoolog/*