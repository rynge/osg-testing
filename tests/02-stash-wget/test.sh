#!/bin/bash

set -e

echo "I'm running on "`hostname -f`
echo "OSG site: $OSG_SITE_NAME"

echo
echo

# http
wget -nv http://stash.osgconnect.net/public/rynge/test.data

# https
wget -nv https://stash.osgconnect.net/public/rynge/test.data

