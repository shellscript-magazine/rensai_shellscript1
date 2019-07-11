#!/bin/sh

smtp_server="smtp.gmail.com"
user_id="Googleアカウントのユーザー名"
user_adress="${user_id}@gnail.com"
password="Googleアカウントのパスワード"
encoding_id_password=$(printf "${user_id}\0${user_id}\0${password}" | base64)

message_file="message1.txt"
message=$(sed 's/$/\\n/g' ${message_file} | tr -d "\n")

dist_address="送信先のメールアドレス"

expect -c "
  set timeout 5
  spawn openssl s_client -connect ${smtp_server}:587 -starttls smtp -crlf
  expect \"250 SMTPUTF8\"
  send \"auth plain ${encoding_id_password}\n\"
  expect \"235 2.7.0 Accepted\"
  send \"mail from:<${user_adress}>\n\"
  expect \"250 2.1.0 OK*\"
  send \"rcpt to:<${dist_address}>\n\"
  expect \"250 2.1.5 OK*\"
  send \"data\n\"
  expect \"354  Go ahead*\"
  send \"To:${user_address}\n\"
  send \"From:${dist_address}\n\"
  send \"${message}\"
  send \".\n\"
  expect \"250 2.0.0 OK*\"
  send \"quit\n\"
  exit 0
" > send.log
