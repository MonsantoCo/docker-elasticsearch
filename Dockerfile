# ################################################################
# NAME: Dockerfile
# DESC: Docker file to create Elasticsearch container.
#
# LOG:
# yyyy/mm/dd [name] [version]: [notes]
# 2014/10/15 cgwong [v0.1.0]: Initial creation.
# 2014/11/07 cgwong v0.1.1: Changed plugin to plugins to match config file.
# 2014/11/10 cgwong v0.1.2: Updated comments and full version designation.
# 2014/12/03 cgwong v0.2.0: Corrected header comment. Switched to specific package download.
# 2014/12/04 cgwong v0.2.1: User more universal useradd/groupadd commands.
# 2015/01/08 cgwong v0.3.1: Updated to ES 1.4.2.
# 2015/01/14 cgwong v0.4.0: More variable usage. Use curl instead of wget for download.
# 2015/01/28 cgwong v0.5.0: Removed need for script.
#                           Switched to CMD (from ENTRYPOINT) and fixed variable usage to actual.
#                           Now using Java 8.
#                           Run as root user (for now).
# 2015/02/02 cgwong v1.0.0: Added curl install, corrected syntax issues.
# 2015/02/24 cgwong v1.1.0: Updated to 1.4.4
# ################################################################

FROM monsantoco/java:orajdk8
MAINTAINER Stuart Wong <carrington.wong@monsanto.com>

# Setup environment
ENV ES_VERSION 1.4.4
ENV ES_HOME /opt/elasticsearch
ENV ES_VOL /esvol
ENV ES_USER elasticsearch
ENV ES_GROUP elasticsearch
ENV ES_EXEC /usr/local/bin/elasticsearch.sh

# Install Elasticsearch
WORKDIR /opt
RUN apt-get -yq update && DEBIAN_FRONTEND=noninteractive apt-get -yq install curl \
  && apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && curl -s https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz | tar zxf - \
  && ln -s elasticsearch-${ES_VERSION} elasticsearch

# Configure environment
COPY src/ /

RUN groupadd -r ${ES_GROUP} \
  && useradd -M -r -d ${ES_HOME} -g ${ES_GROUP} -c "Elasticsearch Service User" -s /bin/false ${ES_USER} \
  && mkdir -p ${ES_VOL}/work \
  && mkdir -p ${ES_VOL}/data \
  && mkdir -p ${ES_VOL}/logs \
  && mkdir -p ${ES_VOL}/plugins \
  && chown -R ${ES_USER}:${ES_GROUP} ${ES_HOME}/ ${ES_VOL} ${ES_EXEC} \
  && chmod +x ${ES_EXEC}

VOLUME ["${ES_VOL}/data", "${ES_VOL}/config", "${ES_VOL}/logs"]

# Define working directory.
WORKDIR ${ES_VOL}

# Listen for connections on TCP port 9200
EXPOSE 9200
# Listen for cluster connections on TCP port 9300
EXPOSE 9300

# Start container
##USER ${ES_USER}
CMD ["/usr/local/bin/elasticsearch.sh"]
