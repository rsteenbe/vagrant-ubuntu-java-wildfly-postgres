#!/bin/bash
echo '====================> Wildfly installation started <===================='
WILDFLY_FILE=/vagrant/wildfly-11.0.0.CR1.tar.gz

if [ -f "$WILDFLY_FILE" ]; then
	echo 'Wildfly TGZ found.'
else
	echo 'No Wildfly TGZ found, it will download Wildfly from jboss.org'
	cd /vagrant
	echo 'Download started, this process may take a while...'
	wget -q http://download.jboss.org/wildfly/11.0.0.CR1/wildfly-11.0.0.CR1.tar.gz
	echo 'Download finished.'
fi

cd /opt
tar -xzf $WILDFLY_FILE

ln -s /opt/wildfly-11.0.0.CR1 /opt/wildfly

cp /opt/wildfly/docs/contrib/scripts/init.d/wildfly.conf /etc/default/wildfly

cp /opt/wildfly/docs/contrib/scripts/init.d/wildfly-init-debian.sh /etc/init.d/wildfly

chown root:root /etc/init.d/wildfly
chmod +X /etc/init.d/wildfly

update-rc.d wildfly defaults
update-rc.d wildfly enable

mkdir -p /var/log/wildfly

useradd --system --shell /bin/false wildfly

chown -R wildfly:wildfly /opt/wildfly-11.0.0.CR1
chown -R wildfly:wildfly /opt/wildfly
chown -R wildfly:wildfly /var/log/wildfly

cd /opt/wildfly-11.0.0.CR1/standalone/configuration

sed -i s/'127.0.0.1'/'0.0.0.0'/g standalone.xml

service wildfly start
echo 'Wildfly started.'

cd /opt/wildfly/bin
sh add-user.sh -u 'admin' -p '@dM1n'
echo ''
echo 'User "admin" with pass "@dM1n" added to Wildfly Administation Console users'
echo ''