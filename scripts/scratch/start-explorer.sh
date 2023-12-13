#!/bin/bash


echo ""
echo ""
echo "======================================================"
echo "  GENERATING EXPLORER NETWORK JSON FILE FOR EXPLORER"
echo "======================================================"
echo ""
echo ""

set -eo pipefail 

temp_file=$(mktemp) 



set -eo pipefail

jq --arg username $(jq -r '.machines[] | select(.name == "explorer") | .user_name' ./config.json) '.client.adminCredential.id = $username' ${PWD}/explorer-data/connection-profile/test-network.json > "$temp_file" && mv "$temp_file" ${PWD}/explorer-data/connection-profile/test-network-updated.json; 


set -eo pipefail

jq --arg password $(jq -r '.machines[] | select(.name == "explorer") | .password' ./config.json) '.client.adminCredential.password = $password' ${PWD}/explorer-data/connection-profile/test-network-updated.json > "$temp_file" && mv "$temp_file" ${PWD}/explorer-data/connection-profile/test-network-updated.json



set -eo pipefail

mv ${PWD}/explorer-data/connection-profile/test-network-updated.json ${PWD}/explorer-data/connection-profile/test-network.json



echo ""
echo ""
echo "====================================================="
echo "  EXPLORER NETWORK JSON FILE GENERATED SUCCESSFULLY"
echo "====================================================="
echo ""
echo ""




echo ""
echo ""
echo "============================================"
echo "  ADDING HOSTS ENTRIES"
echo "============================================"
echo ""
echo ""

sleep 2

set -eo pipefail

./set-peer-base.sh etc

sleep 2

echo ""
echo ""
echo "============================================"
echo "  HOSTS ENTRIES ADDED SUCCESSFULLY"
echo "============================================"
echo ""
echo ""


echo ""
echo ""
echo "============================================"
echo "  RUNNING EXPLORER "
echo "============================================"
echo ""
echo ""

sleep 2

./set-peer-base.sh etc

docker-compose -f ./explorer-data/docker-compose-explorer.yaml up -d

sleep 2

echo ""
echo ""
echo "============================================"
echo "  EXPLORER RUNNING SUCCESSFULLY"
echo "============================================"
echo ""
echo ""


