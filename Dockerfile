FROM alpine
MAINTAINER siniida <sinpukyu@gmail.com>

ENV KAFKA_VERSION=0.8.2.1

RUN apk --no-cache add openjdk8-jre bash \
  && mkdir /opt \
  && wget -O - http://ftp.riken.jp/net/apache/kafka/${KAFKA_VERSION}/kafka_2.10-${KAFKA_VERSION}.tgz | tar zx -C /opt \
  && ln -s /opt/kafka_2.10-${KAFKA_VERSION} /opt/kafka \
  && mkdir /opt/kafka/kafka-logs \
  && chown -R root:root /opt/kafka_2.10-${KAFKA_VERSION} \
  && sed -i \
      -e 's/^\(log.dirs\)=.*/\1=\/opt\/kafka\/kafka\-logs/g' \
      -e 's/^\(log.retention.hours\)=.*/\1=24/g' \
      -e 's/^\(log.cleaner.enable\)=.*/\1=true/g' \
      /opt/kafka/config/server.properties

ENV JAVA_HOME /usr/lib/jvm/default-jvm/jre

EXPOSE 9092

WORKDIR /opt/kafka

ADD entry.sh /

ENTRYPOINT ["/entry.sh"]
CMD ["/opt/kafka/bin/kafka-server-start.sh", "/opt/kafka/config/server.properties"]
