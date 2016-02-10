spool step21_monitor_standby_apply.log

--On Primary
set lines 180
set pages 100
select DATABASE_ROLE,PROTECTION_MODE,SWITCHOVER_STATUS,CURRENT_SCN from v$database;
SELECT SEQUENCE#, FIRST_TIME, NEXT_TIME FROM V$ARCHIVED_LOG ORDER BY SEQUENCE#;
SELECT STATUS,PROCESS FROM V$MANAGED_STANDBY;
SELECT SEQUENCE#,APPLIED FROM V$ARCHIVED_LOG ORDER BY SEQUENCE#;
archive log list
select timestamp, message from v$dataguard_status;

--On Standby
set lines 180
set pages 100
select DATABASE_ROLE,PROTECTION_MODE,SWITCHOVER_STATUS,CURRENT_SCN from v$database;
SELECT SEQUENCE#, FIRST_TIME, NEXT_TIME FROM V$ARCHIVED_LOG ORDER BY SEQUENCE#;
SELECT STATUS,PROCESS FROM V$MANAGED_STANDBY;
SELECT SEQUENCE#,APPLIED FROM V$ARCHIVED_LOG ORDER BY SEQUENCE#;
archive log list
select timestamp, message from v$dataguard_status;

--Verify Standby Database 

--On Primary
ALTER SYSTEM ARCHIVE LOG CURRENT;

archive log list

--On Standby

SELECT sequence#, first_time, next_time, applied FROM v$archived_log ORDER BY sequence#;
archive log list




