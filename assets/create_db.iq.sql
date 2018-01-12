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
