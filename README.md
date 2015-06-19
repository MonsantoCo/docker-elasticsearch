## ElasticSearch Dockerfile

This is a highly configurable [ElasticSearch](https://www.elastic.co/products/elasticsearch) [Docker image](https://www.docker.com) built using [Docker's automated build](https://registry.hub.docker.com/u/monsantoco/elasticsearch/) process published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

It is usually the back-end for a [Logstash](https://www.elastic.co/products/logstash) instance with [Kibana](https://www.elastic.co/products/kibana) as the frontend forming what is commonly referred to as an **ELK stack**.


### How to use this image
To start a basic container using ephemeral storage:

```sh
docker run --name %p \
  --publish 9200:9200 \
  --publish 9300:9300 \
  monsantoco/elasticsearch
```

Within the container the volume `/var/lib/elasticsearch` is exposed. It contains the sub-directories for `data`, `log` and `config`. To start a default container with attached persistent/shared storage for data:

```sh
mkdir -p /es/data
docker run --rm --name %p
  --publish 9200:9200 \
  --publish 9300:9300 \
  --volume /var/lib/elasticsearch/data:/var/lib/elasticsearch/data \
  monsantoco/elasticsearch
```

Attaching persistent storage ensures that the data is retained across container restarts (with some obvious caveats). It is recommended this be done instead via a data container, preferably hosted an AWS S3 bucket or other externalized, distributed persistent storage.


### Available Features
A few plugins are installed:

- [BigDesk](http://bigdesk.org/): Provides live charts and statistics for an Elasticsearch cluster. You can open a browser and navigate to `http://localhost:9200/_plugin/bigdesk/` it will open Bigdesk and auto-connect to the ES node. You will need to change the `localhost` and `9200` port to the correct values for your environment/setup.

- [Elasticsearch Head](http://mobz.github.io/elasticsearch-head/): A web front end for an Elasticsearch cluster. Open `http://localhost:9200/_plugin/head/` and it will run it as a plugin within the Elasticsearch cluster.

- [Curator](https://github.com/elastic/curator): Helps with management of indices.

- [AWS Cloud](https://github.com/elastic/elasticsearch-cloud-aws) - Allows usage of AWS API for unicast discovery and S3 repositories for snapshots.

### Additional Configuration
Environment variables are accepted as a means to provide further configuration by reading those starting with `ES_`. Any matching variables will get added to Elasticsearch's configuration file, `elasticsearch.yml' by:

  1. Removing the `ES_` prefix
  2. Transforming to lower case
  3. Replacing occurrences of `_` with `.`, except where there is a double (`__`) which is replaced by a single (`_`).

For example, an environment variable `ES_CLUSTER_NAME=lscluster` will result in `cluster.name=lscluster` within `elasticsearch.yml`. Similarly, `ES_CLOUD_AWS_ACCESS__KEY=GHKDFIADFNADFIADFKJG` would result in `cloud.aws.access_key=GHKDFIADFNADFIADFKJG` within `elasticsearch.yml`.

You can also import your own configuration file by setting `ES_CFG_URL` to a valid URL. The environment variable substitution can then also be used on your file as well.
