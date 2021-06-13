#!/bin/bash

cat > /etc/guacamole/user-mapping.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<user-mapping>
    <authorize username="${kali_user}" password="${kali_pass}">
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

sudo systemctl restart guacd
sudo systemctl restart tomcat9