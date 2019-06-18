#!/bin/sh

source_address="自分のGmailアドレス"
distination_list="sendlist.txt"
user_id="Googleアカウントのユーザー名"
password="Googleアカウントのパスワード"
message_template_file="message.txt"

number_send=$(cat ${distination_list} | wc -l)
sed "s/%source_address%/${source_address}/" ${message_template_file} > /tmp/tmp_message.txt

for i in $(seq ${number_send})
do
  distination_address=$(sed -n ${i}p ${distination_list} | cut -f 1)
  distination_name=$(sed -n ${i}p ${distination_list} | cut -f 2)
  sed "s/%name%/${distination_name}/g" /tmp/tmp_message.txt | sed -e "s/%dist_address%/${distination_address}/" > /tmp/message.txt
  curl -s -k --url 'smtps://smtp.gmail.com:465' --mail-rcpt ${distination_address} --mail-from ${source_address} --user ${user_id}:${password} --upload-file /tmp/message.txt
done

rm /tmp/tmp_message.txt /tmp/message.txt
