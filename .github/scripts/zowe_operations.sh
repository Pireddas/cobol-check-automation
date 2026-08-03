#!/bin/bash
# zowe_operations.sh

set -e

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
PARAM_STRING="-H $HOSTNAME -P 10443 -u $ZOWE_USERNAME --pw $ZOWE_PASSWORD --ru false"

# Check if directory exists, create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Directory does not exist. Creating it..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck" $PARAM_STRING
else
  echo "Directory already exists."
fi

# Upload files
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --recursive \
  --binary-files "cobol-check-0.2.9.jar" $PARAM_STRING 

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $PARAM_STRING 
