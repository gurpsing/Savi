--Insert Data into Table
insert into CHM_INTEGRATION_RUNS
select * from CHM_INTEGRATION_RUNS_BKP_201124;
/
commit;
/
