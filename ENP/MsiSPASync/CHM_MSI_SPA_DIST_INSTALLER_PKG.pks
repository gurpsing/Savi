create or replace PACKAGE CHM_MSI_SPA_DIST_INSTALLER_PKG 
/**********************************************************************************************************************
* Type                           : PL/SQL Package Body                                                                *
* Package Name                   : CHM_MSI_SPA_DIST_INSTALLER_PKG                                                     *
* Purpose                        : Package Body for MSI SPA Distributor, Installer & Geo Restriction Sync from SFDC   *
* Created By                     : Gurpreet Singh                                                                     *
* Created Date                   : 22-Mar-2025                                                                        *
***********************************************************************************************************************
* Date          By                             Version          Details                                               *
* -----------   ---------------------------    -------------    ------------------------------------------------------*
* 22-Mar-2025   Gurpreet Singh                 1.0              Intial Version                                        *
**********************************************************************************************************************/

AS
    TYPE REC_CHM_MSI_SPA_INSTALLERS IS RECORD (
         ID                              VARCHAR2(4000)              
        ,IS_DELETED                      VARCHAR2(4000)              
        ,NAME                            VARCHAR2(4000)              
        ,CURRENCY_ISO_CODE               VARCHAR2(4000)              
        ,SFDC_CREATED_DATE               TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_CREATED_BY                 VARCHAR2(4000)              
        ,SFDC_LAST_UPDATE_DATE           TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_LAST_UPDATED_BY            VARCHAR2(4000)              
        ,SYSTEM_MOD_STAMP                VARCHAR2(4000)              
        ,LAST_ACTIVITY_DATE              VARCHAR2(4000)              
        ,LAST_VIEWED_DATE                VARCHAR2(4000)              
        ,LAST_REFERENCED_DATE            VARCHAR2(4000)              
        ,SPA                             VARCHAR2(4000)           
        ,STATUS                          VARCHAR2(4000)              
        ,INSTALLER_ENLIGHTEN_ID          VARCHAR2(4000)              
        ,INSTALLER_ID                    VARCHAR2(4000)              
        ,ATTRIBUTE_CONTEXT               VARCHAR2(4000)              
        ,ATTRIBUTE1                      VARCHAR2(4000)              
        ,ATTRIBUTE2                      VARCHAR2(4000)              
        ,ATTRIBUTE3                      VARCHAR2(4000)              
        ,ATTRIBUTE4                      VARCHAR2(4000)              
        ,ATTRIBUTE5                      VARCHAR2(4000)              
        ,ATTRIBUTE6                      VARCHAR2(4000)              
        ,ATTRIBUTE7                      VARCHAR2(4000)              
        ,ATTRIBUTE8                      VARCHAR2(4000)              
        ,ATTRIBUTE9                      VARCHAR2(4000)              
        ,ATTRIBUTE10                     VARCHAR2(4000)              
        ,ATTRIBUTE11                     VARCHAR2(4000)              
        ,ATTRIBUTE12                     VARCHAR2(4000)              
        ,ATTRIBUTE13                     VARCHAR2(4000)              
        ,ATTRIBUTE14                     VARCHAR2(4000)              
        ,ATTRIBUTE15                     VARCHAR2(4000)              
        ,OIC_INSTANCE_ID                 VARCHAR2(4000)              
        ,CREATED_BY                      VARCHAR2(4000)              
        ,CREATION_DATE                   TIMESTAMP(6) WITH TIME ZONE 
        ,LAST_UPDATED_BY                 VARCHAR2(4000)              
        ,LAST_UPDATED_DATE               TIMESTAMP(6) WITH TIME ZONE 
    );

    TYPE TBL_CHM_MSI_SPA_INSTALLERS IS TABLE OF REC_CHM_MSI_SPA_INSTALLERS;

    PROCEDURE MERGE_SPA_INSTALLERS_DATA (
         P_IN_CHM_MSI_SPA_INSTALLERS    IN TBL_CHM_MSI_SPA_INSTALLERS
        ,P_IN_OIC_INSTANCE_ID           IN VARCHAR2
    );


    TYPE REC_CHM_MSI_SPA_DISTRIBUTORS IS RECORD (
         ID                              VARCHAR2(4000)              
        ,IS_DELETED                      VARCHAR2(4000)              
        ,NAME                            VARCHAR2(4000)              
        ,CURRENCY_ISO_CODE               VARCHAR2(4000)              
        ,SFDC_CREATED_DATE               TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_CREATED_BY                 VARCHAR2(4000)              
        ,SFDC_LAST_UPDATE_DATE           TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_LAST_UPDATED_BY            VARCHAR2(4000)              
        ,SYSTEM_MOD_STAMP                VARCHAR2(4000)              
        ,LAST_VIEWED_DATE                VARCHAR2(4000)              
        ,LAST_REFERENCED_DATE            VARCHAR2(4000)              
        ,SPA                             VARCHAR2(4000)              
        ,DISTRIBUTOR_SFDC_ACCOUNT_ID     VARCHAR2(4000)             
        ,SPA_STATUS                      VARCHAR2(4000)              
        ,ORACLE_CUSTOMER_NUMBER          VARCHAR2(4000)              
        ,SPA_AND_OPPORTUNITIES           VARCHAR2(4000)              
        ,LINE_STATUS                     VARCHAR2(4000)              
        ,ATTRIBUTE_CONTEXT               VARCHAR2(4000)              
        ,ATTRIBUTE1                      VARCHAR2(4000)              
        ,ATTRIBUTE2                      VARCHAR2(4000)              
        ,ATTRIBUTE3                      VARCHAR2(4000)              
        ,ATTRIBUTE4                      VARCHAR2(4000)              
        ,ATTRIBUTE5                      VARCHAR2(4000)              
        ,ATTRIBUTE6                      VARCHAR2(4000)              
        ,ATTRIBUTE7                      VARCHAR2(4000)              
        ,ATTRIBUTE8                      VARCHAR2(4000)              
        ,ATTRIBUTE9                      VARCHAR2(4000)              
        ,ATTRIBUTE10                     VARCHAR2(4000)              
        ,ATTRIBUTE11                     VARCHAR2(4000)              
        ,ATTRIBUTE12                     VARCHAR2(4000)              
        ,ATTRIBUTE13                     VARCHAR2(4000)              
        ,ATTRIBUTE14                     VARCHAR2(4000)              
        ,ATTRIBUTE15                     VARCHAR2(4000)              
        ,CREATED_BY                      VARCHAR2(4000)              
        ,CREATION_DATE                   TIMESTAMP(6) WITH TIME ZONE 
        ,LAST_UPDATED_BY                 VARCHAR2(4000)              
        ,LAST_UPDATED_DATE               TIMESTAMP(6) WITH TIME ZONE 
        ,OIC_INSTANCE_ID                 VARCHAR2(4000)              
    );

    TYPE TBL_CHM_MSI_SPA_DISTRIBUTORS IS TABLE OF REC_CHM_MSI_SPA_DISTRIBUTORS;

    PROCEDURE MERGE_SPA_DISTRIBUTOR_DATA (
         P_IN_CHM_MSI_SPA_DISTRIBUTORS  IN TBL_CHM_MSI_SPA_DISTRIBUTORS
        ,P_IN_OIC_INSTANCE_ID           IN VARCHAR2
    );


    TYPE REC_CHM_MSI_SPA_GEO_DETAILS IS RECORD (
         ID                              VARCHAR2(4000)              
        ,IS_DELETED                      VARCHAR2(4000)              
        ,NAME                            VARCHAR2(4000)              
        ,CURRENCY_ISO_CODE               VARCHAR2(4000)              
        ,SFDC_CREATED_DATE               TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_CREATED_BY                 VARCHAR2(4000)              
        ,SFDC_LAST_UPDATE_DATE           TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_LAST_UPDATED_BY            VARCHAR2(4000)              
        ,SYSTEM_MOD_STAMP                VARCHAR2(4000)              
        ,LAST_VIEWED_DATE                VARCHAR2(4000)              
        ,LAST_REFERENCED_DATE            VARCHAR2(4000)              
        ,LAST_ACTIVITY_DATE              VARCHAR2(4000)              
        ,COUNTRY                         VARCHAR2(4000)              
        ,ZIP                             VARCHAR2(32000)             
        ,STATUS                          VARCHAR2(4000)              
        ,STATE                           VARCHAR2(4000)              
        ,SPA                             VARCHAR2(4000)              
        ,ATTRIBUTE_CONTEXT               VARCHAR2(4000)              
        ,ATTRIBUTE1                      VARCHAR2(4000)              
        ,ATTRIBUTE2                      VARCHAR2(4000)              
        ,ATTRIBUTE3                      VARCHAR2(4000)              
        ,ATTRIBUTE4                      VARCHAR2(4000)              
        ,ATTRIBUTE5                      VARCHAR2(4000)              
        ,ATTRIBUTE6                      VARCHAR2(4000)              
        ,ATTRIBUTE7                      VARCHAR2(4000)              
        ,ATTRIBUTE8                      VARCHAR2(4000)              
        ,ATTRIBUTE9                      VARCHAR2(4000)              
        ,ATTRIBUTE10                     VARCHAR2(4000)              
        ,ATTRIBUTE11                     VARCHAR2(4000)              
        ,ATTRIBUTE12                     VARCHAR2(4000)              
        ,ATTRIBUTE13                     VARCHAR2(4000)              
        ,ATTRIBUTE14                     VARCHAR2(4000)              
        ,ATTRIBUTE15                     VARCHAR2(4000)              
        ,CREATED_BY                      VARCHAR2(4000)              
        ,CREATION_DATE                   TIMESTAMP(6) WITH TIME ZONE 
        ,LAST_UPDATED_BY                 VARCHAR2(4000)              
        ,LAST_UPDATED_DATE               TIMESTAMP(6) WITH TIME ZONE 
        ,OIC_INSTANCE_ID                 VARCHAR2(4000)              
    );

    TYPE TBL_CHM_MSI_SPA_GEO_DETAILS IS TABLE OF REC_CHM_MSI_SPA_GEO_DETAILS;

    PROCEDURE MERGE_SPA_GEO_DETAILS_DATA (
         P_IN_CHM_MSI_SPA_GEO_DETAILS   IN TBL_CHM_MSI_SPA_GEO_DETAILS
        ,P_IN_OIC_INSTANCE_ID           IN VARCHAR2
    );


END CHM_MSI_SPA_DIST_INSTALLER_PKG;
/
