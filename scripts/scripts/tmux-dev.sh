#!/bin/bash

SESSIONNAME="dev"
WINDOW=$SESSIONNAME:0

tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ]; then
	tmux new-session -s $SESSIONNAME -d
   
	for i in 0 1
	do
	  tmux split-window -v -t $WINDOW.$i -c '~/dev'
	  tmux send-keys -t $WINDOW.$i C-z Enter
        done
        tmux send-keys -t $WINDOW.2 C-z Enter
        tmux select-layout -t $SESSIONNAME tiled
fi

tmux attach -t $SESSIONNAME

