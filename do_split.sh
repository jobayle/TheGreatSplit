#!/bin/bash

# Debug mode
# Print commands and their arguments as they are executed
set -x

# Prepare environment

# Clone the DHuS with all artifacts (branches, tags, ...)
if [ ! -d DHuS.git ]
then
    echo 'Clone a mirror of the DHuS ...'
    git clone --mirror git@github.com:SercoSPA/DHuS.git DHuS.git \
        || { echo 'git clone failed'; exit 1; }
else
    if [ -d DHuS.git/refs ]
    then
        echo "dhus mirror already cloned, fetch new refs from origin ..."
        cd DHuS.git
        git remote update --prune \
            || { echo 'git fetch origin failed'; exit 1; }
        cd ..
    else
        echo 'invalid dhus/ dir: not a git repo'
        exit 1
    fi
fi

# Donwload bfg.jar
if [ ! -e bfg.jar ]
then
    curl -o bfg.jar 'http://repo1.maven.org/maven2/com/madgag/bfg/1.12.14/bfg-1.12.14.jar' \
        || { echo 'curl failed to download bfg.jar' ; exit 1; }
fi

# Delete dhus/
if [ -e dhus ]
then
    echo "Delete $(file dhus)"
    rm -rf dhus || { echo 'could not delete dhus'; exit 1; }
fi

# is replacements.txt exists, run bfg.jar to remove password from DHuS.git
if [ -f replacements.txt ]
then
    git clone --mirror DHuS.git dhus
    echo 'Run BFG to remove passwords from replacements.txt, this will rewrite history of the mirror clone ...'
    java -jar bfg.jar --no-blob-protection --replace-text replacements.txt dhus \
        || { echo 'bfg.jar failed' ; exit 1; }
    git reflog expire --expire=now --all && git gc --prune=now --aggressive \
        || { echo 'post bfg.jar clean-up operation failed' ; exit 1; }
else
    ln -s DHuS.git dhus
fi

# grab the license from remote HEAD
if [ ! -f LICENSE ]
then
    git clone --depth 1 dhus tmp
    cp tmp/LICENSE .
    rm -rf tmp
fi

# BASEDIR points to the basedir of the LICENSE file
export BASEDIR=${PWD}

# Extract history of GWT client
. split_gwt_client.sh
# Extract history of Addons (/addon/*)
. split_addons.sh
# Extract history of JS GUIs
. split_js_guis.sh
# Extract history of CORE
. split_core.sh
# Extract history of Distributions
. split_distrib.sh

unset BASEDIR
