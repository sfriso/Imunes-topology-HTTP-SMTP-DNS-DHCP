#!/bin/bash

echo 'Progetto di Reti di Calcolatori'
echo ''


echo ''
echo 'Di Alessandro Sfriso'

echo ''
read -rp 'Premi invio per continuare...'  ke

#___________________________________________________________________________________________________
#
#configurazione del router
#

echo 'configuro il router'
sudo himage router1 service quagga restart
cat configRouter1 | sudo himage router1 vtysh
read  -rp 'premi invio per continuare' ke 

#___________________________________________________________________________________________________
#
#assegno gli ip statici
#

echo 'assegno gli ip statici';
read -rp 'Premi invio per continuare...'  ke
sudo himage DNS ip addr add 100.0.0.1/24 dev eth0
sudo himage DHCP ip addr add 100.0.0.2/24 dev eth0
sudo himage pc2 ip addr add  101.0.0.2/24 dev eth0
sudo himage HTTP ip addr add 100.0.0.4/24 dev eth0
sudo himage SMTP ip addr add 100.0.0.3/24 dev eth0
echo 'ho assegnato gli indirizzi ip statici'
echo '.'
echo ''



#___________________________________________________________________________________________________
#
#CONFIGURO IL SERVER HTTP
#
echo 'configuro il server HTTP'
read -rp 'Premi invio per continuare...'  ke
gnome-terminal -e 'sudo himage HTTP python -m SimpleHTTPServer'
echo 'ho configurato il server HTTP'
echo ''
read -rp 'Premi invio per continuare...'  ke


#______________________________________________________________________________________________
#
#CONFIGURO IL SERVER DNS
#

echo 'configuro il DNS'
sudo himage DNS mkdir /var/log/named
sudo hcp named.conf.local DNS:/etc/bind/named.conf.local
sudo hcp db.progetto.com DNS:/etc/bind/db.progetto.com
sudo hcp 0.0.100.in-addr.arpa DNS:/etc/bind/0.0.100.in-addr.arpa
sudo himage DNS named-checkconf
sudo himage DNS named-checkzone progetto.com /etc/bind/db.progetto.com
sudo himage DNS named-checkzone 0.0.100.in-addr.arpa /etc/bind/0.0.100.in-addr.arpa
sudo himage DNS named

sudo hcp resolv.conf pc2:/etc/resolv.conf
sudo hcp resolv.conf SMTP:/etc/resolv.conf
sudo hcp resolv.conf DHCP:/etc/resolv.conf
sudo hcp resolv.conf HTTP:/etc/resolv.conf

read -rp 'Premi invio per continuare...'  ke

#______________________________________________________________________________________________
#
#CONFIGURO IL DHCP
#
echo 'configuro il DHCP'
read -rp 'Premi invio per continuare...'  ke

sudo himage DHCP sh -c 'echo > /etc/dhcp/dhcpd.conf' 
sudo hcp dhcp.conf DHCP:/etc/dhcp/dhcpd.conf 
sudo himage DHCP service isc-dhcp-server restart # riavvio il servizio dhcp
sudo xterm -e 'himage DHCP dhcpd -d' &
sudo himage pc1 dhclient eth0
echo ''
echo 'fine configuratore DHCP'
echo ''





#______________________________________________________________________________________________
#
#CONFIGURO LE ROTTE STATICHE
#
read -rp 'Premi invio per continuare...'  ke
echo 'creo le rotte'
sudo himage pc2 ip route add 0.0.0.0/0 via 101.0.0.5 dev eth0
sudo himage DHCP ip route add 0.0.0.0/0 via 100.0.0.254 dev eth0
sudo himage DNS ip route add 0.0.0.0/0 via 100.0.0.254 dev eth0
sudo himage HTTP ip route add 0.0.0.0/0 via 100.0.0.254 dev eth0
sudo himage SMTP ip route add 0.0.0.0/0 via 100.0.0.254 dev eth0



#______________________________________________________________________________________________
#
#CONFIGURO SMTP
#
echo 'configuro il server SMTP'
read -rp 'Premi invio per continuare...'  ke
sudo himage SMTP sh -c 'echo > /etc/postfix/main.cf'
sudo hcp postfix.cf SMTP:/etc/postfix/main.cf
sudo himage SMTP service postfix restart




read -rp 'Premi invio per uscire'  ke


exit

