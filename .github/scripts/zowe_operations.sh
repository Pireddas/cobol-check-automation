#!/bin/bash
# zowe_operations.sh

set -e

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
PARAM_STRING="-H $HOSTNAME -P 10443 -u $ZOWE_USERNAME --pw $ZOWE_PASSWORD --ru false"

# Check if directory exists, create if it doesn't
zowe zos-files stat uss-file "/z/$LOWERCASE_USERNAME/cobolcheck" $PARAM_STRING

# Upload files
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --recursive \
  --binary-files "cobol-check-0.2.19.jar" $PARAM_STRING 

zowe zos-files upload file-to-uss "./cobol-check-0.2.19.jar" \
  "/z/$LOWERCASE_USERNAME/cobolcheck/bin/cobol-check-0.2.19.jar" \
  --binary $PARAM_STRING

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $PARAM_STRING 
