#!/bin/bash
# In order to run this script you must have imported the public keys for the
# recipients. For instructions and public keys

RECIPIENTS=()
USER_GROUPS=()
FILES=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -g|--group)
      USER_GROUPS+=("$2")
      shift 2 # past argument
      ;;
    -r|--recipient)
      RECIPIENTS+=("$2") # save recipient arg
      shift 2 # past argument
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

# Create one folder that contains all of the secrets, this file can be read by
# the deverlopers with access to the production and staging systems.
GPG_FOLDER=gpg

# reader lists that can be used to simplify picking the right readers for a
# file.
devTeam=('ahadcse@gmail.com')
prod=('ahadcse@gmail.com')

# create list with receivers
for((i=0; i<"${#USER_GROUPS[@]}"; i++ )); do
  USER_GROUP=${USER_GROUPS[i]}

  case $USER_GROUP in
    devTeam)
      GROUP_MEMBERS=("${devTeam[@]}")
      ;;
    prod)
      GROUP_MEMBERS=("${prod[@]}")
      ;;
    -h|--help)
      usage
      exit
      ;;
    *)
      echo "Unknown group"
      echo $USER_GROUP
      exit 1
      ;;
  esac

  for GROUP_MEMBER in "${GROUP_MEMBERS[@]}" ; do 
    value="\<${GROUP_MEMBER}\>"

    if ! printf '%s\0' "${RECIPIENTS[@]}" | grep -qwz $GROUP_MEMBER
    then
      RECIPIENTS+=("$GROUP_MEMBER")
    fi
  done
done

GPG_ARGS=''
for((i=0; i<"${#RECIPIENTS[@]}"; i++ )); do
  RECIPIENT=${RECIPIENTS[i]}
  GPG_ARGS+="-r ${RECIPIENT} "
done

cd $SCRIPTPATH/..
# delete the .DS_Store folder that is added on macs
find . -name ".DS_Store" -type f -delete

mkdir -p $GPG_FOLDER
cd $GPG_FOLDER
pwd

for((i=0; i<"${#FILES[@]}"; i++ )); do
  FILE=${FILES[i]}
  TMP_NAME=$(openssl rand -hex 12)
    if [[ $FILE == ./gpg/* ]]
    then
      FILE="$(echo $FILE | sed -r 's/^.{6}//')"
    elif [[ $FILE == gpg/* ]]
    then
      FILE="$(echo $FILE | sed -r 's/^.{4}//')"
    fi

  if [ -d "$FILE" ]; then
    echo "$FILE is a directory. Call Zip!"
    zip -r $TMP_NAME.zip "${FILE[@]}"
    eval "gpg --output ./$TMP_NAME.zip.gpg --encrypt ${GPG_ARGS[@]} ./$TMP_NAME.zip"
    mv ./$TMP_NAME.zip.gpg "${FILE[@]}".zip.gpg
    rm $TMP_NAME.zip
  else
    cp -r "${FILE[@]}" ./$TMP_NAME
    eval "gpg --output ./$TMP_NAME.gpg --encrypt ${GPG_ARGS[@]} ./$TMP_NAME"
    
    mv ./$TMP_NAME.gpg "${FILE[@]}".gpg
    rm $TMP_NAME
  fi
done

echo 'Encryption complete!'