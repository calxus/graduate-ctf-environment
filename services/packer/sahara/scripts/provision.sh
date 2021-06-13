#!/bin/bash -eux

apt-get install -y php5 apache2 unzip

wget -O /var/www/html/master.zip -L https://github.com/projectworlds32/online-book-store-project-in-php/archive/master.zip
unzip -d /var/www/html/bookstore /var/www/html/master.zip
mv /var/www/html/bookstore/online-book-store-project-in-php-master/* /var/www/html/bookstore
chmod 777 -R /var/www/html/bookstore/
rm -f /var/www/html/master.zip

apt install -y dirmngr
apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 5072E1F5
echo "deb http://repo.mysql.com/apt/debian $(lsb_release -sc) mysql-8.0" | tee /etc/apt/sources.list.d/mysql80.list
apt update
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password tiger"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password tiger"
DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

mysql -u root -ptiger -e "CREATE DATABASE www_project;"
sed -i 's/-- Database:.*/USE www_project;/g' /var/www/html/bookstore/database/www_project.sql
mysql -u root -ptiger < /var/www/html/bookstore/database/www_project.sql
sed -i 's/mysqli_connect("localhost", "root", "", "www_project")/                $conn = mysqli_connect("localhost", "root", "tiger", "www_project");/g' /var/www/html/bookstore/functions/database_functions.php

apt install -y php5-mysql

cat > /cleanup.sh <<EOF
#!/bin/bash

rm -f /tmp/*.gz
EOF

chmod 777 /cleanup.sh

(crontab -l 2>/dev/null; echo "*/2 * * * * /cleanup.sh") | crontab -

echo "4115d27fd62dd648baf69ef180822bab" > /home/boris/proof.txt
chmod 444 /home/boris/proof.txt

echo "d86ad61d5b42c1834cd5f1dd7af1112a" > /root/proof.txt
chmod 400 /root/proof.txt

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
