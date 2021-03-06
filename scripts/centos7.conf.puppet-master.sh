#! /bin/bash
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum update
yum install puppetserver -y

echo "export PATH=/opt/puppetlabs/bin:$PATH" > /etc/profile.d/puppet_path.sh
source /etc/profile.d/puppet_path.sh

sed -i "s/`hostname -s`$/master puppet/g" /etc/hosts

# limpa entradas anteriores
sed -i "s/\[agent/#\[agent/"  /etc/puppetlabs/puppet/puppet.conf
sed -i "s/certname/#certname/"  /etc/puppetlabs/puppet/puppet.conf


echo "[agent]" >>  /etc/puppetlabs/puppet/puppet.conf
echo "certname = `hostname -f`" >>  /etc/puppetlabs/puppet/puppet.conf

#   parâmetros de memória da JVM,
echo "START_TIMEOUT=400" >> /etc/sysconfig/puppetserver


echo "Gerar certificados"
echo " "
echo " "
echo "Digite:  "
echo "puppet cert list -a"
echo "puppet cert generate `hostname -f`  --dns_alt_names=puppet"
echo "puppet cert sign -all"
echo "systemctl start puppetserver"
echo "systemctl enable puppetserver"
