#!/bin/bash

LOGFILE_NAME="/tmp/shellscript_auth.log"
ACCESS_TOKEN="アクセストークン"

##発生日取得関数
date_time(){
  YEAR=$(echo $1 | cut -f 1 -d "T" | cut -f 1 -d "-")
  MONTH=$(echo $1 | cut -f 1 -d "T" | cut -f 2 -d "-")
  DATE=$(echo $1 | cut -f 1 -d "T" | cut -f 3 -d "-")
  HOUR=$(echo $1 | cut -f 2 -d "T" | cut -f 1 -d ":")
  MINUTE=$(echo $1 | cut -f 2 -d "T" | cut -f 2 -d ":")
  SECOND=$(echo $1 | cut -f 2 -d "T" | cut -f 3 -d ":" | cut -f 1 -d ".")
  TIME="${YEAR}年${MONTH}月${DATE}日${HOUR}時${MINUTE}分${SECOND}"
}

##ログインメッセージ送信関数
login_message(){
  MESSAGE="${1}（${2}）から${3}ユーザーでログインがありました。発生日時：${4}"
  curl -s -X POST -H "Authorization: Bearer ${ACCESS_TOKEN}" -F "message=${MESSAGE}" https://notify-api.line.me/api/notify > /dev/null
}

##不正アクセスメッセージ送信関数
nologin_message(){
  MESSAGE="${1}（${2}）から${3}ユーザーで不正アクセスがありました。発生日時：${4}"
  curl -s -X POST -H "Authorization: Bearer ${ACCESS_TOKEN}" -F "message=${MESSAGE}" https://notify-api.line.me/api/notify > /dev/null
}

##メインの処理
if [ -f ${LOGFILE_NAME} ]; then
  sleep 2

##ログ抽出
  mv ${LOGFILE_NAME} /tmp/tmp_auth.log
  service rsyslog restart

##ログイン通知
  cat /tmp/tmp_auth.log | grep "Accepted" > /tmp/tmp_login.log
  cat /tmp/tmp_login.log | while read line
  do
    IP=$(echo $line | cut -f 9 -d " ")
    COUNTRY=$(whois ${IP} | grep "country:" | uniq | sed -e 's/  */ /g' | cut -f 2 -d " ")
    if [ -n $COUNTRY ]; then
      COUNTRY="不明"
    fi
    USER=$(echo $line | cut -f 7 -d " ")
    date_time $line
    login_message $IP $COUNTRY $USER $TIME
  done

##不正アクセス通知
  cat /tmp/tmp_auth.log | grep "error: maximum authentication" | sed -e "s/invalid user\s/登録なし：/g"> /tmp/tmp_nologin.log
  cat /tmp/tmp_nologin.log | while read line
  do
    IP=$(echo $line | cut -f 12 -d " ")
    COUNTRY=$(whois ${IP} | grep "country:" | uniq | sed -e 's/  */ /g' | cut -f 2 -d " ")
    if [ -n $COUNTRY ]; then
      COUNTRY="不明"
    fi
    USER=$(echo $line | cut -f 10 -d " ")
    date_time $line
    nologin_message $IP $COUNTRY $USER $TIME
  done
  sleep 1
#  rm /tmp/tmp_auth.log /tmp/tmp_login.log /tmp/tmp_nologin.log
fi