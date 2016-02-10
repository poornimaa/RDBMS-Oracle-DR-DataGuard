#!//bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
LOGDIR=~/step19_register_with_ocr_DGEPRODSB.log

export ORACLE_SID=DGEPRODSB

#Add the entry in /etc/oratab.
#Node1
ssh odevx3db01
echo "DGEPRODSB:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
echo "DGEPRODSB1:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
#Node2
ssh odevx3db02
echo "DGEPRODSB:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
echo "DGEPRODSB2:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab

#Create a pfile under dbs pointing to SPFILE on ASM disk group.
#Node1
ssh odevx3db01
cd /u01/app/oracle/product/11.2.0.3/dbhome_1/dbs
cp initDGEPRODSB.ora initDGEPRODSB1.ora
mv initDGEPRODSB1.ora initDGEPRODSB1.ora.org
echo "SPFILE='+DATA_ODEVX3/DGEPRODSB/PARAMETERFILE/spfileDGEPRODSB.ora'" > initDGEPRODSB1.ora
scp initDGEPRODSB1.ora odevx3db02:/u01/app/oracle/product/11.2.0.3/dbhome_1/dbs/initDGEPRODSB2.ora

#Node2
ssh odevx3db02
cd /u01/app/oracle/product/11.2.0.3/dbhome_1/dbs
cp initDGEPRODSB.ora initDGEPRODSB2.ora
mv initDGEPRODSB2.ora initDGEPRODSB2.ora.org
echo "SPFILE='+DATA_ODEVX3/DGEPRODSB/PARAMETERFILE/spfileDGEPRODSB.ora'" > initDGEPRODSB2.ora

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
export ORACLE_SID=DGEPROD
sqlplus -s "/ as sysdba" << EOF
alter system set log_archive_dest_state_2='defer' scope=both;
exit
EOF


export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=DGEPRODSB

#Add Database and Database Instances to OCR.

srvctl add database -d DGEPRODSB -o /u01/app/oracle/product/11.2.0.3/dbhome_1 -p '+DATA_ODEVX3/DGEPRODSB/PARAMETERFILE/spfileDGEPRODSB.ora' -r PHYSICAL_STANDBY –n DGEPROD
srvctl modify database -d DGEPRODSB -a "DATA_ODEVX3,RECO_ODEVX3"
srvctl modify database -d DGEPRODSB -s MOUNT
srvctl add instance -d DGEPRODSB -i DGEPRODSB1 -n ODEVX3DB01
srvctl add instance -d DGEPRODSB -i DGEPRODSB2 -n ODEVX3DB02
srvctl config database -d DGEPRODSB
srvctl start database -d DGEPRODSB
srvctl status database -d DGEPRODSB

#Enable log shipping

ssh odevx2db01
export ORACLE_SID=DGEPROD
sqlplus -s "/ as sysdba" << EOF
alter system set log_archive_dest_state_2='enable' scope=both;
exit
EOF

