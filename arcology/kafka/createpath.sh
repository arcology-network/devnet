#!/usr/bin/env bash
host=localhost:2181


$exec $host create /p2p ""
$exec $host create /p2p/conn ""
$exec $host create /p2p/conn/status ""
$exec $host create /p2p/peer ""
$exec $host create /p2p/peer/config ""
