#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

TAR_SECRETS=secrets.tar
SECRETS_FOLDER=secrets

cd $SCRIPTPATH/..

gpg --output decrypted_secrets.tar --decrypt gpg/secrets.tar.gpg

tar -xvf decrypted_secrets.tar

rm -rf decrypted_secrets.tar