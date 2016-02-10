#!//bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
LOGDIR=~/step16_check_dg_status.log

export ORACLE_SID=DGEPRODSB
echo "Date: `date`" > $LOGDIR

sqlplus -s "/ as sysdba" << EOF >> $LOGDIR
set lines 180
set pages 100
col severity for a20
col message for a80
select severity,error_code,message,timestamp from v$dataguard_status where dest_id=2;
exit
EOF

export ORACLE_SID=OAGPRODSB

sqlplus -s "/ as sysdba" << EOF >> $LOGDIR
set lines 180
set pages 100
col severity for a20
col message for a80
select severity,error_code,message,timestamp from v$dataguard_status where dest_id=2;
exit
EOF

export ORACLE_SID=IGAPRODSB

sqlplus -s "/ as sysdba" << EOF >> $LOGDIR
set lines 180
set pages 100
col severity for a20
col message for a80
select severity,error_code,message,timestamp from v$dataguard_status where dest_id=2;
exit
EOF
