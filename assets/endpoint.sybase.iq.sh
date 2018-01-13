#!/bin/bash

# start server and then create a database
source /opt/sybase/iq16/SYBASE.sh
#export PATH=$PATH:/opt/sybase/iq16/IQ-16_0/bin64/
#cd /var/sybase/IQ1
start_iq @./params.cfg ./IQ1.db

while true; do sleep 10000; done
