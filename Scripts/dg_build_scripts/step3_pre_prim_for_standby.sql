spool step3_pre_prim_for_standby.log

alter system set standby_file_management='AUTO' scope=both;
alter system set fal_server='IGAPRODSB' scope=both;
alter system set fal_client='IGAPROD' scope=both;
alter system set LOG_ARCHIVE_DEST_1='LOCATION= +RECO_ODEVX2 VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=IGAPROD' scope=both; 
alter system set log_archive_config='DG_CONFIG=(IGAPROD,IGAPRODSB)' scope=both;
alter system set  LOG_ARCHIVE_DEST_2='SERVICE=IGAPRODSB LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=IGAPRODSB NOAFFIRM NET_TIMEOUT=30 REOPEN=30 max_failure=0 max_connections=1' scope=both;
alter system set  LOG_ARCHIVE_DEST_STATE_1=ENABLE scope=both;
alter system set  LOG_ARCHIVE_DEST_STATE_2=ENABLE scope=both;

spool off
