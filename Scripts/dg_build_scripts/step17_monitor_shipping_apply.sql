spool step17_monitor_shipping_apply.log

set lines 180
set pages 100

--On Primary

col instance_name for a30
col host_name for a30
col CURRENT_SCN for 999999999999999


select instance_name,host_name from v$instance;
archive log list
select DATABASE_ROLE,PROTECTION_MODE,SWITCHOVER_STATUS,CURRENT_SCN from v$database;
SELECT STATUS,PROCESS FROM V$MANAGED_STANDBY;


