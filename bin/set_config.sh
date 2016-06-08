#!/bin/bash

HOST_LIST=$1

[ ! $HOST_LIST ] && exit 0

OLD_IFS=$IFS
IFS=","

for INFO in $HOST_LIST
do
  IFS=" "
  node=(`echo $INFO | awk -F ':' '{print $1,$2,$3}'`)
  zk_ip=${node[0]}
  zk_port=${node[1]}
  zk_order=${node[2]}
  ((zk_order++))
  echo server.$zk_order=$zk_ip:2888:3888 >> ZK_CFG
done

IFS=$OLD_IFS
