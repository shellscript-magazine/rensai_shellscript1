#!/bin/sh

share_folder="share"
readonly_folder="readonly"
setting_file="samba_setting.txt"
workgroup="SHELLMAG"
user_reg="sambauser.txt"

normal_log="normal.txt"
error_log="error.txt"


echo "Sambaのインストールと初期設定を実施します。"
echo "しばらくお待ちください。"
sudo apt-get update 1>${normal_log} 2>${error_log}
sudo apt-get -y install samba 1>>${normal_log} 2>>${error_log}
if [ $? != 0 ]; then
  echo "Sambaのインストールに失敗しました"
  echo "${error_log}内のエラーメッセージを確認してください。"
  exit 1
fi

echo "初期設定を開始します"
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.org
sed "s/%workgroup%/${workgroup}/g" ${setting_file} | sed -e "s/%folder1%/${share_folder}/g" | sed -e "s/%folder2%/${readonly_folder}/g" > /tmp/smb.conf
sudo mv /tmp/smb.conf /etc/samba/.

sudo mkdir -p /var/samba/${share_folder}
sudo mkdir -p /var/samba/${readonly_folder}
sudo chmod 777 /var/samba/${share_folder}

sudo systemctl restart nmbd
sudo systemctl restart smbd

read -p "ユーザー登録処理に進みます。続けるなら「y」キーを押してください。: " okng
case ${okng} in
  [Yy] ) ;;
     * ) echo "終了します。"; exit 0 ;;
esac

cat ${user_reg} | while read line
do
  samba_user=$(echo ${line} | awk '{print $1}')
  sudo useradd -M -s /bin/false -p noneuse ${samba_user}
  samba_password=$(echo ${line} | awk '{print $2}')
  echo "${samba_password}\n${samba_password}" | sudo pdbedit -a -t -u ${samba_user} 1>> ${normal_log} 
done

echo "ユーザー登録が完了しました。"
echo "登録ユーザー"
sudo pdbedit --list | cut -f 1 -d ":"
