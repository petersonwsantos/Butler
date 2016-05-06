#! /bin/bash
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum update -y 
yum install puppet-agent -y 
echo 'PATH=$PATH:/opt/puppetlabs/puppet/bin' > /etc/profile.d/append-puppetlabs-path.sh
/opt/puppetlabs/bin/puppet agent -t
