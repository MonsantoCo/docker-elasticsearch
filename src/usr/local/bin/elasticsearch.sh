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

# Download the config file if given a URL
if [ ! "$(ls -A ${ES_CFG_URL})" ]; then
  curl -Ls -o ${ES_CFG_FILE} ${ES_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[elasticsearch] Unable to download file ${ES_CFG_URL}."
    exit 1
  fi
fi

# Setup for AWS discovery
if [[ ! -z "$ES_DISCOVERY" && ! -z $AWS_ACCESS_KEY && ! -z $AWS_SECRET_KEY && ! -z $AWS_S3_BUCKET ]]; then
  sed -ie "s/#cloud.aws.access_key: AWS_ACCESS_KEY/cloud.aws.access_key: ${AWS_ACCESS_KEY}/g" $ES_CFG_FILE
  sed -ie "s/#cloud.aws.secret_key: AWS_SECRET_KEY/cloud.aws.secret_key: ${AWS_SECRET_KEY}/g" $ES_CFG_FILE
  sed -ie "s/#cloud.node.auto_attributes: true/cloud.node.auto_attributes: true/g" $ES_CFG_FILE
  sed -ie "s/#discovery.type: ec2/discovery.type: ec2/g" $ES_CFG_FILE
  sed -ie "s/#gateway.type: s3/gateway.type: s3/g" $ES_CFG_FILE
  sed -ie "s/#repositories.s3.bucket: \"AWS_S3_BUCKET\"/repositories.s3.bucket: \"$AWS_S3_BUCKET\"/g" $ES_CFG_FILE
  #sed -ie "s/#network.public_host: _ec2_/network.public_host: _ec2_/g" $ES_CFG_FILE
fi

# if `docker run` first argument start with `--` the user is passing launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  /opt/elasticsearch/bin/elasticsearch \
    --config=${ES_CFG_FILE} \
    --cluster.name=${ES_CLUSTER} \
    "$@"
fi

# As argument is not Elasticsearch, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
