#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define usage function
usage(){
  # Displays Usage
  cat <<End-of-message

  Usage: $0 [OPTIONS] file(s)
  
  Used for decryping encrypted gpg file/files. Path to the gpg
  file/files is given as input to the script
  
  Options:
    -l|--list List the available files.
    OR
    -h|--help Display help.
    
End-of-message
  # The EOF token on the line above must be at the very beginning of the line and
  # must be the only thing present on that line.
  exit 1
}

FILES=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -l|--list)
      LIST=true
      shift # past argument
      ;;
    -h|--help)
      usage
      exit
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      FILES+=("$1") # save file arg
      shift # past argument
      ;;
  esac
done


SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH/..

GPG_FOLDER=./gpg

set -- "${FILES[@]}" # restore file parameters

if [ "$LIST" = "true" ]
then
  ls -l $GPG_FOLDER/*.gpg
exit
fi

TAR_SECRETS=secrets.tar
SECRETS_FOLDER=secrets

mkdir -p $SECRETS_FOLDER

for((i=0; i<"${#FILES[@]}"; i++ )); do
  GPG_FILE=${FILES[i]}

  FILE=$(echo $GPG_FILE |sed 's/.gpg$//g')

  if ! [[ $GPG_FILE == ./gpg/* ]] && ! [[ $GPG_FILE == gpg/* ]]
  then
    GPG_FILE="./gpg/$GPG_FILE"
  fi

  if [[ $FILE == ./gpg/* ]]
  then
    FILE="$(echo $FILE | sed -r 's/^.{6}//')"
  elif [[ $FILE == gpg/* ]]
  then
    FILE="$(echo $FILE | sed -r 's/^.{4}//')"
  fi

  gpg --output $GPG_FOLDER/$FILE --decrypt $GPG_FILE

  case $FILE in 
  *.zip)
    unzip $GPG_FOLDER/$FILE -d $GPG_FOLDER
    rm -rf $GPG_FOLDER/$FILE
    ;;
  esac
done