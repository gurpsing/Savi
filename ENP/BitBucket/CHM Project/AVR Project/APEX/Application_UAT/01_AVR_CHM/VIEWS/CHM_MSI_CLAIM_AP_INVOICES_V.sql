--------------------------------------------------------
--  DDL for View CHM_MSI_CLAIM_AP_INVOICES_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CHM_MSI_CLAIM_AP_INVOICES_V" ("CHM_TRANSACTION_ID", "CLAIM_BATCH_ID", "TRANSACTION_DATE", "ACCOUNTING_DATE", "PAYEE_NUMBER", "PAYEE_NAME", "PAYEE_ENLIGHTEN_ID", "INSTALLER_NUMBER", "INSTALLER_NAME", "INSTALLER_ENLIGHTEN_ID", "SPA_NUMBER", "SPA_START_DATE", "SPA_EXPIRATION_DATE", "REBATE_TYPE_CODE", "REBATE_TYPE_NAME", "REBATE_ITEM_NUMBER", "DEVICE_ITEM_NUMBER", "REBATE_TIER", "TRANSACTION_LINE_DESCRIPTION", "SITE_ID", "SITE_NAME", "CURRENCY_CODE", "QUANTITY", "TOTAL_AMOUNT", "UNIT_PRICE", "ORACLE_AP_INTERFACE_STATUS", "ORACLE_AP_INVOICE_NUMBER", "ORACLE_AP_INVOICE_ID", "INVOICE_LINE_NUMBER", "COUNTRY", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATED_DATE", "ADD_TAX", "ATTRIBUTE_CATEGORY", "CALCULATE_TAX", "INVOICE_DESCRIPTION", "INVOICE_SOURCE", "INVOICE_TYPE", "LINE_GROUP_NUMBER", "LINE_TYPE", "PRODUCT_TYPE", "ATTRIBUTE_CONTEXT", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "SOURCE_APP_ID", "ENTERPRISE_ID", "IP_ADDRESS", "USER_AGENT") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select cmap.CHM_TRANSACTION_ID,
cmap.CLAIM_BATCH_ID,
cmap.TRANSACTION_DATE,
cmap.ACCOUNTING_DATE,
cmap.PAYEE_NUMBER,
cmap.payee_name,
cmap.payee_enlighten_id,
cmap.installer_number,
cmap.installer_name,
cmap.installer_enlighten_id,
cmap.SPA_NUMBER,
cmap.SPA_START_DATE,
cmap.SPA_EXPIRATION_DATE,
cmap.rebate_type rebate_type_code,
clv.meaning rebate_type_name,
cmap.rebate_item_number,
cmap.device_item_number,
cmap.rebate_tier,
cmap.TRANSACTION_LINE_DESCRIPTION,
cmap.site_id,
cmap.site_name,
cmap.CURRENCY_CODE,
cmap.QUANTITY,
cmap.TOTAL_AMOUNT,
--1 UNIT_PRICE,
cmap.TOTAL_AMOUNT/CASE WHEN cmap.QUANTITY = 0 THEN 1 WHEN cmap.QUANTITY IS NULL THEN 1 ELSE cmap.QUANTITY END UNIT_PRICE,
cmap.ORACLE_AP_INTERFACE_STATUS,
cmap.ORACLE_AP_INVOICE_NUMBER,
cmap.ORACLE_AP_INVOICE_ID,
cmap.invoice_line_number,
cmap.country,
cmap.CREATED_BY,
cmap.CREATION_DATE,
cmap.LAST_UPDATED_BY,
cmap.LAST_UPDATED_DATE,
add_tax.add_tax,
attribute_category.attribute_category,
calculate_tax.calculate_tax,
invoice_description.invoice_description,
invoice_source.invoice_source,
CASE WHEN cmap.TOTAL_AMOUNT <0 THEN non_standard_invoice_type.non_standard_invoice_type
ELSE standard_invoice_type.standard_invoice_type END invoice_type,
line_group_number.line_group_number,
line_type.line_type,
product_type.product_type,
/*NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','INVOICE_SOURCE'),'MSI') INVOICE_SOURCE,
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','INVOICE_DESCRIPTION'), 'Marketing Services Incentive (MSI)') INVOICE_DESCRIPTION, 
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','INVOICE_TYPE'),'STANDARD') INVOICE_TYPE,
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','CALCULATE_TAX'),'Y') CALCULATE_TAX,
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','ADD_TAX'),'Y') ADD_TAX,
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','LINE_TYPE'),'ITEM') LINE_TYPE,
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','PRODUCT_TYPE'),'SERVICES') PRODUCT_TYPE,
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','LINE_GROUP_NUMBER'),'1') LINE_GROUP_NUMBER,
NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','ATTRIBUTE_CATEGORY'),'ENE_MSI_AP_LINES_DFF') ATTRIBUTE_CATEGORY,
*/
cmap.ATTRIBUTE_CONTEXT,
cmap.ATTRIBUTE1,
cmap.ATTRIBUTE2,
cmap.ATTRIBUTE3,
cmap.ATTRIBUTE4,
cmap.ATTRIBUTE5,
cmap.ATTRIBUTE6,
cmap.ATTRIBUTE7,
cmap.ATTRIBUTE8,
cmap.ATTRIBUTE9,
cmap.ATTRIBUTE10,
cmap.ATTRIBUTE11,
cmap.ATTRIBUTE12,
cmap.ATTRIBUTE13,
cmap.ATTRIBUTE14,
cmap.ATTRIBUTE15,
cmap.SOURCE_APP_ID,
cmap.ENTERPRISE_ID,
cmap.IP_ADDRESS,
cmap.USER_AGENT
from chm_msi_claim_ap_invoices cmap,
chm_lookup_values_v1 clv,
(select meaning add_tax from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='ADD_TAX' and rownum=1) add_tax, 
(select meaning ATTRIBUTE_CATEGORY from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='ATTRIBUTE_CATEGORY' and rownum=1) ATTRIBUTE_CATEGORY, 
(select meaning CALCULATE_TAX from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='CALCULATE_TAX' and rownum=1) CALCULATE_TAX, 
(select meaning INVOICE_DESCRIPTION from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='INVOICE_DESCRIPTION' and rownum=1) INVOICE_DESCRIPTION, 
(select meaning INVOICE_SOURCE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='INVOICE_SOURCE' and rownum=1) INVOICE_SOURCE, 
(select meaning STANDARD_INVOICE_TYPE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='STANDARD_INVOICE_TYPE' and rownum=1) STANDARD_INVOICE_TYPE, 
(select meaning NON_STANDARD_INVOICE_TYPE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='NON_STANDARD_INVOICE_TYPE' and rownum=1) NON_STANDARD_INVOICE_TYPE, 
(select meaning LINE_GROUP_NUMBER from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='LINE_GROUP_NUMBER' and rownum=1) LINE_GROUP_NUMBER, 
(select meaning LINE_TYPE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='LINE_TYPE' and rownum=1) LINE_TYPE, 
(select meaning PRODUCT_TYPE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='PRODUCT_TYPE' and rownum=1) PRODUCT_TYPE
where cmap.rebate_type=clv.lookup_code(+)
and clv.lookup_type(+)='CHM_MSI_REBATE_TYPE'
;
