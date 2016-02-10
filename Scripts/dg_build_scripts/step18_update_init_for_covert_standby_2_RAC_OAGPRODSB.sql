
--Update Standby Parameters

alter system set local_listener='(DESCRIPTION = (ADDRESS=(PROTOCOL=TCP)(HOST=odevx3db01-vip)(PORT=1521)) (ADDRESS=(PROTOCOL=TCP)(HOST=10.10.127.12)(PORT=1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME =  OAGPRODSB) (UR=A)))' sid='OAGPRODSB1' scope=both;

alter system set local_listener='(DESCRIPTION = (ADDRESS=(PROTOCOL=TCP)(HOST=odevx3db02-vip)(PORT=1521)) (ADDRESS=(PROTOCOL=TCP)(HOST=10.10.127.13)(PORT=1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = OAGPRODSB) (UR=A)))' sid='OAGPRODSB2' scope=both;

alter system set cluster_database=TRUE sid='*' scope=spfile;
alter system set instance_number=1 sid='OAGPRODSB1' scope=spfile;
alter system set instance_number=2 sid='OAGPRODSB2' scope=spfile;
ALTER SYSTEM SET undo_tablespace='APPS_UNDOTS1' SID='OAGPRODSB1' SCOPE=SPFILE;

create undo tablespace APPS_UNDOTS2 datafile '+DATA_ODEVX3' size 2048M autoextend on;  
 --This step should be carried out after standby become primary and opened

ALTER SYSTEM SET undo_tablespace='APPS_UNDOTS2' SID='OAGPRODSB2' SCOPE=SPFILE;
--This step may be carried out after standby become primary and opened and 
--APPS_UNDOTS2 is created.

alter system set thread=1  sid='OAGPRODSB1' scope=spfile;
alter system set thread=2  sid='OAGPRODSB2' scope=spfile;
alter system set diagnostic_dest='/u01/app/oracle' sid='*' scope=both;
alter system set  LOG_ARCHIVE_DEST_2='SERVICE=OAGPROD LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OAGPROD NOAFFIRM NET_TIMEOUT=30 REOPEN=30 max_failure=0 max_connections=1' sid ='*' scope=both;
alter system set  LOG_ARCHIVE_DEST_STATE_1=ENABLE sid ='*' scope=both;
alter system set  LOG_ARCHIVE_DEST_STATE_2=ENABLE sid ='*' scope=both;
alter system set fal_client='OAGPRODSB' sid ='*' scope=both;
alter system set fal_server='OAGPROD' sid ='*' scope=both;
