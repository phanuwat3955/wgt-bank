#!/bin/bash
cd
# install "UBUNTU"
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.6.list
echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
cd
# install "Ubuntu Trusty"
sudo tee -a /etc/apt/sources.list.d/mongodb-org-3.6.list << EOF deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.6 multiverse EOF 
sudo tee -a /etc/apt/sources.list.d/pritunl.list << EOF deb http://repo.pritunl.com/stable/apt trusty main EOF 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update 
sudo apt-get --assume-yes install pritunl mongodb-org 
sudo service pritunl start
sudo pritunl setup-key
