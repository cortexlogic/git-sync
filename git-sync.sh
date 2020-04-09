#!/bin/sh

set -e

SOURCE_REPO=$1
SOURCE_BRANCH=$2
DESTINATION_REPO=$3
DESTINATION_BRANCH=$4

if ! echo $SOURCE_REPO | grep '.git'
then
  if [[ -n "$SSH_PRIVATE_KEY_SOURCE" ]]
  then
    echo 'im here'
    SOURCE_REPO="git@github.com:${SOURCE_REPO}.git"
  else
    echo 'no actually im here'
    SOURCE_REPO="https://github.com/${SOURCE_REPO}.git"
  fi
fi
if ! echo $DESTINATION_REPO | grep '.git'
then
  if [[ -n "$SSH_PRIVATE_KEY_DESTINATION" ]]
  then
    DESTINATION_REPO="git@github.com:${DESTINATION_REPO}.git"
  else
    DESTINATION_REPO="https://github.com/${DESTINATION_REPO}.git"
  fi
fi

echo "SOURCE=$SOURCE_REPO:$SOURCE_BRANCH"
echo "DESTINATION=$DESTINATION_REPO:$DESTINATION_BRANCH"

mkdir -p /root/.ssh
echo "$SSH_PRIVATE_KEY_SOURCE" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
git clone "$SOURCE_REPO" --origin source && cd `basename "$SOURCE_REPO" .git`

mkdir -p /root/.ssh
echo "$SSH_PRIVATE_KEY_DESTINATION" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
git remote add destination "$DESTINATION_REPO"

git push destination "${SOURCE_BRANCH}:${DESTINATION_BRANCH}" -f
