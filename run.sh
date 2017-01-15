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
runuser -l soni -c 'ssh soni@"$DOCKER_FARM_IP_ADDR" -i id_rsa.pem << EOF
ssh soni@"$DOCKER_FARM_IP_ADDR" -i id_rsa.pem << EOF
mkdir job-workspace || true
cd job-workspace
mkdir $SHA
cd $SHA
git init
#git remote add origin git@github.com:goodshailesh/nodejs-docker-local-dev-env
git remote add origin git@github.com:goodshailesh/del
git pull origin master
git checkout $SHA > /dev/null 2>&1
export IHOME_PATH=`pwd`
echo $IHOME_PATH

EOF'
