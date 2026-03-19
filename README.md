# MangoCloud Certificate Generation Scripts

## Purpose
This directory provides scripts to generate a complete certificate hierarchy for MangoCloud, including:
- Root Certificate Authority (CA)
- Issuer CA (subordinate to the Root CA)
- Server certificates
- Client certificates

These certificates are essential for securing communication between MangoCloud components such as servers and clients using TLS/SSL.


## Prerequisites
Ensure OpenSSL is installed and accessible on your system.
Install on Ubuntu:
```bash
sudo apt-get install openssl
```

## Steps to Generate Certificates
### Set the required environment variables in env.sh:
Example:
```
CA_CERT_VALIDITY_DAYS=7300
LEAF_CERT_VALIDITY_DAYS=825
```
`CA_CERT_VALIDITY_DAYS` is used for Root CA and Issuer CA certificates.
`LEAF_CERT_VALIDITY_DAYS` is used for Server and Client certificates.
### Update certificate subject fields

Before running the scripts, update the certificate subject fields to match your environment.

Update the certificate subject values as needed, including commonName, countryName, stateOrProvinceName, and organizationName, in the following files:
- Root CA: `conf/rootca.cnf`
- Issuer CA: `conf/issuer.cnf`
- Server certificate: `conf/server.cnf`
- Client certificate: `conf/client.cnf`


### Create Root CA
Run the script to generate the Root Certificate Authority:
```bash
./createRootCA.sh
```

### Create Issuer CA
Generate the Issuer CA signed by the Root CA:
```bash
./createIssuer.sh
```

### Generate Server Certificate

Create the server's private key and certificate:

Make sure `commonName` is set to your actual domain name in: `conf/server.cnf`
```bash
./createServerCerts.sh
```

### Generate Client Certificate
Generate the client's private key and certificate.

`client_id` must be exactly 12 characters (for example, `aabbccddeeff`):
```bash
./createClientCerts.sh <client_id>
```

### Transfer Server Certificate
```bash
./transfer_server_certificates.sh
```

### Transfer Device Certificates
This script will be used to transfer device certs. Client certificate files will be placed on the device with the following names: operational.pem, operational.ca, and key.pem.
If you are using a client firmware version earlier than 4.0, rename the files as follows:

- operational.pem -> cert.pem
- operational.ca  -> cas.pem
```bash
./transfer_client_certificates.sh
```
