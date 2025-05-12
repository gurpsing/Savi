--------------------------------------------------------
--  DDL for View CHM_ENLIGHTEN_DEVICE_REBATES_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CHM_ENLIGHTEN_DEVICE_REBATES_V" ("CHM_DEVICE_REBATE_ID", "CHM_ENLIGHTEN_SITE_ID", "CHM_ENLIGHTEN_DEVICE_ID", "SPA_NUMBER", "SPA_LINE_ID", "DEVICE_ITEM_NUMBER", "REBATE_ITEM_NUMBER", "REBATE_TYPE", "REBATE_TIER", "SPA_ORIGINAL_AMOUNT", "CLAIM_DATE", "REBATE_CURRENCY", "REBATE_AMOUNT", "REBATE_SOURCE", "REBATE_STATUS", "CLAIM_BATCH_ID", "CLAIM_LINE_ID", "REBATE_PAYEE_TYPE", "REBATE_PAYEE_ID", "PAYEE_SFDC_CUSTOMER_KEY", "PAYEE_NAME", "PAYEE_ENLIGHTEN_INSTALLER_ID", "SITE_INSTALLER_SFDC_CUSTOMER_KEY", "SITE_INSTALLER_NAME", "SITE_ENLIGTHEN_INSTALLER_ID", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "IP_ADDRESS", "USER_AGENT") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
      CEDR.CHM_DEVICE_REBATE_ID,
      CEDR.CHM_ENLIGHTEN_SITE_ID,
      CEDR.CHM_ENLIGHTEN_DEVICE_ID,
      CEDR.SPA_NUMBER,
      CEDR.SPA_LINE_ID,
      CEDR.DEVICE_ITEM_NUMBER,
      CEDR.REBATE_ITEM_NUMBER,
      CEDR.REBATE_TYPE,
      CEDR.REBATE_TIER,
      CEDR.SPA_ORIGINAL_AMOUNT,
      CEDR.CLAIM_DATE,
      CEDR.REBATE_CURRENCY,
      CEDR.REBATE_AMOUNT,
      CEDR.REBATE_SOURCE,
      CEDR.REBATE_STATUS,
      CEDR.CLAIM_BATCH_ID,
      CEDR.CLAIM_LINE_ID,
      CEDR.REBATE_PAYEE_TYPE,
      CEDR.REBATE_PAYEE_ID,
      csam_payee.customer_key payee_sfdc_customer_key,
      csam_payee.account_name payee_name,
      csam_payee.enlighten_installer_id payee_enlighten_installer_id,
      csam_installer.customer_key site_installer_sfdc_customer_key,
      csam_installer.account_name site_installer_name,
      csam_installer.enlighten_installer_id site_enligthen_installer_id,
      CEDR.CREATED_BY,
      CEDR.CREATION_DATE,
      CEDR.LAST_UPDATED_BY,
      CEDR.LAST_UPDATE_DATE,
      CEDR.ATTRIBUTE1,
      CEDR.ATTRIBUTE2,
      CEDR.ATTRIBUTE3,
      CEDR.ATTRIBUTE4,
      CEDR.ATTRIBUTE5,
      CEDR.ATTRIBUTE6,
      CEDR.ATTRIBUTE7,
      CEDR.ATTRIBUTE8,
      CEDR.ATTRIBUTE9,
      CEDR.ATTRIBUTE10,
      CEDR.ATTRIBUTE11,
      CEDR.ATTRIBUTE12,
      CEDR.ATTRIBUTE13,
      CEDR.ATTRIBUTE14,
      CEDR.ATTRIBUTE15,
      CEDR.IP_ADDRESS,
      CEDR.USER_AGENT
from chm_enlighten_device_rebates  cedr,
chm_sfdc_account_master csam_payee,
chm_sfdc_account_master csam_installer,
chm_enlighten_site_master chms
WHERE cedr.chm_enlighten_site_id=chms.chm_enlighten_site_id(+)
AND		chms.installer_id=csam_installer.enlighten_installer_id(+)
AND  cedr.rebate_payee_id=csam_payee.chm_account_id
;
