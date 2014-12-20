FROM asteris/java:centos7_java7

MAINTAINER Steven Borrelli <steve@aster.is>

ENV ZOOKEEPER_VERSION 3.4.6
ENV ZK_DATA_DIR /var/lib/zookeeper
ENV ZK_LOG_DIR /var/log/zookeeper

ENV CONSUL_TEMPLATE_VERSION 0.5.0

RUN yum -y install nmap-ncat tar wget  && \
    yum clean all

RUN wget -q https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz && \
    tar zxvf consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz && \
    mv consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64/consul-template  /usr/local/bin/consul-template && \
    chmod +x /usr/local/bin/consul-template

RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$ZOOKEEPER_VERSION /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper

ENV JAVA_HOME /usr/lib/jvm/java

EXPOSE 2181 2888 3888

COPY zk_config.sh /usr/local/bin/
COPY zk_launch.sh /usr/local/bin/
RUN  mkdir -p  /opt/zookeeper/templates

COPY templates /opt/zookeeper/templates/

WORKDIR /opt/zookeeper

VOLUME ["/var/lib/zookeeper", "/var/log/zookeeper"]

ENTRYPOINT ["zk_config.sh"]
CMD ["start-foreground"]

