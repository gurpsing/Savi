CREATE TABLE CHM_MSI_SELF_BILLING_TBL
(
    CHM_MSI_SELF_BILLING_ID         NUMBER  GENERATED ALWAYS AS IDENTITY
    ,INVOICE_ID                     NUMBER
    ,INVOICE_NUMBER                 VARCHAR2(4000)
    ,TO_EMAIL                       VARCHAR2(4000)
    ,EMAIL_SENT_DATE                DATE
    ,EMAIL_SENT_FLAG                CHAR(1) DEFAULT 'N'
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