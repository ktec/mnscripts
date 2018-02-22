#bin/sh
omegacoin-cli stop

cd && mkdir new && cd new

wget https://github.com/omegacoincoin/omegacoin/releases/download/1.0.1/Nihilo_Command_Line_Binaries_Linux_1_0_1.tar.gz
tar -xf Nihilo_Command_Line_Binaries_Linux_1_0_1.tar.gz

cd /usr/bin
sudo rm -rf omegacoind omegacoin-cli omegacoin-tx

cd ~/new
strip omegacoind
strip omegacoin-cli
strip omegacoin-tx
sudo mv omegacoind /usr/bin
sudo mv omegacoin-cli /usr/bin
sudo mv omegacoin-tx /usr/bin

cd && sudo rm -rf new

cd ~/.omegacoincore
sudo rm governance.dat
sudo rm netfulfilled.dat
sudo rm peers.dat
sudo rm -r blocks
sudo rm mncache.dat
sudo rm -r chainstate
sudo rm fee_estimates.dat
sudo rm mnpayments.dat
sudo rm banlist.dat
cd
omegacoind -daemon -reindex
