#!/bin/sh

source_folder="${HOME}/office"
destination_folder="${HOME}/pdf"

currnt=$(pwd)
cd ${source_folder}
office_files=$(ls *.doc *.docx *.odt *.xls *.xlsx *.ods *.ppt *.pptx *.odp 2>/dev/null)
cd ${currnt}

  for i in ${office_files}
  do
    echo "${i}をPDFに変換します。しばらくお待ちください"
    soffice --headless --language=ja --convert-to pdf --outdir ${destination_folder} ${source_folder}/${i} 1>/dev/null
  done 2> /dev/null
