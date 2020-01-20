#!/bin/bash

set -e

echo "I'm running on "`hostname -f`
echo "OSG site: $OSG_SITE_NAME"

module load stashcache

echo
echo

rm -f test.data
stashcp -d stash:///osgconnect/public/rynge/test.data test.data

echo
echo

rm -f test.data
stashcp -d --methods=xrootd stash:///osgconnect/public/rynge/test.data test.data

echo
echo

rm -f test.data
stashcp -d --methods=http stash:///osgconnect/public/rynge/test.data test.data

rm -f test.data
