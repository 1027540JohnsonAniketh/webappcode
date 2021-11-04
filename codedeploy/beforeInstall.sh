#!/bin/bash
# hangingJavaProcessToStop=`jps | grep Application | awk '{print $1}'`
# echo "hangingJavaProcessToStop: $hangingJavaProcessToStop"
# kill -9 $hangingJavaProcessToStop
#ll
cd /webapp
sudo su
sudo mvn clean