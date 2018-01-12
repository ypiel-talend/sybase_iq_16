# start server and then create a database
source /opt/sybase/iq16/SYBASE.sh
export PATH=$PATH:/opt/sybase/iq16/IQ-16_0/bin64/

cd /var/sybase/IQ1

start_iq -n IQ1

echo "* CREATE DB"
cat > /tmp/create_db.sql << EOF_createdb
create database 'IQ1.db'
transaction log on 'IQ1.log'
mirror 'IQ1.mirror'
message path 'IQ1.iqmsg'
iq path '/var/sybase/IQ1/iq_files/IQ1_01.iq'
iq size 1000
iq reserve 1000
temporary path '/var/sybase/IQ1/iq_files/IQ1_01.iqtmp'
temporary size 512
temporary reserve 512
dba user 'tuj'
dba password 'tuj'
EOF_createdb
dbisql -c "uid=DBA;pwd=sql;database=utility_db" -d1 -host 127.0.0.1 -onerror exit -nogui /tmp/create_db.sql 

echo "* STOP ENGINE"
cat > /tmp/stop_engine.sql << EOF_stop
stop engine
EOF_stop
dbisql -c "uid=DBA;pwd=sql;database=utility_db" -d1 -host 127.0.0.1 -onerror exit -nogui /tmp/stop_engine.sql

echo "* GEN PARAMS"
cat > /var/sybase/IQ1/params.cfg << EOF_params
-n IQ1
-iqmc 256
-iqtc 600
EOF_params

cd /var/sybase/IQ1
start_iq @./params.cfg ./IQ1.db

echo "* CONFIGURE DB"
cat > /tmp/dbspace.sql << EOF_dbspace
create dbspace user_main
using file user_main_01 'iq_files/user_main_01.iq'
size 512 MB
reserve 512 MB
iq store;
EOF_dbspace
dbisql -c "uid=tuj;pwd=tuj;database=IQ1" -d1 -host 127.0.0.1 -onerror exit -nogui /tmp/dbspace.sql

echo "* CREATE USER"
cat > /tmp/createuser.sql << EOF_createuser
create user tujuser identified by 'tujuser';
grant create any object to tujuser;
grant READCLIENTFILE to tujuser
set option tujuser.allow_read_client_file=on;
commit
EOF_createuser
dbisql -c "uid=tuj;pwd=tuj;database=IQ1" -d1 -host 127.0.0.1 -onerror exit -nogui /tmp/createuser.sql
