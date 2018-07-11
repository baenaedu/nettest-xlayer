#!/bin/bash

sshpass -p "odroid" scp -o StrictHostKeyChecking=no /opt/monroe/airscopefix.sh root@172.16.253.2:/home/odroid/airscope
odroidname=$(sshpass -p "odroid" ssh -o StrictHostKeyChecking=no -R 8080:localhost:8080 root@172.16.253.2 'cat /etc/hostname')
odroidfile=airscope_node_$odroidname
sshpass -p "odroid" ssh -o StrictHostKeyChecking=no -R 8080:localhost:8080 root@172.16.253.2 'cd /home/odroid/airscope && ./airscope airscope_monroe_restful.conf & sh /home/odroid/airscope/airscopefix.sh' &
PID1=$!
nodejs /opt/monroe/nodejs_server/server.js &
PID2=$!
/usr/bin/python /opt/monroe/nettest.py &
PID3=$!
wait PID3;
cp $odroidfile /monroe/results/
