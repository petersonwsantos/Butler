#! /bin/bash
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum update
yum install puppetserver -y
 
