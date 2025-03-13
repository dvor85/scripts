#!/bin/bash
sudo VBoxManage internalcommands createrawvmdk \
    -filename "$2" \
    -rawdisk $1
sudo chown $USER:$USER "$2"