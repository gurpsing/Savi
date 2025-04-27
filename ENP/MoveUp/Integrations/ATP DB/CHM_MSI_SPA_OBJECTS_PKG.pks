create or replace PACKAGE CHM_MSI_SPA_OBJECTS_PKG

/*******************************************************************************************************
* Type                           : PL/SQL Package Specification                                        *
* Package Name                   : CHM_MSI_SPA_OBJECTS_PKG                                         *
* Purpose                        : Package Specification for MSI SPA OBJECTS sync from SFDC  *
* Created By                     : Raja Ratnakar Reddy                                                      *
* Created Date                   : 21-Mar-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 21-Mar-2025   Raja Ratnakar Reddy                  1.0              Intial Version                         * 
*******************************************************************************************************/

AS

    TYPE REC_CHM_MSI_SPA_UNIT_ACTIVATIONS IS RECORD (                     
        ID                                      VARCHAR2(4000)              
        ,MIN_QUANTITY                           NUMBER                      
        ,SPA                                    VARCHAR2(4000)              
        ,STATUS                                 VARCHAR2(4000)              
        ,SFDC_CREATED_DATE                      TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_LAST_UPDATE_DATE                  TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_CREATED_BY                        VARCHAR2(4000)              
        ,SFDC_LAST_UPDATED_BY                   VARCHAR2(4000)              
        ,ATTRIBUTE_CONTEXT                      VARCHAR2(4000)              
        ,ATTRIBUTE1                             VARCHAR2(4000)              
        ,ATTRIBUTE2                             VARCHAR2(4000)              
        ,ATTRIBUTE3                             VARCHAR2(4000)              
        ,ATTRIBUTE4                             VARCHAR2(4000)              
        ,ATTRIBUTE5                             VARCHAR2(4000)              
        ,ATTRIBUTE6                             VARCHAR2(4000)              
        ,ATTRIBUTE7                             VARCHAR2(4000)              
        ,ATTRIBUTE8                             VARCHAR2(4000)              
        ,ATTRIBUTE9                             VARCHAR2(4000)              
        ,ATTRIBUTE10                            VARCHAR2(4000)              
        ,ATTRIBUTE11                            VARCHAR2(4000)              
        ,ATTRIBUTE12                            VARCHAR2(4000)              
        ,ATTRIBUTE13                            VARCHAR2(4000)              
        ,ATTRIBUTE14                            VARCHAR2(4000)              
        ,ATTRIBUTE15                            VARCHAR2(4000)              
        ,CREATED_BY                             VARCHAR2(4000)              
        ,CREATION_DATE                          TIMESTAMP(6) WITH TIME ZONE 
        ,LAST_UPDATED_BY                        VARCHAR2(4000)              
        ,LAST_UPDATED_DATE                      TIMESTAMP(6) WITH TIME ZONE               
        ,OIC_INSTANCE_ID                        VARCHAR2(4000)
        ,IS_DELETED                             VARCHAR2(4000)              
        ,NAME                                   VARCHAR2(4000)              
        ,CURRENCY_ISO_CODE                      VARCHAR2(4000)              
        ,SYSTEM_MOD_STAMP                       VARCHAR2(4000)              
        ,LAST_ACTIVITY_DATE                     VARCHAR2(4000)              
        ,LAST_VIEWED_DATE                       VARCHAR2(4000)              
        ,LAST_REFERENCED_DATE                   VARCHAR2(4000)              
        ,PER_UNIT_INCENTIVE                     NUMBER(12,2)              
        ,PRODUCT                                VARCHAR2(4000)              
        ,UNIQUE_KEY                             VARCHAR2(4000) 
    );

    TYPE TBL_CHM_MSI_SPA_UNIT_ACTIVATIONS IS TABLE OF REC_CHM_MSI_SPA_UNIT_ACTIVATIONS;

    PROCEDURE MERGE_SPA_UNIT_ACTIVATION_DATA (
         P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS IN TBL_CHM_MSI_SPA_UNIT_ACTIVATIONS
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    );

    TYPE REC_CHM_MSI_SPA_SYSTEM_ATTACHMENTS IS RECORD (                     
         ID                                  VARCHAR2(4000)              
        ,MIN_QUANTITY                        NUMBER                      
        ,STATUS                              VARCHAR2(4000)              
        ,SFDC_CREATED_DATE                   TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_LAST_UPDATE_DATE               TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_CREATED_BY                     VARCHAR2(4000)              
        ,SFDC_LAST_UPDATED_BY                VARCHAR2(4000)              
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
        ,OIC_INSTANCE_ID                     VARCHAR2(4000)  
        ,IS_DELETED                          VARCHAR2(4000)              
        ,NAME                                VARCHAR2(4000)              
        ,CURRENCY_ISO_CODE                   VARCHAR2(4000)              
        ,SYSTEM_MOD_STAMP                    VARCHAR2(4000)              
        ,LAST_ACTIVITY_DATE                  VARCHAR2(4000)              
        ,LAST_VIEWED_DATE                    VARCHAR2(4000)              
        ,LAST_REFERENCED_DATE                VARCHAR2(4000)              
        ,SPA                                 VARCHAR2(4000)              
        ,UNIQUE_KEY                          VARCHAR2(4000)              
        ,PRODUCT                             VARCHAR2(4000)  
        ,PER_UNIT_INCENTIVE                  NUMBER(12,2) 
    );

    TYPE TBL_CHM_MSI_SPA_SYSTEM_ATTACHMENTS IS TABLE OF REC_CHM_MSI_SPA_SYSTEM_ATTACHMENTS;

    PROCEDURE MERGE_SPA_SYSTEM_ATTACHMENTS_DATA (
        P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS IN TBL_CHM_MSI_SPA_SYSTEM_ATTACHMENTS
        ,P_IN_OIC_INSTANCE_ID               IN VARCHAR2
    );	

    TYPE REC_CHM_MSI_SYS_SIZE_INCENTIVE IS RECORD (                    
         ID                            VARCHAR2(4000)              
        ,TIER1_REBATE_AMOUNT           NUMBER                      
        ,TIER2_REBATE_AMOUNT           NUMBER                      
        ,TIER3_REBATE_AMOUNT           NUMBER                      
        ,TIER4_REBATE_AMOUNT           NUMBER                      
        ,TIER5_REBATE_AMOUNT           NUMBER                      
        ,STATUS                        VARCHAR2(4000)              
        ,SFDC_CREATED_DATE             TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_LAST_UPDATE_DATE         TIMESTAMP(6) WITH TIME ZONE 
        ,SFDC_CREATED_BY               VARCHAR2(4000)              
        ,SFDC_LAST_UPDATED_BY          VARCHAR2(4000)              
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
        ,IS_DELETED                    VARCHAR2(4000)              
        ,NAME                          VARCHAR2(4000)              
        ,CURRENCY_ISO_CODE             VARCHAR2(4000)              
        ,SYSTEM_MOD_STAMP              VARCHAR2(4000)              
        ,LAST_ACTIVITY_DATE            VARCHAR2(4000)              
        ,LAST_VIEWED_DATE              VARCHAR2(4000)              
        ,LAST_REFERENCED_DATE          VARCHAR2(4000)              
        ,SPA                           VARCHAR2(4000)              
        ,UNIQUE_KEY                    VARCHAR2(4000)              
        ,PRODUCT                       VARCHAR2(4000)
    );

    TYPE TBL_CHM_MSI_SYS_SIZE_INCENTIVE IS TABLE OF REC_CHM_MSI_SYS_SIZE_INCENTIVE;

    PROCEDURE MERGE_SPA_SYS_SIZE_INCENTIVE_DATA (
         P_IN_CHM_MSI_SYS_SIZE_INCENTIVE IN TBL_CHM_MSI_SYS_SIZE_INCENTIVE
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    );

    TYPE REC_CHM_MSI_SYS_SIZE_INCENTIVE_CHM IS RECORD (                    
         ID                                   VARCHAR2(4000)             
        ,TIER_NAME                            VARCHAR2(4000)             
        ,MIN_QTY                              NUMBER                     
        ,MAX_QTY                              NUMBER                     
        ,UNIT_REBATE_AMOUNT                   NUMBER                     
        ,SFDC_CREATED_DATE                    TIMESTAMP(6) WITH TIME ZONE
        ,SFDC_LAST_UPDATE_DATE                TIMESTAMP(6) WITH TIME ZONE
        ,SFDC_CREATED_BY                      VARCHAR2(4000)             
        ,SFDC_LAST_UPDATED_BY                 VARCHAR2(4000)              
        ,ATTRIBUTE_CONTEXT                    VARCHAR2(4000)              
        ,ATTRIBUTE1                           VARCHAR2(4000)              
        ,ATTRIBUTE2                           VARCHAR2(4000)              
        ,ATTRIBUTE3                           VARCHAR2(4000)              
        ,ATTRIBUTE4                           VARCHAR2(4000)              
        ,ATTRIBUTE5                           VARCHAR2(4000)              
        ,ATTRIBUTE6                           VARCHAR2(4000)              
        ,ATTRIBUTE7                           VARCHAR2(4000)              
        ,ATTRIBUTE8                           VARCHAR2(4000)              
        ,ATTRIBUTE9                           VARCHAR2(4000)              
        ,ATTRIBUTE10                          VARCHAR2(4000)              
        ,ATTRIBUTE11                          VARCHAR2(4000)              
        ,ATTRIBUTE12                          VARCHAR2(4000)              
        ,ATTRIBUTE13                          VARCHAR2(4000)              
        ,ATTRIBUTE14                          VARCHAR2(4000)              
        ,ATTRIBUTE15                          VARCHAR2(4000)              
        ,CREATED_BY                           VARCHAR2(4000)              
        ,CREATION_DATE                        TIMESTAMP(6) WITH TIME ZONE 
        ,LAST_UPDATED_BY                      VARCHAR2(4000)              
        ,LAST_UPDATED_DATE                    TIMESTAMP(6) WITH TIME ZONE              
        ,OIC_INSTANCE_ID       				  VARCHAR2(4000)
        ,IS_DELETED                           VARCHAR2(4000)     
        ,NAME                                 VARCHAR2(4000)
        ,CURRENCY_ISO_CODE                    VARCHAR2(4000)
        ,SYSTEM_MOD_STAMP                     VARCHAR2(4000)
        ,LAST_ACTIVITY_DATE                   VARCHAR2(4000)
        ,LAST_VIEWED_DATE                     VARCHAR2(4000)
        ,LAST_REFERENCED_DATE                 VARCHAR2(4000)
        ,SPA                                  VARCHAR2(4000)
        ,TIER_INCENTIVE                       NUMBER(12,2)
        ,PRODUCT                              VARCHAR2(4000)
        ,STATUS                              VARCHAR2(4000)
    );

    TYPE TBL_CHM_MSI_SYS_SIZE_INCENTIVE_CHM IS TABLE OF REC_CHM_MSI_SYS_SIZE_INCENTIVE_CHM;

    PROCEDURE MERGE_CHM_MSI_SYS_SIZE_INCENTIVE_CHM_DATA(
         P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM IN TBL_CHM_MSI_SYS_SIZE_INCENTIVE_CHM
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
	);								

    

END CHM_MSI_SPA_OBJECTS_PKG;
/
