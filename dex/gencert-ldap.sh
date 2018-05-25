#!/bin/bash

# from https://help.ubuntu.com/lts/serverguide/openldap-server.html

set -x

sudo sh -c "certtool --generate-privkey > /etc/ssl/private/cakey.pem"

echo 'cn = Example Company
ca
cert_signing_key
' > /tmp/ca.info

sudo mv /tmp/ca.info /etc/ssl/ca.info

sudo certtool --generate-self-signed \
--load-privkey /etc/ssl/private/cakey.pem \
--template /etc/ssl/ca.info \
--outfile /etc/ssl/certs/cacert.pem

sudo certtool --generate-privkey \
--bits 1024 \
--outfile /etc/ssl/private/ldap01_slapd_key.pem

echo 'organization = Example Company
cn = ldap01.example.com
tls_www_server
encryption_key
signing_key
expiration_days = 3650' > /tmp/ldap01.info

sudo mv /tmp/ldap01.info /etc/ssl/ldap01.info

sudo certtool --generate-certificate \
--load-privkey /etc/ssl/private/ldap01_slapd_key.pem \
--load-ca-certificate /etc/ssl/certs/cacert.pem \
--load-ca-privkey /etc/ssl/private/cakey.pem \
--template /etc/ssl/ldap01.info \
--outfile /etc/ssl/certs/ldap01_slapd_cert.pem

sudo chgrp openldap /etc/ssl/private/ldap01_slapd_key.pem
sudo chmod 0640 /etc/ssl/private/ldap01_slapd_key.pem
sudo gpasswd -a openldap ssl-cert

sudo sh -c "cat /etc/ssl/certs/cacert.pem >> /etc/ssl/certs/ca-certificates.crt"

sudo systemctl restart slapd.service

