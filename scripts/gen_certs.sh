#!/bin/bash

mkdir -p ../certs
rm ../certs/*.pem

# 1. Generate CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 14 -nodes -keyout ../certs/ca-key.pem -out ../certs/ca-cert.pem -subj "/C=DE/ST=NRW/L=Bochum/O=Studierendenschaft der Ruhr-Universitaet Bochum/OU=Parlament/CN=*.stupa-bochum.de/emailAddress=sprecher@stupa-bochum.de"

echo "CA's self-signed certificate"
openssl x509 -in ../certs/ca-cert.pem -noout -text

# 2. Generate web server's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout ../certs/server-key.pem -out ../certs/server-req.pem -subj "/C=DE/ST=NRW/L=Bochum/O=Studierendenschaft der Ruhr-Universitaet Bochum/OU=Urne 1 API/CN=*.stupa-bochum.de/emailAddress=sprecher@stupa-bochum.de"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in ../certs/server-req.pem -days 14 -CA ../certs/ca-cert.pem -CAkey ../certs/ca-key.pem -CAcreateserial -out ../certs/server-cert.pem -extfile ext.conf

echo "Server's signed certificate"
openssl x509 -in ../certs/server-cert.pem -noout -text

# 4. Generate client's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout ../certs/client-key.pem -out ../certs/client-req.pem -subj "/C=DE/ST=NRW/L=Bochum/O=Studierendenschaft der Ruhr-Universitaet Bochum/OU=Urne 1 GUI/CN=*.stupa-bochum.de/emailAddress=sprecher@stupa-bochum.de"

# 5. Use CA's private key to sign client's CSR and get back the signed certificate
openssl x509 -req -in ../certs/client-req.pem -days 14 -CA ../certs/ca-cert.pem -CAkey ../certs/ca-key.pem -CAcreateserial -out ../certs/client-cert.pem -extfile ext.conf

echo "Client's signed certificate"
openssl x509 -in ../certs/client-cert.pem -noout -text