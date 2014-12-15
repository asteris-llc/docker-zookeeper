#Created automatically 
#Setup environment variables for ZK cluster

declare -a ZK_HOSTS
declare -a ZK_CLIENT_PORTS
declare -a ZK_PEER_PORTS
declare -a ZK_ELECTION_PORTS

{{ range service "%CONSUL_QUERY%" }}

ZK_HOSTS[{{.ID | regexReplaceAll ".*:zkid-([0-9]*)" "$1"}}]={{.Address}}
ZK_CLIENT_PORTS[{{.ID | regexReplaceAll ".*:zkid-([0-9]*)" "$1"}}]={{.Port}}
{{end}}

{{ range service "%CONSUL_QUERY%-2888" }}
ZK_PEER_PORTS[{{.ID | regexReplaceAll ".*:zkid-([0-9]*)" "$1"}}]={{.Port}}
{{end}}

{{ range service "%CONSUL_QUERY%-3888" }}
ZK_ELECTION_PORTS[{{.ID | regexReplaceAll ".*:zkid-([0-9]*)" "$1"}}]={{.Port}}
{{end}}


