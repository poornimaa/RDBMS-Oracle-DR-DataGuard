#!/bin/bash
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3/dbhome_1

echo "DATE: `date`" > step7_check_tnsping.log
echo "------------------------------------"
echo "Checking tnsping for all databases ....."

echo "DATABASE_NAME: DGEPRODSB" >> step7_check_tnsping.log
/u01/app/oracle/product/11.2.0.3/dbhome_1/bin/tnsping DGEPRODSB >> step7_check_tnsping.log
echo "DATABASE_NAME: OAGPRODSB" >> step7_check_tnsping.log
/u01/app/oracle/product/11.2.0.3/dbhome_1/bin/tnsping OAGPRODSB >> step7_check_tnsping.log
echo "DATABASE_NAME: IGAPRODSB" >> step7_check_tnsping.log
/u01/app/oracle/product/11.2.0.3/dbhome_1/bin/tnsping IGAPRODSB >> step7_check_tnsping.log
