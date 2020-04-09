# Git Sync

A GitHub Action for syncing between two independent repositories (and independent accounts) using **force push**. 

The modification from forked repo is to enable this to happen between seperate accounts. 

## Usage

### GitHub Actions
```
# File: .github/workflows/repo-sync.yml

on: push
jobs:
  repo-sync:
    runs-on: ubuntu-latest
    steps:
    - name: repo-sync
      uses: wei/git-sync@v1
      env:
        SOURCE_REPO: ""
        SOURCE_BRANCH: ""
        DESTINATION_REPO: ""
        DESTINATION_BRANCH: ""
        SSH_PRIVATE_KEY_SOURCE: ${{ secrets.SSH_PRIVATE_KEY_SOURCE }}
        SHH_PRIVATE_KEY_DESTINATION: ${{ secrets.SSH_PRIVATE_KEY_DESTINATION }}
      with:
        args: $SOURCE_REPO $SOURCE_BRANCH $DESTINATION_REPO $DESTINATION_BRANCH
```
`SSH_PRIVATE_KEY` can be omitted if using authenticated HTTPS repo clone urls like `https://username:access_token@github.com/username/repository.git`.

#### Advanced: Sync all branches

To Sync all branches from source to destination, use `SOURCE_BRANCH: "refs/remotes/source/*"` and `DESTINATION_BRANCH: "refs/heads/*"`. But be careful, branches with the same name including `master` will be overwritten.

### Docker
```
docker run --rm -e "SSH_PRIVATE_KEY_DESTINATION=$(cat ../../test_rsa)" -e "SSH_PRIVATE_KEY_SOURCE=$(cat ../../test2)" $(docker build -q .) $SOURCE_REPO $SOURCE_BRANCH $DESTINATION_REPO $DESTINATION_BRANCH
```

## Author
[Wei He](https://github.com/wei) _github@weispot.com_
+ modification by Micah


## License
[MIT](https://wei.mit-license.org)
