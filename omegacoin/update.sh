#bin/sh
omegacoin-cli stop

cd /usr/bin
sudo rm -rf omegacoind omegacoin-cli omegacoin-tx

cd && mkdir new && cd new

wget https://github.com/omegacoinnetwork/omegacoin/releases/download/0.12.5/omegacoincore-0.12.5-linux64.tar.gz
tar -xf omegacoincore-0.12.5-linux64.tar.gz

cd ~/new/omegacoincore-0.12.2/bin
strip omegacoind
strip omegacoin-cli
strip omegacoin-tx
sudo mv omegacoind /usr/local/bin
sudo mv omegacoin-cli /usr/local/bin
sudo mv omegacoin-tx /usr/local/bin

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
