## ElasticSearch Dockerfile
This is a highly configurable [ElasticSearch](https://www.elastic.co/products/elasticsearch) (v1.4.4) [Docker image](https://www.docker.com) built using [Docker's automated build](https://registry.hub.docker.com/u/monsantoco/elasticsearch/) process published to the public [Docker Hub Registry](https://registry.hub.docker.com/). It has optional AWS EC2 discovery.

It is usually the back-end for a [Logstash](https://www.elastic.co/products/logstash) instance with [Kibana](https://www.elastic.co/products/kibana) as the frontend forming what is commonly referred to as an **ELK stack**.


### How to use this image
To start a basic container using ephemeral storage:

```sh
docker run --name %p \
  --publish 9200:9200 \
  --publish 9300:9300 \
  monsantoco/elasticsearch
```

Within the container the data (`/esvol/data`), log (`/esvol/logs`) and config (`/esvol/config`) directories are exposed as volumes so to start a default container with attached persistent/shared storage for data:

```sh
mkdir -p /es/data
docker run --rm --name %p
  --publish 9200:9200 \
  --publish 9300:9300 \
  --volume /es/data:/esvol/data \
  monsantoco/elasticsearch
```

Attaching persistent storage ensures that the data is retained across container restarts (with some obvious caveats). It is recommended this be done via a data container, preferably hosting an AWS S3 bucket or other externalized, distributed persistent storage.


### Configuring the environment (changing defaults)
The following environment variables can be used to configure the container using the Docker `-e` (or `--env`) flag:

  - `ES_CFG_URL`      Download external elasticsearch configuration file for use.
  - `ES_PORT`         Use to change from the default client port of 9200.
  - `ES_CLUSTER`      The name of the elasticsearch cluster, default is "es01".
  - `ES_DISCOVERY`    Set to "ec2" to enable AWS EC2 discovery, and also set AWS_ACCESS_KEY, AWS_SECRET_KEY and AWS_S3_BUCKET.
  - `AWS_S3_BUCKET`   The AWS S3 bucket to use for snapshot backups.
  - `AWS_ACCESS_KEY`  The AWS access key to be used for discovery. Not required if the instance profile has ec2 DescribeInstance permissions.
  - `AWS_SECRET_KEY`  The AWS secret key to be used for discovery. Not required if the instance profile has ec2 DescribeInstance permissions.

  > Any port within a Docker image must be appropriately exposed (and mapped) on the Docker host. To avoid port conflicts, a _service discovery_ mechanism must be used and the correct hostname/ip and port on the Docker host passed to remote containers/hosts. Also, if using your own configuration file, you can either set the appropriate values within the file, or make use of variable substitution using the above (review the default file in the image for the expected format).


### Using external files
The following volumes are exposed for Docker host volume mounts using `-v` Docker command line option:

  - `/esvol/config`: Elasticsearch configuration file, `elasticsearch.yml`. The image also supports using a downloadable external configuration file specified via the `ES_CFG_URL` environment variable.
  - `/esvol/data`: Elasticsearch data files.
  - `/esvol/logs`: Elasticsearch log files.

  > The container must be able to access any URL provided, otherwise it will exit with a failure code.


### Service Discovery
Sample systemd unit files have been provided to show how service discovery could be achieved using this image, assuming the same is being done for the other components in the ELK stack. The examples use etcd and consul as the service registries though there are other options including DNS discovery. Below are the expected KV using etc or consul.

- `/services/logging/es/<cluster_name>/host`: The key, a resolvable hostname (preferrably) or IPV4 address of each ES data node in the specified cluster, would be below this directory. The key values are:
  - http_port: HTTP port (default 9200)
  - cluster_port: Cluster transport port (default 9300)

- `/services/logging/es/<cluster_name>/proxy`: The key, resolvable hostname (preferrably) or IPV4 address of the ES proxy node in the specified cluster, would be below this directory. The key values are the same as data nodes.

The `<cluster_name>` directory name is injected/created via the `ES_CLUSTER` environment variable. This variable is then expected to be provided in any supporting Logstash and Kibana images in this series.

A side load unit would be used to dynamically update the appropriate key/values based on health checks.

Please refer to the appropriate systemd unit file for further details.
