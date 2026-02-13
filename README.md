# OpenWiFi Certificate Generation Scripts

## Purpose
This directory provides scripts to generate a complete certificate hierarchy for OpenWiFi, including:
- Root Certificate Authority (CA)
- Issuer CA (subordinate to the Root CA)
- Server certificates
- Client certificates

These certificates are essential for securing communication between OpenWiFi components such as servers and clients using TLS/SSL.


## Pre-requisites
   OpenSSL installed and accessible in your system.
   Install on Ubuntu:
   ```bash
   sudo apt-get install openssl
   ```

## Steps to Generate Certificates
**Update certificate subject fields**

   Before running the scripts, update the certificate subject fields to match your environment.

   Verify these values are correct where applicable: `commonName`, `countryName`, `stateOrProvinceName` and `organizationName`.

   Update the following files:
   - Root CA: `conf/rootca.cnf`
   - Issuer CA: `conf/issuer.cnf`
   - Client certificate: `conf/client.cnf`


 **Create Root CA**
   Run the script to generate the Root Certificate Authority:
   ```bash
   ./createRootCA.sh
   ```

 **Create Issuer CA**
   Generate the Issuer CA signed by the Root CA:
   ```bash
   ./createIssuer.sh
   ```

 **Generate Server Certificate**

   Create the server's private key and certificate:

   Make sure `commonName` is set to your actual domain name in: `conf/server.cnf`
   ```bash
   ./createServerCerts.sh
   ```

 **Generate Client Certificate**

   Generate the client's private key and certificate.

   `client_id` must be exactly 12 characters (for example, `aabbccddeeff`):
   ```bash
   ./createClientCerts.sh <client_id>
   ```

 **Transfer Server Certificate**
   Transfer server certifcates:
   ```bash
   ./transfer_server_certificates.sh
   ```

 **Transfer Client Certificate**
   Transfer client certifcates:
   ```bash
   ./transfer_client_certificates.sh
   ```
   **Note:**
   The client certificates will be placed on the device as operational.pem, operational.ca and key.pem.

   If you are using a client firmware version earlier than 4.0, rename the files as follows:

   - operational.pem -> cert.pem
   - operational.ca  -> cas.pem
