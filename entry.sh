#!/bin/sh

CONFIG=/opt/kafka/config/server.properties

# broker.id
if [ -n "${ID}" ]
then
	echo "id=${ID}"
	sed -i -e "s/^\(broker.id\)=.*$/\1=${ID}/g" ${CONFIG}
fi

# with zookeeper ensamble
# require "--link option" or "ZOOKEEPERS environment"
if [ -n "${ZOOKEEPERS}" ]
then
	echo "zookeeper.connect = ${ZOOKEEPERS}"
	sed -i -e "s/^\(zookeeper.connect\)=.*$/\1=${ZOOKEEPERS}/g" ${CONFIG}
elif [ `env | grep -c 2181_TCP_ADDR` -gt 0 ]
then
	# get zookeeper address from env.
	for i in `env | grep 2181_TCP_ADDR | cut -d = -f 2`
	do
		ZOOKEEPERS="${ZOOKEEPERS},${i}:2181"
	done
	echo "zookeeper.connect = ${ZOOKEEPERS:1}"
	sed -i -e "s/^\(zookeeper.connect\)=.*$/\1=${ZOOKEEPERS:1}/g" ${CONFIG}
else
	echo "standalone kafka"
	/opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties
fi

# hostname
sed -i -e "s/^#\(host\.name\)=.*/\1=`hostname -i`/g" ${CONFIG}

exec $@
