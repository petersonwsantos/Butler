#! /bin/bash
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum update
yum install puppetserver -y
 
echo "[agent]" >>  /etc/puppetlabs/puppet/puppet.conf
echo "certname = puppetserver.virti.local" >>  /etc/puppetlabs/puppet/puppet.conf

[agent]

certname = puppetserver.virti.local
