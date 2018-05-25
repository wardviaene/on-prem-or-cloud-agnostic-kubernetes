#!/bin/bash
sudo ldapmodify -H ldapi:// -Y EXTERNAL -f certinfo.ldif
ldapadd -x -D cn=admin,dc=example,dc=com -W -f users.ldif 
