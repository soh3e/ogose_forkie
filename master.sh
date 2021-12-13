#!/bin/sh
#UBUNTU 18
#sudo su before 

#check if user is root
if [ "$EUID" -ne 0 ] ;
	then echo "Are you root?"
	exit
fi

#firewall and basic permissions
passwd -l root
ufw enable
chmod 640 /etc/shadow
chmod 644 /etc/passwd
chmod 644 /etc/group
chown root /etc/shadow
chown root /etc/passwd
chown root /etc/group
chmod u-s /bin/bash
chmod g-s /bin/bash
chmod u-s /bin/dash
chmod g-s /bin/dash
chmod 755 /bin/bash
chmod 755 /bin/dash
chown root /bin/dash
chown root /bin/bash


#aliases
unalias -a
export EDITOR=nano
alias ll="ls -ltah"
echo $PATH

#overwrites /etc/rc.local
echo 'exit 0' > /etc/rc.local

#overwrites /etc/host.conf
echo -e 'order hosts,bind \nmulti on \nnospoof on' > /etc/host.conf

#sources.list 
wget https://gist.githubusercontent.com/h0bbel/4b28ede18d65c3527b11b12fa36aa8d1/raw/314419c944ce401039c7def964a3e06324db1128/sources.list
cat sources.list > /etc/apt/sources.list

#see all user shells
awk -F: '{print$7}' /etc/passwd > shells.txt

#sysctl.conf config
wget https://klaver.it/linux/sysctl.conf
cat sysctl.conf > /etc/sysctl.conf
cp /etc/sysctl.conf /etc/sysctl.bak 
sysctl -ep


#login.defs
sed -i '/^PASS_MAX_DAYS/ c\PASS_MAX_DAYS   15' /etc/login.defs
sed -i '/^PASS_MIN_DAYS/ c\PASS_MIN_DAYS   7'  /etc/login.defs
sed -i '/^PASS_WARN_AGE/ c\PASS_WARN_AGE   7' /etc/login.defs


#PAM 
apt install libpam-cracklib
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/common-auth
cat common-auth > /etc/pam.d/common-auth
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/common-password
cat common-password > /etc/pam.d/common-password

#adduser.conf config
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/adduser.conf
cat adduser.conf > /etc/adduser.conf

#package finder (BROKEN)
#note: there may be some non-suspicious packages that are attached to suspicious ones (such as many hacking tools using python)
#wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/dpkg
#dpkg -l > dpkg.txt
#grep -Fvf dpkg dpkg.txt > suspackages.txt

          
#maliciousmalware
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/maliciousmalware

#userpassconfig
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/userpass

#updating all packages/bash/kernel
apt update -y
apt install --only-upgrade bash -y
apt autoremove -y
apt autoclean -y
