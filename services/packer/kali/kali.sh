#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
sudo -E apt-get -qy update
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" dist-upgrade
sudo -E apt-get -qy autoclean

sudo mkdir -p /opt/useful/SecLists
sudo git clone https://github.com/danielmiessler/SecLists.git /opt/useful/SecLists
sudo sed -i '/^[[:blank:]]*#/d;s/#.*//' /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt

sudo mkdir -p /opt/useful/privesc
sudo git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git /opt/useful/privesc

curl -o /opt/useful/pspy -L https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64
sudo chmod 777 -R /opt/useful

sudo apt install -y kali-desktop-xfce tigervnc-standalone-server

git clone https://github.com/MysticRyuujin/guac-install.git /tmp/guac-install
cd /tmp/guac-install/
sed -i 's/cgi/lua/g' guac-install.sh
sudo ./guac-install.sh --nomfa --installmysql --mysqlpwd securepassword --guacpwd password

cat > /etc/systemd/system/remote.service <<EOF
[Unit]
Description=Remote Access Service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=forking
User=kali
ExecStart=/usr/bin/vncserver -SecurityTypes None :1

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/guacamole/user-mapping.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<user-mapping>
    <authorize username="gradctf" password="gradctf">
        <connection name="kali">
            <protocol>vnc</protocol>
            <param name="hostname">127.0.0.1</param>
            <param name="port">5901</param>
            <param name="guacd-host">127.0.0.1</param>
            <param name="guacd-port">4822</param>
        </connection>
    </authorize>
</user-mapping>
EOF

sudo systemctl enable remote