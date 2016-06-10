#!/bin/bash

NODE_LIST=(`echo $1 | awk -F ',' '{print $1,$2,$3}'`)


if [ "${#NODE_LIST[*]}" == "$SERVICE_POD_NUM" ];then
  for INFO in ${NODE_LIST[*]}
  do
    node=(`echo $INFO | awk -F ':' '{print $1,$2,$3}'`)
    zk_ip=${node[0]}
    zk_port=${node[1]}
    zk_order=${node[2]}
    ((zk_order++))
    if [ "$SERVICE_POD_NUM" != "1" ];then
      echo server.$zk_order=$zk_ip:2888:3888 >> $ZK_CFG
    fi
    sed -i -r "s#(dataDir)=.*#\1=/data/zookeeper/$zk_order#" $ZK_CFG
  done
  
  touch /tmp/cluster_ok
fi
