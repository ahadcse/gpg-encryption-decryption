# gpg-encryption-decryption

This repository is used to to encrypt and decrypt files using public key cryptography.

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
You must have the public keys imported for each of the persons that you add as recipients of a file. To check the public keys that you currently have imported you can use the command:
```
gpg --list-keys
```
This command also shows the trust level for the keys that you have imported. You should trust the public keys of your team members ultimately. To change the trust level for a key execute
```
gpg --edit-key idForTheKeyToEdit
```
The ID for a key can be found as an output from the `gpg --list-keys` command. Type trust and then a 5 to trust ultimately followed by q and enter to quit gpg.
The trust level should then be changed from unknown to ultimate in the output from the `gpg --list-keys` command.

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

## Scripts
To encrypt, use the script bin/encryptData.sh  
To decrypt, use the script bin/decryptData.sh

Please note that all files inside the secrets folder will be overwritten by the
decrypt script. The secret folder is not under version control.

To update a secret, decrypt the secrets.tar.gpg file with the
decryptData script, make the changes in the correct file inside the
secrets folder. Encrypt the secrets again with the encryptData script,
commit the updated gpg files.

### Decryption
```
bin/decryptData.sh -l
```
The command lists the gpg files available.

```
bin/decryptData.sh ./gpg/secrets.tar.gpg
```
The file is decrypted and then decompressed.

### Encryption
```
bin/encryptData.sh -g devTeam -r ahadcse@gmail.com ./gpg/test
```
This command will create an encrypted file of the content in `test`.

The script contains two groups of user to make it easier to encrypt for the right persons. The groups are called prod and devTeam. The command above will encrypt for the devTeam and also for email@domain.com. 
Please note that you need to have the public keys imported for every person that you encrypt the file for.

## GPG Commands reference
https://kb.iu.edu/d/awiu

## GPG Tool for MAC:
https://gpgtools.org