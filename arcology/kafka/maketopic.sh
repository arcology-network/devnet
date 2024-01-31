#!/usr/bin/env bash
host=localhost:2181



sleep 1

$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic inclusive-txs
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic msgexch
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic receipts
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic exec-rcpt-hash
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic reaping-list

$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic selected-msgs
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic selected-txs
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic meta-block
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic local-block
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic spawned-relations

$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic block-txs
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic p2p.received
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic p2p.sent
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic euresults
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic checked-txs

$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic chkd-message
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic local-txs
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic remote-txs
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic executing-logs
$exec --create --zookeeper $host --replication-factor 1 --partitions 1 --topic access-records
