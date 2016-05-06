#! /bin/bash
rm -f /tmp/epel-release-latest-7.noarch.rpm*
yum install wget -y
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -P /tmp/
rpm -ivh /tmp/epel-release-latest-7.noarch.rpm
rm -f /tmp/epel-release-latest-7.noarch.rpm*
yum update -y
yum update -y

