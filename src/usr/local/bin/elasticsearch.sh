#! /bin/bash
# #################################################################
# NAME: elasticsearch.sh
# DESC: Elasticsearch startup file.
#
# LOG:
# yyyy/mm/dd [user] [version]: [notes]
# 2014/10/23 cgwong v0.1.0: Initial creation
# 2014/11/07 cgwong v0.1.1: Use config file switch.
# 2014/11/10 cgwong v0.2.0: Added environment variables.
# 2015/01/28 cgwong v0.3.0: Updated variables.
# 2015/01/29 cgwong v0.5.0: Enabled previous variables.
# 2015/02/02 cgwong v1.0.0: Removed unneeded variables, simplified directories layout.
# #################################################################

# Fail immediately if anything goes wrong and return the value of the last command to fail/run
set -eo pipefail

# Set environment
ES_VOL=/esvol
ES_CONF=${ES_CONF:-"/esvol/config/elasticsearch.yml"}
ES_CLUSTER_NAME=${ES_CLUSTER_NAME:-"es_cluster01"}
ES_PORT_9200_TCP_ADDR=${ES_PORT_9200_TCP_ADDR:-"9200"}

# Set varibles as provided
[ ! -z ${ES_CLUSTER} ] && sed -e "s/cluster.name: es_cluster01/cluster.name: ${ES_CLUSTER}/" -i $ES_CONF
[ ! -z ${ES_HTTP_PORT} ] && sed -e "s/#node.name: ES_HTTP_PORT/node.name: ${ES_HTTP_PORT}/" -i $ES_CONF
[ ! -z ${ES_RECOVER_TIME} ] && sed -e "s/#gateway.recover_after_time: 5m/gateway.recover_after_time: ${ES_RECOVER_TIME}/" -i $ES_CONF
[ ! -z ${ES_UNICAST_HOSTS} ] && sed -e "s/#discovery.zen.ping.unicast.hosts: [\"host1\", \"host2:port\"]/discovery.zen.ping.unicast.hosts: ${ES_UNICAST_HOSTS}/" -i $ES_CONF

# if `docker run` first argument start with `--` the user is passing launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  /opt/elasticsearch/bin/elasticsearch \
    -config=$ES_CONF \
    -cluster.name=${ES_CLUSTER} \
    "$@"
fi

# As argument is not Elasticsearch, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
