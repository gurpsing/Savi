462842071671

select * from CHM_MSI_SPA_UNIT_ACTIVATIONS;

select * from CHM_MSI_SPA_SYSTEM_ATTACHMENTS;

select * from CHM_MSI_SYS_SIZE_INCENTIVE;

select * from CHM_MSI_SYS_SIZE_INCENTIVE_CHM;

select * from CHM_INTEGRATION_RUNS 
where CHM_INTEGRATION_RUN_ID = '4M3EvRp2EfCLSs1BN-s8Vw';



TRUNCATE TABLE CHM_MSI_SPA_UNIT_ACTIVATIONS;
TRUNCATE TABLE CHM_MSI_SPA_SYSTEM_ATTACHMENTS;
TRUNCATE TABLE CHM_MSI_SYS_SIZE_INCENTIVE;
TRUNCATE TABLE CHM_MSI_SYS_SIZE_INCENTIVE_CHM;



TRUNCATE TABLE CHM_MSI_SPA_DISTRIBUTOR;
TRUNCATE TABLE CHM_MSI_SPA_INSTALLERS;
TRUNCATE TABLE CHM_MSI_SPA_GEO_DETAILS;

TRUNCATE TABLE CHM_MSI_SPA_HEADER;



SELECT * FROM CHM_MSI_SPA_UNIT_ACTIVATIONS;
SELECT * FROM CHM_MSI_SPA_SYSTEM_ATTACHMENTS;
SELECT * FROM CHM_MSI_SYS_SIZE_INCENTIVE;
SELECT * FROM CHM_MSI_SYS_SIZE_INCENTIVE_CHM;


2025-01-01T00:00:00.000Z

SELECT * FROM CHM_MSI_SPA_DISTRIBUTOR;
SELECT * FROM CHM_MSI_SPA_INSTALLERS;
SELECT * FROM CHM_MSI_SPA_GEO_DETAILS;


SELECT * FROM CHM_MSI_SPA_HEADER;


ALTER TRIGGER AIU_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL_TRG DISABLE;
ALTER TRIGGER BIU_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL_TRG DISABLE;






SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,SPA__c  ,Min_Qty__c  ,Max_Qty__c  ,Tier_Incentive__c  ,Product__c  ,Tier_Name__c ,CreatedBy.Name,LastModifiedBy.Name ,System_Size_Incentive__c,Status__c, Approved_Date__c  FROM SPA_MSI_System_Size_for_CHM__c  WHERE lastmodifieddate >= &LastModifiedDate AND Status__c IN ('Approved')



Select Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, SPA__c, Min_Qty__c, Max_Qty__c, Tier_Incentive__c, Product__c, Tier_Name__c, System_Size_Incentive__c, Status__c, Approved_Date__c from SPA_MSI_System_Size_for_CHM__c where Status__c = 'Approved'




--Header
SELECT ORACLE_AP_INVOICE_ID, ORACLE_AP_INVOICE_NUMBER, LOAD_REQUEST_ID,LOAD_REQUEST_STATUS,IMPORT_REQUEST_ID,IMPORT_REQUEST_STATUS,OIC_INSTANCE_ID from CHM_MSI_CLAIM_AP_INVOICE_HEADER
where LOAD_REQUEST_ID = #P_LOAD_REQUEST_ID


--Lines 
SELECT ORACLE_AP_INVOICE_ID, ORACLE_AP_INVOICE_NUMBER, LOAD_REQUEST_ID,LOAD_REQUEST_STATUS,IMPORT_REQUEST_ID,IMPORT_REQUEST_STATUS,OIC_INSTANCE_ID from CHM_MSI_CLAIM_AP_INVOICES
where LOAD_REQUEST_ID = #P_LOAD_REQUEST_ID


"/Custom/Financials/Payables/Invoices/Summary Report.xdo"

SELECT  count(*), NVL(STATUS, 'Struck in Interface because of missing important data') Status from ap_invoices_interface
WHERE LOAD_REQUEST_ID = :LOAD_REQUEST_ID
GROUP BY STATUS



"/Custom/Financials/Payables/Invoices/AP Invoices Rejection Report.xdo"

SELECT
    aii.load_request_id,
    aii.invoice_id,
    aii.INVOICE_NUM,
    air.reject_lookup_code,
    air.rejection_message
FROM
    ap_interface_rejections air,
	ap_invoices_interface aii
WHERE 1=1
AND air.load_request_id = aii.load_request_id
AND aii.load_request_id = :load_request_id


"/Custom/Financials/Payables/Invoices/Load Request ID Report.xdo"

select
    load_request_id,
	invoice_id,
	invoice_num,
	status
FROM
    ap_invoices_interface
WHERE 1=1
AND load_request_id = load_request_id



SELECT
     aii.load_request_id
    ,aii.invoice_id
    ,aii.invoice_num
    ,xmlagg(
        xmlelement(
            e,                      --TAG NAME <E> Value </E>
            air.reject_lookup_code || ', '   --TAG VALUE 
        )
    ).extract('//text()').getclobval() reject_lookup_code
    ,(SELECT count(*) FROM ap_invoices_interface WHERE LOAD_REQUEST_ID = :load_request_id ) failed_count
FROM
     ap_interface_rejections air
	,ap_invoices_interface aii
WHERE 1=1
AND aii.load_request_id = air.load_request_id (+)
AND aii.load_request_id = :load_request_id
group by aii.load_request_id
    ,aii.invoice_id
    ,aii.invoice_num



/*************************************************************************************************
* Report Name           : Invoice Rejection Report                                               *
* Purpose               : Report to extract Invoice Rejection Details                            *
*                                                                                                *
**************************************************************************************************
* Date          Author                 Version          Description                              *
* -----------   ---------------------  -------          -----------------------------------------*
* 16-Apr-2025   Gurpreet Singh         1.0              Initial Version                          *
*************************************************************************************************/
SELECT
     aii.load_request_id
    ,aii.invoice_id
    ,aii.invoice_num
    ,LISTAGG(air.reject_lookup_code, ', ') WITHIN GROUP (ORDER BY air.reject_lookup_code) reject_lookup_code
    ,(SELECT count(*) FROM ap_invoices_interface WHERE LOAD_REQUEST_ID = :load_request_id ) failed_count,
    ,aii.status
FROM
     ap_interface_rejections air
	,ap_invoices_interface aii
WHERE 1=1
AND aii.load_request_id = air.load_request_id (+)
AND aii.load_request_id = :load_request_id
group by aii.load_request_id
    ,aii.invoice_id
    ,aii.invoice_num
    ,aii.status
    
    

UPDATE CHM_MSI_CLAIM_AP_INVOICE_HEADER set ORACLE_AP_INTERFACE_STATUS = #P_ORACLE_AP_INTERFACE_STATUS
where LOAD_REQUEST_ID = #P_LOAD_REQUEST_ID


UPDATE CHM_MSI_CLAIM_AP_INVOICES set ORACLE_AP_INTERFACE_STATUS = #P_ORACLE_AP_INTERFACE_STATUS
where LOAD_REQUEST_ID = #P_LOAD_REQUEST_ID

/Custom/Channel Management/Invoice Rejection/Invoice Rejection.xdo

UPDATE CHM_MSI_CLAIM_AP_INVOICE_HEADER SET REJECTION_REASON = #P_REJECTION_REASON, ORACLE_AP_INTERFACE_STATUS=#P_STATUS WHERE LOAD_REQUEST_ID = #P_LOAD_REQUEST_ID and ORACLE_AP_INVOICE_ID= #P_INVOICE_ID 



CHM_MSI_SUPPLIER_ID	    INSTALLER_NUMBER	SUPPLIER_NUMBER	    SUPPLIER_NAME	    SUPPLIER_SITE	SUPPLIER_ID
2569	                0002021	            1076	            CLEAN SOLAR, INC.	SAN JOSE	    300000147854070
6064	                0002021	            1076	            CLEAN SOLAR, INC.	SAN JOSE	    300000147854070

