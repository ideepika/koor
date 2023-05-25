#!/bin/bash

set -x

GITHUB_TOKEN=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

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

ROOK_REMOTE="https://github.com/rook/rook.git"
ROOK_BRANCH="master"
INPUT_AUTOSQUASH=false

git remote add rook_fork "$ROOK_REMOTE"
git fetch rook_fork $ROOK_BRANCH

set -o xtrace

# do the rebase
git checkout -b rebase-rook-master
if [[ $INPUT_AUTOSQUASH == 'true' ]]; then
	GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash rook_fork/$ROOK_BRANCH
else
	git rebase rook_fork/$ROOK_BRANCH
fi

# push back
git push --force-with-lease origin rebase-rook-master:rebase-rook-master
