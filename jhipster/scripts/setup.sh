#!/bin/sh

VAGRANT_DATA=/vagrant_data


if [ $(grep -c '^deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' /etc/apt/sources.list) -eq 0 ];
then
  echo ">> Add MongoDB APT repo"
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
fi

sudo apt-get update

# need to be in first as it installs add-apt-repository command
sudo apt-get install -y python-software-properties

echo ">> Add Maven3 PPA"
sudo add-apt-repository -y ppa:natecarlson/maven3

echo ">> Add NodeJS PPA"
sudo add-apt-repository -y ppa:chris-lea/node.js

sudo apt-get update

echo ">> Install MongoDB"
sudo apt-get install mongodb-10gen

if [ ! -d /etc/mysql ];
then
  echo ">> Install MySQL"
	sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 1234'
	sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 1234'
	sudo apt-get -y install mysql-server
fi

echo ">> Install Java 7"
sudo apt-get -y install java7-runtime
sudo update-alternatives --set java /usr/lib/jvm/java-7-openjdk-i386/jre/bin/java

echo ">> Install utilities"
sudo apt-get -y install -y openssh-server vim git sudo zip bzip2 fontconfig curl make

echo ">> Install Maven3"
sudo apt-get install -y maven3
sudo ln -s /usr/share/maven3/bin/mvn /usr/bin/mvn

echo ">> Install NodeJS"
sudo apt-get install -y nodejs

echo ">> Install Yeoman"
npm install -g yo

echo ">> Install Jhipster"
npm install -g generator-jhipster@0.11.0

echo ">> Install Compass"
curl -L get.rvm.io | bash -s stable
sudo bash -c "source /etc/profile.d/rvm.sh && rvm requirements; rvm install 1.9.1; gem install compass sass"

#/usr/sbin/sshd -D