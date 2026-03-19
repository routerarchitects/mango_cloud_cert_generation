#!/bin/bash -x

CNF_DIR="$PWD/conf"
OUTPUT_DIR="$PWD/output"

ROOTCA_DIR=$OUTPUT_DIR/RootCA
ISSUER_DIR=$OUTPUT_DIR/issuer
CERT_GEN_DIR=$OUTPUT_DIR/cert_gen

# CA validity applies to Root CA and Issuer CA certificates.
CA_CERT_VALIDITY_DAYS=7300
# Leaf validity applies to Server and Client certificates.
LEAF_CERT_VALIDITY_DAYS=825
