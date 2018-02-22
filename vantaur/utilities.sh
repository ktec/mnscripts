#bin/bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
MAX=10

ShowWalletInfo() {
    omegacoin-cli getinfo;
}

ShowWalletSyncStatus() {
   omegacoin-cli mnsync status
}

MasternodeStatus() {
    omegacoin-cli masternode status
}

ReindexWallet() {
    echo 'Shuting down wallet daemon...'
    omegacoin-cli stop > /dev/null 2>&1
    sleep 10
    echo -e "${GREEN}* Done${NONE}";
    cd ~/.omegacoincore
    sudo rm governance.dat > /dev/null 2>&1
    sudo rm netfulfilled.dat > /dev/null 2>&1
    sudo rm peers.dat > /dev/null 2>&1
    sudo rm -r blocks > /dev/null 2>&1
    sudo rm mncache.dat > /dev/null 2>&1
    sudo rm -r chainstate > /dev/null 2>&1
    sudo rm fee_estimates.dat > /dev/null 2>&1
    sudo rm mnpayments.dat > /dev/null 2>&1
    sudo rm banlist.dat > /dev/null 2>&1
    cd
    echo 'Starting wallet daemon...'
    omegacoind -daemon > /dev/null 2>&1
    sleep 5
    echo -e "${GREEN}* Done${NONE}";
    echo 'Waiting for wallet to sync. It will take a while, you can go grab a coffee :)'
    until omegacoin-cli mnsync status | grep -m 1 '"IsBlockchainSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Blockchain Synced${NONE}";
    until omegacoin-cli mnsync status | grep -m 1 '"IsMasternodeListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Masternode List Synced${NONE}";
    until omegacoin-cli mnsync status | grep -m 1 '"IsWinnersListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Winners List Synced${NONE}";
    until omegacoin-cli mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Done reindexing wallet${NONE}";
}

EditWalletConfig() {
    sudo nano ~/.omegacoincore/omegacoin.conf
}

ViewSentinelLogFile() {
    sudo nano ~/sentinel.log
}

StartWalletDaemon() {
    omegacoind -daemon
    sleep 5
}

StopWalletDaemon() {
    omegacoin-cli stop
    sleep 5
}

echo -e "------------------------------------"
echo -e "| ${CYAN}OmegaCoin masternode utilities${NONE} |"
echo -e "------------------------------------"
echo
echo -e "${CYAN}[1]${NONE} Show wallet info"
echo -e "${CYAN}[2]${NONE} Show wallet sync status"
echo -e "${CYAN}[3]${NONE} Masternode status"
echo -e "${CYAN}[4]${NONE} Reindex wallet"
echo -e "${CYAN}[5]${NONE} Edit wallet config"
echo -e "${CYAN}[6]${NONE} View sentinel log file"
echo -e "${CYAN}[7]${NONE} Start wallet daemon"
echo -e "${CYAN}[8]${NONE} Stop wallet daemon"
echo

echo -e "${BOLD}What would you like me to do?${NONE}"
read -p "Select option with number: " response
echo

case "$response" in
    ("1") ShowWalletInfo ;;
    ("2") ShowWalletSyncStatus ;;
    ("3") MasternodeStatus ;;
    ("4") ReindexWallet ;;
    ("5") EditWalletConfig ;;
    ("6") ViewSentinelLogFile ;;
    ("7") StartWalletDaemon ;;
    ("8") StopWalletDaemon ;;
esac
