. envVar.sh



#file where IPS and ports are set
. set-automate-configuration.sh

export PATH=${HOME}/fabric-samples/bin:$PATH
export VERBOSE=false
export FABRIC_CFG_PATH=${PWD}/../configtx/

CHANNEL_NAME="integra-channel"
CHANNELFILE="../channel-artifacts/${CHANNEL_NAME}.block"

DELAY=2
CLI_DELAY=3
MAX_RETRY=5


export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/integra.com/orderers/orderer.integra.com/msp/tlscacerts/tlsca.integra.com-cert.pem


export ORDERER_ADMIN_TLS_SIGN_CERT=export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/integra.com/orderers/orderer.integra.com/tls/server.crt


createChannel() {
	export FABRIC_CFG_PATH=${PWD}/../configtx/
	echo "=================================================="
    echo "CREATING CHANNEL"
    echo "=================================================="
	setGlobals 1

	echo "=================================================="
    echo "Peers info tls root"
    echo "=================================================="
	echo $CORE_PEER_TLS_ROOTCERT_FILE

	echo "================================================="
    echo "Peers info msp config path"
    echo "=================================================="
	echo $CORE_PEER_MSPCONFIGPATH
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
		# peer channel create -o orderer0.integra.integra.com:$ORDERER_1_OSQO -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer0.integra.integra.com -f ${PWD}/../channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $CHANNELFILE --tls --cafile $ORDERER_CA >& ${PWD}/../logs/peerLogs.txt


		osnadmin channel join --channelID $CHANNEL_NAME --config-block ./system-genesis-file/${CHANNEL_NAME}.block -o orderer.integra.com:7050 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >& ${PWD}/../logs/peerLogs.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)

	done
	cat ${PWD}/../logs/peerLogs.txt
	verifyResult $res "Channel creation failed"
}

# create Channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

