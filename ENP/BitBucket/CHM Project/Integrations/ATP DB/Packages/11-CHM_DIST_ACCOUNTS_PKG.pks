CREATE OR REPLACE PACKAGE CHM_DIST_ACCOUNTS_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                                       *
    * Package Name                   : CHM_DIST_ACCOUNTS_PKG                                                                                                                 *
    * Purpose                        : Package Specification for CHM Distributor acconts sync from fusion                                                                                  *
    * Created By                     : Mahender Kumar                                                                                                                        *
    * Created Date                   : 21-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 21-Jun-2023   Mahender Kumar                  Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    TYPE REC_DIST_ACCOUNTS IS RECORD (
            PARTY_ID                     NUMBER,
            CUST_ACCOUNT_ID              NUMBER,
            PARTY_NUMBER                 VARCHAR2(4000),
            PARTY_NAME                   VARCHAR2(4000),
            SFDC_KEY                     VARCHAR2(4000),
            ACCOUNT_NUMBER               VARCHAR2(4000),
            ACCOUNT_NAME                 VARCHAR2(4000),
            CUSTOMER_CLASS_CODE          VARCHAR2(4000),
            ACCOUNT_TERMINATION_DATE     VARCHAR2(4000),
            PARTY_STATUS                 VARCHAR2(4000),
            ACCOUNT_STATUS               VARCHAR2(4000),
            ENE_SALESPERSON              VARCHAR2(4000),
            ENE_SALESPERSON_EMAIL        VARCHAR2(4000),
            SALESOPS_OWNER_ACCOUNT_LEVEL VARCHAR2(4000),
            CUST_CREDIT_LIMIT            VARCHAR2(4000),
            CUST_CREDIT_LIMIT_CURR       VARCHAR2(4000),
            CREDIT_LIMIT_USED            VARCHAR2(4000),
            PARTY_CREATION_DATE          VARCHAR2(4000),
            PARTY_CREATED_BY             VARCHAR2(4000),
            PARTY_LAST_UPDATE_DATE       VARCHAR2(4000),
            PARTY_LAST_UPDATED_BY        VARCHAR2(4000),
            ACCT_CREATION_DATE           VARCHAR2(4000),
            ACCT_CREATED_BY              VARCHAR2(4000),
            ACCT_LAST_UPDATE_DATE        VARCHAR2(4000),
            ACCT_LAST_UPDATED_BY         VARCHAR2(4000),
            ATTRIBUTE1                   VARCHAR2(4000),
            ATTRIBUTE2                   VARCHAR2(4000),
            ATTRIBUTE3                   VARCHAR2(4000),
            ATTRIBUTE4                   VARCHAR2(4000),
            ATTRIBUTE5                   VARCHAR2(4000),
            ATTRIBUTE6                   VARCHAR2(4000),
            ATTRIBUTE7                   VARCHAR2(4000),
            ATTRIBUTE8                   VARCHAR2(4000),
            ATTRIBUTE9                   VARCHAR2(4000),
            ATTRIBUTE10                  VARCHAR2(4000),
            ATTRIBUTE11                  VARCHAR2(4000),
            ATTRIBUTE12                  VARCHAR2(4000),
            ATTRIBUTE13                  VARCHAR2(4000),
            ATTRIBUTE14                  VARCHAR2(4000),
            ATTRIBUTE15                  VARCHAR2(4000),
            OIC_RUN_ID                   VARCHAR2(4000),
            IS_SEEDED                    CHAR(1),
            ENABLED_FLAG                 CHAR(1),
            START_DATE_ACTIVE            DATE,
            END_DATE_ACTIVE              DATE,
            CREATED_BY                   VARCHAR2(4000),
            CREATION_DATE                DATE,
            LAST_UPDATED_BY              VARCHAR2(4000),
            LAST_UPDATE_DATE             DATE
    );
   
    TYPE TBL_DIST_ACCOUNTS IS TABLE OF REC_DIST_ACCOUNTS;
--Procedure to merge distributor account data received from fusion
    PROCEDURE MERGE_DATA (
        P_IN_DIST_ACCOUNTS    IN TBL_DIST_ACCOUNTS,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,           ----- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    );

END CHM_DIST_ACCOUNTS_PKG;
/
