#! /bin/bash

clear

echo -n "Placas disponíveis"
echo
for x in `ip a | grep ^[0-9] | grep -v lo: | cut -d : -f2` ; do
  echo -n $x
  echo
done

# Placa de rede
echo
echo -n "Qual o nome da Placa de rede? "
echo
read PLACA

# IP
echo
echo -n "Digite o IP deste  Host? "
echo
read IP

# Máscara
echo
echo -n "Qual a máscara? "
echo
read MASCARA

# Gateway
echo
echo -n "Qual o Gateway? "
echo
read GATEWAY

# DNS 1
echo
echo -n "Qual o DNS 1? "
echo
read DNS1

# DNS 2
echo
echo -n "Qual o DNS 2? "
echo
read DNS2


# hostname
echo
echo -n "Qual o nome deste Host? "
echo
read HOST





# hostname
echo
 echo -n "Qual o nome Domínio? "
echo
read DOMINIO

echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts
echo $IP"  "$HOST.$DOMINIO"   "$HOST  >> /etc/hosts

echo $HOST.$DOMINIO  > /etc/hostname

echo "nameserver $DNS1" > /etc/resolv.conf
echo "nameserver $DNS2" >> /etc/resolv.conf

cp /etc/sysctl.conf /etc/sysctl.`date +%Y-%m-%d-%H-%M` 
sed -i "s/net.ipv6.conf.all.disable_ipv6/#net.ipv6.conf.all.disable_ipv6/"  /etc/sysctl.conf   
sed -i "s/net.ipv6.conf.default.disable_ipv6/#net.ipv6.conf.default.disable_ipv6/"  /etc/sysctl.conf 
echo "net.ipv6.conf.all.disable_ipv6 = 0" >>   /etc/sysctl.conf 
echo "net.ipv6.conf.default.disable_ipv6 = 0" >> /etc/sysctl.conf 
sysctl -p 

cat <<'EOF' > /etc/sysconfig/network-scripts/ifcfg-$PLACA
TYPE=Ethernet
IPADDR=sed-IP
NETMASK=sed-MASCARA
GATEWAY=sed-GATEWAY
DNS1=sed-DNS1
DNS2=sed-DNS2
BOOTPROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
NAME=sed-PLACA
DEVICE=sed-PLACA
ONBOOT=yes
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_PEERDNS=no
IPV6_PEERROUTES=no
IPV6_FAILURE_FATAL=no
EOF


sed -i "s/sed-IP/$IP/"           /etc/sysconfig/network-scripts/ifcfg-$PLACA
sed -i "s/sed-MASCARA/$MASCARA/" /etc/sysconfig/network-scripts/ifcfg-$PLACA
sed -i "s/sed-GATEWAY/$GATEWAY/" /etc/sysconfig/network-scripts/ifcfg-$PLACA
sed -i "s/sed-DNS1/$DNS1/"      /etc/sysconfig/network-scripts/ifcfg-$PLACA
sed -i "s/sed-DNS2/$DNS2/"     /etc/sysconfig/network-scripts/ifcfg-$PLACA
sed -i "s/sed-PLACA/$PLACA/"   /etc/sysconfig/network-scripts/ifcfg-$PLACA
sed -i "s/sed-PLACA/$PLACA/" /etc/sysconfig/network-scripts/ifcfg-$PLACA


