#!/bin/bash
echo '====================> chkconfig installation started <===================='
apt-get update
apt-get install chkconfig

echo '====================> Java installation started <===================='
JAVA_FILE=/vagrant/jdk-8u144-linux-x64.tar.gz
INSTALLATION_DIR=/opt/java

if [ -f "$JAVA_FILE" ]; then
	echo 'Java TGZ found.'
	echo 'Starting Java installation.'
	mkdir $INSTALLATION_DIR
	cd $INSTALLATION_DIR
	tar -xzvf $JAVA_FILE
	update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_144/bin/java 1
else
	echo 'No Java TGZ found, install through apt-get'
	echo 'Starting Java installation.'
	apt-get install openjdk-8-jre-headless -y
fi

echo 'Java installation successful.'