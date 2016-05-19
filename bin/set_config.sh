#!/bin/bash

HOST_LIST=$!

[ ! $HOST_LIST ] && exit 0

OLD_IFS=$IFS
IFS=","

for INFO in $HOST_LIST
do
  read zk_ip zk_port zk_order < <(echo $INFO | awk -F : '{print $1,$2,$3}')
  ((zk_order++))
  sed -i -r "s#(server.$zk_order)=SERVER_IP(:2888:3888)#\1=$zk_ip\2#" $ZK_CFG
done

IFS=$OLD_IFS
