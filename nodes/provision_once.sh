#!/bin/sh

#echo 'root:strongpassword' | chpasswd
#sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#service ssh restart

echo 'vagrant:strongpassword' | chpasswd

(echo '"\e[A": history-search-backward'; echo '"\e[B": history-search-forward') >> /etc/inputrc

timedatectl set-timezone Europe/Moscow

apt update
#apt install -y docker.io