#!/bin/sh

# Create a repository each DHuS addon

for addon in sentinel-1 sentinel-2 sentinel-3
do
    # Prepare environment
    git clone --no-local dhus ${addon} && cd ${addon}

    # First commit for that addon
    START_COMMIT=$(git log --oneline --reverse --full-history -- addon/${addon} | head -n1 | cut -d " " -f1)

    # addons/${addon} => /
    # Restore license file at root of git repo
    git filter-branch --prune-empty --subdirectory-filter addon/${addon} \
        --index-filter "cp ${BASEDIR}/LICENSE . ; git add LICENSE" \
        -f -- ${START_COMMIT}^..master

    # Clean-up
    git gc --prune=now

    cd ..
done
