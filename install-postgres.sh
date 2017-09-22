#!/bin/bash
echo '====================> Postgres installation started <===================='

echo 'Installing Postgres'
apt-get install postgresql -y

echo 'Installing Postgres Driver to Wildfly'
cd /vagrant
wget -q https://jdbc.postgresql.org/download/postgresql-42.1.4.jar
cp postgresql-42.1.4.jar /opt/wildfly/standalone/deployments
rm -rf postgresql-42.1.4.jar


echo 'Edit postgres.conf'
cd /etc/postgresql/9.5/main
sed -i s/'#listen_addresses = '/'listen_addresses = '/g postgresql.conf

sed -i '/# IPv4 local connections:/a host    all             all             127.0.0.1/24            trust' pg_hba.conf

echo 'Restarting Postgres'
/etc/init.d/postgresql restart

echo 'Adding datasource to Wildfly'
cd /opt/wildfly/bin
sh jboss-cli.sh --connect -u=admin -p=@dM1n --commands="data-source add --name=ApplicationDS --driver-name=postgresql-42.1.4.jar --connection-url=jdbc:postgresql://localhost:5432/postgres --jndi-name=java:jboss/jdbc/ApplicationDS --user-name=postgres --password=postgres --use-ccm=false --max-pool-size=25 --blocking-timeout-wait-millis=5000,data-source enable --name=ApplicationDS,exit"