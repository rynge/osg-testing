#!/bin/bash

set -e

echo "I'm running on "`hostname -f`
echo "OSG site: $OSG_SITE_NAME"

echo
echo

module load stashcache

dd if=/dev/urandom of=file.txt count=1048576 bs=1024
time stashcp --debug file.txt stash:///osgconnect/rynge/osg-testing/write-test-${1}.txt



