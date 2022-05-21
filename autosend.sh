#!/bin/bash
#set -o xtrace #uncomment for detailed debugging
#DO NOT CHANGE ---START---
echo "Send out script started:"
date
i="0"
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
NC="\e[0m"
#DO NOT CHANGE ---END---
FEE="0" #Fee in Mojo
FINGERPRINT="<YOUR WALLET FINGERPRINT>"
ID="<YOUR CATS ID WITHIN YOUR WALLET>"
TARGETADDRESS="<YOUR TARGET XCH ADDRESS>"
AMOUNT="1" #The Amount you want to send in a single Transaction in Chia Asset Tokens
#CHANGE THE PATH BELOW TO THE LOCATION OF YOUR CHIA FOLDER AND REMOVE THE COMMENT #
#cd ~/chia-blockchain && . ./activate
#Change (1..20) to how many Tokens should be sent out. For Example: 50 Tokens should be (1..50)
cd ~/chia-blockchain && . ./activate #add # infront if you have installed chia in a different location
AMOUNT=$((AMOUNT * 1000)) #converting Token to Mojo
for i in {1..2}
do
                                paymentin="notdone"
                                while [[ "$paymentin" != "done" ]]
                                do
                                        until [ `chia rpc wallet get_sync_status  | grep "synced"   | cut -d"\"" -f 3  | cut -d" " -f2  | cut -d"," -f1` == "true" ];
                                        do
                                                echo  -e "${YELLOW}SEND Wallet not synced!${NC}"
                                                sleep 30s
                                        done
                                        until [ `chia rpc wallet get_wallet_balance '{"wallet_id": '$ID'}' | grep "spendable_balance" | cut -d ":" -f 2 | cut -d " " -f2 | cut -d "," -f1` -ge "$AMOUNT" ] ;
                                        do
                                                echo  -e "${YELLOW}SEND Wallet not ready...${NC}"
                                                sleep 10s
                                        done
                                        output=$(chia rpc wallet cat_spend '{"fingerprint": '$FINGERPRINT',"wallet_id": '$ID',"amount": '$AMOUNT',"fee": '$FEE',"inner_address": "'$TARGETADDRESS'"}')
                                        result=$(echo "$output" | grep "success" | cut -d ":" -f 2 | cut -d " " -f 2 | cut -d "," -f 1)
                                        if [ "$result" != "true" ]
                                        then
                                                echo -e "${RED}Error sending out PAYMENT, trying again...${NC}"
                                                echo -e "Error: ${output}"
                                                sleep 10s
                                        elif [ "$result" == "true" ]
                                        then
                                                echo -e "${GREEN}PAYMENT Transaction worked${NC}"
                                                paymentin="done"
                                        fi
                                done
done
deactivate && cd ~
date
