# Easy Install

Automate the installation of alt coins.
Create a new linux server and run the commands listed below.

----

## Bulwark

Create user:
```
COIN=bulwark
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
COIN=bulwark
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/$COIN/install)
```

## GoByte

Create user:
```
COIN=gobyte
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
COIN=gobyte
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/$COIN/install)
```

## Neutron

Create user:
```
COIN=neutron
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
COIN=neutron
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/$COIN/install)
```

## Numus

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser numus && usermod -aG sudo numus && su - numus
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/numus/install)
```

## Polis

Create user:
```
COIN=polis
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
COIN=polis
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/$COIN/install)
```

## SmartCash

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser smartcash && usermod -aG sudo smartcash && su - smartcash
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/smartcash/install)
```

## SafeInsure

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser safeinsure && usermod -aG sudo safeinsure && su - safeinsure
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/safeinsure/install)
```

## BlacerCoin

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser blacercoin && usermod -aG sudo blacercoin && su - blacercoin
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/blacercoin/install)
```
