#!/bin/bash

set -eo pipefail

handle_error() {
  local exit_code=$?
  echo "Script failed with error on line $1: $2"
  exit $exit_code
}

# Set the error handler
trap 'handle_error $LINENO "$BASH_COMMAND"' ERR


if [[ $# -lt 1 ]] ; then
  warnln "Please provide organization name"
  exit 0
fi

ORG_NAME=$1


if [ ! -f "../channel-artifacts/osqo-channel.tx" ] || [ ! -f "../system-genesis-file/genesis.block" ];then

  echo""
  echo""
  echo "============================================================"
  echo "    GENERATE NETWORK CERTIFICATES FOR ORGS"
  echo "============================================================"
  echo""
  echo""


  ./scratch/generate-msp.sh re-generate 


  echo""
  echo""
  echo "============================================================"
  echo "    CERTIFICATES GENERATION DONE"
  echo "============================================================"
  echo""
  echo""

  sleep 2


  echo""
  echo""
  echo "============================================================"
  echo "    GENERATE NETWORK CONFIGS FILES FOR NODES "
  echo "============================================================"
  echo""
  echo""


  ./scratch/generate-peer-base.sh etc

  sleep 1

  ./scratch/generate-network-files.sh

  echo""
  echo""
  echo "============================================================"
  echo "    NETWORK FILES GENERATION DONE"
  echo "============================================================"
  echo""
  echo""

  sleep 1

  echo""
  echo""
  echo "============================================================"
  echo "    GENERATING GENESIS BLOCK AND CHANNEL TX FILE"
  echo "============================================================"
  echo""
  echo""

  ./scratch/genesis.sh

  echo""
  echo""
  echo "============================================================"
  echo "    GENESIS BLOCK GENERATION DONE"
  echo "============================================================"
  echo""
  echo""

  sleep 1


  echo""
  echo""
  echo "============================================================"
  echo "    GENERATING CONNECTION FILES"
  echo "============================================================"
  echo""
  echo""


  ./scratch/ccp-generate.sh

  echo""
  echo""
  echo "============================================================"
  echo "    CONNECTION FILES GENERATION DONE"
  echo "============================================================"
  echo""
  echo""

  sleep 1


  echo""
  echo""
  echo "============================================================"
  echo "    GENERATING ZIP FOR CERTIFICATES, GENESIS, CHANNEL FILES"
  echo "============================================================"
  echo""
  echo""


  ./scratch/zip-certificate-data.sh


  echo""
  echo""
  echo "============================================================"
  echo "    ZIPPING CERTIFICATE FILES DONE"
  echo "============================================================"
  echo""
  echo""

  sleep 1



  echo""
  echo""
  echo "============================================================"
  echo "    SETTING UP HYPERLEDGER SDK FOLDER AND FILES"
  echo "============================================================"
  echo""
  echo""


  echo "

      set -eo pipefail
      cp ./connection-osqo.json connection-org1.json

      set -eo pipefail
      cp ./set-automate-configuration.sh set-automate-ip.sh


      echo "**********************************************************"
      echo "GENERATING COMPOSE FILE FOR SDK"
      echo "**********************************************************"

      set -eo pipefail
      ./generate-new-sdk-compose-file.sh sdk-new

      sleep 3

      echo "**********************************************************"
      echo "RUNNING SDK COMPOSE FILE"
      echo "**********************************************************"

      set -eo pipefail
      docker-compose -f ./docker-compose-osqo-sdk.yaml up -d

  " > ./setup-sdk.sh


    chmod +x ./setup-sdk.sh

    sudo cp -rf  ../organizations/peerOrganizations/osqo.osqo.com/connection-osqo.json ./set-automate-configuration.sh ./config.json ./utils.sh ./setup-sdk.sh /hlf-volume/efs-volume/hyperledger-sdk


    sleep 2

    echo""
    echo""
    echo "============================================================"
    echo "    SETTING UP HYPERLEDGER EXPLORER FOLDER AND FILES"
    echo "============================================================"
    echo""
    echo""

    sudo mkdir -p /hlf-volume/efs-volume/explorer

    sudo cp -rf ../organizations/  ../explorer-data/ ./scratch/start-explorer.sh ./set-automate-configuration.sh ./set-peer-base.sh ./config.json ./utils.sh /hlf-volume/efs-volume/explorer

    sudo chown ubuntu:ubuntu -R /hlf-volume/efs-volume/explorer/

    echo""
    echo""
    echo "============================================================"
    echo "STARTING NODES OF ORGANIZATION $1"
    echo "============================================================"
    echo""
    echo""


    ./start-org.sh $ORG_NAME

    sleep 7

    echo""
    echo""
    echo "============================================================"
    echo "NODES OF ORGANIZATION $1 STARTED SUCCESSFULLY"
    echo "============================================================"
    echo""
    echo""

else    

    echo""
    echo""
    echo "============================================================"
    echo "ADDING HOSTS ENTRIES"
    echo "============================================================"
    echo""
    echo""


    set -eo pipefail

    ./set-peer-base.sh etc



    echo""
    echo""
    echo "============================================================"
    echo "HOSTS ENTRIES ADDED"
    echo "============================================================"
    echo""
    echo""


    echo""
    echo""
    echo "============================================================"
    echo "STARTING NODES OF ORGANIZATION $1"
    echo "============================================================"
    echo""
    echo""


    ./start-org.sh $ORG_NAME

    sleep 7

    echo""
    echo""
    echo "============================================================"
    echo "NODES OF ORGANIZATION $1 STARTED SUCCESSFULLY"
    echo "============================================================"
    echo""
    echo""
fi


