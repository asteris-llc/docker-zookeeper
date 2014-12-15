#!/bin/bash

set -e 
set -x 

#Environment file containing ZK host definitions
# You can override this with a volume mounted zoo.env
ZOO_ENV=${ZOO_ENV:-"/opt/zookeeper/conf/zoo.env"}
source ${ZOO_ENV} 

export ZK_DATA_DIR=${ZK_DATA_DIR:-/var/lib/zookeeper}
export ZK_LOG_DIR=${ZK_LOG_DIR:-/var/log/zookeeper}

#For log4j:
export ZOO_LOG_DIR=${ZOO_LOG_DIR:-${ZK_LOG_DIR}}

ZOO_CFG_TEMPLATE=${ZOO_CFG_TEMPLATE:-"/opt/zookeeper/templates/zoo.cfg.tmpl"}

ZOO_CFG=${ZOO_CFG:-/opt/zookeeper/conf/zoo.cfg}

ZK_ID=${ZK_ID:-1}
MYID_FILE=${MYID_FILE:-/var/lib/zookeeper/myid}

write_settings() {
    cp /opt/zookeeper/conf/zoo_sample.cfg ${ZOO_CFG} 
    echo "dataDir=${ZK_DATA_DIR}" >> ${ZOO_CFG}
    echo "dataLogDir=${ZK_LOG_DIR}" >> ${ZOO_CFG}
}

write_zkid() {
  echo $ZK_ID > ${MYID_FILE}
}

single_host_setup () {
   echo "server.1=0.0.0.0:2888:3888" >> ${ZOO_CFG}
}

ensemble_setup () {
   for i in "${!ZK_HOSTS[@]}"; do   
       ID=${i}
       HOST="${ZK_HOSTS[$i]}"
       PEER="${ZK_PEER_PORTS[$i]}"
       ELECTION="${ZK_ELECTION_PORTS[$i]}"

       #skip if all data is not available
       if [ -z ${HOST+x} ] || [ -z ${PEER+x} ] || [ -z ${ELECTION+x} ]; then
          continue
       fi

       #bind to all ports on my host
       if [ "${ID}" == "${ZK_ID}" ]; then
          echo "server.${ID}=0.0.0.0:2888:3888" >> ${ZOO_CFG} 
       else
          echo "server.${ID}=${HOST}:${PEER}:${ELECTION}" >> ${ZOO_CFG}
       fi
   done
}

#Sanity check. If no hosts are defined, assume a 1-node cluster
check_vars () {
   if [ "${#ZK_HOSTS[@]}" == "0" ]; then
     single_host_setup	
   else
     ensemble_setup 
   fi
}

write_settings
check_vars
write_zkid

/opt/zookeeper/bin/zkServer.sh restart 
