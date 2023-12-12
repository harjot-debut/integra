#!/bin/bash

# my_dir="$(dirname "$0")"
# echo "$PWD/utils.sh"
# . "$my_dir/utils.sh"

. utils.sh
# imports
# . utils.sh



. set-automate-configuration.sh

script_dir="$(dirname "$0")"
# . "$script_dir/../utils/utils.sh"
# echo "oieoiwuoriuwr3294872839492834792387"
echo "$script_dir/utils.sh"



export CORE_PEER_TLS_ENABLED=true
# export ORDERER_CA=${PWD}/../organizations/peerOrganizations/integra.integra.com/peers/orderer0.integra.integra.com/msp/tlscacerts/tlsca.integra.integra.com-cert.pem
export PEER0_OSQO_CA=${PWD}/../organizations/peerOrganizations/integra.integra.com/peers/peer0.integra.integra.com/tls/ca.crt
# # export PEER1_OSQO_CA=${PWD}/../organizations/peerOrganizations/integra.integra.com/peers/peer1.integra.integra.com/tls/ca.crt
# export PEER0_BCP_CA=${PWD}/../organizations/peerOrganizations/bcp.integra.com/peers/peer0.bcp.integra.com/tls/ca.crt
# export PEER1_BCP_CA=${PWD}/../organizations/peerOrganizations/bcp.integra.com/peers/peer1.bcp.integra.com/tls/ca.crt
# export PEER0_ESP_CA=${PWD}/../organizations/peerOrganizations/esp.integra.com/peers/peer0.esp.integra.com/tls/ca.crt
# export PEER1_ESP_CA=${PWD}/../organizations/peerOrganizations/esp.integra.com/peers/peer1.esp.integra.com/tls/ca.crt
# export PEER0_BROKER_CA=${PWD}/../organizations/peerOrganizations/broker.integra.com/peers/peer0.broker.integra.com/tls/ca.crt
# export PEER1_BROKER_CA=${PWD}/../organizations/peerOrganizations/broker.integra.com/peers/peer1.broker.integra.com/tls/ca.crt

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    PEER0NAME=peer0.integra.integra.com
    ORGNAME=OSQO
    export CORE_PEER_LOCALMSPID="integraMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OSQO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/integra.integra.com/users/Admin@integra.integra.com/msp
    # export CORE_PEER_ADDRESS=peer0.integra.integra.com:$PEER_1_OSQO
  # elif [ $USING_ORG -eq 2 ]; then
  # PEER0NAME=peer0.bcp.integra.com
  # ORGNAME=BCP
  #   export CORE_PEER_LOCALMSPID="bcpMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BCP_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.integra.com/users/Admin@bcp.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer0.bcp.integra.com:$PEER_1_BCP
  # elif [ $USING_ORG -eq 3 ]; then
  #  PEER0NAME=peer0.esp.integra.com
  #  ORGNAME=ESP
  #   export CORE_PEER_LOCALMSPID="espMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ESP_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/esp.integra.com/users/Admin@esp.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer0.esp.integra.com:$PEER_1_ESP  
  # elif [ $USING_ORG -eq 4 ]; then
  #  PEER0NAME=peer0.broker.integra.com
  #  ORGNAME=BROKER
  #   export CORE_PEER_LOCALMSPID="brokerMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BROKER_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/broker.integra.com/users/Admin@broker.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer0.broker.integra.com:$PEER_1_BROKER
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}


setPeersGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 11 ]; then
    PEER_NAME=peer0.integra.integra.com
    export CORE_PEER_LOCALMSPID="integraMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OSQO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/integra.integra.com/users/Admin@integra.integra.com/msp
    export CORE_PEER_ADDRESS=peer0.integra.integra.com:$PEER_1_OSQO
  elif [ $USING_ORG -eq 12 ]; then
  PEER_NAME=peer1.integra.integra.com
    export CORE_PEER_LOCALMSPID="integraMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_OSQO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/integra.integra.com/users/Admin@integra.integra.com/msp
    export CORE_PEER_ADDRESS=peer1.integra.integra.com:$PEER_2_OSQO
  elif [ $USING_ORG -eq 21 ]; then
  PEER_NAME=peer0.bcp.integra.com
    export CORE_PEER_LOCALMSPID="bcpMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BCP_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.integra.com/users/Admin@bcp.integra.com/msp
    export CORE_PEER_ADDRESS=peer0.bcp.integra.com:$PEER_1_BCP
  elif [ $USING_ORG -eq 22 ]; then
  PEER_NAME=peer1.bcp.integra.com
    export CORE_PEER_LOCALMSPID="bcpMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_BCP_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.integra.com/users/Admin@bcp.integra.com/msp
    export CORE_PEER_ADDRESS=peer1.bcp.integra.com:$PEER_2_BCP
  elif [ $USING_ORG -eq 31 ]; then
  PEER_NAME=peer0.esp.integra.com
    export CORE_PEER_LOCALMSPID="espMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ESP_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/esp.integra.com/users/Admin@esp.integra.com/msp
    export CORE_PEER_ADDRESS=peer0.esp.integra.com:$PEER_1_ESP
  elif [ $USING_ORG -eq 32 ]; then
  PEER_NAME=peer1.esp.integra.com
    export CORE_PEER_LOCALMSPID="espMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ESP_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/esp.integra.com/users/Admin@esp.integra.com/msp
    export CORE_PEER_ADDRESS=peer1.esp.integra.com:$PEER_2_ESP
  elif [ $USING_ORG -eq 41 ]; then
  echo "=============================================="
      echo $PEER_1_BROKER
      echo "=============================================="
  PEER_NAME=peer0.broker.integra.com
    export CORE_PEER_LOCALMSPID="brokerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BROKER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/broker.integra.com/users/Admin@broker.integra.com/msp
    export CORE_PEER_ADDRESS=peer0.broker.integra.com:$PEER_1_BROKER
  elif [ $USING_ORG -eq 42 ]; then
    echo "=============================================="
      echo $PEER_2_BROKER
      echo "=============================================="
    PEER_NAME=peer1.broker.integra.com
    export CORE_PEER_LOCALMSPID="brokerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_BROKER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/broker.integra.com/users/Admin@broker.integra.com/msp
    export CORE_PEER_ADDRESS=peer1.broker.integra.com:$PEER_2_BROKER
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

setOrgPeersGlobals() {
  local USING_ORG=""
  USING_ORG=$1
  USING_PEER=$2
  infoln "Using organization ${USING_ORG} and Peer ${USING_PEER}"
 
  # export CORE_PEER_TLS_ENABLED=true
  if [ $USING_ORG == "integra" ] && [ $USING_PEER == 1 ]; then 
    echo "=============================================="
    echo $PEER_1_OSQO
    echo "=============================================="

    PEER_NAME=peer0.integra.integra.com
        export CORE_PEER_LOCALMSPID="integraMSP"
        export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OSQO_CA
        export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/integra.integra.com/users/Admin@integra.integra.com/msp
        export CORE_PEER_ADDRESS=peer0.integra.integra.com:$PEER_1_OSQO
  elif [ $USING_ORG == "integra" ] && [ $USING_PEER == 2 ]; then
    echo "=============================================="
    echo $PEER_2_OSQO
    echo "=============================================="
  PEER_NAME=peer1.integra.integra.com
    export CORE_PEER_LOCALMSPID="integraMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_OSQO_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/integra.integra.com/users/Admin@integra.integra.com/msp
    export CORE_PEER_ADDRESS=peer1.integra.integra.com:$PEER_2_OSQO
  # elif [ $USING_ORG == "bcp" ] && [ $USING_PEER == 1 ]; then
  #     echo "=============================================="
  #     echo $PEER_1_BCP
  #     echo "=============================================="
  # PEER_NAME=peer0.bcp.integra.com
  #   export CORE_PEER_LOCALMSPID="bcpMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BCP_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.integra.com/users/Admin@bcp.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer0.bcp.integra.com:$PEER_1_BCP
  # elif [ $USING_ORG == "bcp" ] && [ $USING_PEER == 2 ]; then
  #     echo "=============================================="
  #     echo $PEER_2_BCP
  #     echo "=============================================="
  # PEER_NAME=peer1.bcp.integra.com
  #   export CORE_PEER_LOCALMSPID="bcpMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_BCP_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.integra.com/users/Admin@bcp.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer1.bcp.integra.com:$PEER_2_BCP 
  # elif [ $USING_ORG == "esp" ] && [ $USING_PEER == 1 ]; then
  #     echo "=============================================="
  #     echo $PEER_1_ESP
  #     echo "=============================================="
  # PEER_NAME=peer0.esp.integra.com
  #   export CORE_PEER_LOCALMSPID="espMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ESP_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/esp.integra.com/users/Admin@esp.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer0.esp.integra.com:$PEER_1_ESP
  # elif [ $USING_ORG == "esp" ] && [ $USING_PEER == 2 ]; then
  #     echo "=============================================="
  #     echo $PEER_2_ESP
  #     echo "=============================================="
  # PEER_NAME=peer1.esp.integra.com
  #   export CORE_PEER_LOCALMSPID="espMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ESP_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/esp.integra.com/users/Admin@esp.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer1.esp.integra.com:$PEER_2_ESP
  # elif [ $USING_ORG == "broker" ] && [ $USING_PEER == 1 ]; then
  #     echo "=============================================="
  #     echo $PEER_1_BROKER
  #     echo "=============================================="
  # PEER_NAME=peer0.broker.integra.com
  #   export CORE_PEER_LOCALMSPID="brokerMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BROKER_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/broker.integra.com/users/Admin@broker.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer0.broker.integra.com:$PEER_1_BROKER
  # elif [ $USING_ORG == "broker" ] && [ $USING_PEER == 2 ]; then
  #     echo "=============================================="
  #     echo $PEER_2_BROKER
  #     echo "=============================================="
  #   PEER_NAME=peer1.broker.integra.com
  #   export CORE_PEER_LOCALMSPID="brokerMSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_BROKER_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/broker.integra.com/users/Admin@broker.integra.com/msp
  #   export CORE_PEER_ADDRESS=peer1.broker.integra.com:$PEER_2_BROKER  
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.integra.integra.com:$PEER_1_OSQO
  # elif [ $USING_ORG -eq 2 ]; then
  #   export CORE_PEER_ADDRESS=peer0.bcp.integra.com:$PEER_1_BCP
  # elif [ $USING_ORG -eq 3 ]; then
  #   export CORE_PEER_ADDRESS=peer0.esp.integra.com:$PEER_1_ESP
  # elif [ $USING_ORG -eq 4 ]; then
  #   export CORE_PEER_ADDRESS=peer.broker.integra.com:$PEER_1_BROKER
  else
    errorln "ORG Unknown"
  fi
}

# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do  #number of peers greater than 0 

    setGlobals $1
    PEER=$P                                                                                                                     
    echo "PEER in parsePeerConnectionParameters $PEER"                                    

    PEERS="$PEERS $PEER"
    echo "========================================="
    echo " PEERS = $PEER"
    echo "========================================="
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"

    echo "========================================="
    echo " PEER_CONN_PARMS = $PEER_CONN_PARMS"
    echo "========================================="
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$CORE_PEER_TLS_ROOTCERT_FILE")
    echo "========================================="
    echo " TLSINFO = $TLSINFO"
    echo "========================================="
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    echo "========================================="
    echo " PEER_CONN_PARMS = $PEER_CONN_PARMS"
    echo "========================================="
    shift 
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[:space:]*//')"
  echo "FINAL PEERS $PEERS"

}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
