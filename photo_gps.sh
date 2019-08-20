#!/bin/bash

##Yahoo アプリケーションID
yahoo_appid="Yahoo！ JAPANのアプリケーションID"

## 地図の大きさ、縮尺
width="300"
height="200"
scale="15"

identify -verbose $1 | grep -e "exif:DateTime:" -e "exif:GPSLatitude" -e "exif:GPSLongitude" > /tmp/gps_data

## 撮影時刻取得
photo_date_time=$(cat /tmp/gps_data | grep "exif:DateTime:" | sed "s/exif:DateTime://")
photo_date=$(echo ${photo_date_time} | cut -f 1 -d " ")
photo_time=$(echo ${photo_date_time} | cut -f 2 -d " ")

## 緯度・経度の取得関数
function coordinate () {
  gps=$(cat /tmp/gps_data | grep $1 | sed "s/$1//")
  gps_do=$(echo ${gps} | tr "/" "," | cut -f 1 -d ",")
  gps_fun=$(echo ${gps} | tr "/" "," | cut -f 3 -d ",")
  gps_byo=$(echo ${gps} | tr "/" "," | cut -f 5 -d ",")
  gps=$(echo "scale=5;${gps_do} + ${gps_fun} / 60 + ${gps_byo} / 360000" | bc)
  gps_ref=$(cat /tmp/gps_data | grep "$2" | sed "s/$2//")
  test ${gps_ref} = $3 && printf "-"
  printf ${gps}
}

## 緯度・経度の取得
gps_latitude=$(coordinate exif:GPSLatitude: exif:GPSLatitudeRef: S)
gps_longitude=$(coordinate exif:GPSLongitude: exif:GPSLongitudeRef: W)

##HTMLファイル生成
echo "<!DOCTYPE html>" > photo.html
echo "<html lang='ja'>" >> photo.html
echo "<head>" >> photo.html
echo "<meta charset='UTF-8'>" >> photo.html
echo "<title>撮影日時・場所</title>" >> photo.html
echo "</head>" >> photo.html
echo "<body>" >> photo.html
echo "<p>ファイル名：$1<br>" >> photo.html
echo "撮影日：${photo_date}<br>" >> photo.html
echo "撮影時間：${photo_time}</p>" >> photo.html
echo "<p>撮影場所：<br>" >> photo.html
echo "<img width=${width} height=${height} src='https://map.yahooapis.jp/map/V1/static?appid=${yahoo_appid}&lat=${gps_latitude}&lon=${gps_longitude}&z=${scale}&width=${width}&height=${height}&pointer=on'>" >> photo.html
echo "</p>" >> photo.html
echo "</body>" >> photo.html
echo "</html>" >> photo.html
