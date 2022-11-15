#!/bin/bash
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELAY=2000*1 #in secs - how often restart the script 
WALLET_NAME=wallet #example: = WALLET_NAME=wallet_qwwq_54
#NODE="tcp://localhost:26658" #change it only if you use another rpc port of your node

for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo | gitopiad tx distribution withdraw-rewards $GITOPIA_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$GITOPIA_CHAIN_ID -y
        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
 
#        BAL=$(gitopiad query bank balances $GITOPIA_WALLET_ADDRESS | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(gitopiad query bank balances $GITOPIA_WALLET_ADDRESS --chain-id=$GITOPIA_CHAIN_ID --output json | jq -r '.balances[] | select(.denom=="utlore")' | jq -r .amount)
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} utlore\n"

       
        BAL=$(gitopiad query bank balances $GITOPIA_WALLET_ADDRESS --chain-id=$GITOPIA_CHAIN_ID --output json | jq -r '.balances[] | select(.denom=="utlore")' | jq -r .amount)
#        BAL=$(gitopiad query bank balances $GITOPIA_WALLET_ADDRESS | awk '/amount:/{print $NF}' | tr -d '"')
        BAL=$(($BAL-50000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} utlore\n"
        echo -e "Stake ALL 11111\n"
        if (( BAL > 900000 )); then
        echo | gitopiad tx staking delegate $GITOPIA_VALOPER_ADDRESS ${BAL}utlore --from=$WALLET --chain-id=$GITOPIA_CHAIN_ID --gas=auto --yes
        else
          echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} utlore BAL < 900000 ((((\n"
        fi 
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done       

done
