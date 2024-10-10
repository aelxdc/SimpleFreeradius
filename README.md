# SimpleFreeradius
Simple install of a Radiusd + Mysql authentication

- Install and tested with Ubuntu 22.04 and Freeradius 3.2.6


# INSTALL
apt update
 - Install some dependencies <br>

<code>apt install dirmngr ca-certificates software-properties-common apt-transport-https curl make cmake build-essential libboost-all-dev libssl-dev libtalloc-dev snmp snmp-mibs-downloader libmemcached-dev libhiredis-dev asciidoctor pandoc doxygen nodejs npm libykclient-dev freetds-dev libmysqlclient-dev libjson-perl libpcap-dev libcap-dev graphviz collectd-dev libgdbm-dev libjson-c-dev libkrb5-dev libldap2-dev libykclient-dev libcollectdclient-dev libpam0g-dev libperl-dev python3-dev libcurl4-openssl-dev libiodbc2-dev -y</code> <br>

<code>npm install -g @antora/cli @antora/site-generator-default</code>

# Download Freeradius and install
<code>wget https://github.com/FreeRADIUS/freeradius-server/releases/download/release_3_2_6/freeradius-server-3.2.6.tar.gz
tar -zxf freeradius-server-* && cd freeradius-server-3.2.6/ <br>
./configure --with-logdir=/var/log/radius --with-radacctdir=/var/log/radius/radacct --with-raddbdir=/etc/freeradius/3.2/ <br>
make <br>
make install </code><br>

Make a backup of the sql module, just in case and copy the simple configuration of the SQL module to the mods-enabled of radius.<br>

<code>mv /etc/freeradius/3.2/mods-available/sql /etc/freeradius/3.2/mods-available/sql.orig <br>
cp ../sql /etc/freeradius/3.2/mods-available/sql <br>
ln -s /etc/freeradius/3.2/mods-available/sql /etc/freeradius/3.2/mods-enabled/sql</code><br><br>

Do the same with sites-avaiable/default file: <br>
<code>mv /etc/freeradius/3.2/sites-available/default /etc/freeradius/3.2/sites-available/default.orig <br>
cp ../default /etc/freeradius/3.2/sites-available/default 
</code> <br> <br>

And to the radiusd.conf <br>
<code>mv /etc/freeradius/3.2/radiusd.conf /etc/freeradius/3.2/radiusd.conf.orig <br>
cp SimpleFreeradius/radiusd.conf /etc/freeradius/3.2/radiusd.conf </code><br><br>

And the last one, inner-tunnel<br>
<code>cp /etc/freeradius/3.2/sites-available/inner-tunnel /etc/freeradius/3.2/sites-available/inner-tunnel.orig <br>
cp ../inner-tunnel /etc/freeradius/3.2/sites-available/inner-tunnel</code><br>

# Create a systemd script for initial login:

<code>mkdir -p /var/run/radiusd/ <br>

echo "
[Unit]
Description=FreeRADIUS Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/sbin/radiusd -f
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/var/run/radiusd/radiusd.pid
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/freeradius.service</code>

## Install Mariadb and initial schema

<code> apt install mariadb-server mariadb-client -y </code>

Change the bind address for MariaDb<br>
<code>systemctl enable mariadb
sed -i 's/^bind-address\s*=.*/bind-address            = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb</code> <br>

Create the database
<code>mysql -p

CREATE DATABASE radius CHARACTER SET UTF8 COLLATE UTF8_BIN;
CREATE USER 'radius'@'%' IDENTIFIED BY 'radpass';
GRANT ALL PRIVILEGES ON radius.* TO 'radius'@'%';
QUIT;</code><br>

Import schema<br>
<code>mysql -u radius -p radius < /etc/freeradius/3.2/mods-config/sql/main/mysql/schema.sql</code> <br>


- Populate MariaDB for initial data for testing: <br>
<code>#### INSERIR DADOS NA TABELA radcheck
INSERT INTO radcheck (username, attribute, op, value)
VALUES
('teste1', 'Cleartext-Password', ':=', 'teste1'),
('teste2', 'Cleartext-Password', ':=', 'teste2'),
('teste3', 'Cleartext-Password', ':=', 'teste3'),
('teste4', 'Cleartext-Password', ':=', 'teste4'),
('teste5', 'Cleartext-Password', ':=', 'teste5'),
('teste6', 'Cleartext-Password', ':=', 'teste6'),
('teste7', 'Cleartext-Password', ':=', 'teste7'),
('teste8', 'Cleartext-Password', ':=', 'teste8'),
('teste9', 'Cleartext-Password', ':=', 'teste9'),
('teste10', 'Cleartext-Password', ':=', 'teste10'),
('teste11', 'Cleartext-Password', ':=', 'teste11'),
('teste12', 'Cleartext-Password', ':=', 'teste12'),
('teste13', 'Cleartext-Password', ':=', 'teste13'),
('teste14', 'Cleartext-Password', ':=', 'teste14'),
('teste15', 'Cleartext-Password', ':=', 'teste15'),
('teste16', 'Cleartext-Password', ':=', 'teste16'),
('teste17', 'Cleartext-Password', ':=', 'teste17'),
('teste18', 'Cleartext-Password', ':=', 'teste18'),
('teste19', 'Cleartext-Password', ':=', 'teste19'),
('teste20', 'Cleartext-Password', ':=', 'teste20');</code><br>

<code>### INSERIR NA TABELA NAS
INSERT INTO nas (nasname, shortname, secret, server, description)
VALUES ('192.168.0.1', 'nas3', 'nastest1234', NULL, 'Test NAS 1');</code><br>




