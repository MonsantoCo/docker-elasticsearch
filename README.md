## ElasticSearch for Docker
This is a highly configurable [ElasticSearch](https://www.elastic.co/products/elasticsearch) [Docker image](https://www.docker.com) built using [Docker's automated build](https://registry.hub.docker.com/u/monsantoco/elasticsearch/) process published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

It is usually the back-end for a [Logstash](https://www.elastic.co/products/logstash) instance with [Kibana](https://www.elastic.co/products/kibana) as the frontend forming what is commonly referred to as an **ELK stack**.

### How to use this image
To start a basic container using ephemeral storage, exposing port 9200 for client connectivity:

```sh
docker run --name elasticsearch \
  --publish 9200:9200 \
  monsantoco/elasticsearch
```

Within the container the volume `/var/lib/elasticsearch` is exposed. It contains the sub-directories for `data`, `log` and `config`. To start a default container with attached persistent/shared storage for data:

```sh
mkdir -p /es/data
docker run --name elasticsearch
  --publish 9200:9200 \
  --volume /data:/var/lib/elasticsearch/data \
  monsantoco/elasticsearch
```

Attaching persistent storage ensures that the data is retained across container restarts (with some obvious caveats). It is recommended this be done instead via a data container, preferably hosted an AWS S3 bucket or other externalized, distributed persistent storage.

### Available Features
A few plugins are installed:

- [BigDesk](http://bigdesk.org/): Provides live charts and statistics for an Elasticsearch cluster. You can open a browser and navigate to `http://localhost:9200/_plugin/bigdesk/` it will open Bigdesk and auto-connect to the ES node. You will need to change the `localhost` and `9200` port to the correct values for your environment/setup.

- [ElasticHQ](https://github.com/royrusso/elasticsearch-HQ): Monitoring, management, and querying web interface for ElasticSearch instances and clusters.

- [Whatson](https://github.com/xyu/elasticsearch-whatson): an ElasticSearch plugin to visualize the state of a cluster.

- [Kopf](https://github.com/lmenezes/elasticsearch-kopf): A simple web administration tool for Elasticsearch.

- [AWS Cloud](https://github.com/elastic/elasticsearch-cloud-aws) - Allows usage of AWS API for unicast discovery and S3 repositories for snapshots.

Any commands passed on the command line are accepted as input to the elasticsearch command. For example, to set the JVM heap size to 10GB:

```sh
docker run --name elasticsearch \
  --publish 9200:9200 \
  monsantoco/elasticsearch -Xmx10g -Xms10g
```

### Additional Configuration
Environment variables are accepted as a means to provide further configuration by reading those starting with `ES_`. Any matching variables will get added to ElasticSearch's configuration file, `elasticsearch.yml' by:

  1. Removing the `ES_` prefix
  2. Transforming to lower case
  3. Replacing occurrences of `_` with `.`, except where there is a double (`__`) which is replaced by a single (`_`).

For example, an environment variable `ES_CLUSTER_NAME=lscluster` will result in `cluster.name=lscluster` within `elasticsearch.yml`. Similarly, `ES_CLOUD_AWS_ACCESS__KEY=GHKDFIADFNADFIADFKJG` would result in `cloud.aws.access_key=GHKDFIADFNADFIADFKJG` within `elasticsearch.yml`.

You can also import your own configuration file by setting `ES_CFG_URL` to a valid URL. The environment variable substitution can then also be used for the appropriate variables within your file as well.

As an example:
```sh
docker run --name elasticsearch \
  --publish 9200:9200 \
  --env ES_CFG_URL=http://[some url] \
  --env ES_CLUSTER_NAME=es_test_01 \
  monsantoco/elasticsearch
```

### Exposed Ports
- 9200/tcp: For client connectivity.
- 9300/tcp: For clustering using ransport/node protocols.
