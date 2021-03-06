#!/bin/sh

set -e


echo 'starting action'
echo $SOURCE_REPO
echo $SOURCE_BRANCH
echo $DESTINATION_REPO
echo $DESTINATION_BRANCH
echo $SSH_PRIVATE_KEY_SOURCE
echo $SSH_PRIVATE_KEY_DESTINATION
echo $DESTINATION_URL

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
if [ -z ${DESTINATION_URL+x} ]
then
  echo "DESTINATION_URL is unset"
  if ! echo $DESTINATION_REPO | grep '.git'
  then
    if [[ -n "$SSH_PRIVATE_KEY_DESTINATION" ]]
    then
      DESTINATION_REPO="git@github.com:${DESTINATION_REPO}.git"
    else
      DESTINATION_REPO="https://github.com/${DESTINATION_REPO}.git"
    fi
  fi
else
  echo "DESTINATION_URL is set to '$DESTINATION_URL'"
  DESTINATION_REPO=$DESTINATION_URL
fi

echo "SOURCE=$SOURCE_REPO:$SOURCE_BRANCH"
echo "DESTINATION=$DESTINATION_REPO:$DESTINATION_BRANCH"

mkdir -p /root/.ssh
echo "$SSH_PRIVATE_KEY_SOURCE" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
cp /root/.ssh/* ~/.ssh/ 2> /dev/null || true
git clone "$SOURCE_REPO" --origin source && cd `basename "$SOURCE_REPO" .git`
echo 'Cloned existing repo...'

#echo 'removing .github/workflows...'
#rm .github/ -r

git branch
git checkout $SOURCE_BRANCH

mkdir -p /root/.ssh
echo "$SSH_PRIVATE_KEY_DESTINATION" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
cp /root/.ssh/* ~/.ssh/ 2> /dev/null || true
git remote add destination "$DESTINATION_REPO"

echo 'added remote destination...'

git push destination "${SOURCE_BRANCH}:${DESTINATION_BRANCH}" -f
echo 'Pushed to remote'
