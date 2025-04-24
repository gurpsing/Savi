select count(*) from CHM_MSI_SUPPLIERS;

select * from CHM_MSI_SUPPLIERS where INSTALLER_NUMBER='0000950';

select * from CHM_MSI_CLAIM_AP_INVOICE_HEADER;

select * from CHM_MSI_CLAIM_AP_INVOICES;

select * from CHM_MSI_CLAIM_AP_INVOICE_HEADER
where ORACLE_AP_INTERFACE_STATUS = 'REJECTED' order by 1;

select distinct import_set from CHM_MSI_CLAIM_AP_INVOICE_HEADER
where ORACLE_AP_INTERFACE_STATUS = 'REJECTED' order by 1;


update CHM_MSI_CLAIM_AP_INVOICE_HEADER
set supplier_number=null, supplier_name=null,supplier_site=null
where ORACLE_AP_INTERFACE_STATUS = 'REJECTED' 
;

update CHM_MSI_CLAIM_AP_INVOICE_HEADER
set country='DE'
where ORACLE_AP_INVOICE_ID='9000013'
;

update CHM_MSI_CLAIM_AP_INVOICES
set country='DE'
where ORACLE_AP_INVOICE_ID='9000013'
;


UPDATE CHM_MSI_CLAIM_AP_INVOICES line
SET
    DIST_CODE_COMBINATION = NULL
WHERE OIC_INSTANCE_ID='HbvdoR8ZEfCLSs1BN-s8Vw'
;


select distinct import_set,bu_name from CHM_MSI_CLAIM_AP_INVOICE_HEADER   
where import_set is not null order by 1;


select to_char(inv.invoice_date,'YYYY/MM/DD') formatted_invoice_date,inv.* 
from CHM_MSI_CLAIM_AP_INVOICE_HEADER inv 
where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID AND IMPORT_SET = #P_IMPORT_SET
;

select seq,lookup_code,meaning,description,tag from chm_msi_ap_bu_name_lookup where lookup_code='US';

select * from CHM_MSI_CLAIM_AP_INVOICE_HEADER 
where ORACLE_AP_INTERFACE_STATUS = 'REJECTED' ;

select * from CHM_MSI_CLAIM_AP_INVOICES
where ORACLE_AP_INVOICE_ID=9000013;

select 
     hdr.ORACLE_AP_INVOICE_ID	
    ,hdr.ORACLE_AP_INVOICE_NUMBER	
    ,hdr.INVOICE_AMOUNT	
    ,hdr.INVOICE_CURRENCY
    ,hdr.COUNTRY
    ,hdr.ORACLE_AP_INTERFACE_STATUS
    ,hdr.BU_NAME	
    ,hdr.SUPPLIER_NUMBER	
    ,hdr.SUPPLIER_NAME	
    ,hdr.SUPPLIER_SITE
    ,hdr.REJECTION_REASON
    ,line.DIST_CODE_COMBINATION
from 
    CHM_MSI_CLAIM_AP_INVOICE_HEADER hdr
    ,CHM_MSI_CLAIM_AP_INVOICES line
where 1=1
AND hdr.ORACLE_AP_INVOICE_ID = line.ORACLE_AP_INVOICE_ID
AND hdr.ORACLE_AP_INVOICE_ID=9000013;
ORACLE_AP_INTERFACE_STATUS = 'REJECTED' ;

select * from CHM_MSI_CLAIM_AP_INVOICES
where ORACLE_AP_INVOICE_ID=9000013;

