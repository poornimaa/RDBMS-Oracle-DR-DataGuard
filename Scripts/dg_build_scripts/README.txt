/*Purpose: Data Guard Build
Author: Sudheer Kondla
Date: 08/15/2014
Details: This document illustrates steps involved in building data guard. These steps must be executed as sysdba
*/

STEP 1: On Primary Enable Force logging
STEP 2: On Primary Create Standby Redo Logs
STEP 3: On Primary and Standby Adjust/Add/Modify database network configuration (listener.ora, tnsnames.ora, sqlnet.ora) for connectivity and bounce the listeners.
STEP 4: From Primary $ORACLE_HOME/dbs directory ftp the password file to standby site $ORACLE_HOME/dbs
STEP 5: Prepare init parameters file to bring standby in nomount.
STEP 6: Start standby database using pfile @$ORACLE_HOME/dbs in NOMOUNT state.
STEP 7: check the tnsping
STEP 8: Check the Connectivity with sys password using TNS String.
STEP 9: On primary - prepare primary database for standby configuration. 
STEP 10: Check rman connectivity to primary and standby using sys password and tns string. And optinally connect to catalog DB.
STEP 11: -PLAN A: Prep rman restore script(s) and execute to restore standby from primary (from active database)
STEP 12: -PLAN B: RMAN level0 backup for duplicate standby database
STEP 13: -PLAN B: Prep rman restore script(s) and execute to restore standby from RMAN backup.
STEP 14: Enable Media Recovery (log shipping & log apply)
STEP 15: Add SRLs to standby instances
STEP 16: Check Data Guard Status
STEP 17: Monitor Log Shipping & Redo Apply
STEP 18: Update init parameters for Converting Standby database to RAC cluster database.
STEP 19: Register standby database with Cluster Registry.
