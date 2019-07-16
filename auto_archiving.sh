#!/bin/sh

# zip:1 tar.gz:2 tar.bz2:3 tar.xz:4
archiving_mode="2"

backup_folder="${HOME}/backup"
archive_folder="${HOME}/archive"

mkdir -p ${archive_folder}

backup_list=$(cd ${backup_folder} &amp;&amp; ls -p | grep /$ | tr -d /)

datetime=$(date +%Y%m%d%H%M)
echo "■■ Create Archive：${datetime} ■■" >> ${archive_folder}/archive.log

for i in $backup_list
do
  cd ${backup_folder}
  case ${archiving_mode} in
          1 ) zip -r ${archive_folder}/${i}-${datetime} ${i} >> ${archive_folder}/archive.log ;;
          2 ) tar czvf  ${archive_folder}/${i}-${datetime}.tar.gz ${i} >> ${archive_folder}/archive.log ;;
          3 ) tar cjvf  ${archive_folder}/${i}-${datetime}.tar.bz2 ${i} >> ${archive_folder}/archive.log ;;
          4 ) tar cJvf  ${archive_folder}/${i}-${datetime}.tar.xz ${i} >> ${archive_folder}/archive.log ;;
  esac
  rm -rf ${backup_folder}/${i}
  cd
done
