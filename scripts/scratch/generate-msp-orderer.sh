#!/bin/bash
set -e
. envVar.sh

if [[ $# -lt 1 ]] ; then
  warnln "Invalid Command"
  exit 0
fi


if [[ $1 != "re-generate" ]] ; then
  warnln "Invalid Command"
  exit 0
fi


ORDERER="orderer"


# certificate authorities compose file for orderer
COMPOSE_FILE_CA_ORDERER=../docker-compose-ca/orderer/compose/docker-compose-orderer-ca.yaml

function orgCaUp(){
  echo "Running ca server for orderer"
  docker-compose -f $1 up -d 2>&1
}

orgCaUp $COMPOSE_FILE_CA_ORDERER




export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../configtx
export VERBOSE=false




# =========================================== ORDERER ======================================

# =============================== ENROLLING CA ADMIN FOR ORDERER ===============================
function enrollOrdererCaAdmin(){
    echo "=================================================="
    echo "ENROLL CA for "$1
    echo "=================================================="

    mkdir -p ${PWD}/../organizations/ordererOrganizations/integra.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/integra.com/

    set -x
    fabric-ca-client enroll -u https://admin:adminpw@localhost:$2 --caname ca-$1 --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
    { set +x; } 2>/dev/null

}

# enrolling orderer CA Admin
enrollOrdererCaAdmin $ORDERER 11054



# Writing config.yaml file for orderer
    echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/ordererOrganizations/integra.com/msp/config.yaml


# =============================== REGISTER ORDERER ===============================

function RegisterOrderer(){
  echo "=================================================="
  echo "Register orderer "
  echo "=================================================="

 export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/integra.com/

  set -x
  fabric-ca-client register --caname ca-$1 --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null
}

RegisterOrderer $ORDERER

# =============================== REGISTER ORDERER ADMIN ===============================

function RegisterOrdererAdmin(){
  echo "=================================================="
  echo "Register orderer admin"
  echo "=================================================="

 export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/integra.com/

  set -x
  fabric-ca-client register --caname ca-$1 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null
}

RegisterOrdererAdmin $ORDERER


# =============================== REGISTER ORDERER MSP ===============================

function GenerateOrdererMSP(){
  echo "=================================================="
  echo "Generating orderer MSP for" $2
  echo "=================================================="

  echo "ca orderer"
  echo $1

   echo "ca node"
  echo $2

   echo "port"
  echo $3

 export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/integra.com/

  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:$3 --caname ca-$1 -M ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/msp --csr.hosts $2.integra.com --csr.hosts 13.59.243.154 --csr.hosts 18.217.52.1 --csr.hosts localhost --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/ordererOrganizations/integra.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/msp/config.yaml

 } 

GenerateOrdererMSP $ORDERER orderer 11054
GenerateOrdererMSP $ORDERER orderer2 11054
GenerateOrdererMSP $ORDERER orderer3 11054
GenerateOrdererMSP $ORDERER orderer4 11054
GenerateOrdererMSP $ORDERER orderer5 11054
 

function GenerateOrdererAdminMSP(){
  echo "=================================================="
  echo "Generating orderer Admin MSP"
  echo "=================================================="

  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/ordererOrganizations/integra.com/users/Admin@integra.com/msp --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/ordererOrganizations/integra.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/integra.com/users/Admin@integra.com/msp/config.yaml
}

GenerateOrdererAdminMSP $ORDERER 11054

# =============================== GENERATE ORDERER TLS ===============================

function GenerateOrdererTLS(){
  echo "=================================================="
  echo "Generate orderer TLS for "$2
  echo "=================================================="

  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/integra.com/

  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:$3 --caname ca-$1 -M ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls --enrollment.profile tls --csr.hosts 13.59.243.154 --csr.hosts 18.217.52.1 --csr.hosts $2.integra.com --csr.hosts localhost --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null


  
  cp ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/ca.crt
  
  cp ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/signcerts/* ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/server.crt

  cp ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/keystore/* ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/server.key

  mkdir -p ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/msp/tlscacerts/tlsca.integra.com-cert.pem

  mkdir -p ${PWD}/../organizations/ordererOrganizations/integra.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/integra.com/orderers/$2.integra.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/integra.com/msp/tlscacerts/tlsca.integra.com-cert.pem

}

GenerateOrdererTLS $ORDERER orderer 11054
GenerateOrdererTLS $ORDERER orderer2 11054
GenerateOrdererTLS $ORDERER orderer3 11054
GenerateOrdererTLS $ORDERER orderer4 11054
GenerateOrdererTLS $ORDERER orderer5 11054

