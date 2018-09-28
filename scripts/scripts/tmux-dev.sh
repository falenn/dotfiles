#!/bin/bash

SESSIONNAME="dev"
WINDOW=$SESSIONNAME:0

tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ]; then
	tmux new-session -s $SESSIONNAME -d

	for i in 0 1
	do
	  tmux split-window -v -t $WINDOW.$i
	done
	
	tmux select-layout -t $SESSIONNAME tiled

	tmux send-keys -t $WINDOW.0 'cd ~/dev' C-m
fi

tmux attach -t $SESSIONNAME

