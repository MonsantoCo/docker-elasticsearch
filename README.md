## ElasticSearch Dockerfile

This repository contains a **Dockerfile** of [ElasticSearch](http://www.elasticsearch.org/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/monsantoco/elasticsearch/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

It is usually the back-end for a Logstash instance with Kibana as the frontend.


### Base Docker Image

* [monsantoco/java:orajdk8](https://registry.hub.docker.com/u/monsantoco/java/) which is based on [monsantoco/min-jessie](https://registry.hub.docker.com/u/monsantoco/min-jessie/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/monsantoco/elasticsearch/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull monsantoco/elasticsearch:v1.4.4`

   (alternatively, you can build an image from Dockerfile: `docker build -t="monsantoco/elasticsearch:v1.4.4" github.com/monsantoco/docker-elasticsearch`)


### Usage
To start a basic container using ephemeral storage:

```sh
docker run --rm --name %p -p 9200:9200 -p 9300:9300 monsantoco/elasticsearch:v1.4.4
```

Within the container the data (`/esvol/data`), log (`/esvol/logs`) and config (`/esvol/config`) directories are exposed as volumes so to start a default container with attached persistent/shared storage for data:

```sh
mkdir -p /es/data
docker run --rm --name %p -v /es/data:/esvol/data -p 9200:9200 -p 9300:9300 monsantoco/elasticsearch:v1.4.4
```

Attaching persistent storage ensures that the data is retained across container restarts (with some obvious caveats). At this time though, given the state of maturity in this space, I would recommend this be done via a data container (hosting an AWS S3 bucket or other externalized, distributed persistent storage) in a possible production environment.

### Using an Elasticsearch Cluster
Multiple Elasticsearch containers can be launched (or stopped) and the cluster will dynamically resize using the provided systemd unit files.

### Changing Defaults
A few environment variables can be passed via the Docker `-e` flag to do some further configuration:

  - ES_CLUSTER: Sets the cluster name (defaults to `es01`)
  - ES_CONF: Sets the location of the ES configuration file.
  - ES_PORT: Sets the ES port (defaults to `9200`)
  
**Note: The systemd procedures assume you are using CoreOS. If you are not using CoreOS then simply substitute the CoreOS specific statements with the appropriate OS specific equivalents.**
