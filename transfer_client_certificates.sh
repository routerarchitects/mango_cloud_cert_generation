#!/bin/bash

# Usage information
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <client_id> <destination_path>"
  echo "Example (Remote Copy): $0 7210e3ad221f root@200.20.20.115:/etc/ucentral"
  echo "Example (Local Copy):  $0 7210e3ad221f /home/user/ucentral"
  exit 1
fi

# Assign arguments
CLIENT_ID=$1
DEST_PATH=$2

# Source paths
SOURCE_PATH="output"

# Check if the destination is remote (contains '@')
if [[ "$DEST_PATH" == *"@"*":"* ]]; then
  IS_REMOTE=true
else
  IS_REMOTE=false
fi

# Function to check if a file exists before copying
copy_file() {
  local src=$1
  local dest=$2

  if [ ! -f "$src" ]; then
    echo "❌ Error: File not found -> $src"
    exit 1
  fi

  if $IS_REMOTE; then
    scp "$src" "$dest"
  else
    cp "$src" "$dest"
  fi

  if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to copy $src to $dest"
    exit 1
  fi

  echo "✅ Copied $src to $dest"
}

# Combine Root CA and Issuer CA into clientcas.pem
cat "$SOURCE_PATH/RootCA/certs/cacert.pem" "$SOURCE_PATH/issuer/certs/issuer-cert.pem" > /tmp/clientcas.pem
# Copy combined file to the destination
copy_file "/tmp/clientcas.pem" "$DEST_PATH/operational.ca"
copy_file "$SOURCE_PATH/cert_gen/certs/client-cert-${CLIENT_ID}.pem" "$DEST_PATH/operational.pem"
copy_file "$SOURCE_PATH/cert_gen/private/client-private-${CLIENT_ID}.pem" "$DEST_PATH/key.pem"

echo "✅ Certificates for client ID $CLIENT_ID have been successfully transferred to $DEST_PATH."
