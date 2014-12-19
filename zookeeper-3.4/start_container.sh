#!/bin/bash

#Example script
#Launch a ZK container that registers and configures an ensemble
# using consul and consul template

DOCKER_IMAGE=${DOCKER_IMAGE:-"asteris/zookeeper:latest"}

#Run a single zk container 
PORTS=" -p 2181:2181 -p 2888:2888 -p 3888:3888 "

#Option #2: Map contaier to host ports
#PORTS=" -p 2181 -p 2888 -p 3888 "

# Zookeeper needs an ID for each node in an ensemble
ZK_ID=${ZK_ID:-${RANDOM}}

#Values for service discovery in consul
SERVICE_TAGS=${SERVICE_TAGS:-"zookeeper"}
ZK_ENV=${ZK_ENV:-"dev"}
ZK_CLUSTER_ID=${ZK_CLUSTER_ID:-"cluster1"}

# what we register in consul
# query at http://consul:8500/v1/catalog/service/${CONSUL_SERVICE}
CONSUL_SERVICE=${CONSUL_SERVICE:-"zookeeper"}

#Used for service discovery in consul template
# for example {{ range "cluster1.zookeeper" }}
CONSUL_QUERY=${CONSUL_QUERY:-"${ZK_CLUSTER_ID}.${CONSUL_SERVICE}"}

CONTAINER_NAME="${CONSUL_SERVICE}-${ZK_ENV}-${ZK_CLUSTER_ID}-${ZK_ID}"

docker run -d --name ${CONTAINER_NAME} \
             --link consul:consul \
             ${PORTS}  \
             -e ZK_ID="${ZK_ID}" \
             -e CONSUL_QUERY="${CONSUL_QUERY}" \
             -e SERVICE_2181_NAME="${CONSUL_SERVICE}" \
             -e SERVICE_2181_ID="$(hostname -s):${CONTAINER_NAME}:2181:zkid-${ZK_ID}" \
             -e SERVICE_2888_NAME="${CONSUL_SERVICE}-2888" \
             -e SERVICE_2888_ID="$(hostname -s):${CONTAINER_NAME}:2888:zkid-${ZK_ID}" \
             -e SERVICE_3888_NAME="${CONSUL_SERVICE}-3888" \
             -e SERVICE_3888_ID="$(hostname -s):${CONTAINER_NAME}:3888:zkid-${ZK_ID}" \
             -e SERVICE_TAGS="${SERVICE_TAGS},${ZK_ENV},${ZK_CLUSTER_ID},zkid-${ZK_ID}" \
                ${DOCKER_IMAGE}

