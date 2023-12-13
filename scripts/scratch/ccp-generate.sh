#!/bin/bash
# . envVar.sh

. utils.sh

# if [[ $# -lt 1 ]] ; then
#   warnln "Please provide machine name"
#   exit 0
# fi


. set-automate-configuration.sh


function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${PEERNAME1}/$6/" \
        -e "s/\${PEERNAME2}/$7/" \
        -e "s/\${P1PORT}/$8/" \
        ${PWD}/../ccp-files/ccp-osqo.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${PEERNAME1}/$6/" \
        -e "s/\${PEERNAME2}/$7/" \
        -e "s/\${P1PORT}/$8/" \
        ${PWD}/../ccp-files/ccp-osqo.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

# generating ccp for osqo

ORG="osqo"
P0PORT=${PEER_1_OSQO}
P1PORT=${PEER_2_OSQO}
CAPORT=7054
PEERPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem
CAPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/ca/ca.${ORG}.osqo.com-cert.pem
PEERNAME1=peer0
PEERNAME2=peer1


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/$ORG.osqo.com/connection-$ORG.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.yaml



# generating ccp for bcp

ORG="bcp"
CAPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/ca/ca.${ORG}.osqo.com-cert.pem
PEERNAME1=peer0
PEERNAME2=peer1


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/$ORG.osqo.com/connection-$ORG.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.yaml



# generating ccp for bcp1

ORG="bcp"
P0PORT=${PEER_1_BCP}
P1PORT=${PEER_2_BCP}
CAPORT=8054
PEERPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem
CAPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/ca/ca.${ORG}.osqo.com-cert.pem
PEERNAME1=peer0
PEERNAME2=peer1

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.yaml


# generating ccp for esp

ORG="esp"
P0PORT=${PEER_1_ESP}
P1PORT=${PEER_2_ESP}
CAPORT=9054
PEERPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem
CAPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/ca/ca.${ORG}.osqo.com-cert.pem
PEERNAME1=peernbhJfZXhbyjKmBGn7WNW0
PEERNAME2=peer1

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.yaml



# generating ccp for esp

ORG="broker"
P0PORT=${PEER_1_BROKER}
P1PORT=${PEER_2_BROKER}
CAPORT=10054
PEERPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/tlsca/tlsca.${ORG}.osqo.com-cert.pem
CAPEM=${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/ca/ca.${ORG}.osqo.com-cert.pem
PEERNAME1=peer0
PEERNAME2=peer1

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.osqo.com/connection-${ORG}.yaml






function json_explorer_network {
    sed -e "s/\${P0PORT}/$1/" \
        ${PWD}/../ccp-files/explorer-test-network.json
}



P0PORT=${PEER_1_OSQO}


echo "$(json_explorer_network $P0PORT)" > ${PWD}/../explorer-data/connection-profile/test-network.json