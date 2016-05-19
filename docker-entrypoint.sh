#!/bin/bash

[ $DEBUG ] && set -x


HOST_ID=${POD_ORDER:4}

if [ ! -d $ZK_DATA/$HOST_ID ];then
 mkdir -pv ${ZK_DATA}/${HOST_ID} 
 chown zookeeper.zookeeper ${ZK_DATA}/${HOST_ID} -R
fi
