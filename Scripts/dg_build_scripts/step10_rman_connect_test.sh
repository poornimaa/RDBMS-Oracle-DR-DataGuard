#!//bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1


export ORACLE_SID=DGEPRODSB
export PATH=$ORACLE_HOME/bin:$PATH
LOGDIR=~/dgbuild/scripts/step10_rman_connect_test.log

echo "Date: `date`" > $LOGDIR

echo "DATABASE_NAME: $ORACLE_SID" >> $LOGDIR

rman target sys/password@DGEPROD auxiliary sys/password@DGEPRODSB  catalog rman/password@oemr1 << EOF >> $LOGDIR
show all;
exit
EOF


export ORACLE_SID=OAGPRODSB
echo "DATABASE_NAME: $ORACLE_SID" >> $LOGDIR

rman target sys/password@OAGPROD auxiliary sys/password@OAGPRODSB  catalog rman/password@oemr1 << EOF >> $LOGDIR
show all;
exit
EOF
export ORACLE_SID=IGAPRODSB
echo "DATABASE_NAME: $ORACLE_SID"

rman target sys/password@IGAPROD auxiliary sys/password@IGAPRODSB  catalog rman/password@oemr1 << EOF >> $LOGDIR
show all;
exit
EOF
