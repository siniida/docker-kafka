# siniida/kafka

[![](https://badge.imagelayers.io/siniida/kafka:latest.svg)](https://imagelayers.io/?images=siniida/kafka:latest 'Get your own badge on imagelayers.io')

for gennai cluster. ([gennai.docker](https://github.com/siniida/gennai.docker))

## Standadlone Kafka

use Kafka's ZooKeeper.

    $ docker run -d siniida/kafka


## with ZooKeeper ensamble 1

use `docker --link` option.

    $ docker run -d --link zk1:zk1 --link zk2:zk2 --link zk3:zk3 siniida/kafka

use with zookeeper/cluster.sh ([docker-zookeeper](https://github.com/siniida/docker-zookeeper))

    $ ../docker-zookeeper/cluster.sh start 3
    $ docker run -d `../zookeeper/cluster.sh status -l` siniida/kafka

## with ZooKeeper ensamble 2

use `docker -e` option.

    $ docker run -d -e ZOOKEEPERS="zk1:2181,zk2:2181,zk3:2181" siniida/kafka

use with zookeeper/cluster.sh ([docker-zookeeper](https://github.com/siniida/docker-zookeeper))

    $ ../docker-zookeeper/cluster.sh start 5
    $ docker run -d -e ZOOKEEPERS="`../zookeeper/cluster.sh status -a`" siniida/kafka

## Multi Brokers

with ZooKeeper container.

    $ docker run -d -e ID=1 --link zk:zk siniida/kafka
    $ docker run -d -e ID=2 --link zk:zk siniida/kafka

