FROM centos:6
MAINTAINER siniida <sinpukyu@gmail.com>

ENV KAFKA_VERSION=0.9.0.1

RUN yum update -y \
    && yum install -y tar

RUN curl -L -O -b "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jre-7u80-linux-x64.rpm \
    && rpm -ivh jre-7u80-linux-x64.rpm && rm jre-7u80-linux-x64.rpm

RUN curl http://ftp.riken.jp/net/apache/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz | tar zx -C /opt \
    && ln -s /opt/kafka_2.11-${KAFKA_VERSION} /opt/kafka \
    && mkdir /opt/kafka/kafka-logs \
    && chown -R root:root /opt/kafka_2.11-${KAFKA_VERSION} \
    && sed -i \
        -e 's/^\(log.dirs\)=.*/\1=\/opt\/kafka\/kafka\-logs/g' \
        -e 's/^\(log.retention.hours\)=.*/\1=24/g' \
        -e 's/^\(log.cleaner.enable\)=.*/\1=true/g' \
        /opt/kafka/config/server.properties
RUN yum clean all

ENV JAVA_HOME /usr/java/default

EXPOSE 9092

WORKDIR /opt/kafka

ADD entry.sh /

ENTRYPOINT ["/entry.sh"]
CMD ["/opt/kafka/bin/kafka-server-start.sh", "/opt/kafka/config/server.properties"]
