#!/bin/bash -x
# Purpose: Generate a self-signed Root CA certificate for the certificate hierarchy.

source ./env.sh

ROOTCA_DIR=$OUTPUT_DIR/RootCA
mkdir -p $ROOTCA_DIR
cd $ROOTCA_DIR

mkdir newcerts certs crl private requests

# Generate the Root CA private key.
openssl genrsa -out private/cakey.pem 4896

# Create a self-signed Root CA certificate using rootca.cnf.
openssl req -new -x509 -key private/cakey.pem -out certs/cacert.pem -days $CERT_VALIDITY_DAYS -set_serial 0 -config $CNF_DIR/rootca.cnf

