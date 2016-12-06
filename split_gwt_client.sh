#!/bin/sh

# Create a repository for the DHuS module: GWT-Client

# Prepare environment
git clone --no-local dhus GWT-Client && cd GWT-Client

# What we want to keep (chronological order)
# /dhus-webapp && /dhus-gwt-client && /dhus-gwt-server
# /gui          => /
# /client/gwt   => /
NEW_RANGE=$(git log --oneline --reverse --full-history -- client/gwt | head -n1 | cut -d " " -f1)
MID_RANGE=$(git log --oneline --reverse --full-history -- gui/ | head -n1 | cut -d " " -f1)
OLD_RANGE=$(git log --oneline --reverse --full-history | head -n1 | cut -d " " -f1)

# Edit history (in reverse chronological order to preserve old references)
# /client/gwt   => /gui
# Restore license file at root of git repo
git filter-branch --tree-filter "if [ -d client/gwt/ ] ; then mv client/gwt/ gui/ ; fi" \
    -f -- ${NEW_RANGE}^..master

# /gui          => /
# Restore license file at root of git repo
git filter-branch --prune-empty --subdirectory-filter gui \
    --index-filter "cp ${BASEDIR}/LICENSE . ; git add LICENSE" \
    -f -- $MID_RANGE^..master

# /dhus-webapp && /dhus-gwt-client && /dhus-gwt-server
git filter-branch --prune-empty --index-filter \
    "git rm -r --cached --ignore-unmatch \
        dhus-api             \
        dhus-core            \
        dhus-distributions   \
        dhus-gui             \
        dhus-gui-admin       \
        dhus-gui-user        \
        dhus-hibernate       \
        dhus-hsqldb          \
        dhus-hsqldb-server   \
        dhus-jetty           \
        dhus-launcher        \
        dhus-new             \
        dhus-odata           \
        dhus-packager        \
        dhus-parent          \
        dhus-right           \
        dhus-scihub          \
        dhus-security        \
        dhus-solr            \
        dhus-tomcat          \
        dhus-war             \
        addons               \
        core                 \
        distribution         \
        parent               \
        releaseNotes" \
    -f -- $OLD_RANGE..master

# The last commit deletes all files, delete that commit
git reset HEAD^ --hard

# Clean-up
git gc --prune=now

cd ..
