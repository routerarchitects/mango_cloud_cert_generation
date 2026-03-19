#!/bin/bash -x
# Purpose: Generate a server certificate signed by the Issuer CA.

source ./env.sh

mkdir -p $CERT_GEN_DIR
cd $CERT_GEN_DIR
mkdir newcerts certs crl private requests

# Generate the server's private key.
openssl genrsa -out private/server-private.pem 4896

# Create a Certificate Signing Request (CSR) for the server.
openssl req -new -key private/server-private.pem -out requests/server.csr -config $CNF_DIR/server.cnf

# Sign the server CSR with the Issuer CA's private key to create the server certificate.
openssl x509 -req -in requests/server.csr \
  -CA $ISSUER_DIR/certs/issuer-cert.pem \
  -CAkey $ISSUER_DIR/private/issuer-private.pem \
  -CAcreateserial \
  -out certs/server-cert.pem \
  -extfile $CNF_DIR/server_sign.cnf \
  -extensions server \
  -days $CERT_VALIDITY_DAYS
# Display the details of the generated server certificate.
openssl x509 -in certs/server-cert.pem -text

