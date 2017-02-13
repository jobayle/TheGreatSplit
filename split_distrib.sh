#!/bin/sh

# Create a repository for distributions
git clone --no-local dhus distrib && cd distrib

# Edit history
# /distribution/software => /
git filter-branch --prune-empty --subdirectory-filter distribution/software \
    --index-filter "cp ${BASEDIR}/LICENSE . ; git add LICENSE" \
    --tag-name-filter cat \
    -f -- --all

# Clean-up
git gc --prune=now

cd ..
