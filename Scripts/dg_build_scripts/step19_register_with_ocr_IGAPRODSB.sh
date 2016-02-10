#!//bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
LOGDIR=~/step19_register_with_ocr_IGAPRODSB.log

export ORACLE_SID=IGAPRODSB

#Add the entry in /etc/oratab.
#Node1
ssh odevx3db01
echo "IGAPRODSB:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
echo "IGAPRODSB1:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
#Node2
ssh odevx3db02
echo "IGAPRODSB:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab
echo "IGAPRODSB2:/u01/app/oracle/product/11.2.0.3/dbhome_1:N" >> /etc/oratab

#Create a pfile under dbs pointing to SPFILE on ASM disk group.
#Node1
ssh odevx3db01
cd /u01/app/oracle/product/11.2.0.3/dbhome_1/dbs
cp initIGAPRODSB.ora initIGAPRODSB1.ora
mv initIGAPRODSB1.ora initIGAPRODSB1.ora.org
echo "SPFILE='+DATA_ODEVX3/IGAPRODSB/PARAMETERFILE/spfileIGAPRODSB.ora'" > initIGAPRODSB1.ora
scp initIGAPRODSB1.ora odevx3db02:/u01/app/oracle/product/11.2.0.3/dbhome_1/dbs/initIGAPRODSB2.ora

#Node2
ssh odevx3db02
cd /u01/app/oracle/product/11.2.0.3/dbhome_1/dbs
cp initIGAPRODSB.ora initIGAPRODSB2.ora
mv initIGAPRODSB2.ora initIGAPRODSB2.ora.org
echo "SPFILE='+DATA_ODEVX3/IGAPRODSB/PARAMETERFILE/spfileIGAPRODSB.ora'" > initIGAPRODSB2.ora

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
export ORACLE_SID=IGAPROD
sqlplus -s "/ as sysdba" << EOF
alter system set log_archive_dest_state_2='defer' scope=both;
exit
EOF


export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=IGAPRODSB

#Add Database and Database Instances to OCR.

srvctl add database -d IGAPRODSB -o /u01/app/oracle/product/11.2.0.3/dbhome_1 -p '+DATA_ODEVX3/IGAPRODSB/PARAMETERFILE/spfileIGAPRODSB.ora' -r PHYSICAL_STANDBY –n IGAPROD
srvctl modify database -d IGAPRODSB -a "DATA_ODEVX3,RECO_ODEVX3"
srvctl modify database -d IGAPRODSB -s MOUNT
srvctl add instance -d IGAPRODSB -i IGAPRODSB1 -n ODEVX3DB01
srvctl add instance -d IGAPRODSB -i IGAPRODSB2 -n ODEVX3DB02
srvctl config database -d IGAPRODSB
srvctl start database -d IGAPRODSB
srvctl status database -d IGAPRODSB

ssh odevx2db01
export ORACLE_SID=IGAPROD
sqlplus -s "/ as sysdba" << EOF
alter system set log_archive_dest_state_2='enable' scope=both;
exit
EOF

#Check Redo shipping and apply status on Primary & Standby:


