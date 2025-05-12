create or replace PACKAGE CHM_MSI_SPA_HEADER_PKG 
/*******************************************************************************************************
* Type                           : PL/SQL Package Specification                                        *
* Package Name                   : CHM_MSI_SPA_HEADER_PKG                                         *
* Purpose                        : Package Specification for MSI SPA HEADER sync from fusion  *
* Created By                     : Raja Ratnakar Reddy                                                      *
* Created Date                   : 10-Mar-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 10-Mar-2025   Raja Ratnakar Reddy                  1.0              Intial Version                         * 
*******************************************************************************************************/

AS

TYPE REC_CHM_MSI_SPA_HEADER IS RECORD (
                      
 SPA_NUMBER                          VARCHAR2(4000)              
,OPPORTUNITY_OWNER                   VARCHAR2(4000)              
,INSTALLER_ACCOUNT_NAME              VARCHAR2(4000)              
,INSTALLER_CUSTOMER_KEY              VARCHAR2(4000)              
,PRIMARY_PARTNER                     VARCHAR2(4000)              
,SPA_NAME                            VARCHAR2(4000)              
,GEOGRAPHY                           VARCHAR2(4000)              
,STAGE                               VARCHAR2(4000)              
,OPPORTUNITY_NAME                    VARCHAR2(4000)              
,DEAL_LOGISTICS                      VARCHAR2(4000)              
,STATUS                              VARCHAR2(4000)              
,SPECIAL_PRICING_TYPE                VARCHAR2(4000)              
,FINAL_APPROVAL_TIME                 VARCHAR2(4000)              
,SPA_START_DATE                      TIMESTAMP(6) WITH TIME ZONE 
,SPA_EXPIRATION_DATE                 TIMESTAMP(6) WITH TIME ZONE 
,DEAL_CATEGORY                       VARCHAR2(4000)              
,SPA_TOTAL_PRICE_CURRENCY            VARCHAR2(4000)              
,SPA_TOTAL_PRICE                     NUMBER                      
,SPA_CREATED_DATE                    TIMESTAMP(6) WITH TIME ZONE 
,SPA_TYPE                            VARCHAR2(4000)              
,SPA_BACK_DATED                      VARCHAR2(4000)              
,ID                                  VARCHAR2(4000)              
,OPPORTUNITY_OWNER_ID                VARCHAR2(4000)              
,SPA_OPPORTUNITY_ID                  VARCHAR2(4000)              
,ACCOUNT_ID                          VARCHAR2(4000)              
,NEW_RENEWAL                         VARCHAR2(4000)              
,DISTRIBUTOR_ACCOUNT_NAME            VARCHAR2(4000)              
,DISTRIBUTOR_SFDC_ID                 VARCHAR2(4000)              
,DISTRIBUTOR_ORACLE_ACCOUNT_ID       VARCHAR2(4000)              
,DISTRIBUTOR_SFDC_CUSTOMER_KEY       VARCHAR2(4000)              
,SPA_LAST_UPDATE_DATE                TIMESTAMP(6) WITH TIME ZONE 
,SPA_CREATED_BY                      VARCHAR2(4000)              
,SPA_LAST_UPDATED_BY                 VARCHAR2(4000)              
,SPA_FINAL_APPROVAL_DATE_TIME        TIMESTAMP(6) WITH TIME ZONE 
,SPA_CONTACT                         VARCHAR2(4000)              
,SPA_TIERS                           NUMBER                      
,TIER1_MIN                           NUMBER                      
,TIER2_MIN                           NUMBER                      
,TIER3_MIN                           NUMBER                      
,TIER4_MIN                           NUMBER                      
,TIER5_MIN                           NUMBER                      
,TIER1_MAX                           NUMBER                      
,TIER2_MAX                           NUMBER                      
,TIER3_MAX                           NUMBER                      
,TIER4_MAX                           NUMBER                      
,TIER5_MAX                           NUMBER                      
,ATTRIBUTE_CONTEXT                   VARCHAR2(4000)              
,ATTRIBUTE1                          VARCHAR2(4000)              
,ATTRIBUTE2                          VARCHAR2(4000)              
,ATTRIBUTE3                          VARCHAR2(4000)              
,ATTRIBUTE4                          VARCHAR2(4000)              
,ATTRIBUTE5                          VARCHAR2(4000)              
,ATTRIBUTE6                          VARCHAR2(4000)              
,ATTRIBUTE7                          VARCHAR2(4000)              
,ATTRIBUTE8                          VARCHAR2(4000)              
,ATTRIBUTE9                          VARCHAR2(4000)              
,ATTRIBUTE10                         VARCHAR2(4000)              
,ATTRIBUTE11                         VARCHAR2(4000)              
,ATTRIBUTE12                         VARCHAR2(4000)              
,ATTRIBUTE13                         VARCHAR2(4000)              
,ATTRIBUTE14                         VARCHAR2(4000)              
,ATTRIBUTE15                         VARCHAR2(4000)              
,CREATED_BY                          VARCHAR2(4000)              
,CREATION_DATE                       TIMESTAMP(6) WITH TIME ZONE 
,LAST_UPDATED_BY                     VARCHAR2(4000)              
,LAST_UPDATED_DATE                   TIMESTAMP(6) WITH TIME ZONE            
,OIC_INSTANCE_ID       				VARCHAR2(4000)
    );

TYPE TBL_CHM_MSI_SPA_HEADER IS TABLE OF REC_CHM_MSI_SPA_HEADER;


PROCEDURE MERGE_SPA_HEADER_DATA(P_IN_CHM_MSI_SPA_HEADER IN TBL_CHM_MSI_SPA_HEADER
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2);
									
END CHM_MSI_SPA_HEADER_PKG;
/
