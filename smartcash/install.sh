#/bin/bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
MAX=12

NAME=SmartCash
USER=smartcash
COINSRC=~/src/smartcash
COINGITHUB=https://github.com/SmartCash/smartcash.git
COINDOWNLOAD=# no release available
COINBINPATH=# no release available
SENTINELGITHUB=https://github.com/dashpay/sentinel.git
COINPORT=9678
COINRPCPORT=14855
COINDAEMON=smartcashd
COINCLI=smartcash-cli
COINTX=smartcash-tx
COINCORE=.smartcash
COINCONFIG=smartcash.conf


# Functions

checkForUbuntuVersion() {
   echo "[1/${MAX}] Checking Ubuntu version..."
    if [[ `cat /etc/issue.net`  == *16.04* ]]; then
        echo -e "${GREEN}* You are running `cat /etc/issue.net` . Setup will continue.${NONE}";
    else
        echo -e "${RED}* You are not running Ubuntu 16.04.X. You are running `cat /etc/issue.net` ${NONE}";
        echo && echo "Installation cancelled" && echo;
        exit;
    fi
}

updateAndUpgrade() {
    echo
    echo "[2/${MAX}] Running update and upgrade. Please wait..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq -y > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq > /dev/null 2>&1
    echo -e "${GREEN}* Done${NONE}";
}

setupSwap() {
    echo -e "${BOLD}"
    read -e -p "Add swap space? (Recommended for VPS that have 1GB of RAM) [Y/n] :" add_swap
    if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
        swap_size="4G"
    else
        echo -e "${NONE}[3/${MAX}] Swap space not created."
    fi

    if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
        echo && echo -e "${NONE}[3/${MAX}] Adding swap space...${YELLOW}"
        sudo fallocate -l $swap_size /swapfile > /dev/null 2>&1
        sleep 2
        sudo chmod 600 /swapfile > /dev/null 2>&1
        sudo mkswap /swapfile > /dev/null 2>&1
        sudo swapon /swapfile > /dev/null 2>&1
        echo -e "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null 2>&1
        sudo sysctl vm.swappiness=10 > /dev/null 2>&1
        sudo sysctl vm.vfs_cache_pressure=50 > /dev/null 2>&1
        echo -e "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf > /dev/null 2>&1
        echo -e "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf > /dev/null 2>&1
        echo -e "${NONE}${GREEN}* Done${NONE}";
    fi
}

installFail2Ban() {
    echo
    echo -e "[4/${MAX}] Installing fail2ban. Please wait..."
    sudo apt-get -y install fail2ban > /dev/null 2>&1
    sudo systemctl enable fail2ban > /dev/null 2>&1
    sudo systemctl start fail2ban > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installFirewall() {
    echo
    echo -e "[5/${MAX}] Installing UFW. Please wait..."
    sudo apt-get -y install ufw > /dev/null 2>&1
    sudo ufw default deny incoming > /dev/null 2>&1
    sudo ufw default allow outgoing > /dev/null 2>&1
    sudo ufw allow ssh > /dev/null 2>&1
    sudo ufw limit ssh/tcp > /dev/null 2>&1
    sudo ufw allow $COINPORT/tcp > /dev/null 2>&1
    sudo ufw allow $COINRPCPORT/tcp > /dev/null 2>&1
    sudo ufw logging on > /dev/null 2>&1
    echo "y" | sudo ufw enable > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installDependencies() {
    echo
    echo -e "[6/${MAX}] Installing dependecies. Please wait..."
    sudo apt-get install git nano rpl wget python-virtualenv -qq -y > /dev/null 2>&1
    sudo apt-get install build-essential libtool automake autoconf -qq -y > /dev/null 2>&1
    sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -qq -y > /dev/null 2>&1
    sudo apt-get install software-properties-common python-software-properties -qq -y > /dev/null 2>&1
    sudo add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
    sudo apt-get update -qq -y > /dev/null 2>&1
    sudo apt-get install libdb4.8-dev libdb4.8++-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libminiupnpc-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libzmq5 -qq -y > /dev/null 2>&1
    sudo apt-get install virtualenv -qq -y > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

compileWallet() {
    echo
    echo -e "[7/${MAX}] Compiling wallet. Please wait..."

    # Download and compile from source via git
    git clone $COINGITHUB $COINSRC > /dev/null 2>&1
    cd $COINSRC
    ./autogen.sh > /dev/null 2>&1
    ./configure > /dev/null 2>&1
    make > /dev/null 2>&1

    echo -e "${NONE}${GREEN}* Done${NONE}";
}

downloadWallet() {
  echo
  echo -e "[7/${MAX}] Download wallet. Please wait..."

  # Download and install precompiled binaries
  mkdir -p $COINSRC && cd $COINSRC
  wget $COINDOWNLOAD > /dev/null 2>&1
  tar -xf *.tar.gz > /dev/null 2>&1
  cd $COINBINPATH
  mv $COINDAEMON $COINSRC > /dev/null 2>&1

  echo -e "${NONE}${GREEN}* Done${NONE}";
}

installWallet() {
    echo
    echo -e "[8/${MAX}] Installing wallet. Please wait..."
    cd && cd $COINSRC/src
    strip $COINDAEMON $COINCLI $COINTX
    chmod +x $COINDAEMON $COINCLI $COINTX
    sudo mv $COINDAEMON $COINCLI $COINTX /usr/local/bin

    #Create sh in /usr/local/bin for getinfo for cli getinfo
    cd
    wget https://raw.githubusercontent.com/ktec/mnscripts/master/$USER/utilities.sh > /dev/null 2>&1
    chmod 755 utilities.sh
    sudo mv utilities.sh /usr/local/bin
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

configureWallet() {
    echo
    echo -e "[9/${MAX}] Configuring wallet. Please wait..."
    $COINDAEMON -daemon > /dev/null 2>&1
    sleep 10

    mnip=$(curl --silent ipinfo.io/ip)
    rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    rpcpass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    mnkey=$($COINCLI smartnode genkey)

    $COINCLI stop > /dev/null 2>&1
    sleep 10

    echo -e "
    rpcuser=${rpcuser}
    rpcpassword=${rpcpass}
    rpcport=${COINRPCPORT}
    rpcallowip=127.0.0.1
    rpcthreads=8
    listen=1
    server=1
    daemon=1
    maxconnections=64
    txindex=1
    smartnode=1
    externalip=${mnip}:${COINPORT}
    smartnodeprivkey=${mnkey}
    " | sed "s/^[ \t]*//" | sed '/^$/d' > ~/$COINCORE/$COINCONFIG
    # Using sed to remove leading whitespace and blank lines

    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installSentinel() {
    echo
    echo -e "[10/${MAX}] Installing Sentinel...${YELLOW}"
    cd ~/$COINCORE
    git clone $SENTINELGITHUB sentinel > /dev/null 2>&1
    cd sentinel
    export LC_ALL=C > /dev/null 2>&1
    virtualenv ./venv > /dev/null 2>&1
    ./venv/bin/pip install -r requirements.txt > /dev/null 2>&1
    echo  "* * * * * cd ~/${COINCORE}/sentinel && ./venv/bin/python bin/sentinel.py >> ~/sentinel.log 2>&1" >> mycron
    crontab mycron > /dev/null 2>&1
    rm mycron > /dev/null 2>&1
    CONFLOCATION=$(cd ~/$COINCORE && pwd)
    rpl dash_conf=/home/YOURUSERNAME/$COINCORE/$COINCONFIG dash_conf=$CONFLOCATION/$COINCONFIG sentinel.conf > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

startWallet() {
    echo
    echo -e "[11/${MAX}] Starting wallet daemon..."
    cd ~/$COINCORE
    sudo rm governance.dat > /dev/null 2>&1
    sudo rm netfulfilled.dat > /dev/null 2>&1
    sudo rm peers.dat > /dev/null 2>&1
    sudo rm -r blocks > /dev/null 2>&1
    sudo rm mncache.dat > /dev/null 2>&1
    sudo rm -r chainstate > /dev/null 2>&1
    sudo rm fee_estimates.dat > /dev/null 2>&1
    sudo rm snpayments.dat > /dev/null 2>&1
    sudo rm banlist.dat > /dev/null 2>&1
    cd
    $COINDAEMON -daemon > /dev/null 2>&1
    sleep 5
    echo -e "${GREEN}* Done${NONE}";
}

downloadBlockchain() {
    echo
    echo -e "${BOLD}"
    read -e -p "Download blockchain? (Recommended if you dont want to wait) [Y/n] :" download_blockchain
    if [[ ("$download_blockchain" == "y" || "$download_blockchain" == "Y" || "$download_blockchain" == "") ]]; then
        echo -e "[11.1/${MAX}] Downloading blockchain wallet. Please wait..."
        $COINCLI stop > /dev/null 2>&1
        sleep 10
        wget http://proteanx.com/txindexstrap.zip -P /tmp
        unzip -o /tmp/txindexstrap.zip -d ~/$COINCORE
        chmod -R 700 ~/$COINCORE
        $COINDAEMON -daemon > /dev/null 2>&1
        sleep 10
        echo -e "${NONE}${GREEN}* Done${NONE}";
    else
        echo -e "${NONE}[11.1/${MAX}] Syncing blockchain manually."
    fi
}


syncWallet() {
    echo
    echo "[12/${MAX}] Waiting for wallet to sync. It will take a while, you can go grab a coffee :)"
    until $COINCLI snsync status | grep -m 1 '"IsBlockchainSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Blockchain Synced${NONE}";
    until $COINCLI snsync status | grep -m 1 '"IsMasternodeListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Masternode List Synced${NONE}";
    until $COINCLI snsync status | grep -m 1 '"IsWinnersListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Winners List Synced${NONE}";
    until $COINCLI snsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}* Done reindexing wallet${NONE}";
}

clear
cd

echo -e "${BOLD}"
read -p "This script will setup your ${NAME} Coin Masternode. Do you wish to continue? (y/n)?" response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    checkForUbuntuVersion
    updateAndUpgrade
    setupSwap
    installFail2Ban
    installFirewall
    installDependencies
    compileWallet
    installWallet
    configureWallet
    # installSentinel
    startWallet
    syncWallet

    echo
    echo -e "${BOLD}The VPS side of your smartnode has been installed. Use the following line in your cold wallet smartnode.conf and replace the tx and index${NONE}".
    echo
    echo -e "${CYAN}smartnode1 ${mnip}:${COINPORT} ${mnkey} tx index${NONE}"
    echo
    echo -e "${BOLD}Continue with the cold wallet part of the guide${NONE}"
    echo
else
    echo && echo "Installation cancelled" && echo
fi
