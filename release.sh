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

# Tag Docker images and push them to DockerHub
#

JITSI_BUILD=${VERSION} JITSI_RELEASE=${RELEASE} make release

# Changelog
#

echo -e "## ${VERSION}\n\nBased on ${RELEASE} release ${V}.\n\n${CHANGES}\n" > tmp
cat CHANGELOG.md >> tmp
mv tmp CHANGELOG.md

# Set specific image tags in compose files
#

sed -i "" -e "s/unstable/${VERSION}/" *.yml

# Commit all changes and tag the repo
#

git commit -a -m "release: ${VERSION}" -m "${CHANGES}"
git tag -a "${VERSION}" -m "release" -m "${CHANGES}"

# Revert back to "unstable" for development
#

sed -i "" -e "s/${VERSION}/unstable/" *.yml

git commit -a -m "misc: working on unstable"

# Push all changes and tags
#

git push
git push --tags
