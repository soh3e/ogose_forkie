#!/bin/sh
#UBUNTU 18
#sudo su before 


#firewall and basic permissions
passwd -l root
ufw enable
chmod 640 /etc/shadow
chmod 644 /etc/passwd
chown root /etc/shadow
chown root /etc/passwd

#aliases
unalias -a
echo "unalias -a" >> ~/.bashrc
echo "unalias -a" >> /root/.bashrc
export EDITOR=nano
alias edit="sudoedit"
alias ls -la="ls -ltah"

#check if user is root
if [ "$EUID" -ne 0 ] ;
	then echo "Are you root?"
	exit
fi

#overwrites /etc/rc.local
echo 'exit 0' > /etc/rc.local

#sources.list 
wget https://gist.githubusercontent.com/h0bbel/4b28ede18d65c3527b11b12fa36aa8d1/raw/314419c944ce401039c7def964a3e06324db1128/sources.list
cat sources.list > /etc/apt/sources.list

#see all user shells
awk -F: '{print$7}' /etc/passwd > shells.txt

#sysctl.conf config
wget https://klaver.it/linux/sysctl.conf
cat sysctl.conf > /etc/sysctl.conf



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

#package finder
#note: there may be some non-suspicious packages that are attached to suspicious ones (such as many hacking tools using python)
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/dpkg
dpkg -l > dpkg.txt
grep -Fvf dpkg dpkg.txt > suspackages.txt

#possible services (WIP)
#read -p "ssh?[y/n]: "
#        	if [ $a = y ];
#        	then apt install openssh-server
          
#maliciousmalware
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/maliciousmalware

#userpassconfig
wget https://raw.githubusercontent.com/ingbay-ongbay/ogose/main/userpass

#updating all packages/bash/kernel
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt install --only-upgrade-bash
apt autoremove -y
apt autoclean -y
apt install --only-install-bash
