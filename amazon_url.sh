#!/bin/sh

URL=$(sed "s%\n%\s%g" $1)

for i in $URL
do
  DP=$(echo $i | cut -f 4 -d "/")
  if [ "$DP" = "dp" ]; then
    echo $i | cut -f 1 -d "?" | cut -f 1,2,3,4,5 -d "/"| sed "s%$%/%g"
  else
    echo $i | cut -f 1,2,3,5,6 -d "/" | sed "s%$%/%g"
  fi
done
