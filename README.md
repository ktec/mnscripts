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
cd && wget "https://raw.githubusercontent.com/ktec/mnscripts/master/$COIN/install.sh" && chmod 755 install.sh && bash install.sh
```

## Numus

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser numus && usermod -aG sudo numus && su - numus
```

Install wallet:
```
cd && wget "https://raw.githubusercontent.com/ktec/mnscripts/master/numus/install.sh" && chmod 755 install.sh && bash install.sh
```

## Omega

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser omega && usermod -aG sudo omega && su - omega
```

Install wallet:
```
cd && wget "https://raw.githubusercontent.com/ktec/mnscripts/master/omega/install.sh" && chmod 755 install.sh && bash install.sh
```

## SmartCash

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser smartcash && usermod -aG sudo smartcash && su - smartcash
```

Install wallet:
```
cd && wget "https://raw.githubusercontent.com/ktec/mnscripts/master/smartcash/install.sh" && chmod 755 install.sh && bash install.sh
```


## Vantaur

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser vantaur && usermod -aG sudo vantaur && su - vantaur
```

Install wallet:
```
cd && wget "https://raw.githubusercontent.com/ktec/mnscripts/master/vantaur/install.sh" && chmod 755 install.sh && bash install.sh
```
