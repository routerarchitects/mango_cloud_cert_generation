#!/bin/bash -x
# Purpose: Generate a client certificate signed by the Issuer CA.

source ./env.sh

# Check if client ID is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <client_id>"
  echo "Example: $0 7210e3ad221f"
  exit 1
fi

CLIENT_ID=$1

# Validate that the client ID is exactly 12 characters long
if [[ ${#CLIENT_ID} -ne 12 ]]; then
  echo "Error: Client ID must be exactly 12 characters long."
  exit 1
fi

# Define certificate paths
mkdir -p $CERT_GEN_DIR
cd $CERT_GEN_DIR
mkdir -p newcerts certs crl private requests

CL_PRIVATE="private/client-private-$CLIENT_ID.pem"
CL_PUB="requests/client-$CLIENT_ID.csr"
CL_CERT="certs/client-cert-$CLIENT_ID.pem"

# Generate the client's private key.
openssl genrsa -out "$CL_PRIVATE" 4896

# Create a Certificate Signing Request (CSR) for the client using the provided Client ID in CN
openssl req -new -key "$CL_PRIVATE" -out "$CL_PUB" -config "$CNF_DIR/client.cnf" -subj "/CN=$CLIENT_ID"

# Sign the client CSR with the Issuer CA's private key to create the client certificate.
openssl x509 -req -in "$CL_PUB" \
  -CA "$ISSUER_DIR/certs/issuer-cert.pem" \
  -CAkey "$ISSUER_DIR/private/issuer-private.pem" \
  -CAcreateserial \
  -out "$CL_CERT" \
  -extfile "$CNF_DIR/client_sign.cnf" \
  -extensions client \
  -days 365

# Display the details of the generated client certificate.
openssl x509 -in "$CL_CERT" -text

