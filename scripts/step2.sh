#!/bin/bash


set -eo pipefail

handle_error() {
  local exit_code=$?
  echo "Script failed with error on line $1: $2"
  exit $exit_code
}

# Set the error handler
trap 'handle_error $LINENO "$BASH_COMMAND"' ERR


. utils.sh

if [[ $# -lt 1 ]] ; then
  warnln "Please provide organization name"
  exit 0
fi


if [ ! -f "../channel-artifacts/osqo-channel.block" ]; 
then


  echo""
  echo""
  echo "============================================================"
  echo "CREATING CHANNEL"
  echo "============================================================"
  echo""
  echo""

  sleep 10

  ./scratch/create-channel.sh

  echo""
  echo""
  echo "============================================================"
  echo "CHANNEL CREATION DONE"
  echo "============================================================"
  echo""
  echo""

fi

sleep 2

echo""
echo""
echo "============================================================"
echo "JOINING CHANNEL FOR $1"
echo "============================================================"
echo""
echo""


./scratch/join-channel-org.sh $1


echo""
echo""
echo "============================================================"
echo "CHANNEL JOINING FOR $1 DONE"
echo "============================================================"
echo""
echo""

sleep 2


echo""
echo""
echo "============================================================"
echo "INSTALLING CHAINCODE ON $1"
echo "============================================================"


./chaincode/install-chaincode.sh $1 osqo-chaincode /hlf-volume/efs-volume/hyperledger-chaincode/osqo-chaincode 1.0 1


echo""
echo""
echo "============================================================"
echo "CHAINCODE INSTALLATION FOR $1 DONE"
echo "============================================================"
echo""
echo""

sleep 2



echo""
echo""
echo "============================================================"
echo "CHECKING CHAINCODE COMMITREADINESS using org $1"
echo "============================================================"
echo""
echo""



 set -eo pipefail

./chaincode/commit-chaincode.sh $1 osqo-chaincode 1.0 1


echo""
echo""
echo "============================================================"
echo "RUN CONTAINERS AUTOMATICALLY IN MACHINE RESTART SCENARIO"
echo "============================================================"
echo""
echo""

sleep 2


docker update --restart unless-stopped $(docker ps -q)










