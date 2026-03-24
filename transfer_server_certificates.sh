#!/bin/bash

# Usage information
print_usage() {
  echo "Usage: $0 <destination_path>"
  echo "Usage: $0 -i <pem_file> <destination_path>"
  echo "Example (Remote Copy): $0 taruna@200.20.20.113:~/Downloads/certs"
  echo "Example (EC2 Remote):  $0 -i </path/to/acs-key.pem> ubuntu@<PUBLIC_DOMAIN_NAME>:/home/ubuntu/openwifi-sdk/mango-cloud-deployment/docker-compose/certs"
  echo "Example (Local Copy):  $0 /home/taruna/OpenWiFi_workspace/wlan-cloud-ucentral-deploy/docker-compose/certs"
}

# Optional ssh/scp identity file
PEM_FILE=""
while getopts ":i:" opt; do
  case $opt in
    i)
      PEM_FILE=$OPTARG
      ;;
    \?)
      print_usage
      exit 1
      ;;
    :)
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

if [ "$#" -lt 1 ]; then
  print_usage
  exit 1
fi

# Assign arguments
DEST_PATH=$1

# Source paths
SOURCE_PATH="output"

# Detect if destination is remote (contains '@:')
if [[ "$DEST_PATH" == *"@"*":"* ]]; then
  IS_REMOTE=true
else
  IS_REMOTE=false
fi

# Validate identity file when provided
if [ -n "$PEM_FILE" ]; then
  if [ ! -f "$PEM_FILE" ]; then
    echo "❌ Error: PEM file not found -> $PEM_FILE"
    exit 1
  fi
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
    if [ -n "$PEM_FILE" ]; then
      scp -i "$PEM_FILE" "$src" "$dest"
    else
      scp "$src" "$dest"
    fi
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
copy_file "/tmp/clientcas.pem" "$DEST_PATH/clientcas.pem"

copy_file "$SOURCE_PATH/RootCA/certs/cacert.pem" "$DEST_PATH/root.pem"
copy_file "$SOURCE_PATH/issuer/certs/issuer-cert.pem" "$DEST_PATH/issuer.pem"
copy_file "$SOURCE_PATH/cert_gen/certs/server-cert.pem" "$DEST_PATH/websocket-cert.pem"
copy_file "$SOURCE_PATH/cert_gen/private/server-private.pem" "$DEST_PATH/websocket-key.pem"

echo "✅ Successfully copied the server certificates!"
