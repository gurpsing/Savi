--------------------------------------------------------
--  DDL for View CHM_MSI_SPA_INSTALLERS_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CHM_MSI_SPA_INSTALLERS_V" ("SPA_NUMBER", "CHM_MSI_SPA_INSTALLER_ID", "ID", "INSTALLER_ENLIGHTEN_ID", "STATUS", "SFDC_CREATED_DATE", "SFDC_LAST_UPDATE_DATE", "SFDC_CREATED_BY", "SFDC_LAST_UPDATED_BY", "ATTRIBUTE_CONTEXT", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATED_DATE", "SOURCE_APP_ID", "ENTERPRISE_ID", "IP_ADDRESS", "USER_AGENT", "OIC_INSTANCE_ID", "IS_DELETED", "NAME", "CURRENCY_ISO_CODE", "SYSTEM_MOD_STAMP", "LAST_ACTIVITY_DATE", "LAST_VIEWED_DATE", "LAST_REFERENCED_DATE", "INSTALLER_ID", "SPA") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
        s.spa_number,
        i."CHM_MSI_SPA_INSTALLER_ID",
        i."ID",
        i."INSTALLER_ENLIGHTEN_ID",
        i."STATUS",
        i."SFDC_CREATED_DATE",
        i."SFDC_LAST_UPDATE_DATE",
        i."SFDC_CREATED_BY",
        i."SFDC_LAST_UPDATED_BY",
        i."ATTRIBUTE_CONTEXT",
        i."ATTRIBUTE1",
        i."ATTRIBUTE2",
        i."ATTRIBUTE3",
        i."ATTRIBUTE4",
        i."ATTRIBUTE5",
        i."ATTRIBUTE6",
        i."ATTRIBUTE7",
        i."ATTRIBUTE8",
        i."ATTRIBUTE9",
        i."ATTRIBUTE10",
        i."ATTRIBUTE11",
        i."ATTRIBUTE12",
        i."ATTRIBUTE13",
        i."ATTRIBUTE14",
        i."ATTRIBUTE15",
        i."CREATED_BY",
        i."CREATION_DATE",
        i."LAST_UPDATED_BY",
        i."LAST_UPDATED_DATE",
        i."SOURCE_APP_ID",
        i."ENTERPRISE_ID",
        i."IP_ADDRESS",
        i."USER_AGENT",
        i."OIC_INSTANCE_ID",
        i."IS_DELETED",
        i."NAME",
        i."CURRENCY_ISO_CODE",
        i."SYSTEM_MOD_STAMP",
        i."LAST_ACTIVITY_DATE",
        i."LAST_VIEWED_DATE",
        i."LAST_REFERENCED_DATE",
        i."INSTALLER_ID",
        i."SPA"
    FROM
        chm_msi_spa_installers i,
        chm_msi_spa_header     s
    WHERE
        i.spa = s.id (+)
;
