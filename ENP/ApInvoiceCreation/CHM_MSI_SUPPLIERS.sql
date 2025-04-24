CREATE TABLE CHM_MSI_SUPPLIERS
(
     CHM_MSI_SUPPLIER_ID   NUMBER  GENERATED ALWAYS AS IDENTITY
    ,INSTALLER_NUMBER               VARCHAR2(4000) 
    ,SUPPLIER_NUMBER                VARCHAR2(4000)
    ,SUPPLIER_NAME                  VARCHAR2(4000)
    ,SUPPLIER_SITE                  VARCHAR2(4000)
    ,SUPPLIER_ID                    NUMBER
    ,SUPPLIER_SITE_ID               NUMBER PRIMARY KEY
    ,BU_ID                          NUMBER
    ,BU_NAME                        VARCHAR2(4000)
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