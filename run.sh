#!/bin/sh
exec 1>/tmp/log
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
PWD=`pwd`
ssh root@"$DOCKER_FARM_IP_ADDR" << EOF
mkdir /home/soni/job-workspace || true
cd /home/soni/job-workspace
mkdir $SHA
cd $SHA
git init
#git remote add origin git@github.com:goodshailesh/nodejs-docker-local-dev-env
git remote add origin git@github.com:goodshailesh/del
git pull origin master
git checkout $SHA
export IHOME_PATH=`pwd`
./farm-shell.sh 
#./deploy-dev-env.sh $SHA $DOCKER_FARM_IP_ADDR  > /dev/null 2>&1
EOF
