create or replace PACKAGE CHM_INSTALLER_PKG
    
    /**************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                         *
    * Package Name                   : CHM_INSTALLER_PKG                                                                      *
    * Purpose                        : Package for CHM Installer Integrations                                                 *
    * Created By                     : Gurpreet Singh                                                                         *
    * Created Date                   : 30-Aug-2023                                                                            *     
    ***************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                  * 
    * -----------   ---------------------------    ---------------------------      -------------    -------------------------*
    * 30-Aug-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version           * 
    * 11-Sep-2024   Gurpreet Singh                 Transform Edge                   2.0              For Setting Merge Status *  
    * 25-Sep-2024   Gurpreet Singh                 Transform Edge                   3.0              Addition of new fields   *
    * 20-Nov-2024   Dhivagar                        Transform Edge                  3.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar 
    * 05-March-2025  Raja                                                           4.0             Adding New Field Bank_Details_Flag
    **************************************************************************************************************************/

AS

    TYPE REC_ACCOUNT IS RECORD (
         SFDC_ACCOUNT_ID             VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_NAME                VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_STATUS              VARCHAR2(4000)      DEFAULT NULL
        ,CUSTOMER_KEY                VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_TYPE                VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_OWNER               VARCHAR2(4000)      DEFAULT NULL
        ,ENLIGHTEN_INSTALLER_ID      VARCHAR2(4000)      DEFAULT NULL
        ,PARENT_ACCOUNT              VARCHAR2(4000)      DEFAULT NULL
        ,PARENT_ACCOUNT_ID           VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_RECORD_TYPE         VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_OWNER_ALIAS         VARCHAR2(4000)      DEFAULT NULL
        ,GEOGRAPHY                   VARCHAR2(4000)      DEFAULT NULL
        ,TERRITORY                   VARCHAR2(4000)      DEFAULT NULL
        ,SUB_TERRITORY               VARCHAR2(4000)      DEFAULT NULL
        ,ENLIGHTEN_COMPANY_ID        VARCHAR2(4000)      DEFAULT NULL
        ,ENLIGHTEN_INSTALLER_FLAG    VARCHAR2(4000)      DEFAULT NULL
        ,BILLING_STREET              VARCHAR2(4000)      DEFAULT NULL
        ,BILLING_CITY                VARCHAR2(4000)      DEFAULT NULL
        ,BILLING_STATE               VARCHAR2(4000)      DEFAULT NULL
        ,BILLING_ZIP                 VARCHAR2(4000)      DEFAULT NULL
        ,SHIPPING_STREET             VARCHAR2(4000)      DEFAULT NULL
        ,SHIPPING_CITY               VARCHAR2(4000)      DEFAULT NULL
        ,SHIPPING_STATE              VARCHAR2(4000)      DEFAULT NULL
        ,SHIPPING_ZIP                VARCHAR2(4000)      DEFAULT NULL
        ,COUNTRY                     VARCHAR2(4000)      DEFAULT NULL
        ,BILLING_COUNTRY             VARCHAR2(4000)      DEFAULT NULL
        ,SHIPPING_COUNTRY            VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_CURRENCY            VARCHAR2(4000)      DEFAULT NULL
        ,RELATIONSHIP                VARCHAR2(4000)      DEFAULT NULL
        ,ORACLE_CUSTOMER_NUMBER      VARCHAR2(4000)      DEFAULT NULL
        ,ACCOUNT_OWNER_ID            VARCHAR2(4000)      DEFAULT NULL
        ,CI_SYNC_FLAG	             VARCHAR2(4000)      DEFAULT NULL
        ,REGION	                     VARCHAR2(4000)      DEFAULT NULL
        ,APPROVAL_GEOGRAPHY	         VARCHAR2(4000)      DEFAULT NULL
        ,FORECASTABLE_ACCOUNT	     VARCHAR2(4000)      DEFAULT NULL
        ,CHM_C                       VARCHAR2(4000)      DEFAULT NULL           --added for v3.0
        ,MERGE_ID_C                  VARCHAR2(4000)      DEFAULT NULL           --added for v3.0
        ,ENLIGHTEN_COMPANY_DUP_KEY_C VARCHAR2(4000)      DEFAULT NULL           --added for v3.0
        ,SFDC_CREATED_BY             VARCHAR2(4000)      DEFAULT NULL
        ,SFDC_CREATION_DATE          TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
        ,SFDC_LAST_UPDATED_BY        VARCHAR2(4000)                 DEFAULT NULL
        ,SFDC_LAST_UPDATE_DATE       TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
        ,CREATED_BY                  VARCHAR2(4000)                 DEFAULT NULL
        ,CREATION_DATE               TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
        ,LAST_UPDATED_BY             VARCHAR2(4000)                 DEFAULT NULL
        ,LAST_UPDATE_DATE            TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
		,BANK_DETAILS_FLAG           VARCHAR2(4000)      DEFAULT NULL           --added for v4.0
    );

    TYPE TBL_ACCOUNT IS TABLE OF REC_ACCOUNT;

    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_ACCOUNT			        IN      TBL_ACCOUNT
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2        ---- V3.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );

    /* Changes for v2.0 starts */

    --Procedure to merge data into CHM table
    PROCEDURE TRUNCATE_MASTER_KEY_TBL(
         P_IN_OIC_INSTANCE_ID            IN      VARCHAR2       ------ V3.1
        ,P_OUT_ERROR_MESSAGE             OUT     VARCHAR2
    );


    TYPE REC_ACCOUNT_KEY IS RECORD (
         SFDC_ACCOUNT_ID             VARCHAR2(4000)      DEFAULT NULL
        ,SFDC_CREATED_BY             VARCHAR2(4000)      DEFAULT NULL
        ,SFDC_CREATION_DATE          TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
        ,SFDC_LAST_UPDATED_BY        VARCHAR2(4000)                 DEFAULT NULL
        ,SFDC_LAST_UPDATE_DATE       TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
        ,CREATED_BY                  VARCHAR2(4000)      DEFAULT NULL
        ,CREATION_DATE               TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
        ,LAST_UPDATED_BY             VARCHAR2(4000)                 DEFAULT NULL
        ,LAST_UPDATE_DATE            TIMESTAMP(6) WITH TIME ZONE    DEFAULT NULL
    );

    TYPE TBL_ACCOUNT_KEY IS TABLE OF REC_ACCOUNT_KEY;

    --Procedure to merge data into CHM table
    PROCEDURE MERGE_ACCOUNT_KEY_DATA(
         P_IN_ACCOUNT_KEYS			    IN      TBL_ACCOUNT_KEY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );

    --Procedure to setting Merged status
    PROCEDURE SET_MERGED_STATUS(
         P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_SYNCED_RECORDS           OUT     NUMBER
        ,P_OUT_MERGED_INSTALLERS        OUT     NUMBER
        ,P_OUT_UNIQUE_INSTALLERS        OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );

    /* Changes for v2.0 ends */

END CHM_INSTALLER_PKG;