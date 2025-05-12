CREATE TABLE CHM_INTEGRATION_RUNS(
     CHM_INTEGRATION_RUN_ID     VARCHAR2(4000)              PRIMARY KEY
    ,INTEGRATION_IDENTIFIER     VARCHAR2(4000)
    ,PHASE                      VARCHAR2(4000)      DEFAULT 'Running'
    ,STATUS                     VARCHAR2(4000)      DEFAULT 'Normal'
    ,LAST_COMPLETED_STAGE       VARCHAR2(4000)      
    ,ERROR_MESSAGE              VARCHAR2(4000)      
    ,LOG                        CLOB
    ,START_DATE                 DATE                DEFAULT SYSDATE
    ,COMPLETION_DATE            DATE         
    ,TOTAL_FETCHED_RECORDS      NUMBER
    ,TOTAL_SUCCESS_RECORDS      NUMBER
    ,TOTAL_ERROR_RECORDS        NUMBER
    ,JIRA_TICKET                VARCHAR2(4000)   
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
    ,CREATED_BY                 VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,CREATION_DATE              DATE                DEFAULT SYSDATE
    ,LAST_UPDATED_BY            VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,LAST_UPDATE_DATE           DATE                DEFAULT SYSDATE
);