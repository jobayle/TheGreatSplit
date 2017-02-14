#!/bin/sh

# Create a repository for the DHuS module: Core

# Prepare environment
git clone --no-local dhus core && cd core

# Edit history
# We want to keep the following directories, everything else must be removed
# /dhus-core
# /dhus-odata
# /dhus-hibernate
# /dhus-solr
# /dhus-tomcat
# /dhus-parent
# /liquibase-logs
# Add LICENSE file if not there
# 
git filter-branch --prune-empty --index-filter \
    "git rm -r --cached --ignore-unmatch \
        dhus-api             \
        dhus-distributions   \
        dhus-gui             \
        dhus-gui-admin       \
        dhus-gui-user        \
        dhus-hsqldb          \
        dhus-hsqldb-server   \
        dhus-jetty           \
        dhus-new             \
        dhus-packager        \
        dhus-right           \
        dhus-scihub          \
        dhus-security        \
        dhus-war             \
        addon                \
        client               \
        distribution         \
        parent               \
        releaseNotes         \
        pom.xml;             \
    cp -n ${BASEDIR}/LICENSE .; git add LICENSE" \
    --tag-name-filter cat \
    -f -- --all

# Fix pom.xml
# TODO

# Clean-up
git gc --prune=now

cd ..
