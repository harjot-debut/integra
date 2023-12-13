#!/bin/bash


. utils.sh

# if [[ $# -lt 1 ]] ; then
#   warnln "Please provide machine name"
#   exit 0
# fi


. set-automate-configuration.sh




echo "**********************************************************"
echo "        GENERATING CONFIGTX.YAML File"
echo "**********************************************************"

echo "
Organizations:

    - &Osqo
       
        Name: osqoMSP
        

        # ID to load the MSP definition as
        ID: osqoMSP

        MSPDir: ../organizations/peerOrganizations/osqo.osqo.com/msp

        Policies:
            Readers:
                Type: Signature
                Rule: OR('osqoMSP.admin', 'osqoMSP.peer', 'osqoMSP.client')
            Writers:
                Type: Signature
                Rule: OR('osqoMSP.admin', 'osqoMSP.client', 'osqoMSP.orderer')
            Admins:
                Type: Signature
                Rule: OR('osqoMSP.admin')
            Endorsement:
                Type: Signature
                Rule: OR('osqoMSP.peer')

        OrdererEndpoints:
            - orderer0.osqo.osqo.com:${ORDERER_1_OSQO}

        AnchorPeers:
            - Host: peer0.osqo.osqo.com
              Port: ${PEER_1_OSQO}        

    - &Bcp
    
        Name: bcpMSP

        # ID to load the MSP definition as
        ID: bcpMSP

        MSPDir: ../organizations/peerOrganizations/bcp.osqo.com/msp

        Policies:
            Readers:
                Type: Signature
                Rule: OR('bcpMSP.admin', 'bcpMSP.peer', 'bcpMSP.client')
            Writers:
                Type: Signature
                Rule: OR('bcpMSP.admin', 'bcpMSP.client', 'bcpMSP.orderer')
            Admins:
                Type: Signature
                Rule: OR('bcpMSP.admin')
            Endorsement:
                Type: Signature
                Rule: OR('bcpMSP.peer')

        OrdererEndpoints:
            - orderer0.bcp.osqo.com:${ORDERER_1_BCP}

        AnchorPeers:       
            - Host: peer0.bcp.osqo.com
              Port: ${PEER_1_BCP} 
              
    - &Esp
        
        Name: espMSP

        # ID to load the MSP definition as
        ID: espMSP

        MSPDir: ../organizations/peerOrganizations/esp.osqo.com/msp

       
        Policies:
            Readers:
                Type: Signature
                Rule: OR('espMSP.admin', 'espMSP.peer', 'espMSP.client')
            Writers:
                Type: Signature
                Rule: OR('espMSP.admin', 'espMSP.client', 'espMSP.orderer')
            Admins:
                Type: Signature
                Rule: OR('espMSP.admin')
            Endorsement:
                Type: Signature
                Rule: OR('espMSP.peer')

        OrdererEndpoints:
            - orderer0.esp.osqo.com:${ORDERER_1_ESP}

        AnchorPeers:
            - Host: peer0.esp.osqo.com
              Port: ${PEER_1_ESP}  

    - &Broker
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: brokerMSP

        # ID to load the MSP definition as
        ID: brokerMSP

        MSPDir: ../organizations/peerOrganizations/broker.osqo.com/msp

        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: OR('brokerMSP.admin', 'brokerMSP.peer', 'brokerMSP.client')
            Writers:
                Type: Signature
                Rule: OR('brokerMSP.admin', 'brokerMSP.client', 'brokerMSP.orderer')
            Admins:
                Type: Signature
                Rule: OR('brokerMSP.admin')
            Endorsement:
                Type: Signature
                Rule: OR('brokerMSP.peer')
        
        OrdererEndpoints:
            - orderer0.broker.osqo.com:${ORDERER_1_BROKER}

        AnchorPeers:
            # AnchorPeers defines the location of peers which can be used
            # for cross org gossip communication.  Note, this value is only
            # encoded in the genesis block in the Application section context
            - Host: peer0.broker.osqo.com
              Port: ${PEER_1_BROKER}                    

################################################################################
#
#   SECTION: Capabilities

################################################################################
Capabilities:
    Channel: &ChannelCapabilities
        V2_0: true

    Orderer: &OrdererCapabilities
        V2_0: true

    Application: &ApplicationCapabilities
        V2_0: true

################################################################################
#
#   SECTION: Application
#
################################################################################
Application: &ApplicationDefaults

    Organizations:

    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        LifecycleEndorsement:
            Type: ImplicitMeta
            Rule: "MAJORITY Endorsement"
        Endorsement:
            Type: ImplicitMeta
            Rule: "MAJORITY Endorsement"

    Capabilities:
        <<: *ApplicationCapabilities
################################################################################
#
#   SECTION: Orderer
#
################################################################################
Orderer: &OrdererDefaults

    # Orderer Type: The orderer implementation to start
    OrdererType: etcdraft
    
    Addresses:
        - orderer0.osqo.osqo.com:${ORDERER_1_OSQO}
        - orderer0.bcp.osqo.com:${ORDERER_1_BCP}
        - orderer0.esp.osqo.com:${ORDERER_1_ESP}
        - orderer0.broker.osqo.com:${ORDERER_1_BROKER}
        

    EtcdRaft:
        Consenters:
        - Host: orderer0.osqo.osqo.com
          Port: ${ORDERER_1_OSQO} 
          ClientTLSCert: ../organizations/peerOrganizations/osqo.osqo.com/peers/orderer0.osqo.osqo.com/tls/server.crt
          ServerTLSCert: ../organizations/peerOrganizations/osqo.osqo.com/peers/orderer0.osqo.osqo.com/tls/server.crt
        - Host: orderer0.bcp.osqo.com
          Port: ${ORDERER_1_BCP} 
          ClientTLSCert: ../organizations/peerOrganizations/bcp.osqo.com/peers/orderer0.bcp.osqo.com/tls/server.crt
          ServerTLSCert: ../organizations/peerOrganizations/bcp.osqo.com/peers/orderer0.bcp.osqo.com/tls/server.crt
        - Host: orderer0.esp.osqo.com
          Port: ${ORDERER_1_ESP} 
          ClientTLSCert: ../organizations/peerOrganizations/esp.osqo.com/peers/orderer0.esp.osqo.com/tls/server.crt
          ServerTLSCert: ../organizations/peerOrganizations/esp.osqo.com/peers/orderer0.esp.osqo.com/tls/server.crt
        - Host: orderer0.broker.osqo.com
          Port: ${ORDERER_1_BROKER} 
          ClientTLSCert: ../organizations/peerOrganizations/broker.osqo.com/peers/orderer0.broker.osqo.com/tls/server.crt
          ServerTLSCert: ../organizations/peerOrganizations/broker.osqo.com/peers/orderer0.broker.osqo.com/tls/server.crt
        



    # Batch Timeout: The amount of time to wait before creating a batch
    BatchTimeout: 2s

    # Batch Size: Controls the number of messages batched into a block
    BatchSize:

        # Max Message Count: The maximum number of messages to permit in a batch
        MaxMessageCount: 10

        # Absolute Max Bytes: The absolute maximum number of bytes allowed for
        # the serialized messages in a batch.
        AbsoluteMaxBytes: 99 MB

        # Preferred Max Bytes: The preferred maximum number of bytes allowed for
        # the serialized messages in a batch. A message larger than the preferred
        # max bytes will result in a batch larger than preferred max bytes.
        PreferredMaxBytes: 512 KB

    # Organizations is the list of orgs which are defined as participants on
    # the orderer side of the network
    Organizations:

    # Policies defines the set of policies at this level of the config tree
    # For Orderer policies, their canonical path is
    #   /Channel/Orderer/<PolicyName>
    Policies:
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"
        # BlockValidation specifies what signatures must be included in the block
        # from the orderer for the peer to validate it.
        BlockValidation:
            Type: ImplicitMeta
            Rule: "ANY Writers"
    Capabilities:
        <<: *OrdererCapabilities        

################################################################################
#
#   CHANNEL
#
################################################################################
Channel: &ChannelDefaults
    Policies:
        # Who may invoke the 'Deliver' API
        Readers:
            Type: ImplicitMeta
            Rule: "ANY Readers"
        # Who may invoke the 'Broadcast' API
        Writers:
            Type: ImplicitMeta
            Rule: "ANY Writers"
        # By default, who may modify elements at this config level
        Admins:
            Type: ImplicitMeta
            Rule: "MAJORITY Admins"

    Capabilities:
        <<: *ChannelCapabilities

################################################################################
#
#   Profile
#
################################################################################
Profiles:

    OrgsOrdererGenesis:
        <<: *ChannelDefaults
        Capabilities:
            <<: *ChannelCapabilities
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *Osqo
                - *Bcp
                - *Esp
                - *Broker
            Capabilities:
                <<: *OrdererCapabilities
        Consortiums:
            OsqoConsortium:
                Organizations:
                    - *Osqo
                    - *Bcp
                    - *Esp
                    - *Broker
    OrgsChannel:
        Consortium: OsqoConsortium
        <<: *ChannelDefaults
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *Osqo
                - *Bcp
                - *Esp
                - *Broker
            Capabilities:
                <<: *ApplicationCapabilities

    MultiNodeEtcdRaft:
        <<: *ChannelDefaults
        Capabilities:
            <<: *ChannelCapabilities
        Orderer:
            <<: *OrdererDefaults
            OrdererType: etcdraft
            EtcdRaft:
                Consenters:
                - Host: orderer0.osqo.osqo.com
                  Port: 7050
                  ClientTLSCert: ../organizations/peerOrganizations/osqo.osqo.com/peers/orderer0.osqo.osqo.com/tls/server.crt
                  ServerTLSCert: ../organizations/peerOrganizations/osqo.osqo.com/peers/orderer.osqo.osqo.com/tls/server.crt
                - Host: orderer0.bcp.osqo.com
                  Port: 7050
                  ClientTLSCert: ../organizations/peerOrganizations/bcp.osqo.com/peers/orderer0.bcp.osqo.com/tls/server.crt
                  ServerTLSCert: ../organizations/peerOrganizations/bcp.osqo.com/peers/orderer0.bcp.osqo.com/tls/server.crt
                - Host: orderer0.broker.osqo.com
                  Port: 7050
                  ClientTLSCert: ../organizations/peerOrganizations/broker.osqo.com/peers/orderer0.broker.osqo.com/tls/server.crt
                  ServerTLSCert: ../organizations/peerOrganizations/broker.osqo.com/peers/orderer0.broker.osqo.com/tls/server.crt
                - Host: orderer0.esp.osqo.com
                  Port: 7050
                  ClientTLSCert: ../organizations/peerOrganizations/esp.osqo.com/peers/orderer0.esp.osqo.com/tls/server.crt
                  ServerTLSCert: ../organizations/peerOrganizations/esp.osqo.com/peers/orderer0.esp.osqo.com/tls/server.crt

            Addresses:
                - orderer0.osqo.osqo.com:7050
                - orderer0.bcp.osqo.com:8050
                - orderer0.esp.osqo.com:9050
                - orderer0.broker.osqo.com:10050
                

            # Organizations:
            # - *Orderermethodbridge
            Capabilities:
                <<: *OrdererCapabilities
        Application:
            <<: *ApplicationDefaults
            # Organizations:
            # - <<: *Orderermethodbridge
        Consortiums:
            OsqoConsortium:
                Organizations:
                - *Osqo
                - *Bcp
                - *Esp
                - *Broker
"> ../configtx/configtx.yaml





echo "**********************************************************"
echo "        GENERATING PEER/ORDERER FOR OSQO"
echo "**********************************************************"


echo "
version: '2'

networks:
  netname:
    name: osqo-methodbridge

services:



  orderer0.osqo.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: orderer0.osqo.osqo.com
    image: hyperledger/fabric-orderer:2.4.4
    environment:
      - FABRIC_LOGGING_SPEC=INFO
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_LISTENPORT=7050
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=osqoMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
      # enabled TLS
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_TLS_CERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_TLS_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
      - ORDERER_KAFKA_TOPIC_REPLICATIONFACTOR=1
      - ORDERER_KAFKA_VERBOSE=true
      - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_CLUSTER_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    ports:
      - ${ORDERER_1_OSQO}:7050
    volumes:
        - ../system-genesis-file/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
        - ../organizations/peerOrganizations/osqo.osqo.com/peers/orderer0.osqo.osqo.com/msp:/var/hyperledger/orderer/msp
        - ../organizations/peerOrganizations/osqo.osqo.com/peers/orderer0.osqo.osqo.com/tls/:/var/hyperledger/orderer/tls
        - ../../../network-data/orderer0.osqo.osqo.com:/var/hyperledger/production/orderer
    networks:
      - netname


  peer0.osqo.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer0.osqo.osqo.com
    image: hyperledger/fabric-peer:2.4.4
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer0.osqo.osqo.com
      - CORE_PEER_ADDRESS=peer0.osqo.osqo.com:${PEER_1_OSQO}
      - CORE_PEER_LISTENADDRESS=0.0.0.0:${PEER_1_OSQO}
      - CORE_PEER_CHAINCODEADDRESS=peer0.osqo.osqo.com:`expr $PEER_1_OSQO + 1`
      # - CORE_PEER_CHAINCODEADDRESS=peer0.osqo.osqo.com:`expr $PEER_1_OSQO + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_1_OSQO + 1`
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer1.osqo.osqo.com:${PEER_2_OSQO}
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.osqo.osqo.com:${PEER_1_OSQO}
      - CORE_PEER_LOCALMSPID=osqoMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-osqo-peer0:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_OSQO_PEER1}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_OSQO_PEER1}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/osqo.osqo.com/peers/peer0.osqo.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/osqo.osqo.com/peers/peer0.osqo.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer0.osqo.osqo.com:/var/hyperledger/production
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - ${PEER_1_OSQO}:${PEER_1_OSQO}
    networks:
      - netname
    depends_on:
      - couchdb-osqo-peer0         

  peer1.osqo.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer1.osqo.osqo.com
    image: hyperledger/fabric-peer:2.4.4
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer1.osqo.osqo.com
      - CORE_PEER_ADDRESS=peer1.osqo.osqo.com:${PEER_2_OSQO}
      - CORE_PEER_LISTENADDRESS=0.0.0.0:${PEER_2_OSQO}
      - CORE_PEER_CHAINCODEADDRESS=peer1.osqo.osqo.com:`expr $PEER_2_OSQO + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_2_OSQO + 1`
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.osqo.osqo.com:${PEER_1_OSQO}
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.osqo.osqo.com:${PEER_2_OSQO}
      - CORE_PEER_LOCALMSPID=osqoMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-osqo-peer1:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_OSQO_PEER2}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_OSQO_PEER2}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/osqo.osqo.com/peers/peer1.osqo.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/osqo.osqo.com/peers/peer1.osqo.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer1.osqo.osqo.com:/var/hyperledger/production
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - $PEER_2_OSQO:$PEER_2_OSQO
    networks:
      - netname 
    depends_on:
      - couchdb-osqo-peer1    

  couchdb-osqo-peer0:
    container_name: couchdb-osqo-peer0
    image: couchdb:3.1.1

    environment:
      - COUCHDB_USER=${COUCHDB_USER_OSQO_PEER1}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_OSQO_PEER1}
    ports:
      - $COUCHDB_OSQO_PEER_1:5984
    networks:
      - netname

  couchdb-osqo-peer1:
    container_name: couchdb-osqo-peer1
    image: couchdb:3.1.1
    environment:
      - COUCHDB_USER=${COUCHDB_USER_OSQO_PEER2}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_OSQO_PEER2}
    ports:
      - $COUCHDB_OSQO_PEER_2:5984
    networks:
      - netname   
"> ../docker-compose-network/docker-compose-osqo.yaml       



echo "**********************************************************"
echo "        GENERATING PEER/ORDERER FOR BCP"
echo "**********************************************************"


echo "
version: '2'

networks:
  netname:
    name: osqo-methodbridge

services:



  orderer0.bcp.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: orderer0.bcp.osqo.com
    image: hyperledger/fabric-orderer:2.4.4
    environment:
      - FABRIC_LOGGING_SPEC=INFO
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_LISTENPORT=7050
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=bcpMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
      # enabled TLS
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_TLS_CERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_TLS_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
      - ORDERER_KAFKA_TOPIC_REPLICATIONFACTOR=1
      - ORDERER_KAFKA_VERBOSE=true
      - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_CLUSTER_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    ports:
      - $ORDERER_1_BCP:7050
    volumes:
        - ../system-genesis-file/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
        - ../organizations/peerOrganizations/bcp.osqo.com/peers/orderer0.bcp.osqo.com/msp:/var/hyperledger/orderer/msp
        - ../organizations/peerOrganizations/bcp.osqo.com/peers/orderer0.bcp.osqo.com/tls/:/var/hyperledger/orderer/tls
        - ../../../network-data/orderer0.bcp.osqo.com:/var/hyperledger/production/orderer
    networks:
      - netname

  peer0.bcp.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer0.bcp.osqo.com
    image: hyperledger/fabric-peer:2.4.4
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer0.bcp.osqo.com
      - CORE_PEER_ADDRESS=peer0.bcp.osqo.com:$PEER_1_BCP
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER_1_BCP
      - CORE_PEER_CHAINCODEADDRESS=peer0.bcp.osqo.com:`expr $PEER_1_BCP + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_1_BCP + 1`
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.bcp.osqo.com:$PEER_1_BCP
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer1.bcp.osqo.com:$PEER_2_BCP
      - CORE_PEER_LOCALMSPID=bcpMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-bcp-peer0:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_BCP_PEER1}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_BCP_PEER1}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/bcp.osqo.com/peers/peer0.bcp.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/bcp.osqo.com/peers/peer0.bcp.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer0.bcp.osqo.com:/var/hyperledger/production      
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - $PEER_1_BCP:$PEER_1_BCP
    networks:
      - netname
    depends_on:
      - couchdb-bcp-peer0  

  peer1.bcp.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer1.bcp.osqo.com
    image: hyperledger/fabric-peer:2.4.4
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer1.bcp.osqo.com
      - CORE_PEER_ADDRESS=peer1.bcp.osqo.com:$PEER_2_BCP
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER_2_BCP
      - CORE_PEER_CHAINCODEADDRESS=peer1.bcp.osqo.com:`expr $PEER_2_BCP + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_2_BCP + 1`
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.bcp.osqo.com:$PEER_2_BCP
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.bcp.osqo.com:$PEER_1_BCP
      - CORE_PEER_LOCALMSPID=bcpMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-bcp-peer1:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_BCP_PEER2}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_BCP_PEER2}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/bcp.osqo.com/peers/peer1.bcp.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/bcp.osqo.com/peers/peer1.bcp.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer1.bcp.osqo.com:/var/hyperledger/production
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - $PEER_2_BCP:$PEER_2_BCP
    networks:
      - netname  
    depends_on:
      - couchdb-bcp-peer1    

  couchdb-bcp-peer0:
    container_name: couchdb-bcp-peer0
    image: couchdb:3.1.1
    environment:
      - COUCHDB_USER=${COUCHDB_USER_BCP_PEER1}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_BCP_PEER1}
    ports:
      - $COUCHDB_BCP_PEER_1:5984
    networks:
      - netname       

  couchdb-bcp-peer1:
    container_name: couchdb-bcp-peer1
    image: couchdb:3.1.1

    environment:
      - COUCHDB_USER=${COUCHDB_USER_BCP_PEER2}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_BCP_PEER2}
    ports:
      - $COUCHDB_BCP_PEER_2:5984
    networks:
      - netname
"> ../docker-compose-network/docker-compose-bcp.yaml   



echo "**********************************************************"
echo "        GENERATING PEER/ORDERER FOR ESP"
echo "**********************************************************"


echo "
version: '2'

networks:
  netname:
    name: osqo-methodbridge

services:


  orderer0.esp.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: orderer0.esp.osqo.com
    image: hyperledger/fabric-orderer:2.4.4
    environment:
      - FABRIC_LOGGING_SPEC=INFO
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_LISTENPORT=7050
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=espMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
      # enabled TLS
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_TLS_CERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_TLS_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
      - ORDERER_KAFKA_TOPIC_REPLICATIONFACTOR=1
      - ORDERER_KAFKA_VERBOSE=true
      - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_CLUSTER_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    ports:
      - $ORDERER_1_ESP:7050
    volumes:
        - ../system-genesis-file/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
        - ../organizations/peerOrganizations/esp.osqo.com/peers/orderer0.esp.osqo.com/msp:/var/hyperledger/orderer/msp
        - ../organizations/peerOrganizations/esp.osqo.com/peers/orderer0.esp.osqo.com/tls/:/var/hyperledger/orderer/tls
        - ../../../network-data/orderer0.esp.osqo.com:/var/hyperledger/production/orderer
    networks:
      - netname

  peer0.esp.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer0.esp.osqo.com
    image: hyperledger/fabric-peer:2.4.4
 
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer0.esp.osqo.com
      - CORE_PEER_ADDRESS=peer0.esp.osqo.com:$PEER_1_ESP
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER_1_ESP
      - CORE_PEER_CHAINCODEADDRESS=peer0.esp.osqo.com:`expr $PEER_1_ESP + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_1_ESP + 1`
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.esp.osqo.com:$PEER_1_ESP
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer1.esp.osqo.com:$PEER_2_ESP
      - CORE_PEER_LOCALMSPID=espMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-esp-peer0:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_ESP_PEER1}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_ESP_PEER1}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/esp.osqo.com/peers/peer0.esp.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/esp.osqo.com/peers/peer0.esp.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer0.esp.osqo.com:/var/hyperledger/production      
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - $PEER_1_ESP:$PEER_1_ESP
    networks:
      - netname
    depends_on:
      - couchdb-esp-peer0    

  peer1.esp.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer1.esp.osqo.com
    image: hyperledger/fabric-peer:2.4.4
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer1.esp.osqo.com
      - CORE_PEER_ADDRESS=peer1.esp.osqo.com:$PEER_2_ESP
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER_2_ESP
      - CORE_PEER_CHAINCODEADDRESS=peer1.esp.osqo.com:`expr $PEER_2_ESP + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_2_ESP + 1`
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.esp.osqo.com:$PEER_2_ESP
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.esp.osqo.com:$PEER_1_ESP
      - CORE_PEER_LOCALMSPID=espMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-esp-peer1:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_ESP_PEER2}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_ESP_PEER2}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/esp.osqo.com/peers/peer1.esp.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/esp.osqo.com/peers/peer1.esp.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer1.esp.osqo.com:/var/hyperledger/production      
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - $PEER_2_ESP:$PEER_2_ESP
    networks:
      - netname
    depends_on:
      - couchdb-esp-peer1
    
  couchdb-esp-peer0:
    container_name: couchdb-esp-peer0
    image: couchdb:3.1.1

    environment:
      - COUCHDB_USER=${COUCHDB_USER_ESP_PEER1}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_ESP_PEER1}
    ports:
      - $COUCHDB_ESP_PEER_1:5984
    networks:
      - netname

  couchdb-esp-peer1:
    container_name: couchdb-esp-peer1
    image: couchdb:3.1.1

    environment:
      - COUCHDB_USER=${COUCHDB_USER_ESP_PEER2}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_ESP_PEER2}
    ports:
      - $COUCHDB_ESP_PEER_2:5984
    networks:
      - netname 
  
"> ../docker-compose-network/docker-compose-esp.yaml



echo "**********************************************************"
echo "        GENERATING PEER/ORDERER FOR BROKER"
echo "**********************************************************"


echo "
version: '2'

networks:
  netname:
    name: osqo-methodbridge
  

services:


  orderer0.broker.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: orderer0.broker.osqo.com
    image: hyperledger/fabric-orderer:2.4.4
    environment:
      - FABRIC_LOGGING_SPEC=INFO
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_LISTENPORT=7050
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=brokerMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
      # enabled TLS
      - ORDERER_GENERAL_TLS_ENABLED=true
      - ORDERER_GENERAL_TLS_PRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_TLS_CERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_TLS_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
      - ORDERER_KAFKA_TOPIC_REPLICATIONFACTOR=1
      - ORDERER_KAFKA_VERBOSE=true
      - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=/var/hyperledger/orderer/tls/server.crt
      - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=/var/hyperledger/orderer/tls/server.key
      - ORDERER_GENERAL_CLUSTER_ROOTCAS=[/var/hyperledger/orderer/tls/ca.crt]
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    ports:
      - $ORDERER_1_BROKER:7050
    volumes:
        - ../system-genesis-file/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
        - ../organizations/peerOrganizations/broker.osqo.com/peers/orderer0.broker.osqo.com/msp:/var/hyperledger/orderer/msp
        - ../organizations/peerOrganizations/broker.osqo.com/peers/orderer0.broker.osqo.com/tls/:/var/hyperledger/orderer/tls
        - ../../../network-data/orderer0.broker.osqo.com:/var/hyperledger/production/orderer
    networks:
      - netname
      

  peer0.broker.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer0.broker.osqo.com
    image: hyperledger/fabric-peer:2.4.4
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_PROFILE_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer0.broker.osqo.com
      - CORE_PEER_ADDRESS=peer0.broker.osqo.com:$PEER_1_BROKER
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER_1_BROKER
      - CORE_PEER_CHAINCODEADDRESS=peer0.broker.osqo.com:`expr $PEER_1_BROKER + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_1_BROKER + 1`
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.broker.osqo.com:$PEER_1_BROKER
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer1.broker.osqo.com:$PEER_2_BROKER
      - CORE_PEER_LOCALMSPID=brokerMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-broker-peer0:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_BROKER_PEER1}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_BROKER_PEER1}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/broker.osqo.com/peers/peer0.broker.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/broker.osqo.com/peers/peer0.broker.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer0.broker.osqo.com:/var/hyperledger/production      
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - $PEER_1_BROKER:$PEER_1_BROKER
    networks:
      - netname
    depends_on:
      - couchdb-broker-peer0

  peer1.broker.osqo.com:
    extends:
      file: peer-base.yaml
      service: peer
    container_name: peer1.broker.osqo.com
    image: hyperledger/fabric-peer:2.4.4
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=osqo-methodbridge
      - FABRIC_LOGGING_SPEC=INFO
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/fabric/tls/server.crt
      - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/fabric/tls/server.key
      - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
      - CORE_PEER_ID=peer1.broker.osqo.com
      - CORE_PEER_ADDRESS=peer1.broker.osqo.com:$PEER_2_BROKER
      - CORE_PEER_LISTENADDRESS=0.0.0.0:$PEER_2_BROKER
      - CORE_PEER_CHAINCODEADDRESS=peer1.broker.osqo.com:`expr $PEER_2_BROKER + 1`
      - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:`expr $PEER_2_BROKER + 1`
      - CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.broker.osqo.com:$PEER_2_BROKER
      - CORE_PEER_GOSSIP_BOOTSTRAP=peer0.broker.osqo.com:$PEER_1_BROKER
      - CORE_PEER_LOCALMSPID=brokerMSP
      - CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb-broker-peer1:5984
      - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=${COUCHDB_USER_BROKER_PEER2}
      - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=${COUCHDB_PASSWORD_BROKER_PEER2}
    volumes:
        - /var/run/docker.sock:/host/var/run/docker.sock
        - ../organizations/peerOrganizations/broker.osqo.com/peers/peer1.broker.osqo.com/msp:/etc/hyperledger/fabric/msp
        - ../organizations/peerOrganizations/broker.osqo.com/peers/peer1.broker.osqo.com/tls:/etc/hyperledger/fabric/tls
        - ../../../network-data/peer1.broker.osqo.com:/var/hyperledger/production
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    command: peer node start
    ports:
      - $PEER_2_BROKER:$PEER_2_BROKER
    networks:
      - netname  
    depends_on:
      - couchdb-broker-peer1    

  couchdb-broker-peer0:
    container_name: couchdb-broker-peer0
    image: couchdb:3.1.1

    environment:
      - COUCHDB_USER=${COUCHDB_USER_BROKER_PEER1}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_BROKER_PEER1}
    ports:
      - $COUCHDB_BROKER_PEER_1:5984
    networks:
      - netname 

  couchdb-broker-peer1:
    container_name: couchdb-broker-peer1
    image: couchdb:3.1.1

    environment:
      - COUCHDB_USER=${COUCHDB_USER_BROKER_PEER2}
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD_BROKER_PEER2}
    ports:
      - $COUCHDB_BROKER_PEER_2:5984
    networks:
      - netname               
   
"> ../docker-compose-network/docker-compose-broker.yaml
