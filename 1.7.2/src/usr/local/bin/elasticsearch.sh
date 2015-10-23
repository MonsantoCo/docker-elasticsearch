#! /usr/bin/env bash
# Elasticsearch startup file.

# Fail immediately if anything goes wrong and return the value of the last command to fail/run
set -eo pipefail

# Set environment
ES_CLUSTER_NAME=${ES_CLUSTER_NAME:-"escluster01"}
ES_CFG_FILE="/var/lib/elasticsearch/config/elasticsearch.yml"

# Download the config file if given a URL
if [ ! -z ${ES_CFG_URL} ]; then
  curl -sSL --output ${ES_CFG_FILE} ${ES_CFG_URL}
  if [ $? -ne 0 ]; then
    echo "[ES] Unable to download file ${ES_CFG_URL}."
    exit 1
  fi
fi

# Reset/set to value to avoid errors in env processing
ES_CFG_URL=${ES_CFG_FILE}

# Process environment variables
for VAR in `env`; do
  if [[ "$VAR" =~ ^ES_ && ! "$VAR" =~ ^ES_CFG_ && ! "$VAR" =~ ^ES_PLUGIN_ && ! "$VAR" =~ ^ES_HOME && ! "$VAR" =~ ^ES_VERSION && ! "$VAR" =~ ^ES_VOL && ! "$VAR" =~ ^ES_USER && ! "$VAR" =~ ^ES_GROUP ]]; then
    ES_CONFIG_VAR=$(echo "$VAR" | sed -r "s/ES_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ . | sed  -r "s/\.\./_/g")
    ES_ENV_VAR=$(echo "$VAR" | sed -r "s/(.*)=.*/\1/g")

    if egrep -q "(^|^#)$ES_CONFIG_VAR" $ES_CFG_FILE; then
      # No config values may contain an '@' char. Below is due to bug otherwise seen.
      sed -r -i "s@(^|^#)($ES_CONFIG_VAR): (.*)@\2: ${!ES_ENV_VAR}@g" $ES_CFG_FILE
    else
      echo "$ES_CONFIG_VAR: ${!ES_ENV_VAR}" >> $ES_CFG_FILE
    fi
  fi
done

# if `docker run` first argument start with `--` the user is passing launcher arguments
if [[ "$1" == "--"* || -z $1 ]]; then
  exec /opt/elasticsearch/bin/elasticsearch --config=${ES_CFG_FILE} "$@"
else
  exec "$@"
fi
