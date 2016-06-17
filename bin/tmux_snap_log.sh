#!/bin/bash

tmux new-session -d 'vagrant ssh snap1'

SNAP_DEMO_VMS=${SNAP_DEMO_VMS:=1}
for i in `seq 1 ${SNAP_DEMO_VMS}`;
do
  tmux split-window -h "vagrant ssh snap${i}"
  tmux send-key "tail -f /var/log/snap/snapd.log" C-m
done

tmux select-layout even-vertical
tmux -2 attach-session -d
