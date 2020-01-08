#!/bin/bash

set -e

echo "I'm running on "`hostname -f`
echo "OSG site: $OSG_SITE_NAME"

module load stashcache

echo
echo

stashcp -d stash:///osgconnect/public/rynge/test.data test.data

