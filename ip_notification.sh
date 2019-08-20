#!/bin/sh

line_accesstoken="LINEのアクセストークン"

ipaddress=$(curl -s ifconfig.io)
gobal_ipaddress=$(cat /tmp/gobal_ipaddress)

if [ ${ipaddress} != ${gobal_ipaddress} ]; then
  message="更新されました。IPアドレスは${ipaddress}"
  curl -X POST -H "Authorization: Bearer ${line_accesstoken}" -F "message=${message}" https://notify-api.line.me/api/notify > /dev/null
  echo ${ipaddress} > /tmp/gobal_ipaddress
fi
