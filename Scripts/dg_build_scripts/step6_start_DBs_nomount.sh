#!//bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export ORACLE_SID=DGEPRODSB
export PATH=$ORACLE_HOME/bin:$PATH

sqlplus -s "/ as sysdba" < EOF
startup nomount pfile=$ORACLE_HOME/dbs/init$ORACLE_SID.ora
EOF

export ORACLE_SID=OAGPRODSB

sqlplus -s "/ as sysdba" < EOF
startup nomount pfile=$ORACLE_HOME/dbs/init$ORACLE_SID.ora
EOF

export ORACLE_SID=IGAPRODSB

sqlplus -s "/ as sysdba" < EOF
startup nomount pfile=$ORACLE_HOME/dbs/init$ORACLE_SID.ora
EOF
