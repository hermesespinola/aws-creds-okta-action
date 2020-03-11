#!/bin/sh

CREDS_DIR="$HOME/.aws"
mkdir $CREDS_DIR
echo "[profile ${INPUT_AWS_PROFILE:-default}]\noutput = json" >> $CREDS_DIR/config
tokendito -ou $INPUT_OKTA_APP_URL -R $INPUT_AWS_ROLE_ARN --username $INPUT_OKTA_USERNAME --password $INPUT_OKTA_PASSWORD --mfa-method ${INPUT_OKTA_MFA_METHOD:-token:software:totp} --mfa-response `echo $INPUT_OKTA_MFA_SEED | mintotp` -o $CREDS_DIR/credentials >> /dev/null

echo "::set-env name=AWS_CONFIG_FILE::$CREDS_DIR/config"
echo "::set-env name=AWS_SHARED_CREDENTIALS_FILE::$CREDS_DIR/credentials"
