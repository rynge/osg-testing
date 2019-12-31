#!/bin/bash

set -e

echo "I'm running on "`hostname -f`
echo "OSG site: $OSG_SITE_NAME"

echo
echo

stashcp -debug stash://osgconnect/rynge/test.data test.data

