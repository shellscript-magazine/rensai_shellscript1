#!/bin/sh

# Gmailに関する設定
pop_server="pop.gmail.com"
user_id="GoogleアカウントのID"
password="Googleアカウントのパスワード"

# 「【重要】」というタイトルをエンコード
subject_base64="44CQ6YeN6KaB44CR"

# Slackに関する設定
channel_urlencoding=$(echo "シェルスクリプト連載" | urlencode)
token="トークン"

# 受信メール数の取得
expect -c "
  set timeout 30
  spawn openssl s_client -connect ${pop_server}:995
  expect \"+OK Gpop ready\"
  send \"user ${user_id}\n\"
  expect \"+OK send PASS\"
  send \"pass ${password}\n\"
  expect \"+OK Welcome.\"
  send \"stat\n\"
  expect \"+OK\"
  send \"quit\n\"
  expect \"+OK Farewell.\"
  exit 0
" > receive.log

receive_count=$(grep +OK receive.log | tail -n 2 | head -n 1 | cut -d " " -f 2)

#　メッセージ受信
for i in $(seq ${receive_count})
do
  expect -c "
    set timeout 30
    spawn openssl s_client -connect ${pop_server}:995
    expect \"+OK Gpop ready\"
    send \"user ${user_id}\n\"
    expect \"+OK send PASS\"
    send \"pass ${password}\n\"
    expect \"+OK Welcome.\"
    send \"retr 1\n\"
    expect \".\"
    send \"quit\n\"
    expect \"+OK Farewell.\"
    exit 0
  " > message.log

# タイトルの先頭部分を抽出
  subject=$(cat message.log | grep "Subject: =" | sed "s/Subject: =?UTF-8?B?//g "| cut -c 1-16)

# 重要なメッセージをSlackに転送
  if [ ${subject} = ${subject_base64} ] ; then
    cat message.log | awk '/Content-Transfer-Encoding\: 8bit/,/^\./' | head -n -1 | tail -n +2 > message.txt
    message_urlencoding=$(cat message.txt | urlencode)
    curl "https://slack.com/api/chat.postMessage?token=${token}&channel=${channel_urlencoding}&text=${message_urlencoding}"
  fi
done
