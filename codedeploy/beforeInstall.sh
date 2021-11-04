#!/bin/bash
# hangingJavaProcessToStop=`jps | grep Application | awk '{print $1}'`
# echo "hangingJavaProcessToStop: $hangingJavaProcessToStop"
# kill -9 $hangingJavaProcessToStop
#llsee


#lsof -i tcp:8080 | grep "java" | awk '{print $2}'
#TENOVAR=$(lsof -i tcp:8080 | grep "java" | awk '{print $2}')
#kill -9 $
sleep 20s
sudo su
cd /home/ubuntu/webapp/
TENOVAR=$(lsof -i tcp:8080 | grep "java" | awk '{print $2}')

if [ -z "$TENOVAR" ]
then
    echo "\$TENOVAR is empty"
else
    kill -9 $TENOVAR
fi