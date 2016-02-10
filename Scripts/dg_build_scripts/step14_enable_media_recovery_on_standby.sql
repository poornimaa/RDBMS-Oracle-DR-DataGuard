spool step14_enable_media_recovery_on_standby.log

set lines 180
set pages 100

select name, database_role from v$database;
alter database recover managed standby database disconnect;
--For Real Time Apply
--alter database recover managed standby database using current logfile disconnect;
spool off
