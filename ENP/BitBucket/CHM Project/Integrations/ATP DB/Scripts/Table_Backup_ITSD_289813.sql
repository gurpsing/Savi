--Create a backUp table

Create table CHM_INTEGRATION_RUNS_BKP_201124
as select * from CHM_INTEGRATION_RUNS;
/
drop table CHM_INTEGRATION_RUNS;
/
commit;
