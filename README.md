# Easy Install

This project aims to automate the process of creating a masternode for many alt coins.
Simply create a new linux server and run the commands listed below.


This is work in progress. Pull requests welcome...

----

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

## Ventaur

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser vantaur && usermod -aG sudo vantaur && su - vantaur
```

Install wallet:
```
cd && wget "https://raw.githubusercontent.com/ktec/mnscripts/master/vantaur/install.sh" && chmod 755 install.sh && bash install.sh
```

## SmartCoin

Create user:
```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
adduser smart && usermod -aG sudo smart && su - smart
```

Install wallet:
```
cd && wget "https://raw.githubusercontent.com/ktec/mnscripts/master/smart/install.sh" && chmod 755 install.sh && bash install.sh
```
