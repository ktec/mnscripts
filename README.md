# Easy Install

This project aims to automate the process of creating a masternode for many alt coins.
Simply create a new linux server and run the commands listed below.


Sources:

- https://github.com/nihilocoin/nihilo
- https://github.com/SmartCash/smartnode



This is work in progress. Pull requests welcome...

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

## Omega

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser omega && usermod -aG sudo omega && su - omega
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/omega/install)
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


## Vantaur

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser vantaur && usermod -aG sudo vantaur && su - vantaur
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/vantaur/install)
```
