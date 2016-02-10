#!/bin/bash
scp $ORACLE_HOME/dbs/orapwDGEPROD odevx3db01:$ORACLE_HOME/dbs/orapwDGEPRODSB
scp $ORACLE_HOME/dbs/orapwDGEPROD odevx3db02:$ORACLE_HOME/dbs/orapwDGEPRODSB

scp $ORACLE_HOME/dbs/orapwOAGPROD odevx3db01:$ORACLE_HOME/dbs/orapwOAGPRODSB
scp $ORACLE_HOME/dbs/orapwOAGPROD odevx3db02:$ORACLE_HOME/dbs/orapwOAGPRODSB

scp $ORACLE_HOME/dbs/orapwIGAPROD odevx3db01:$ORACLE_HOME/dbs/orapwIGAPRODSB
scp $ORACLE_HOME/dbs/orapwIGAPROD odevx3db02:$ORACLE_HOME/dbs/orapwIGAPRODSB
