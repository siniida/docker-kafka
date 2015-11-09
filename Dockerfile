FROM centos:6
MAINTAINER siniida <sinpukyu@gmail.com>

RUN yum update -y
RUN yum install -y tar

RUN curl -L -O -b "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jre-7u80-linux-x64.rpm
RUN rpm -ivh jre-7u80-linux-x64.rpm && rm jre-7u80-linux-x64.rpm

RUN curl http://ftp.riken.jp/net/apache/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz | tar zx -C /opt
RUN ln -s /opt/kafka_2.10-0.8.2.1 /opt/kafka
RUN mkdir /opt/kafka/kafka-logs
RUN chown -R root:root /opt/kafka_2.10-0.8.2.1
RUN sed -i -e 's/^\(log.dirs\)=.*/\1=\/opt\/kafka\/kafka\-logs/g' /opt/kafka/config/server.properties

ENV JAVA_HOME /usr/java/default

EXPOSE 9092

WORKDIR /opt/kafka

ADD entry.sh /

ENTRYPOINT ["/entry.sh"]
CMD ["/opt/kafka/bin/kafka-server-start.sh", "/opt/kafka/config/server.properties"]
