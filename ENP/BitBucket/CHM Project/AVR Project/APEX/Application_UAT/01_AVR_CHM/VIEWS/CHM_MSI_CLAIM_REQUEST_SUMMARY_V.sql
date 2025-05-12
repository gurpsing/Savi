--------------------------------------------------------
--  DDL for View CHM_MSI_CLAIM_REQUEST_SUMMARY_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CHM_MSI_CLAIM_REQUEST_SUMMARY_V" ("REQ_SUMMARY_ID", "MSI_CLAIM_REQ_ID", "BATCH_ID", "DIST_ID", "INSTALLER_ID", "SFDC_CUSTOMER_KEY", "INSTALLER_NAME", "ENLIGHTEN_INSTALLER_ID", "CLAIM_TYPE", "CLAIM_DATE", "SPA_NUMBER", "SPA_START_DATE", "SPA_EXPIRATION_DATE", "CURRENCY", "TOTAL_BATCH_LINES", "TOTAL_LINES_SUBMITTED", "TOTAL_LINES_NOT_SUBMITTED", "TOTAL_LINES_OVERRIDDEN", "TOTAL_LINES_NOT_OVERRIDDEN", "LINES_OVERRIDDEN_CLAIM_AMOUNT", "LINES_NOT_OVERRIDDEN_CLAIM_AMOUNT", "UNIT_INCENTIVE_AMOUNT", "SYSTEM_ATTACHMENT_AMOUNT", "SYSTEM_SIZE_AMOUNT", "TOTAL_CLAIM_AMOUNT", "ATTRIBUTE_CONTEXT", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATED_DATE", "SOURCE_APP_ID", "ENTERPRISE_ID", "IP_ADDRESS", "USER_AGENT") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select
    cmc.req_summary_id, cmc.msi_claim_req_id, cmcr.batch_id,cmc.dist_id, cmc.installer_id, 
    csam.customer_key sfdc_customer_key, csam.account_name installer_name,
	csam.enlighten_installer_id,
    cmc.claim_type, cmc.claim_date, cmc.spa_number,TRUNC(cmsh.spa_start_date) spa_start_date,
TRUNC(cmsh.spa_expiration_date) spa_expiration_date,
     cmc.currency, cmc.total_batch_lines, cmc.total_lines_submitted, cmc.total_lines_not_submitted, cmc.total_lines_overridden
    , cmc.total_lines_not_overridden, cmc.lines_overridden_claim_amount, cmc.lines_not_overridden_claim_amount,
    cmc.unit_incentive_amount, cmc.system_attachment_amount, cmc.system_size_amount, cmc.total_claim_amount, cmc.attribute_context
    , cmc.attribute1, cmc.attribute2, cmc.attribute3, cmc.attribute4, cmc.attribute5, cmc.attribute6, cmc.attribute7, cmc.attribute8
    , cmc.attribute9, cmc.attribute10, cmc.attribute11, cmc.attribute12, cmc.attribute13, cmc.attribute14, cmc.attribute15
    , cmc.created_by, cmc.creation_date, cmc.last_updated_by, cmc.last_updated_date, cmc.source_app_id, cmc.enterprise_id
    , cmc.ip_address, cmc.user_agent
  from
    chm_msi_claim_request_summary cmc,
    chm_msi_claim_request cmcr,
    chm_sfdc_account_master csam ,
    chm_msi_spa_header cmsh
    where 
    cmc.msi_claim_req_id=cmcr.msi_claim_req_id
    AND cmc.installer_id=csam.chm_account_id(+)
    AND cmc.spa_number=cmsh.spa_number(+)
;
