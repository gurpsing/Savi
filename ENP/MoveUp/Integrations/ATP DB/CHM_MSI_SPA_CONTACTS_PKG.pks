create or replace PACKAGE CHM_MSI_SPA_CONTACTS_PKG

/*******************************************************************************************************
* Type                           : PL/SQL Package Specification                                        *
* Package Name                   : CHM_MSI_SPA_CONTACTS_PKG                                            *
* Purpose                        : Package Specification for MSI SPA Contacts sync from SFDC           *
* Created By                     : Gurpreet Singh                                                      *
* Created Date                   : 15-Apr-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 15-Apr-2025   Gurpreet Singh                  1.0              Intial Version                        * 
*******************************************************************************************************/

AS

    TYPE REC_CHM_MSI_SPA_CONTACT IS RECORD (                    
         ID                            VARCHAR2(4000)              
        ,IS_DELETED                    VARCHAR2(4000)              
        ,NAME                          VARCHAR2(4000)              
        ,CURRENCY_ISO_CODE             VARCHAR2(4000)              
        ,SFDC_CREATED_DATE             TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_CREATED_BY               VARCHAR2(4000)              
        ,SFDC_LAST_UPDATE_DATE         TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_LAST_UPDATED_BY          VARCHAR2(4000)              
        ,SYSTEM_MOD_STAMP              VARCHAR2(4000)              
        ,LAST_ACTIVITY_DATE            VARCHAR2(4000)              
        ,LAST_VIEWED_DATE              VARCHAR2(4000)              
        ,LAST_REFERENCED_DATE          VARCHAR2(4000)              
        ,CONTACT_ID                    VARCHAR2(4000)              
        ,CONTACT_NAME                  VARCHAR2(4000)              
        ,SPA                           VARCHAR2(4000)              
        ,EMAIL                         VARCHAR2(4000)              
        ,ATTRIBUTE_CONTEXT             VARCHAR2(4000)              
        ,ATTRIBUTE1                    VARCHAR2(4000)              
        ,ATTRIBUTE2                    VARCHAR2(4000)              
        ,ATTRIBUTE3                    VARCHAR2(4000)              
        ,ATTRIBUTE4                    VARCHAR2(4000)              
        ,ATTRIBUTE5                    VARCHAR2(4000)              
        ,ATTRIBUTE6                    VARCHAR2(4000)              
        ,ATTRIBUTE7                    VARCHAR2(4000)              
        ,ATTRIBUTE8                    VARCHAR2(4000)              
        ,ATTRIBUTE9                    VARCHAR2(4000)              
        ,ATTRIBUTE10                   VARCHAR2(4000)              
        ,ATTRIBUTE11                   VARCHAR2(4000)              
        ,ATTRIBUTE12                   VARCHAR2(4000)              
        ,ATTRIBUTE13                   VARCHAR2(4000)              
        ,ATTRIBUTE14                   VARCHAR2(4000)              
        ,ATTRIBUTE15                   VARCHAR2(4000)              
        ,CREATED_BY                    VARCHAR2(4000)              
        ,CREATION_DATE                 TIMESTAMP(6) WITH TIME ZONE 
        ,LAST_UPDATED_BY               VARCHAR2(4000)              
        ,LAST_UPDATED_DATE             TIMESTAMP(6) WITH TIME ZONE              
        ,OIC_INSTANCE_ID               VARCHAR2(4000)              
    );

    TYPE TBL_CHM_MSI_SPA_CONTACT IS TABLE OF REC_CHM_MSI_SPA_CONTACT;

    PROCEDURE MERGE_SPA_CONTACT_DATA (
         P_IN_CHM_MSI_SPA_CONTACT       IN TBL_CHM_MSI_SPA_CONTACT
        ,P_IN_OIC_INSTANCE_ID           IN VARCHAR2
    );


END CHM_MSI_SPA_CONTACTS_PKG;
/

