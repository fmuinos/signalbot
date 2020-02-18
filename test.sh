#!/bin/bash

filename="output.txt"
thisfile=$(echo -e $filename)

mapfile -t filearr < "$thisfile"
cnt=0
for ((i = 0; i < ${#filearr[@]}; i++)); do
  file="${filearr[$i]}"
  if echo $file | grep -q -i -E "^timestamp:"; then
    thistimestamp=$(echo "${file}" | awk '{ print $2 $3}')
  elif echo $file | grep -q -i -E "^sender:"; then
    thissender=$(echo "${file}" | awk '{ print $2}')
  elif echo $file | grep -q -i -E "^body:"; then
    thisbody=$(echo "${file}" | awk '{ print $2}')
    cnt=$((cnt+1))
    echo "----- Message #$cnt ---------"
    echo "Timestamp: $thistimestamp"
    echo "Sender: $thissender"
    echo "Body: $thisbody"
  fi

done
