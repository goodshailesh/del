#!/bin/sh

if [ "$1" == '' ]; then
        echo "Commit SHA missing"
        echo "Usage: $0 [SHA] [IPADDR]"
        exit
fi
if [ "$2" == '' ]; then
        echo "Docker-Farm IP Addr missing"
        echo "Usage: $0 [SHA] [IPADDR]"
        exit
fi
export SHA=$1
export DOCKER_FARM_IP_ADDR=$2
ssh root@"$DOCKER_FARM_IP_ADDR" << EOF
mkdir /home/soni/job-workspace || true
cd /home/soni/job-workspace
mkdir $SHA
cd $SHA
git init
git remote add origin git@github.com:goodshailesh/nodejs-docker-local-dev-env
git pull origin master
git checkout $SHA
export IHOME_PATH=`pwd`
# ENVIRONEMENT VARIABLES
#=========================
#export SHA=`git log --oneline | cut -d ' ' -f 1 | head -n 1`
export SHA=$SHA

# DOCKER SERVER'S IP ADDRESS
#export XIPADDR=`ifconfig | grep -A 1 'enp0s8' | tail -n 1 | tr -s ' ' ' ' | cut -d ' ' -f 3`
export XIPADDR=$DOCKER_FARM_IP_ADDR

# RANDOMPORT based on last 5 digits of current epoch-https://www.cyberciti.biz/faq/bash-shell-script-generating-random-numbers/
#export XPORT=`date +%s | sed 's/[[:digit:]]\{5\}\([[:digit:]]\{5\}\).*/\1/'`
export XPORT=`echo $((RANDOM%9999+30000))`
#Creates a new isolated project each time
export COMPOSE_PROJECT_NAME="sha${SHA}"
export NET_LABEL=$COMPOSE_PROJECT_NAME

# Don't use 'docker-compose run' to remove the containers, because it can't remove the running containers. 
# Use 'docker-compose down'
# docker-compose rm -f
docker-compose down
# Remove unnecessary images
docker images | grep 'none' | sed 's/\s\{2,\}/#/g' | cut -d '#' -f 3 | xargs docker rmi []
#docker network rm inet || true
docker network create $NET_LABEL || true
docker-compose up --build
EOF
