#!/bin/bash

while true
do
  buttons=`xinput --list | sed -rn 's/.*A4TECH USB.*id=([0-9]+).*keyboard.*/\1/p'`
  for button in $buttons; do
    xinput --disable $button
  
    event_file=`xinput --list-props $button | grep -oE '/dev/input/event[0-9]+'`
    evtest $event_file | awk '/KEY_LEFTMETA), value 1/ {system("xdotool click --delay 100 --repeat 2 1")}' &
  done;

  inotifywait -e create /dev/input
  sleep 2
done
