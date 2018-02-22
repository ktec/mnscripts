# Easy Install


This is the currently implemented projects. If yours isn't available, please submit a pull request to add it.


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
