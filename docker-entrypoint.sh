#!/bin/bash

[ $DEBUG ] && set -x

HOST_ID=${POD_ORDER:4}
((HOST_ID++))

LOG_LEVEL=${LOG_LEVEL:-1}


if [ ! -d $ZK_DATA/$HOST_ID ];then
 mkdir -pv ${ZK_DATA}/${HOST_ID} 
 chown zookeeper.zookeeper ${ZK_DATA}/${HOST_ID} -R
fi

# wait zookeeper
MAXWAIT=${MAXWAIT:-30}
wait=0
while [ $wait -lt $MAXWAIT ]
do
    echo stat | nc $ZK_HOST $ZK_PORT
    if ! grep SERVER_IP $ZK_CFG;then
        break
    fi
    
    NodeNetPlugin -url=http://172.30.42.1:8080/api/v1/namespaces/${TENANT_ID}/endpoints/ \
    -regx_label=${SERVICE_NAME} \
    -frequency=once \
    -exec_num=3 \
    -interval=10 \
    -regx_port=2181 \
    -v=${LOG_LEVEL} \
    -logtostderr=true \
    -rec_cmd=/opt/zookeeper/bin/set_config.sh
    
    wait=`expr $wait + 1`;
    echo "Waiting cluster other zookeeper service $wait seconds"
    sleep 1
done

if [ "$wait" = $MAXWAIT ]; then
	echo >&2 'zookeeper cluster start failed.'
	exit 1
fi

# allow the container to be started with `--user`
if [ "$(id -u)" = '0' ]; then
	chown -R zookeeper .
	exec su-exec zookeeper /opt/zookeeper/bin/zkServer.sh "$@"
fi

exec /opt/zookeeper/bin/zkServer.sh "$@"
