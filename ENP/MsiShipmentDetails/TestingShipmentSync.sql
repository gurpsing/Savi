select * from chm_integration_runs 
where CHM_INTEGRATION_RUN_ID='vId1ZCu-EfCMUS88KW0Sag';


select * from chm_integration_runs 
where CHM_INTEGRATION_RUN_ID='aKfiKyyUEfCMUS88KW0Sag';

select * from CHM_MSI_SHIP_DETAILS_TBL;

select count(*) from CHM_MSI_SHIP_DETAILS_TBL;

select serial_number from CHM_MSI_SHIP_DETAILS_TBL group by serial_number having count(*)>1;


select * from chm_msi_spa_distributor;

select * from CHM_MSI_SPA_HEADER
where SPA_NUMBER='Q-00065059';


select ORACLE_AP_INTERFACE_STATUS,LOAD_REQUEST_ID,	LOAD_REQUEST_STATUS,	IMPORT_REQUEST_ID,	IMPORT_REQUEST_STATUS,
OIC_INSTANCE_ID,	BU_NAME,	SUPPLIER_NUMBER,	SUPPLIER_NAME,	SUPPLIER_SITE,	
REJECTION_REASON,	IMPORT_SET,	PAYMENT_TERM
from CHM_MSI_CLAIM_AP_INVOICE_HEADER
where ORACLE_AP_INTERFACE_STATUS in ('NEW','REJECTED');

