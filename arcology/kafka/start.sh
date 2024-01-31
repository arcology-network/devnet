#!/usr/bin/env bash


$basepath/bin/zookeeper-server-start.sh -daemon $basepath/config/zookeeper.properties

$basepath/bin/kafka-server-start.sh -daemon $basepath/config/server.properties

sleep 10

$basepath/bin/kafka-server-start.sh -daemon $basepath/config/server.properties
