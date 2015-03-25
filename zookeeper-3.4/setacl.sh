#!/bin/bash

set -e

# Sets ACLs on a zookeeper znode

# Vars needed:
# ZK_AUTH="user:password"
# ZNODE="/myznode"
# ZNODE_ACL="world:anyone:r,digest:user:pass:cdraw" #comma separated
# ZK_SERVER="zookeeper server:port"

ZK_SERVER=${ZK_SERVER:-"localhost:2181"}

printf "addauth digest ${ZK_AUTH}\n\ncreate ${ZNODE} \"\"\nsetAcl ${ZNODE} ${ZNODE_ACL}\n" | /opt/zookeeper/bin/zkCli.sh -server ${ZK_SERVER}
