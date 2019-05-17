# Easy Install

Automate the installation of alt coins.
Create a new linux server and run the commands listed below.

----

Restrict root login to ssh keys

```
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
```


----



## Bulwark

Create user:
```
COIN=bulwark
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/bulwark/install)
```

## GoByte

Create user:
```
COIN=gobyte
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/gobyte/install)
```

## Neutron

Create user:
```
COIN=neutron
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/neutron/install)
```

## Numus

Create user:
```
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
adduser $COIN && usermod -aG sudo $COIN && su - $COIN
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/polis/install)
```

## SmartCash

Create user:
```
adduser smartcash && usermod -aG sudo smartcash && su - smartcash
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/smartcash/install)
```

## SafeInsure

Create user:
```
adduser safeinsure && usermod -aG sudo safeinsure && su - safeinsure
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/safeinsure/install)
```

## BlacerCoin

Create user:
```
adduser blacercoin && usermod -aG sudo blacercoin && su - blacercoin
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/blacercoin/install)
```

## IchIbaCoin

Create user:
```
adduser ichibacoin && usermod -aG sudo ichibacoin && su - ichibacoin
```

Install wallet:
```
cd && bash <(curl -fsSL https://raw.githubusercontent.com/ktec/mnscripts/master/ichibacoin/install)
```
