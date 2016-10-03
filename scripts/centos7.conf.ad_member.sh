#!/bin/bash

echo
echo -n "Qual o nome do Domínio?(digitar minúsculo) ex: foobar.local "
echo
echo 
read var_domain

echo
echo -n "Qual o nome do Netbios?(digitar minúsculo) ex: foobar.local "
echo
read var_netbios

echo
echo -n "Digite o fqdn de um Controlador de domínio.(digitar minúsculo) ex: pdc.foobar.local "
echo
read var_ad_server

echo
echo -n "Digite o usuário administrador. ex: administrator "
echo
read var_admin

echo
echo -n "Digite a senha do usuário administrador. ex: P@ssw0rd "
echo
read var_password

echo
echo -n "Qual grupo do AD terá direitos administrativos neste srvidor Linux. ex: g-linux-admins"
echo
read var_sudoers_group_admin

var_domain_upper=` echo $var_domain | tr '[:lower:]' '[:upper:]' `
var_netbios_upper=` echo $var_netbios | tr '[:lower:]' '[:upper:]' `





yum install -y samba-winbind-clients samba-winbind-krb5-locator   sssd  sssd-client adcli cifs-utils krb5-devel krb5-workstation  libcgroup-pam mod_authnz_pam  nscd  nss-pam-ldapd  ntp  ntpdate   oddjob   oddjob-mkhomedir pam_krb5  base   pam_ssh_agent_auth realmd samba samba-common samba-winbind 


systemctl enable ntpd.service
ntpdate $var_ad_server
systemctl restart ntpd.service
sleep 3
realm discover $var_domain_upper 
sleep 5
echo "$var_password" | realm join $var_domain_upper -U $var_admin
sleep 5
realm permit -g $var_sudoers_group_admin@$var_domain



cat <<EOF > /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log

[libdefaults]
 default_realm = $var_domain_upper
 dns_lookup_realm = true
 dns_lookup_kdc = true
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false

# You may also want either of:
# allow_weak_crypto = true
# default_tkt_enctypes = arcfour-hmac

[realms]
# Define only if DNS lookups are not working
$var_domain_upper = {
 kdc = $var_ad_server
 master_kdc = $var_ad_server
 admin_server = $var_ad_server
}

[domain_realm]
# Define only if DNS lookups are not working
.$var_domain = $var_domain_upper
 $var_domain = $var_domain_upper
EOF


cat <<EOF >  /etc/samba/smb.conf
[global]
	security = ads
	realm = $var_domain_upper
	workgroup = $var_netbios_upper

	log file = /var/log/samba/%m.log

	kerberos method = secrets and keytab

	client signing = yes
	client use spnego = yes
EOF

cat <<EOF >  /etc/nsswitch.conf

passwd:         files sss
shadow:         files sss
group:          files sss

hosts:          files dns

bootparams:     files

ethers:         files
netmasks:       files
networks:       files
protocols:      files
rpc:            files
services:       files sss

netgroup:       files sss

publickey:      files

automount:      files
aliases:        files
EOF

sleep 3
echo "$var_password" | kinit $var_admin
sleep 5
net ads join -k
sleep 3
klist -ke
sleep 2
authconfig --enablesssd --enablesssdauth --enablemkhomedir --update

systemctl enable winbind
systemctl restart winbind



echo "%$var_netbios\\$var_sudoers_group_admin ALL=(ALL) ALL" >  /etc/sudoers.d/windows_group_admin
echo "%$var_sudoers_group_admin@$var_domain ALL=(ALL) ALL" >>  /etc/sudoers.d/windows_group_admin
