#!/bin/bash
# . envVar.sh

. utils.sh



. set-automate-configuration.sh



function json_explorer_network {
    sed -e "s/\${P0PORT}/$1/" \
        ${PWD}/../ccp-files/explorer-test-network.json
}



P0PORT=${PEER_1_OSQO}


echo "$(json_explorer_network $P0PORT)" > ${PWD}/../explorer/connection-profile/test-network.json
