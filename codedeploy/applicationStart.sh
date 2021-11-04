#!/bin/bash
##### CLOUD WATCH AGENT

# run the node js application
# sudo su
# ls
# cd /home/ubuntu/webapp
# sudo mvn clean install
# node index.js
# Export variables
# sudo mvn spring-boot:run

cd /home/ubuntu/webapp/
sudo su
sudo mvn clean
sudo mvn clean install
sudo java -jar target/*.jar . &
sleep 1m