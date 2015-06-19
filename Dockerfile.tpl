# ################################################################
# DESC: Docker file to create Elasticsearch container.
# ################################################################

FROM alpine:latest

# Setup environment
ENV ES_VERSION %%VERSION%%
ENV ES_HOME /opt/elasticsearch
ENV ES_VOL /var/lib/elasticsearch
ENV ES_USER elasticsearch
ENV ES_GROUP elasticsearch

ENV PKG_URL "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64"
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 45
ENV JAVA_VERSION_BUILD 14
ENV JAVA_BASE /usr/local/java
ENV JAVA_HOME $JAVA_BASE/jdk

# Install requirements and Elasticsearch
RUN apk --update add \
      curl \
      python \
      py-pip \
      bash && \
    curl --silent --insecure --location --remote-name "${PKG_URL}/glibc-2.21-r2.apk" &&\
    curl --silent --insecure --location --remote-name "${PKG_URL}/glibc-bin-2.21-r2.apk" &&\
    apk add --allow-untrusted \
      glibc-2.21-r2.apk \
      glibc-bin-2.21-r2.apk &&\
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib &&\
    mkdir -p ${ES_VOL}/data ${ES_VOL}/logs ${ES_VOL}/plugins ${ES_VOL}/work ${ES_VOL}/config ${JAVA_BASE} /opt &&\
    curl --silent --insecure --location --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar zxf - -C $JAVA_BASE &&\
    ln -s $JAVA_BASE/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} &&\
    curl --silent --insecure --location https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz | tar zxf - -C /opt &&\
    ln -s /opt/elasticsearch-${ES_VERSION} ${ES_HOME} &&\
    addgroup ${ES_GROUP} &&\
    adduser -h ${ES_HOME} -D -s /bin/bash -G ${ES_GROUP} ${ES_USER} &&\
    chown -R ${ES_USER}:${ES_GROUP} ${ES_HOME}/ ${ES_VOL} &&\
    ${ES_HOME}/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.5.0 --silent --timeout 2m &&\
    ${ES_HOME}/bin/plugin -install lukas-vlcek/bigdesk --silent --timeout 2m &&\
    ${ES_HOME}/bin/plugin -install mobz/elasticsearch-head --silent --timeout 2m

# Configure environment
COPY src/ /

# Expose volumes
VOLUME ["${ES_VOL}"]

# Define working directory.
WORKDIR ${ES_VOL}

# Listen for 9200/tcp (HTTP) and 9300/tcp (cluster)
EXPOSE 9200 9300

# Start container
ENTRYPOINT ["/usr/local/bin/elasticsearch.sh"]
CMD [""]
