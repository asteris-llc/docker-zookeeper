FROM gliderlabs/alpine 

MAINTAINER Steven Borrelli <steve@aster.is>

ENV ZOOKEEPER_VERSION 3.4.6
ENV ZK_DATA_DIR /var/lib/zookeeper
ENV ZK_LOG_DIR /var/log/zookeeper
ENV ZK_CLI_VERSION 1.3

ENV CONSUL_TEMPLATE_VERSION 0.7.0

RUN apk-install bash openjdk7-jre nmap

ADD https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz /

RUN tar zxvf consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz && \
    mv consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64/consul-template /usr/local/bin/consul-template && \
    rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz && \
    rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64

RUN mkdir -p /opt && wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$ZOOKEEPER_VERSION /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper

ADD https://oss.sonatype.org/content/groups/public/com/loopfor/zookeeper/zookeeper-cli/${ZK_CLI_VERSION}/zookeeper-cli-${ZK_CLI_VERSION}.tar.gz /

RUN tar -zxvf /zookeeper-cli-${ZK_CLI_VERSION}.tar.gz && \
    mv /zookeeper-cli-${ZK_CLI_VERSION} /opt/zkcli && \
    rm /zookeeper-cli-${ZK_CLI_VERSION}.tar.gz

ENV JAVA_HOME /usr/lib/jvm/default-jvm

EXPOSE 2181 2888 3888

COPY zk_config.sh /usr/local/bin/
COPY zk_launch.sh /usr/local/bin/
RUN  mkdir -p  /opt/zookeeper/templates

COPY templates /opt/zookeeper/templates/

WORKDIR /opt/zookeeper

VOLUME ["/var/lib/zookeeper", "/var/log/zookeeper"]

ENTRYPOINT ["zk_config.sh"]
CMD ["start-foreground"]

