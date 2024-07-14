#!/bin/bash

rm -rf ../certs
mkdir -p ../certs

# 1. Generate CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -nodes -days 14 -keyout ../certs/api-ca.key -out ../certs/api-ca.crt -subj "/C=DE/ST=NRW/L=Bochum/O=Studierendenschaft der Ruhr-Universitaet Bochum/OU=Parlament/CN=*.stupa-bochum.de/emailAddress=sprecher@stupa-bochum.de"

echo "CA's self-signed certificate"
openssl x509 -in ../certs/api-ca.crt -noout -text

# 2. Generate web server's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096  -nodes -keyout ../certs/api-server.key -out ../certs/server-req.pem -subj "/C=DE/ST=NRW/L=Bochum/O=Studierendenschaft der Ruhr-Universitaet Bochum/OU=Urne 1 API/CN=*.stupa-bochum.de/emailAddress=sprecher@stupa-bochum.de"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in ../certs/server-req.pem -days 14 -CA ../certs/api-ca.crt -CAkey ../certs/api-ca.key -CAcreateserial -out ../certs/api-server.crt -extfile ../conf/ext.conf

echo "Server's signed certificate"
openssl x509 -in ../certs/api-server.crt -noout -text

# 4. Generate client's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout ../certs/api-client.key -out ../certs/client-req.pem -subj "/C=DE/ST=NRW/L=Bochum/O=Studierendenschaft der Ruhr-Universitaet Bochum/OU=Urne 1 GUI/CN=*.stupa-bochum.de/emailAddress=sprecher@stupa-bochum.de"

# 5. Use CA's private key to sign client's CSR and get back the signed certificate
openssl x509 -req -in ../certs/client-req.pem -days 14 -CA ../certs/api-ca.crt -CAkey ../certs/api-ca.key -CAcreateserial -out ../certs/api-client.crt -extfile ../conf/ext.conf

echo "Client's signed certificate"
openssl x509 -in ../certs/api-client.crt -noout -text

rm ../certs/*.srl
rm ../certs/*.pem