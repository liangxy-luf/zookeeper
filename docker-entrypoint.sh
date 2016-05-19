#!/bin/bash

[ $DEBUG ] && set -x

HOST_ID=${POD_ORDER:4}
((HOST_ID++))

if [ ! -d $ZK_DATA/$HOST_ID ];then
 mkdir -pv ${ZK_DATA}/${HOST_ID} 
 chown zookeeper.zookeeper ${ZK_DATA}/${HOST_ID} -R
fi

# allow the container to be started with `--user`
if [ "$(id -u)" = '0' ]; then
	chown -R zookeeper .
	exec su-exec zookeeper /opt/zookeeper/bin/zkServer.sh "$@"
fi

exec /opt/zookeeper/bin/zkServer.sh "$@"
