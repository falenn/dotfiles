#!/bin/bash

SESSIONNAME="mon"
WINDOW=$SESSIONNAME:0

tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ]; then
  tmux new-session -s $SESSIONNAME -d
  
  tmux selectp -t 0 # select first pane
  tmux split -v -t 0 -p 30
  tmux selectp -t 0
  tmux split -h -p 70 # split pane in half
  tmux selectp -t 1
  tmux split -h -p 40
  tmux selectp -t 1
  tmux plit -v -p 20
  tmux send-keys -t $WINDOW.0 C-z C-m
  tmux send-keys -t $WINDOW.1 'sudo htop' C-m
  tmux send-keys -t $WINDOW.2 'sudo iotop -o' C-m
  tmux send-keys -t $WINDOW.3 'sudo iftop' C-m
  tmux send-keys -t $WINDOW.4 'watch -n 5 sudo docker ps' C-m
fi

tmux attach -t $SESSIONNAME
