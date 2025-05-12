CREATE SEQUENCE CHM_INTEGRATION_SEQ             INCREMENT BY 1 MINVALUE 1;

CREATE TABLE CHM_INTEGRATIONS(
     CHM_INTEGRATION_ID         NUMBER    DEFAULT CHM_INTEGRATION_SEQ.NEXTVAL PRIMARY KEY
    ,IDENTIFIER                 VARCHAR2(4000)      NOT NULL UNIQUE
    ,NAME                       VARCHAR2(4000)      NOT NULL UNIQUE
    ,DESCRIPTION                VARCHAR2(4000)   
    ,SOURCE                     VARCHAR2(4000)      NOT NULL
    ,TARGET                     VARCHAR2(4000)      NOT NULL
    ,FREQUENCY                  VARCHAR2(4000)      NOT NULL
    ,LAST_RUN_ID                NUMBER        
    ,LAST_RUN_DATE              DATE        
    ,LAST_RUN_STATUS            VARCHAR2(4000)        
    ,OUTAGE_FLAG                CHAR(1)             DEFAULT 'N'
    ,ENABLED_FLAG               CHAR(1)             DEFAULT 'Y'
    ,START_DATE_ACTIVE          DATE                DEFAULT SYSDATE
    ,END_DATE_ACTIVE            DATE         
    ,IS_SEEDED                  CHAR(1)             DEFAULT 'N'
    ,ATTRIBUTE1                 VARCHAR2(4000)   
    ,ATTRIBUTE2                 VARCHAR2(4000)   
    ,ATTRIBUTE3                 VARCHAR2(4000)   
    ,ATTRIBUTE4                 VARCHAR2(4000)   
    ,ATTRIBUTE5                 VARCHAR2(4000)   
    ,ATTRIBUTE6                 VARCHAR2(4000)   
    ,ATTRIBUTE7                 VARCHAR2(4000)   
    ,ATTRIBUTE8                 VARCHAR2(4000)   
    ,ATTRIBUTE9                 VARCHAR2(4000)   
    ,ATTRIBUTE10                VARCHAR2(4000)   
    ,CREATED_BY                 VARCHAR2(4000)      DEFAULT 'SEED_DATA'
    ,CREATION_DATE              DATE                DEFAULT SYSDATE
    ,LAST_UPDATED_BY            VARCHAR2(4000)      DEFAULT 'SEED_DATA'
    ,LAST_UPDATE_DATE           DATE                DEFAULT SYSDATE
); 