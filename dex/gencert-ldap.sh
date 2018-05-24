#!/bin/bash

mkdir -p ssl-ldap

cat << EOF > ssl-ldap/req.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name

[req_distinguished_name]

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ldap.example.com
EOF

openssl genrsa -out ssl-ldap/ca-key.pem 2048
openssl req -x509 -new -nodes -key ssl-ldap/ca-key.pem -days 10 -out ssl-ldap/ca.pem -subj "/CN=ldap"

openssl genrsa -out ssl-ldap/key.pem 2048
openssl req -new -key ssl-ldap/key.pem -out ssl-ldap/csr.pem -subj "/CN=kube-ca" -config ssl-ldap/req.cnf
openssl x509 -req -in ssl-ldap/csr.pem -CA ssl-ldap/ca.pem -CAkey ssl-ldap/ca-key.pem -CAcreateserial -out ssl-ldap/cert.pem -days 10 -extensions v3_req -extfile ssl-ldap/req.cnf

# cp cert
sudo cp ssl-ldap/ca.pem /etc/ssl/certs/ldap_ca_server.pem
sudo cp ssl-ldap/cert.pem /etc/ssl/certs/ldap_server.pem
sudo cp ssl-ldap/key.pem /etc/ssl/private/ldap_server.key
sudo chgrp openldap /etc/ssl/private/ldap_server.key 
sudo chmod 0640 /etc/ssl/private/ldap_server.key

