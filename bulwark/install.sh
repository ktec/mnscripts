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

USER=bulwark
COINSRC=~/src/bulwark
COINGITHUB=https://github.com/bulwark-crypto/Bulwark.git
COINPORT=52543
COINRPCPORT=52544
COINDAEMON=bulwarkd
COINCLI=bulwark-cli
COINTX=bulwark-tx
COINCORE=.bulwark
COINCONFIG=bulwark.conf

checkForUbuntuVersion() {
   echo "[1/${MAX}] Checking Ubuntu version..."
    if [[ `cat /etc/issue.net`  == *16.04* ]]; then
        echo -e "${GREEN}\xE2\x9C\x94 You are running `cat /etc/issue.net` . Setup will continue.${NONE}";
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
    echo -e "${GREEN}\xE2\x9C\x94 Done${NONE}";
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
        echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
    fi
}

installFail2Ban() {
    echo
    echo -e "[4/${MAX}] Installing fail2ban. Please wait..."
    sudo apt-get -y install fail2ban > /dev/null 2>&1
    sudo systemctl enable fail2ban > /dev/null 2>&1
    sudo systemctl start fail2ban > /dev/null 2>&1
    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
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
    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
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
    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
}

downloadWallet() {
    echo
    echo -e "[7/${MAX}] Downloading wallet. Please wait..."

    # Download and install precompiled binaries
    mkdir -p $COINSRC && cd $COINSRC
    wget $COINDOWNLOAD > /dev/null 2>&1
    tar -xf *.tar.gz > /dev/null 2>&1
    cd $COINBINPATH
    mv $COINDAEMON $COINCLI $COINTX $COINSRC > /dev/null 2>&1

    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
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

    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
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
    wget https://raw.githubusercontent.com/ktec/mnscripts/master/bulwark/utilities.sh > /dev/null 2>&1
    chmod 755 utilities.sh
    sudo mv utilities.sh /usr/local/bin
    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
}

configureWallet() {
    echo
    echo -e "[9/${MAX}] Configuring wallet. Please wait..."
    # $COINDAEMON -daemon > /dev/null 2>&1
    # sleep 10

    mnip=$(curl --silent ipinfo.io/ip)
    rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    rpcpass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

    # requires us to create a username/password before we can run the daemon
    mkdir -p ~/$COINCORE/
    echo -e "rpcuser=${rpcuser}\nrpcpassword=${rpcpass}\n" > ~/$COINCORE/$COINCONFIG
    # Now we can run the daemon!
    $COINDAEMON -daemon > /dev/null 2>&1
    sleep 10

    mnkey=$($COINCLI masternode genkey)

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
    staking=0
    discover=1
    externalip=${mnip}:${COINPORT}
    masternode=1
    masternodeprivkey=${mnkey}
    " | sed "s/^[ \t]*//" | sed '/^$/d' > ~/$COINCORE/$COINCONFIG
    # Using sed to remove leading whitespace and blank lines

    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
}

configureCrontab() {
    echo
    echo -e "[10/${MAX}] Configuring crontab. Please wait..."

    (
      crontab -l 2>/dev/null
      echo '@reboot sleep 30 && bulwarkd -daemon -shrinkdebugfile'
    ) | crontab
    # (
    #   crontab -l 2>/dev/null
    #   echo '@reboot sleep 60 && bulwark-cli startmasternode local false'
    # ) | crontab

    echo -e "${NONE}${GREEN}\xE2\x9C\x94 Done${NONE}";
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
    sudo rm mnpayments.dat > /dev/null 2>&1
    sudo rm banlist.dat > /dev/null 2>&1
    cd
    $COINDAEMON -daemon > /dev/null 2>&1
    sleep 5
    echo -e "${GREEN}\xE2\x9C\x94 Done${NONE}";
}

syncWallet() {
    echo
    echo "[12/${MAX}] Waiting for wallet to sync. It will take a while, you can go grab a coffee :)"
    until $COINCLI mnsync status | grep -m 1 '"IsBlockchainSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}\xE2\x9C\x94 Blockchain Synced${NONE}";
    until $COINCLI mnsync status | grep -m 1 '"IsMasternodeListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}\xE2\x9C\x94 Masternode List Synced${NONE}";
    until $COINCLI mnsync status | grep -m 1 '"IsWinnersListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}\xE2\x9C\x94 Winners List Synced${NONE}";
    until $COINCLI mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
    echo -e "${GREEN}\xE2\x9C\x94 Done reindexing wallet${NONE}";
}

clear
cd

echo -e "${BOLD}"
read -p "This script will setup your Bulwark Coin Masternode. Do you wish to continue? (y/n)?" response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    checkForUbuntuVersion
    updateAndUpgrade
    setupSwap
    installFail2Ban
    installFirewall
    installDependencies
    # downloadWallet
    compileWallet
    installWallet
    configureWallet
    configureCrontab
    startWallet
    syncWallet

    echo
    echo -e "${BOLD}The VPS side of your masternode has been installed. Use the following line in your cold wallet masternode.conf and replace the tx and index${NONE}".
    echo
    echo -e "${CYAN}masternode1 ${mnip}:${COINPORT} ${mnkey} tx index${NONE}"
    echo
    echo -e "${BOLD}Continue with the cold wallet part of the guide${NONE}"
    echo
else
    echo && echo "Installation cancelled" && echo
fi
