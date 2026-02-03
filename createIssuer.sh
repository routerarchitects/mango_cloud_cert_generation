#!/bin/bash -x
# Purpose: Generate an Issuer CA certificate signed by the Root CA for signing subordinate certificates.

source ./env.sh

ISSUER_DIR=$OUTPUT_DIR/issuer
mkdir -p $ISSUER_DIR
cd $ISSUER_DIR
mkdir newcerts certs crl private requests

# Generate Issuer CA private key.
openssl genrsa -out private/issuer-private.pem 4896

# Create CSR for Issuer CA using issuer.cnf.
openssl req -new -key private/issuer-private.pem -out requests/issuer.csr -config $CNF_DIR/issuer.cnf

# Sign Issuer CA CSR with Root CA's private key.
openssl x509 -req -in requests/issuer.csr \
  -CA $ROOTCA_DIR/certs/cacert.pem \
  -CAkey $ROOTCA_DIR/private/cakey.pem \
  -CAcreateserial \
  -out certs/issuer-cert.pem \
  -extfile $CNF_DIR/issuer_sign.cnf \
  -extensions issuer \
  -days 365
