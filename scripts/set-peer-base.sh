#!/bin/bash


. utils.sh


if [[ $# -lt 1 ]] ; then
  warnln "Please provide machine name"
  exit 0
fi

# importing automate-Ip file
. set-automate-configuration.sh

#PEERS

PEER0_INTEGRA=peer0.integra.integra.com
PEER1_INTEGRA=peer1.integra.integra.com

PEER0_INTEGRA_IP=${INTEGRA_IP}
PEER1_INTEGRA_IP=${INTEGRA_IP}


# PEER0_BCP=peer0.bcp.integra.com
# PEER1_BCP=peer1.bcp.integra.com

# PEER0_BCP_IP=${BCP_IP}
# PEER1_BCP_IP=${BCP_IP}


# PEER0_ESP_IP=${ESP_IP}
# PEER1_ESP_IP=${ESP_IP}


# PEER0_ESP=peer0.esp.integra.com
# PEER1_ESP=peer1.esp.integra.com

# PEER0_BROKER_IP=${BROKER_IP}
# PEER1_BROKER_IP=${BROKER_IP}


# PEER0_BROKER=peer0.broker.integra.com
# PEER1_BROKER=peer1.broker.integra.com


# #ORDERERS

# ORDERER_INTEGRA_IP=${INTEGRA_IP}
# ORDERER_BCP_IP=${BCP_IP}
# ORDERER_ESP_IP=${ESP_IP}
# ORDERER_BROKER_IP=${BROKER_IP}


# LOCALHOST_IP=127.0.0.1


# ORDERER_INTEGRA=orderer0.integra.integra.com
# ORDERER_BCP=orderer0.bcp.integra.com
# ORDERER_BROKER=orderer0.broker.integra.com
# ORDERER_ESP=orderer0.esp.integra.com




if [[ $1 = "etc" ]] ; then


  export EXTRA_HOSTS="
       - ${PEER0_INTEGRA}:${INTEGRA_IP}    
       - ${PEER1_INTEGRA}:${INTEGRA_IP}  
       - ${ORDERER_INTEGRA}:${INTEGRA_IP}  
       - ${PEER0_BCP}:${BCP_IP}    
       - ${PEER1_BCP}:${BCP_IP}  
       - ${ORDERER_BCP}:${BCP_IP}   
       - ${PEER0_ESP}:${ESP_IP}    
       - ${PEER1_ESP}:${ESP_IP}  
       - ${ORDERER_ESP}:${ESP_IP}     
       - ${PEER0_BROKER}:${BROKER_IP}         
       - ${PEER1_BROKER}:${BROKER_IP} 
       - ${ORDERER_BROKER}:${BROKER_IP}              
  "

  declare -A ENTRIES=(
    [${PEER0_INTEGRA}]="${PEER0_INTEGRA_IP}"
    [${PEER1_INTEGRA}]="${PEER1_INTEGRA_IP}"
    [${ORDERER_INTEGRA}]="${ORDERER_INTEGRA_IP}"
    [${PEER0_BCP}]="${PEER0_BCP_IP}"
    [${PEER1_BCP}]="${PEER1_BCP_IP}"
    [${ORDERER_BCP}]="${ORDERER_BCP_IP}"
    [${PEER0_ESP}]="${PEER0_ESP_IP}"
    [${PEER1_ESP}]="${PEER1_ESP_IP}"
    [${ORDERER_ESP}]="${ORDERER_ESP_IP}"
    [${PEER0_BROKER}]="${PEER0_BROKER_IP}"
    [${PEER1_BROKER}]="${PEER1_BROKER_IP}"
    [${ORDERER_BROKER}]="${ORDERER_BROKER_IP}"
  )

  first_entry_added=false

  for hostname in "${!ENTRIES[@]}"; do
    ip="${ENTRIES[$hostname]}"
    entry="$ip $hostname"
  
    
    if grep -qFx "$entry" /etc/hosts; then
      echo "Entry already exists: $entry"
      continue
    else

      if ! $first_entry_added; then
        echo | sudo tee -a /etc/hosts >/dev/null
        first_entry_added=true
      fi

        # Append entry to /etc/hosts
      echo "$entry" | sudo tee -a /etc/hosts >/dev/null
      
      echo "Entry added: $entry"  
    fi
  done

fi



if [[ $1 = "hlf2" ]] ; then
  export MACHINE="HLF 2"
  export EXTRA_HOSTS="- ${PEER0_INTEGRA}:${PEER0_INTEGRA_IP}  #HLF 1 instance
      - ${PEER1_INTEGRA}:${PEER1_INTEGRA_IP}  #HLF 1 instance 
      - ${ORDERER_INTEGRA}:${ORDERER_INTEGRA_IP} #HLF 1 instance
      - ${PEER0_ESP}:${PEER0_ESP_IP}    #HLF 3 instance        
      - ${PEER1_ESP}:${PEER1_ESP_IP}   #HLF 3 instance           
      - ${ORDERER_ESP}:${PEER0_ESP_IP} #HLF 3 instance
      - ${PEER0_BROKER}:${PEER0_BROKER_IP}    #HLF 4 instance        
      - ${PEER1_BROKER}:${PEER1_BROKER_IP}   #HLF 4 instance
      - ${ORDERER_BROKER}:${PEER0_BROKER_IP} #HLF 4 instance    
  "

sudo /bin/sh -c 'echo "
'${PEER0_INTEGRA_IP}' '${PEER0_INTEGRA}'
'${PEER1_INTEGRA_IP}' '${PEER1_INTEGRA}'
'${ORDERER_INTEGRA_IP}' '${ORDERER_INTEGRA}' 
'${LOCALHOST_IP}' '${PEER0_BCP}'
'${LOCALHOST_IP}' '${PEER1_BCP}'
'${LOCALHOST_IP}' '${ORDERER_BCP}'
'${PEER0_BROKER_IP}' '${PEER0_BROKER}'
'${PEER1_BROKER_IP}' '${PEER1_BROKER}'
'${ORDERER_BROKER_IP}' '${ORDERER_BROKER}'
'${PEER0_ESP_IP}' '${PEER0_ESP}'
'${PEER1_ESP_IP}' '${PEER1_ESP}'
'${ORDERER_ESP_IP}' '${ORDERER_ESP}' 
" >> /etc/hosts'
fi


# FOR HLF 3

if [[ $1 = "hlf3" ]] ; then
  export MACHINE="HLF 3"
  export EXTRA_HOSTS="- ${PEER0_INTEGRA}:${PEER0_INTEGRA_IP}  #HLF 1 instance
      - ${PEER1_INTEGRA}:${PEER1_INTEGRA_IP}  #HLF 1 instance
      - ${ORDERER_INTEGRA}:${ORDERER_INTEGRA_IP} #HLF 1 instance   
      - ${PEER0_BCP}:${PEER0_BCP_IP}    #HLF 2  instance        
      - ${PEER1_BCP}:${PEER1_BCP_IP}   #HLF 2 instance
      - ${ORDERER_BCP}:${PEER0_BCP_IP} #HLF 2 instance
      - ${PEER0_BROKER}:${PEER0_BROKER_IP} #HLF 3 instance        
      - ${PEER1_BROKER}:${PEER1_BROKER_IP} #HLF 3 instance       
      - ${ORDERER_BROKER}:${ORDERER_BROKER_IP} #HLF 3 instance    
  "

sudo /bin/sh -c 'echo "
'${PEER0_INTEGRA_IP}' '${PEER0_INTEGRA}'
'${PEER1_INTEGRA_IP}' '${PEER1_INTEGRA}'
'${ORDERER_INTEGRA_IP}' '${ORDERER_INTEGRA}' 
'${PEER0_BCP_IP}' '${PEER0_BCP}'
'${PEER1_BCP_IP}' '${PEER1_BCP}'
'${ORDERER_BCP_IP}' '${ORDERER_BCP}'
'${PEER0_BROKER_IP}' '${PEER0_BROKER}'
'${PEER1_BROKER_IP}' '${PEER1_BROKER}'
'${ORDERER_BROKER_IP}' '${ORDERER_BROKER}'
'${LOCALHOST_IP}' '${PEER0_ESP}'
'${LOCALHOST_IP}' '${PEER1_ESP}'
'${LOCALHOST_IP}' '${ORDERER_ESP}' 
" >> /etc/hosts'
fi
 


# FOR HLF 4

if [[ $1 = "hlf4" ]] ; then
  export MACHINE="HLF 4"
  export EXTRA_HOSTS="- ${PEER0_INTEGRA}:${PEER0_INTEGRA_IP}  #HLF 1 instance
      - ${PEER1_INTEGRA}:${PEER1_INTEGRA_IP}  #HLF 1 instance
      - ${ORDERER_INTEGRA}:${ORDERER_INTEGRA_IP} #HLF 1 instance   
      - ${PEER0_BCP}:${PEER0_BCP_IP}    #HLF 2  instance        
      - ${PEER1_BCP}:${PEER1_BCP_IP}   #HLF 2 instance
      - ${ORDERER_BCP}:${PEER0_BCP_IP} #HLF 2 instance
      - ${PEER0_ESP}:${PEER0_ESP_IP} #HLF 4 instance        
      - ${PEER1_ESP}:${PEER1_ESP_IP} #HLF 4 instance       
      - ${ORDERER_ESP}:${ORDERER_ESP_IP} #HLF 4 instance    
  "

sudo /bin/sh -c 'echo "
'${PEER0_INTEGRA_IP}' '${PEER0_INTEGRA}'
'${PEER1_INTEGRA_IP}' '${PEER1_INTEGRA}'
'${ORDERER_INTEGRA_IP}' '${ORDERER_INTEGRA}' 
'${PEER0_BCP_IP}' '${PEER0_BCP}'
'${PEER1_BCP_IP}' '${PEER1_BCP}'
'${ORDERER_BCP_IP}' '${ORDERER_BCP}'
'${LOCALHOST_IP}' '${PEER0_BROKER}'
'${LOCALHOST_IP}' '${PEER1_BROKER}'
'${LOCALHOST_IP}' '${ORDERER_BROKER}'
'${PEER0_ESP_IP}' '${PEER0_ESP}'
'${PEER1_ESP_IP}' '${PEER1_ESP}'
'${ORDERER_ESP_IP}' '${ORDERER_ESP}' 
" >> /etc/hosts'
fi



