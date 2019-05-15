#!/bin/sh
 
photo_directory="画像"
mkdir -p ${photo_directory}/処理済み
 
bl_photo_name=$(ls ${photo_directory}/*.JPG 2>/dev/null)
sl_photo_name=$(ls ${photo_directory}/*.jpg 2>/dev/null)
name_check="1"
 
clear
 
for i in ${bl_photo_name} ${sl_photo_name}
do
  jp2a --colors -f ${i}
 
  while [ ${name_check} = "1" ]
  do
    echo "画像の新しいファイル名を入力してください（拡張子「.jpg」不要）。"
    read photo_new_name
    ls ${photo_directory}/処理済み/${photo_new_name}.jpg 1>/dev/null 2>/dev/null
    if [ $? = "0" ]; then
      echo "同じ名前のファイルがあります。"
    else
      name_check="0"
    fi
  done
 
  mv ${i} ${photo_directory}/処理済み/${photo_new_name}.jpg
  echo "ファイル名を書き換えました。ファイル名：${photo_new_name}.jpg"
  name_check="1"
  echo "［Enter］キーを押してください。"
  read key
  clear
done