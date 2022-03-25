#!/bin/bash
#Comment with # if you are not interested in every detail
set -o xtrace
echo "Send out script started:"
date
i="0"
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
NC="\e[0m"
FEE="0.000000000001" #1 Mojo
FINGERPRINT="<YOUR_WALLET_FINGERPRINT>"
ID="<YOUR_WALLET_INDEX_ID>"
TARGETADDRESS="<ADRESS_OF_YOUR_TARGET_WALLET>"
#CHANGE THE PATH BELOW TO THE LOCATION OF YOUR CHIA FOLDER AND REMOVE THE COMMENT #
#cd ~/chia-blockchain && . ./activate
#Change (1..20) to how many Tokens should be sent out. For Example: 50 Tokens should be (1..50)
for i in {1..20}
do
                                paymentin="notdone"
                                while [[ "$paymentin" != "done" ]]
                                do
                                        while chia wallet show -f "$FINGERPRINT" | grep -q -e "Not synced" -e "Syncing..."
                                        do
                                                echo  -e "${YELLOW}SEND Wallet not synced!${NC}"
                                                sleep 30s
                                        done
                                        until [ `chia wallet show -f "$FINGERPRINT" | grep "Wallet ID $ID" -A3 | grep "Spendable:" | cut -d"(" -f2 | cut -d" " -f1` == `chia wallet show -f "$FINGERPRINT" | grep "Wallet ID $ID" -A3  | grep "\-Total Balance:" | cut -d"(" -f2 | cut -d" " -f1` ] ;
                                        do
                                                echo  -e "${YELLOW}SEND Wallet not ready...${NC}"
                                                sleep 10s
                                        done
                                        output=$(chia wallet send -f "$FINGERPRINT" -i $ID -a "1" -t "$TARGETADDRESS" -m "$FEE")
                                        testvar=$(echo $output| grep -o "Exception")
                                        if [ -n "$testvar" ]
                                        then
                                                echo -e "${RED}Error sending out PAYMENT, trying again...${NC}"
                                                echo -e "Error: ${output}"
                                                sleep 10s
                                        elif [ -z "$testvar" ]
                                        then
                                                echo -e "${GREEN}PAYMENT Transaction worked${NC}"
                                                #echo -e "${BLUE}Sleeping for 30 Seconds...${NC}"
                                                paymentin="done"
                                                sleep 30s
                                        fi
                                done
done
deactivate && cd ~
date
