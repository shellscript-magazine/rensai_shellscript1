【Sambaの設定ファイルの内容】
　「samba_setting.txt」内に記述したSambaの設定です。矢印以下に各行の設定の説明を記しました。

[global]　← 全体設定
workgroup = %workgroup%　← ワークグループの設定
dos charset = CP932　← Windowsの文字コード（CP932はシフトJISの拡張）
unix charset = UTF8　← Linux/Unixの文字コード
 
[%folder1%]　← 共有フォルダ設定（予約されていない文字列をかっこ内に書くとフォルダ名となる）
comment = read/write ok　← 説明（コメント）
path = /var/samba/%folder1%　← 共有フォルダに割り当てるディレクトリのパス
browsable = yes　← ブラウズ許可（Windowsのエクスプローラーなどから探せる）
writable = yes　← 書き込み許可
create mask = 0777　← 保存したファイルのパーミッション
directory mask = 0777　← 作成したサブフォルダのパーミッション

[%folder2%]　←共有フォルダ設定
comment = read only　← 説明（コメント）
path = /var/samba/%folder2%　← 共有フォルダに割り当てるディレクトリのパス
browsable = yes　← ブラウズ許可
writable = no　← 書き込み不可
