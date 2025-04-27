
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "CHM"."CHM_MSI_CLAIM_AP_INVOICE_HEADER_V" ("ORACLE_AP_INVOICE_ID", "ORACLE_AP_INVOICE_NUMBER", "INVOICE_AMOUNT", "INVOICE_CURRENCY", "INVOICE_DATE", "INSTALLER_NUMBER", "INSTALLER_SFDC_ACCOUNT_ID", "COUNTRY", "NO_OF_INVOICE_LINES", "ORACLE_AP_INTERFACE_STATUS", "ADD_TAX", "CALCULATE_TAX", "INVOICE_DESCRIPTION", "INVOICE_SOURCE", "INVOICE_TYPE", "ATTRIBUTE_CONTEXT", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATED_DATE", "SOURCE_APP_ID", "ENTERPRISE_ID", "IP_ADDRESS", "USER_AGENT") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select ap.oracle_ap_invoice_id,ap.oracle_ap_invoice_number,
 ap.invoice_amount, ap.invoice_currency,
 ap.invoice_date,ap.installer_number, 
 ap.installer_sfdc_account_id,
 ap.country, 
 ap.no_of_invoice_lines,
 ap.oracle_ap_interface_status,
 add_tax.add_tax,
calculate_tax.calculate_tax,
invoice_description.invoice_description,
invoice_source.invoice_source,
--invoice_type.invoice_type,
CASE WHEN ap.invoice_amount > 0 THEN standard_invoice_type.invoice_type
ELSE non_standard_invoice_type.invoice_type END invoice_type,
ap.ATTRIBUTE_CONTEXT,
ap.ATTRIBUTE1,
ap.ATTRIBUTE2,
ap.ATTRIBUTE3,
ap.ATTRIBUTE4,
ap.ATTRIBUTE5,
ap.ATTRIBUTE6,
ap.ATTRIBUTE7,
ap.ATTRIBUTE8,
ap.ATTRIBUTE9,
ap.ATTRIBUTE10,
ap.ATTRIBUTE11,
ap.ATTRIBUTE12,
ap.ATTRIBUTE13,
ap.ATTRIBUTE14,
ap.ATTRIBUTE15,
ap.CREATED_BY,
ap.CREATION_DATE,
ap.LAST_UPDATED_BY,
ap.LAST_UPDATED_DATE,
ap.SOURCE_APP_ID,
ap.ENTERPRISE_ID,
ap.IP_ADDRESS,
ap.USER_AGENT
 from CHM_MSI_CLAIM_AP_INVOICE_HEADER ap,
 (select meaning add_tax from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='ADD_TAX' and rownum=1) add_tax, 
(select meaning CALCULATE_TAX from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='CALCULATE_TAX' and rownum=1) CALCULATE_TAX, 
(select meaning INVOICE_DESCRIPTION from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='INVOICE_DESCRIPTION' and rownum=1) INVOICE_DESCRIPTION, 
(select meaning INVOICE_SOURCE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='INVOICE_SOURCE' and rownum=1) INVOICE_SOURCE, 
(select meaning INVOICE_TYPE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='STANDARD_INVOICE_TYPE' and rownum=1) STANDARD_INVOICE_TYPE,
(select meaning INVOICE_TYPE from chm_lookup_values_v1
where lookup_type = 'CHM_MSI_AP_INVOICE_SETUP'
and lookup_code='NON_STANDARD_INVOICE_TYPE' and rownum=1) NON_STANDARD_INVOICE_TYPE;

