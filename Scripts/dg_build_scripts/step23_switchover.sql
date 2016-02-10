spool step23_switchover.log

set lines 180
set pages 100

--On Primary
select DATABASE_ROLE,PROTECTION_MODE,SWITCHOVER_STATUS,CURRENT_SCN from gv$database;
SELECT UNIQUE THREAD# AS THREAD, MAX(SEQUENCE#) OVER (PARTITION BY thread#) AS LAST from GV$ARCHIVED_LOG;
--on Standby
select DATABASE_ROLE,PROTECTION_MODE,SWITCHOVER_STATUS,CURRENT_SCN from gv$database;
SELECT UNIQUE THREAD# AS THREAD, MAX(SEQUENCE#) OVER (PARTITION BY thread#) AS LAST from GV$ARCHIVED_LOG;

--On Primary Switch log File
-- This is last archivelog switch after apps are down or stopped transactions
ALTER SYSTEM SWITCH LOGFILE;  

--On StandBy Stop Apply
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

--On Standby Finish applying all received redo data:

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE FINISH;

--##shutdown Source (current Primary) . This is to make sure no role transition to happen.

--On Standby:

ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY WITH SESSION SHUTDOWN;

--Open new primary (Old Standby)

ALTER DATABASE OPEN;

--Check Database Role on new Primary.

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';
select DATABASE_ROLE,PROTECTION_MODE,SWITCHOVER_STATUS,CURRENT_SCN from v$database;





