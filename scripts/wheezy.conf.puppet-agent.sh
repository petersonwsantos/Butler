apt-get remove puppetlabs-release puppetlabs-release-pc1 puppet-agent -y
rm -rfv /opt/puppetlabs
rm -rfv /etc/puppetlabs
dpkg -l | grep puppet

wget https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb
dpkg -i puppetlabs-release-pc1-wheezy.deb
rm -fv puppetlabs-release-pc1-wheezy.deb
apt-get update 
apt-get install puppet-agent -y
/opt/puppetlabs/bin/puppet agent -t
