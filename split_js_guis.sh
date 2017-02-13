#!/bin/sh

# Create a repository each JS GUIs

for gui in html webclient owc-client
do
# Prepare environment
    git clone --no-local dhus ${gui} && cd ${gui}

    # client/${gui}  =>  /
    # Restore license file at root of git repo
    # Applied on all branches
    git filter-branch --prune-empty --subdirectory-filter client/${gui} \
        --index-filter "cp ${BASEDIR}/LICENSE . ; git add LICENSE" \
        --tag-name-filter cat \
        -f -- --all

    # Clean-up
    git gc --prune=now

    cd ..
done
