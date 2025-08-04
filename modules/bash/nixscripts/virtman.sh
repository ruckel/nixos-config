#!/bin/sh
sleeptime=5
run() {
if [[ $1 != '' ]];then sleeptime=$1;fi
sudo -A virsh net-start default
sudo virt-manager & \
sleepthenexit 
}
sleepthenexit() {
echo sleeping && sleep $sleeptime
echo exiting && exit
}
run $@
