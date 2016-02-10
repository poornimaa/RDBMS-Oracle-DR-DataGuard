spool step20_setup_adg.log

set lines 180
set pages 100
col instance_name for a30
col status for a15

--On Primary
select status,instance_name,database_role from v$instance,v$database;
--On Standby
select status,instance_name,database_role from v$database,v$instance;

--Check if MRP is active on Standby
--On Standby
select process,status,sequence# from v$managed_standby;

--Cencel MRP on Standby
--On StandBy

alter database recover managed standby database cancel;
ALTER DATABASE OPEN READ ONLY;

select status,instance_name,database_role,open_mode from v$database,v$instance;

alter database recover managed standby database disconnect from session;

--OR
alter database recover managed standby database using current logfile disconnect;-- (FOR REAL TIME APPLY)





