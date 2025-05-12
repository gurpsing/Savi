CREATE OR REPLACE PACKAGE CHM_DIST_SITE_USES_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_DIST_SITE_USES_PKG                                                                                                                *
    * Purpose                        : Package Specification for CHM Distributor Site and Site uses sync from fusion                                                         *
    * Created By                     : Mahender Kumar                                                                                                                        *
    * Created Date                   : 19-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 21-Jun-2023   Mahender Kumar                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    TYPE REC_CHM_DIST_SITE_USES IS RECORD (
            PARTY_ID                   NUMBER,
            CUST_ACCOUNT_ID            NUMBER,
            PARTY_SITE_ID              NUMBER,
            CUST_ACCT_SITE_ID          NUMBER,
            SITE_USE_ID                NUMBER,
            LOCATION_ID                NUMBER,
            PARTY_NUMBER               VARCHAR2(4000),
            PARTY_NAME                 VARCHAR2(4000),
            SFDC_KEY                   VARCHAR2(4000),
            ACCOUNT_NUMBER             VARCHAR2(4000),
            ACCOUNT_NAME               VARCHAR2(4000),
            CUSTOMER_CLASS_CODE        VARCHAR2(4000),
            PARTY_SITE_NUMBER          VARCHAR2(4000),
            ACCOUNT_TERMINATION_DATE   VARCHAR2(4000),
            LOCATION                   VARCHAR2(4000),
            SITE_USE_CODE              VARCHAR2(4000),
            PRIMARY_FLAG               VARCHAR2(4000),
            ADDRESS1                   VARCHAR2(4000),
            ADDRESS2                   VARCHAR2(4000),
            ADDRESS3                   VARCHAR2(4000),
            ADDRESS4                   VARCHAR2(4000),
            CITY                       VARCHAR2(4000),
            STATE                      VARCHAR2(4000),
            COUNTY                     VARCHAR2(4000),
            PROVINCE                   VARCHAR2(4000),
            COUNTRY                    VARCHAR2(4000),
            POSTAL_CODE                VARCHAR2(4000),
            PARTY_SITE_STATUS          VARCHAR2(4000),
            CUST_ACCOUNT_SITES_STATUS  VARCHAR2(4000),
            CUST_SITE_USES_STATUS      VARCHAR2(4000),
            EDI_LOCATION_CODE          VARCHAR2(4000),
            SALESOPS_OWNER_SITE_LEVEL  VARCHAR2(4000),
            SITE_CREATION_DATE         VARCHAR2(4000),
            SITE_CREATED_BY            VARCHAR2(4000),
            SITE_LAST_UPDATE_DATE      VARCHAR2(4000),
            SITE_LAST_UPDATED_BY       VARCHAR2(4000),
            SITE_USE_CREATION_DATE     VARCHAR2(4000),
            SITE_USE_CREATED_BY        VARCHAR2(4000),
            SITE_USE_LAST_UPDATE_DATE  VARCHAR2(4000),
            SITE_USE_LAST_UPDATED_BY   VARCHAR2(4000),
            CUST_SITE_CREATION_DATE    VARCHAR2(4000),
            CUST_SITE_CREATED_BY       VARCHAR2(4000),
            CUST_SITE_LAST_UPDATE_DATE VARCHAR2(4000),
            CUST_SITE_LAST_UPDATED_BY  VARCHAR2(4000),
            LOC_CREATION_DATE          VARCHAR2(4000),
            LOC_CREATED_BY             VARCHAR2(4000),
            LOC_LAST_UPDATE_DATE       VARCHAR2(4000),
            LOC_LAST_UPDATED_BY        VARCHAR2(4000),
            ATTRIBUTE1                 VARCHAR2(4000),
            ATTRIBUTE2                 VARCHAR2(4000),
            ATTRIBUTE3                 VARCHAR2(4000),
            ATTRIBUTE4                 VARCHAR2(4000),
            ATTRIBUTE5                 VARCHAR2(4000),
            ATTRIBUTE6                 VARCHAR2(4000),
            ATTRIBUTE7                 VARCHAR2(4000),
            ATTRIBUTE8                 VARCHAR2(4000),
            ATTRIBUTE9                 VARCHAR2(4000),
            ATTRIBUTE10                VARCHAR2(4000),
            ATTRIBUTE11                VARCHAR2(4000),
            ATTRIBUTE12                VARCHAR2(4000),
            ATTRIBUTE13                VARCHAR2(4000),
            ATTRIBUTE14                VARCHAR2(4000),
            ATTRIBUTE15                VARCHAR2(4000),
            OIC_RUN_ID                 VARCHAR2(4000),
            IS_SEEDED                  CHAR(1),
            ENABLED_FLAG               CHAR(1),
            START_DATE_ACTIVE          DATE,
            END_DATE_ACTIVE            DATE,
            CREATED_BY                 VARCHAR2(4000),
            CREATION_DATE              DATE,
            LAST_UPDATED_BY            VARCHAR2(4000),
            LAST_UPDATE_DATE           DATE,
            SET_ID                     NUMBER,
            BU_ID                      NUMBER,
            LEGAL_ENTITY_ID            NUMBER,
            PRIMARY_LEDGER_ID          NUMBER,
            BU_NAME                    VARCHAR2(4000),
            SHORT_CODE                 VARCHAR2(4000)
    );
    
    TYPE TBL_CHM_DIST_SITE_USES IS TABLE OF REC_CHM_DIST_SITE_USES;
 --Procedure to merge distributor sites and site uses data received from fusion   
    PROCEDURE MERGE_DATA (
        P_IN_CHM_DIST_SITE_USES IN TBL_CHM_DIST_SITE_USES,
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2,                ------ V1.1
        P_OUT_RECORDS_FETCHED   OUT NUMBER,
        P_OUT_RECORDS_MERGED    OUT NUMBER,
        P_OUT_ERROR_MESSAGE     OUT VARCHAR2
    );

END CHM_DIST_SITE_USES_PKG;
/