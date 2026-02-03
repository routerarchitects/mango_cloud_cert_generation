#!/bin/bash


# Check if a serial number is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <serial_number>"
  echo "Example: $0 dc6279652f19"
  exit 1
fi

SERIAL="$1"
TARGET_DIR="certs-$SERIAL"
ARCHIVE_NAME="client.tar"
mkdir $TARGET_DIR
sh transfer_client_certificates.sh  $SERIAL $TARGET_DIR

# Paths to the required files
CAS="$TARGET_DIR/cas.pem"
CERT="$TARGET_DIR/cert.pem"
KEY="$TARGET_DIR/key.pem"
GATEWAY="gateway.json"
DEVICE_ID="dev-id"
echo "$SERIAL" >  $DEVICE_ID
# Check if all files exist
for FILE in "$CAS" "$CERT" "$KEY" "$GATEWAY"; do
  if [ ! -f "$FILE" ]; then
    echo "❌ Missing file: $FILE"
    exit 1
  fi
done

# Copy gateway.json into the target directory (if not already there)
if [ ! -f "$TARGET_DIR/gateway.json" ]; then
  cp "$GATEWAY" "$TARGET_DIR/"
fi
cp "$DEVICE_ID" "$TARGET_DIR/"

# Create the tar archive inside the serial number directory
tar -cf "$TARGET_DIR/$ARCHIVE_NAME" -C "$TARGET_DIR" \
  "$(basename "$CAS")" \
  "$(basename "$CERT")" \
  "$(basename "$KEY")" \
  "gateway.json" \
  "dev-id"

# Confirm creation
if [ $? -eq 0 ]; then
  echo "✅ Created $ARCHIVE_NAME in $TARGET_DIR/"
  find "$TARGET_DIR" ! -name "$ARCHIVE_NAME" -type f -delete
else
  echo "❌ Failed to create $ARCHIVE_NAME"
  exit 1
fi

