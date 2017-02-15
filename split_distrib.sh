#!/bin/sh

# Create a repository for distributions
git clone --no-local dhus distrib && cd distrib

# Edit history
# /distribution/software => /
git filter-branch --prune-empty --subdirectory-filter distribution/software \
    --index-filter "cp ${BASEDIR}/LICENSE . ; git add LICENSE" \
    --tag-name-filter cat \
    -f -- --all

# remove Kakadu, jmeter, data, eclipse, ...
java -jar ../bfg.jar --delete-folders '{data,jmeter,lib,native,.settings}' --delete-files '*.{jar,dll,so,project}'

# Clean-up
git gc --prune=now

cd ..
