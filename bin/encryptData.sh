#!/bin/bash
# In order to run this script you must have imported the public keys for the
# recipients. For instructions see README file and public keys are also in this repo. dir: public-keys.

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Create one folder that contains all of the secrets, this file can be read by
# the developers with right access
TAR_SECRETS=secrets.tar
SECRETS_FOLDER=secrets
GPG_FOLDER=gpg

cd $SCRIPTPATH/..
mkdir -p $GPG_FOLDER
# delete the .DS_Store folder that is added on macs
find . -name ".DS_Store" -type f -delete

# create tar for encryption that contains all of the sensitive data
tar -czvf $TAR_SECRETS $SECRETS_FOLDER

rm $GPG_FOLDER/$TAR_SECRETS.gpg
gpg --output $GPG_FOLDER/$TAR_SECRETS.gpg --encrypt -r 8DC5CA6794B89E85966C5C19D5814488AB765370 $TAR_SECRETS

rm -rf $TAR_SECRETS
rm -rf $SECRETS_FOLDER