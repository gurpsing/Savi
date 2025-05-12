--------------------------------------------------------
--  DDL for View CHM_MSI_CLAIM_BATCH_PAYEE_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CHM_MSI_CLAIM_BATCH_PAYEE_V" ("PAYEE_ID", "PAYEE_TYPE", "PAYEE_SFDC_CUSTOMER_KEY", "PAYEE_SFDC_ACCOUNT_NAME", "PAYEE_ENLIGHTEN_INSTALLER_ID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
DISTINCT
PAYEE_ID,
PAYEE_TYPE,
payee_sfdc_customer_key,
payee_sfdc_account_name,
payee_enlighten_installer_id
FROM chm_msi_claim_batch_lines_av
;
