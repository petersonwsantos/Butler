#! /bin/bash
yum install wget -y 
rpm -Uvh  https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
rm -fv puppetlabs-release-pc1*
yum install puppet-agent -y 
echo 'PATH=$PATH:/opt/puppetlabs/puppet/bin' > /etc/profile.d/append-puppetlabs-path.sh
#/opt/puppetlabs/bin/puppet agent -t
#/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
