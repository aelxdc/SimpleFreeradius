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
cp SimpleFreeradius/sql /etc/freeradius/3.2/mods-available/sql <br>
ln -s /etc/freeradius/3.2/mods-available/sql /etc/freeradius/3.2/mods-enabled/sql</code><br><br>

Do the same with sites-avaiable/default file: <br>
<code>mv /etc/freeradius/3.2/sites-available/default /etc/freeradius/3.2/sites-available/default.orig <br>
cp SimpleFreeradius/sites-avaiable/default /etc/freeradius/3.2/sites-available/default 
</code> <br> <br>

And to the radiusd.conf <br>
<code>mv /etc/freeradius/3.2/radiusd.conf /etc/freeradius/3.2/radiusd.conf.orig <br>
cp SimpleFreeradius/radiusd.conf /etc/freeradius/3.2/radiusd.conf </code><br><br>

And the last one, inner-tunnel<br>
<code>cp /etc/freeradius/3.2/sites-available/inner-tunnel /etc/freeradius/3.2/sites-available/inner-tunnel.orig <br>
cp SimpleFreeradius/inner-tunnel /etc/freeradius/3.2/sites-available/inner-tunnel</code><br>
