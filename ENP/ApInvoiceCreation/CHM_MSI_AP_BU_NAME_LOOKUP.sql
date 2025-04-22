CREATE TABLE CHM_MSI_AP_BU_NAME_LOOKUP
(
     CHM_MSI_AP_BU_NAME_LOOKUP_ID   NUMBER  GENERATED ALWAYS AS IDENTITY
    ,SEQ                            NUMBER
    ,LOOKUP_CODE                    VARCHAR2(4000) PRIMARY KEY
    ,MEANING                        VARCHAR2(4000)
    ,DESCRIPTION                    VARCHAR2(4000)
    ,TAG                            VARCHAR2(4000)
    ,ENABLED_FLAG                   VARCHAR2(4000)
    ,START_DATE_ACTIVE              DATE
    ,END_DATE_ACTIVE                DATE
    ,FUSION_CREATED_BY              VARCHAR2(4000)
    ,FUSION_CREATION_DATE           VARCHAR2(4000)
    ,FUSION_LAST_UPDATED_BY         VARCHAR2(4000)
    ,FUSION_LAST_UPDATE_DATE        VARCHAR2(4000)
    ,ATTRIBUTE1                     VARCHAR2(4000) 
    ,ATTRIBUTE2                     VARCHAR2(4000) 
    ,ATTRIBUTE3                     VARCHAR2(4000) 
    ,ATTRIBUTE4                     VARCHAR2(4000) 
    ,ATTRIBUTE5                     VARCHAR2(4000) 
    ,ATTRIBUTE6                     VARCHAR2(4000) 
    ,ATTRIBUTE7                     VARCHAR2(4000) 
    ,ATTRIBUTE8                     VARCHAR2(4000) 
    ,ATTRIBUTE9                     VARCHAR2(4000) 
    ,ATTRIBUTE10                    VARCHAR2(4000)
    ,OIC_INSTANCE_ID                VARCHAR2(4000)
    ,CREATION_DATE                  DATE
    ,CREATED_BY                     VARCHAR2(4000)
    ,LAST_UPDATE_DATE               DATE
    ,LAST_UPDATED_BY                VARCHAR2(4000)
);
