create or replace PACKAGE CHM_SPA_MASTER_HDR_LINE_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE                                                                                                                        *
    * PACKAGE NAME                   : CHM_SPA_MASTER_HDR_LINE_PKG                                                                                                                 *
    * PURPOSE                        : PACKAGE FOR CHM SPA MASTER HEADER AND LINES SYNC FROM SALES FORCE                                                                                  *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 29-AUG-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 29-AUG-2023   MAHENDER KUMAR                  TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS

TYPE REC_SPA_MASTER_LINE_NEW IS RECORD (
        LINE_ITEM_NUMBER                     VARCHAR2(4000),
        QUANTITY                             VARCHAR2(4000),
        SALES_PRICE                          VARCHAR2(4000),
        SALES_PRICE_CURRENCY                 VARCHAR2(4000),
        REBATE                               VARCHAR2(4000),
        REBATE_CURRENCY                      VARCHAR2(4000),
        LIST_PRICE                           VARCHAR2(4000),
        LIST_PRICE_CURRENCY                  VARCHAR2(4000),
        RECOMMENDED_INSTALLER_PRICE          VARCHAR2(4000),
        RECOMMENDED_INSTALLER_PRICE_CURRENCY VARCHAR2(4000),
        DISTRIBUTOR_MARGIN                   VARCHAR2(4000),
        APPROVED_LIST_PRICE_CURRENCY         VARCHAR2(4000),
        APPROVED_LIST_PRICE                  VARCHAR2(4000),
        CREATED_DATE                         VARCHAR2(4000),
        CREATED_BY                           VARCHAR2(4000),
        UPDATE_DATE                          VARCHAR2(4000),
        UPDATE_BY                            VARCHAR2(4000),
        PRODUCT_NUMBER                       VARCHAR2(4000),
        ENPHASE_PART_NUMBER                  VARCHAR2(4000),
        RECOMMENDED_INSTALLER_PRICING        VARCHAR2(4000),
        UOM_CODE                             VARCHAR2(4000),
        PRODUCT_NAME                         VARCHAR2(4000),
        SPA_LINE_CREATION_DATE               VARCHAR2(4000),
        SPA_LINE_CREATED_BY                  VARCHAR2(4000),
        SPA_LINE_LAST_UPDATED_BY             VARCHAR2(4000),
        SPA_LINE_LAST_MODIFIED_DATE          VARCHAR2(4000)
);

TYPE TBL_SPA_MASTER_LINE_NEW IS TABLE OF REC_SPA_MASTER_LINE_NEW;

TYPE REC_SPA_MASTER_HDR_NEW IS Record (
        SPA_NUMBER                    VARCHAR2(4000),
        SPA_NAME                      VARCHAR2(4000),
        OPPORTUNITY_NAME              VARCHAR2(4000),
        OPPORTUNITY_OWNER             VARCHAR2(4000),
        ACCOUNT_NAME                  VARCHAR2(4000),
        CUSTOMER_KEY                  VARCHAR2(4000),
        GEOGRAPHY                     VARCHAR2(4000),
        STAGE                         VARCHAR2(4000),
        STATUS                        VARCHAR2(4000),
        SPECIAL_PRICING_TYPE          VARCHAR2(4000),
        DEAL_CATEGORY                 VARCHAR2(4000),
        SPA_BACK_DATED                VARCHAR2(4000),
        SPA_START_DATE                VARCHAR2(4000),
        EXPIRATION_DATE               VARCHAR2(4000),
        SPA__CREATED_DATE             VARCHAR2(4000),
        SPA__TOTAL_PRICE              VARCHAR2(4000),
        SPA__TOTAL_PRICE_CURRENCY     VARCHAR2(4000),
        CREATED_DATE                  VARCHAR2(4000),
        CREATED_BY                    VARCHAR2(4000),
        UPDATE_DATE                   VARCHAR2(4000),
        UPDATE_BY                     VARCHAR2(4000),
        PRIMARY_PARTNER               VARCHAR2(4000),
        DEAL_LOGISTICS                VARCHAR2(4000),
        FINAL_APPROVAL_TIME           VARCHAR2(4000),
        SPA_TYPE                      VARCHAR2(4000),
        ID                            VARCHAR2(4000),
        OPPORTUNITY_OWNER_ID          VARCHAR2(4000),
        SPA_OPPORTUNITY_ID            VARCHAR2(4000),
        ACCOUNT_ID                    VARCHAR2(4000),
        NEW_RENEWAL                   VARCHAR2(4000),
        DISTRIBUTOR_ACCOUNT_NAME      VARCHAR2(4000),
        DISTRIBUTOR_SFDC_ID           VARCHAR2(4000),
        DISTRIBUTOR_ORACLE_ACCOUNT_ID VARCHAR2(4000),
        DISTRIBUTOR_SFDC_CUSTOMER_KEY VARCHAR2(4000),
        SPA_LAST_UPDATE_DATE          VARCHAR2(4000),
        SPA_CREATED_BY                VARCHAR2(4000),
        SPA_LAST_UPDATED_BY           VARCHAR2(4000),
        SPA_FINAL_APPROVAL_DATE_TIME  VARCHAR2(4000),
        SPA_MASTER_LINE               TBL_SPA_MASTER_LINE_NEW
);

    TYPE TBL_SPA_MASTER_HDR_NEW IS TABLE OF REC_SPA_MASTER_HDR_NEW;
--PROCEDURE TO MERGE SPA MASTER HEADER DATA RECEIVED FROM FUSION
    PROCEDURE MERGE_DATA (
        P_IN_SPA_MASTER_HDR   IN TBL_SPA_MASTER_HDR_NEW,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,             ----------- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    );
END CHM_SPA_MASTER_HDR_LINE_PKG;
/
