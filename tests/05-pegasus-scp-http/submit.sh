#!/bin/bash

set -e

# refresh the checkout every so often
find . -maxdepth 1 -name tutorial-pegasus -cmin +2

# time for a new checkout?
if [ ! -e tutorial-pegasus ]; then
    git clone https://github.com/OSGConnect/tutorial-pegasus.git
fi

cd tutorial-pegasus/wordfreq

# change the site catalog to scp/http
cat >sites.xml.template <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<sitecatalog xmlns="http://pegasus.isi.edu/schema/sitecatalog" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://pegasus.isi.edu/schema/sitecatalog http://pegasus.isi.edu/schema/sc-4.0.xsd" version="4.0">

    <site  handle="local" arch="x86_64">
        <directory type="shared-scratch" path="\$WORK_DIR/scratch">
            <file-server operation="all" url="file://\$WORK_DIR/scratch"/>
        </directory>
        <directory type="local-storage" path="\$WORK_DIR/outputs">
            <file-server operation="all" url="file://\$WORK_DIR/outputs"/>
        </directory>
        <profile namespace="env" key="PATH">\$PATH</profile>
        <profile namespace="pegasus" key="SSH_PRIVATE_KEY" >\$HOME/.ssh/workflow</profile>
    </site>

    <!-- this is our staging site, where intermediate data will be stored -->
    <site  handle="stash" arch="x86_64" os="LINUX">
        <directory type="shared-scratch" path="/public/\$USER/staging">
            <file-server operation="put" url="scp://\$USER@\$HOSTNAME:/public/\$USER/staging"/>
            <file-server operation="get" url="http://stash.osgconnect.net/public/\$USER/staging"/>
        </directory>
    </site>

    <!-- this is our execution site -->
    <site  handle="condorpool" arch="x86_64" os="LINUX">
        <profile namespace="pegasus" key="style" >condor</profile>
        <profile namespace="condor" key="universe" >vanilla</profile>
        <profile namespace="condor" key="requirements" >OSGVO_OS_STRING == "RHEL 7" &amp;&amp; HAS_MODULES == True &amp;&amp; GLIDEIN_Site =!= "OSG_US_ASU_DEL"</profile>
        <profile namespace="condor" key="request_cpus" >1</profile>
        <profile namespace="condor" key="request_memory" >1 GB</profile>
        <profile namespace="condor" key="request_disk" >1 GB</profile>
        <profile namespace="condor" key="+WantsStashCache" >True</profile>
    </site>

</sitecatalog>
EOF

# fix the WORK_DIR
perl -p -i -e 's/^export WORK_DIR.*/export WORK_DIR=\$PWD\/work/' submit

# now submit
./submit


