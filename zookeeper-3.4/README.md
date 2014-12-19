Overview
--------
This project creates a docker-based Zookeeper container that 
supports dynamically changing the enemble configuration based
on consul service discovery. This allows you to spin up and
modify ZK ensembles quickly. 

Warning! This is a test of consul-template. Don't use for anything important at this time, as we haven't tested various failure scenarios. 


Features
--------
- Uses [consul-template](https://github.com/hashicorp/consul-template.git) to dynamicaly write zoo.cfg and restart Zookeeper
- Supplies environment variables for [registrator](https://github.com/progrium/registrator) for service discovery
- Configurable via environment variables passed to container
- Supports docker-assigned ports for client, peer and leaders (you can run multiple zookeepers on the same machine without port conflicts)
- Will generate random ZKIDs if one is not provided
- Supports tagging for use with registrator and consul service discovery

Running 
------
### From the command line

- Ensure that consul is running. We recommend using the instructions from [docker-consul](https://github.com/progrium/docker-consul). The container should be named `consul`

- Ensure that registrator is running: 
 	```docker run -d \
       -v /var/run/docker.sock:/tmp/docker.sock \
       -h $HOSTNAME progrium/registrator```

- Optional: configure dnsmasq to use consul for DNS. See http://www.morethanseven.net/2014/04/25/consul/


- Run `./start_container.sh`

- If you want to use Consul DNS instead of container linking, replace the `--link consul:consul` line in the script with a `CONSUL_CONNECT` pointing to the dns name of the consul system

###Environment variables

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `CONSUL_CONNECT` | `consul:8500` | DNS name of consul server. If using dnsmasq + consul you can use `consul.service.consl` instead and pass `--dns=127.0.0.1` when starting the container|
| `CONSUL_MINWAIT` | `20s` | Consul template minimum wait |
| `CONSUL_MAXWAIT` | `60s` | Consul template maximum wait |
| `CONSUL_QUERY` | `${CONSUL_SERVICE}` if `${CONSUL_TAG}` is defined the default will be `${CONSUL_TAG}.${CONSUL_SERVICE}` | Consul template query. For example, set the tag & service name to have consul template look for systems like: `cluster1.zookeeper` |
| `CONSUL_SERVICE` | `zookeeper` | Consul Service discovery name |
| `CONSUL_TAG` | Not defined | Consul Service discovery tag |
| `ZOO_LOG_DIR` | `${ZK_LOG_DIR}` | log4j zookeeper.out file location | 
| `ZK_DATA_DIR` | `/var/lib/zookeeper` | location of Zookeeper data |
| `ZK_LOG_DIR` | `/var/log/zookeeper` | location of Zookeeper dataLog | 
| `ZK_HOME`  | `/opt/zookeeper`  | Zookeeper install directory  |
| `ZK_ID`    | 1       | Zookeeper serverid |



##License
This software is released under an Apache 2.0 License

Copyright Asteris, LLC 2014
