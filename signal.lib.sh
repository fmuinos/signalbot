#!/bin/bash
# Signal Library
# by Fernando Muiños

signaluser="" # signalbot phone number
tasksf="tasks.txt"  # tasks file
whitelist="whitelist.txt" # phone users with perms to chat with bot

signal_send() {
  if [ $# != 2 ]; then
    echo "Syntax: $FUNCNAME <phonenumber> <msg>"
    return 1
  fi
  # signal send message
  # signal_send <phone> <message>
  signal-cli -u $signaluser send -m "$2" $1
}

signal_receive() {
  # signal receive message
  local thismsgs=$(signal-cli -u $signaluser receive)

  local thisuser
  local thissender
  local thisbody
  local thistimestamp
  local cnt

  if [[ ! -z $thismsgs ]];then
    mapfile -t filearr < <( echo -E "$thismsgs")
    cnt=0
    for ((i = 0; i < ${#filearr[@]}; i++)); do
      file="${filearr[$i]}"
      if echo $file | grep -q -i -E "^timestamp:"; then
        thistimestamp=$(echo "${file}" | awk '{ print $2 $3}')
      elif echo $file | grep -q -i -E "^sender:"; then
        thissender=$(echo "${file}" | awk '{ print $2}')
        thisuser=$(is_user $thissender)
      elif echo $file | grep -q -i -E "^body:"; then
        if [[ $thisuser = 0 ]];then
          thisbody=$(echo "${file}" | awk '{ print $2}')
          cnt=$((cnt+1))
          echo "----- Message #$cnt ---------"
          echo "Timestamp: $thistimestamp"
          echo "Sender: $thissender"
          echo "Body: $thisbody"
        else
          echo "User $thissender not in whitelist"
        fi
      fi
    done
  else
    echo "No new messages"
    return 1
  fi
  return 0
}

################### CHATBOT #####################################
start_signal_chatbot() {
  # signal chatbot daemon
  # get messages from signal with commands and return response.
  # status - list - help
  local thisuser
  local thissender
  local thisbody
  local thistimestamp
  local cnt
  local thisnewbody

  local taskf="tasks.txt"

  echo "Started Signal ChatBot..."
  # while loop
  while :
  do
    # get input messages
    thismsgs=$(signal-cli -u $signaluser receive)

  if [[ ! -z $thismsgs ]];then
    mapfile -t filearr < <( echo -E "$thismsgs")
    cnt=0
    for ((i = 0; i < ${#filearr[@]}; i++)); do
      file="${filearr[$i]}"
      if echo $file | grep -q -i -E "^timestamp:"; then
        thistimestamp=$(echo "${file}" | awk '{ print $2 $3}')
      elif echo $file | grep -q -i -E "^sender:"; then
        thissender=$(echo "${file}" | awk '{ print $2}')
        thisuser=$(is_user $thissender)
      elif echo $file | grep -q -i -E "^body:"; then
        if [[ $thisuser = 0 ]];then
          thisbody=$(echo "${file}" | cut -d ' ' -f 2- |  sed 's/[^a-z  A-Z]//g')
          cnt=$((cnt+1))
          echo "----- Message #$cnt ---------"
          echo "Timestamp: $thistimestamp"
          echo "Sender: $thissender"
          echo "Body: $thisbody"
          # if a command?
          thiscmd=$(echo $thisbody | awk '{ print $1 }' |  sed 's/[^a-z  A-Z]//g')
          case "$thiscmd" in
          list)  echo "List cmd"
                 thisnewbody=$(cat $taskf)
                 signal_send $thissender "$thisnewbody"
              ;;
          add)  echo  "New task cmd"
              thisarg=$(echo $thisbody | cut -d ' ' -f 2-)
              echo "$thisarg"  |  sed 's/[^a-z  A-Z]//g' >> "$taskf"
              signal_send $thissender "New task: $thisarg - add OK"
              ;;
          help)  echo  "Help"
              signal_send $thissender "Commands: list - add - help"
              ;;
          *) echo "$thiscmd cmd no exist"
              signal_send $thissender "$thiscmd cmd no exist"
             ;;
          esac
        else
          echo "User $thissender not in whitelist"
          signal_send $thissender "Your user not in whitelist"
        fi
      fi
    done
  else
    echo "No new messages"
  fi
  sleep 3
  done
}

action_list() {
  local thistasks=$(cat $tasksf)
  return $thistasks
}

action_help() {
  return "status - list - help"
}

is_user() {
  if [ $# != 1 ]; then
    echo "Syntax: $FUNCNAME <phonenumber>"
    return 1
  fi
  # check user in white list
  local seeking=$1
  local in=1
  local thisuser

  mapfile -t usersarray <"$whitelist"
  for ((i = 0; i < ${#usersarray[@]}; i++)); do
    thisuser=$(echo ${usersarray[$i]})
    if [[ $thisuser = "$seeking" ]]; then
      in=0
      break
    fi
  done
  echo $in
  return $in
}
