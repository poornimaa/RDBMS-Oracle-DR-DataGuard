#!//bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
LOGDIR=~/step19_register_with_ocr_OAGPRODSB.log

export ORACLE_SID=OAGPRODSB

#Add the entry in /etc/oratab.
#Node1
ssh odevx3db01
echo "OAGPRODSB:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
echo "OAGPRODSB1:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
#Node2
ssh odevx3db02
echo "OAGPRODSB:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
echo "OAGPRODSB2:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab

#Create a pfile under dbs pointing to SPFILE on ASM disk group.
#Node1
ssh odevx3db01
cd /u01/app/oracle/product/11.2.0.3/dbhome_1/dbs
cp initOAGPRODSB.ora initOAGPRODSB1.ora
mv initOAGPRODSB1.ora initOAGPRODSB1.ora.org
echo "SPFILE='+DATA_ODEVX3/OAGPRODSB/PARAMETERFILE/spfileOAGPRODSB.ora'" > initOAGPRODSB1.ora
scp initOAGPRODSB1.ora odevx3db02:/u01/app/oracle/product/11.2.0.3/dbhome_1/dbs/initOAGPRODSB2.ora

#Node2
ssh odevx3db02
cd /u01/app/oracle/product/11.2.0.3/dbhome_1/dbs
cp initOAGPRODSB.ora initOAGPRODSB2.ora
mv initOAGPRODSB2.ora initOAGPRODSB2.ora.org
echo "SPFILE='+DATA_ODEVX3/OAGPRODSB/PARAMETERFILE/spfileOAGPRODSB.ora'" > initOAGPRODSB2.ora

#Bring up instances with SPFILE 
sqlplus -s "/ as sysdba" << EOF
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
shutdown immediate
startup mount
select INSTANCE_NUMBER,INSTANCE_NAME,HOST_NAME,THREAD#,STATUS from gv$instance;
exit
EOF

#on Primary Stop the Log Shipping temporarily.

ssh odevx2db01
export ORACLE_SID=OAGPROD
sqlplus -s "/ as sysdba" << EOF
alter system set log_archive_dest_state_2='defer' scope=both;
exit
EOF


export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=OAGPRODSB

#Add Database and Database Instances to OCR.

srvctl add database -d OAGPRODSB -o /u01/app/oracle/product/11.2.0.3/dbhome_1 -p '+DATA_ODEVX3/OAGPRODSB/PARAMETERFILE/spfileOAGPRODSB.ora' -r PHYSICAL_STANDBY –n OAGPROD
srvctl modify database -d OAGPRODSB -a "DATA_ODEVX3,RECO_ODEVX3"
srvctl modify database -d OAGPRODSB -s MOUNT
srvctl add instance -d OAGPRODSB -i OAGPRODSB1 -n ODEVX3DB01
srvctl add instance -d OAGPRODSB -i OAGPRODSB2 -n ODEVX3DB02
srvctl config database -d OAGPRODSB
srvctl start database -d OAGPRODSB
srvctl status database -d OAGPRODSB

ssh odevx2db01
export ORACLE_SID=OAGPROD
sqlplus -s "/ as sysdba" << EOF
alter system set log_archive_dest_state_2='enable' scope=both;
exit
EOF

