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
   Before running the scripts, update the subject fields to match your environment:
   - Root CA: conf/rootca.cnf
   - Issuer CA: conf/issuer.cnf
   - Server cert: conf/server.cnf

   Ensure values like commonName, countryName, and stateOrProvinceName are correct.

1. **Create Root CA**
   Run the script to generate the Root Certificate Authority:
   ```bash
   ./createRootCA.sh
   ```

2. **Create Issuer CA**
   Generate the Issuer CA signed by the Root CA:
   ```bash
   ./createIssuer.sh
   ```

3. **Generate Server Certificate**
   Create the server's private key and certificate:
   ```bash
   ./createServerCerts.sh
   ```

4. **Update Client ID**
   Edit `createClientCerts.sh` to set a unique `clientID` and update the `commonName` in the `.cnf` file to match the client ID (e.g., `commonName = <ClientID>`).


5. **Generate Client Certificate**
   Generate the client's private key and certificate. Make sure clientId should 12 chars or a valid MAC:
   ```bash
   ./createClientCerts.sh
   ```

6. **Transfer Server Certificate**
   Transfer server certifcates:
   ```bash
   ./transfer_server_certificates.sh
   ```

7. **Transfer Client Certificate**
   Transfer client certifcates:
   ```bash
   ./transfer_client_certificates.sh
   ```
