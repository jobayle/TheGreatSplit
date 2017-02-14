#!/bin/sh

# Create a repository each DHuS addon

for addon in sentinel-1 sentinel-2 sentinel-3
do
    # Prepare environment
    git clone --no-local dhus ${addon} && cd ${addon}

    # addons/${addon} => /
    # Restore license file at root of git repo
    git filter-branch --prune-empty --subdirectory-filter addon/${addon} \
        --index-filter "cp ${BASEDIR}/LICENSE . ; git add LICENSE" \
        --tag-name-filter cat \
        -f -- --all

    # Clean-up
    git gc --prune=now

    cd ..
done
