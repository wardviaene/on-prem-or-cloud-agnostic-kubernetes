#!/bin/bash
sudo gpasswd -a openldap ssl-cert
sudo systemctl restart slapd.service
sudo ldapmodify -H ldapi:// -Y EXTERNAL -f addcerts.ldif
ldapadd -x -D cn=admin,dc=example,dc=com -W -f users.ldif 
