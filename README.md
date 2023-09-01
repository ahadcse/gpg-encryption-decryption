# gpg-encryption-decryption

This is the place for public keys.

## General instructions for how to generate, import ad trust GPG keys

### Download
On most linux GPG is default installed, but if you need something, look here: https://gnupg.org/download/index.html.

#### Mac OS
```
brew install gnupg
```

### Create your key
Use the GUI you downloaded or the command line as:
```
gpg --gen-key
```

### Export key
```
gpg --output [YourNameTag].gpg --export [your_email]@domain.com
```
Now you can add the file here to make it possible for others to encrypt files for you.

### Import keys
```
gpg --import [NameTag].gpg
```

## Encrypt and sign files
```
gpg --output doc.zip.gpg --encrypt --recipient [email_address1]@domain.com --recipient [email_address2]@domain.com doc.zip
```
You need to include person/s who should be able to open this file, including yourself!

## Decrypt
```
gpg --output doc.zip --decrypt doc.zip.gpg
```

## Preparations needed for the servers
The public keys for the developers that should be able to create config folders
for these environments currently have to be imported manually on the servers.

## Commands
To encrypt, use the script bin/encryptData.sh  
To decrypt, use the script bin/decryptData.sh

Please note that all files inside the secrets folder will be overwritten by the
decrypt script. The secret folder is not under version control.

To update a secret, decrypt the secrets.tar.gpg file with the
decryptData script, make the changes in the correct file inside the
secrets folder. Encrypt the secrets again with the encryptData script,
commit the updated gpg files.

## GPG Commands
https://kb.iu.edu/d/awiu

## TODO:
Access level. Some people can decrypt and some cannot