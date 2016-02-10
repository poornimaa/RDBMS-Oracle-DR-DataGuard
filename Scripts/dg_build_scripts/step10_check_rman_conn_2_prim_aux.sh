#!/bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

LOGFILE=~/rman_conn_check.log
echo "Date: `date`" > $LOGFILE

export ORACLE_SID=DGEPRODSB
rman target sys/password@DGEPROD auxiliary sys/password@DGEPRODSB  catalog rman/password@oemr1 << EOF >> $LOGFILE
show all;
exit
EOF

export ORACLE_SID=OAGPRODSB
rman target sys/password@OAGPROD auxiliary sys/password@OAGPRODSB  catalog rman/password@oemr1 << EOF >> $LOGFILE
show all;
exit
EOF

export ORACLE_SID=IGAPRODSB
rman target sys/password@DGEPROD auxiliary sys/password@DGEPRODSB  catalog rman/password@oemr1 << EOF >> $LOGFILE
show all;
exit
EOF
