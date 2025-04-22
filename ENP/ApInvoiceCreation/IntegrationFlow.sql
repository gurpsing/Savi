--Update OIC Instance Id
UPDATE CHM_MSI_CLAIM_AP_INVOICE_HEADER set OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID
where ORACLE_AP_INTERFACE_STATUS IN ('NEW', 'REJECTED')

--Update OIC Instance Id
UPDATE CHM_MSI_CLAIM_AP_INVOICES set OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID
where ORACLE_AP_INTERFACE_STATUS IN ('NEW', 'REJECTED')


--Get Invoices

select ORACLE_AP_INVOICE_ID,ORACLE_AP_INVOICE_NUMBER,INVOICE_AMOUNT,INVOICE_DATE,Installer_Number,INSTALLER_NUMBER,INVOICE_CURRENCY,COUNTRY, ORACLE_AP_INTERFACE_STATUS, ATTRIBUTE1 ,ATTRIBUTE2 ,ATTRIBUTE3 ,ATTRIBUTE4 ,ATTRIBUTE5 ,ATTRIBUTE6 ,ATTRIBUTE7 ,ATTRIBUTE8 ,ATTRIBUTE9 from CHM_MSI_CLAIM_AP_INVOICE_HEADER  
where ORACLE_AP_INTERFACE_STATUS IN ('NEW', 'REJECTED')

--Get Invoice Lines
select ORACLE_AP_INVOICE_ID,Invoice_Source,ORACLE_AP_INVOICE_NUMBER,TOTAL_AMOUNT,TRANSACTION_DATE,Installer_Number,Installer_Name,SITE_NAME,Accounting_Date,Line_Type,Quantity,Invoice_Line_Number,CURRENCY_CODE,INVOICE_TYPE,TRANSACTION_LINE_DESCRIPTION, REBATE_TYPE, DEVICE_ITEM_NUMBER, COUNTRY, ATTRIBUTE1 ,ATTRIBUTE2 ,ATTRIBUTE3 ,ATTRIBUTE4 ,ATTRIBUTE5 ,ATTRIBUTE6 ,ATTRIBUTE7 ,ATTRIBUTE8 ,ATTRIBUTE9 from CHM_MSI_CLAIM_AP_INVOICES  
where ORACLE_AP_INTERFACE_STATUS IN ('NEW', 'REJECTED')




concat ($GetDistCombination/nsmpr7:executeResponse/ns39:response-wrapper/ns39:items[(ns39:LookupCode = $forEachInvoiceLine/nsmpr5:GetInvoiceLinesDetailsOutput/nsmpr5:COUNTRY)]/ns39:Tag, &quot;.0000.213000.000.00000.A00.000.0000&quot; )



<ns33:Properties>
<ns33:C1>/oracle/apps/ess/financials/payables/invoices/transactions/</ns33:C1>--JobPackageName
<ns33:C2>APXIIMPT</ns33:C2> JobDefinationName
<ns33:C3>AP_INV</ns33:C3> --zip_file_name
<ns33:C4>#NULL</ns33:C4> Attribute1
<ns33:C5>#NULL</ns33:C5> attribute2
<ns33:C6>N</ns33:C6> Attribute3
<ns33:C7>#NULL</ns33:C7> Accounting Date
<ns33:C8>#NULL</ns33:C8> Hold
<ns33:C9>#NULL</ns33:C9> Hold Reason
<ns33:C10>1000</ns33:C10> Attribute7
<ns33:C11>MSI</ns33:C11>  Source
<ns33:C12>#NULL</ns33:C12> Import Set
<ns33:C13>N</ns33:C13> Purge
<ns33:C14>N</ns33:C14> Summarize Report
<ns33:C15>1</ns33:C15> number of parallel processes
<ns33:C16>ENE NLD Business Unit</ns33:C16>  Business Unit
<ns33:C17>#NULL</ns33:C17>SummarizeReport
</ns33:Properties>

SELECT organization_id
FROM hr_operating_units
WHERE name = 'US1 BU'


SELECT ledger_id
FROM gl_ledgers
WHERE name = 'US1 Ledger'

SELECT lookup_code,
       meaning
FROM fnd_lookup_values
WHERE lookup_type = 'SOURCE'


SELECT lookup_code,
       meaning
FROM fnd_lookup_values
WHERE lookup_type = 'HOLD_CODE'
       
       
'apinvoiceimport.properties'
'/temp'

select * from CHM_MSI_AP_BU_NAME_LOOKUP;

<ns30:Distribution_Combination xml:id="id_1148">
      <xsl:value-of xml:id="id_1149" select="concat ($GetDistCombination/nsmpr7:executeResponse/ns39:response-wrapper/ns39:items[(ns39:LookupCode = $forEachInvoiceLine/nsmpr5:GetInvoiceLinesDetailsOutput/nsmpr5:COUNTRY)]/ns39:Tag, &quot;.0000.213000.000.00000.A00.000.0000&quot; )"/>
</ns30:Distribution_Combination>

UPDATE CHM_MSI_CLAIM_AP_INVOICE_HEADER inv SET BU_NAME = (SELECT description FROM chm_msi_ap_bu_name_lookup lkp WHERE lkp.lookup_code = inv.country) where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID3

update CHM_MSI_CLAIM_AP_INVOICE_HEADER set SUPPLIER_NAME=#P_SUPPLIER_NAME,SUPPLIER_SITE=#P_SUPPLIER_SITE,SUPPLIER_NUMBER=#P_SUPPLIER_NUMBER where INSTALLER_NUMBER=#P_INSTALLER_NUMBER

UPDATE CHM_MSI_CLAIM_AP_INVOICES SET DIST_CODE_COMBINATION = #P_DIST_CODE_COMBINATION where country=#P_COUNTRY and 
OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID


select distinct import_set from CHM_MSI_CLAIM_AP_INVOICE_HEADER where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID order by 1

select * from CHM_MSI_CLAIM_AP_INVOICE_HEADER  where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID AND IMPORT_SET = #P_IMPORT_SET


select * from CHM_MSI_CLAIM_AP_INVOICES  where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID AND IMPORT_SET = #P_IMPORT_SET


select distinct import_set,bu_name from CHM_MSI_CLAIM_AP_INVOICE_HEADER where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID AND import_set is not null  order by 1


UPDATE CHM_MSI_CLAIM_AP_INVOICE_HEADER set LOAD_REQUEST_ID = #P_LOAD_REQUEST_ID, LOAD_REQUEST_STATUS = #P_LOAD_REQUEST_STATUS
where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID AND IMPORT_SET = #P_IMPORT_SET


UPDATE CHM_MSI_CLAIM_AP_INVOICES set LOAD_REQUEST_ID = #P_LOAD_REQUEST_ID, LOAD_REQUEST_STATUS = #P_LOAD_REQUEST_STATUS
where OIC_INSTANCE_ID = #P_OIC_INSTANCE_ID AND IMPORT_SET = #P_IMPORT_SET


string (xp20:format-dateTime (nsmpr0:INVOICE_DATE, "[Y0001]/M[01]/D[01]" ) )



