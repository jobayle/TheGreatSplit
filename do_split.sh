#!/bin/sh

# Prepare environment

# Clone the DHuS with all artifacts (branches, tags, ...)
if [ ! -d dhus ]
then 
    git clone --mirror git@github.com:SercoSPA/DHuS.git dhus
else
    if [ -d dhus/refs ]
    then
        echo "dhus repo already cloned"
    else
        echo "invalid dhus/ dir: not a git repo"
        exit 1
    fi
fi

# grab the license from remote HEAD
if [ ! -f LICENSE ]
then
    git clone dhus tmp
    cp tmp/LICENSE .
    rm -rf tmp
fi

# BASEDIR points to the basedir of the LICENSE file
export BASEDIR=${PWD}

# Extract history of GWT client
./split_gwt_client.sh

unset BASEDIR

