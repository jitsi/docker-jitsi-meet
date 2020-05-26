#!/bin/bash

set -e

# Don't start a release if the tree is dirty
#

if [[ ! -z $(git status -s) ]]; then
    echo "Git tree is not clean, aborting release!"
    exit 1
fi

# Get version and branch (we only do stable for now)
#

V="$1"
RELEASE="${2:-stable}"

if [[ -z $V ]]; then
    echo "A version must be specified!"
    exit 1
fi

VERSION="${RELEASE}-${V}"
echo "Releasing ${VERSION}"

if git rev-parse "${VERSION}" >/dev/null 2>&1; then
	echo "Tag for such version already exists!"
	exit 1
fi

# Prepare changelog
#

LAST_VERSION=$(git describe --tags --abbrev=0)
CHANGES=$(git log --oneline --no-decorate --no-merges ${LAST_VERSION}..HEAD --pretty=format:"%x2a%x20%h%x20%s")

echo "Changelog:"
echo "$CHANGES"

echo -e "## ${VERSION}\n\nBased on ${RELEASE} release ${V}.\n\n${CHANGES}\n" > tmp
cat CHANGELOG.md >> tmp
mv tmp CHANGELOG.md

# Set specific image tags in compose files
#

sed -i "" -e "s/latest/${VERSION}/" *.yml

# Commit all changes and tag the repo
#

git commit -a -m "release: ${VERSION}" -m "${CHANGES}"
git tag -a "${VERSION}" -m "release" -m "${CHANGES}"

# Tag Docker images and push them to DockerHub
#

JITSI_BUILD=${VERSION} make release

# Revert back to "latest" for development
#

sed -i "" -e "s/${VERSION}/latest/" *.yml

git commit -a -m "misc: working on latest"

# Push all changes and tags
#

git push
git push --tags
