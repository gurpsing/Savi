CREATE OR REPLACE PACKAGE BODY CHM_DIST_ACCOUNTS_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_DIST_ACCOUNTS_PKG                                                                                                                 *
    * Purpose                        : Package Body for CHM Distributor acconts sync from fusion                                                                             *
    * Created By                     : Mahender Kumar                                                                                                                        *
    * Created Date                   : 19-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 21-Jun-2023   Mahender Kumar                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    --Procedure to merge distributor account data received from fusion
    PROCEDURE MERGE_DATA (
        P_IN_DIST_ACCOUNTS    IN TBL_DIST_ACCOUNTS,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,               ----- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_DIST_ACCOUNTS.FIRST..P_IN_DIST_ACCOUNTS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_DIST_ACCOUNTS TBL
                USING (
                    SELECT
                        P_IN_DIST_ACCOUNTS(I).PARTY_ID                     PARTY_ID,
                        P_IN_DIST_ACCOUNTS(I).CUST_ACCOUNT_ID              CUST_ACCOUNT_ID,
                        P_IN_DIST_ACCOUNTS(I).PARTY_NUMBER                 PARTY_NUMBER,
                        P_IN_DIST_ACCOUNTS(I).PARTY_NAME                   PARTY_NAME,
                        P_IN_DIST_ACCOUNTS(I).SFDC_KEY                     SFDC_KEY,
                        P_IN_DIST_ACCOUNTS(I).ACCOUNT_NUMBER               ACCOUNT_NUMBER,
                        P_IN_DIST_ACCOUNTS(I).ACCOUNT_NAME                 ACCOUNT_NAME,
                        P_IN_DIST_ACCOUNTS(I).CUSTOMER_CLASS_CODE          CUSTOMER_CLASS_CODE,
                        P_IN_DIST_ACCOUNTS(I).ACCOUNT_TERMINATION_DATE     ACCOUNT_TERMINATION_DATE,
                        P_IN_DIST_ACCOUNTS(I).PARTY_STATUS                 PARTY_STATUS,
                        P_IN_DIST_ACCOUNTS(I).ACCOUNT_STATUS               ACCOUNT_STATUS,
                        P_IN_DIST_ACCOUNTS(I).ENE_SALESPERSON              ENE_SALESPERSON,
                        P_IN_DIST_ACCOUNTS(I).ENE_SALESPERSON_EMAIL        ENE_SALESPERSON_EMAIL,
                        P_IN_DIST_ACCOUNTS(I).SALESOPS_OWNER_ACCOUNT_LEVEL SALESOPS_OWNER_ACCOUNT_LEVEL,
                        P_IN_DIST_ACCOUNTS(I).CUST_CREDIT_LIMIT            CUST_CREDIT_LIMIT,
                        P_IN_DIST_ACCOUNTS(I).CUST_CREDIT_LIMIT_CURR       CUST_CREDIT_LIMIT_CURR,
                        P_IN_DIST_ACCOUNTS(I).CREDIT_LIMIT_USED            CREDIT_LIMIT_USED,
                        P_IN_DIST_ACCOUNTS(I).PARTY_CREATION_DATE          PARTY_CREATION_DATE,
                        P_IN_DIST_ACCOUNTS(I).PARTY_CREATED_BY             PARTY_CREATED_BY,
                        P_IN_DIST_ACCOUNTS(I).PARTY_LAST_UPDATE_DATE       PARTY_LAST_UPDATE_DATE,
                        P_IN_DIST_ACCOUNTS(I).PARTY_LAST_UPDATED_BY        PARTY_LAST_UPDATED_BY,
                        P_IN_DIST_ACCOUNTS(I).ACCT_CREATION_DATE           ACCT_CREATION_DATE,
                        P_IN_DIST_ACCOUNTS(I).ACCT_CREATED_BY              ACCT_CREATED_BY,
                        P_IN_DIST_ACCOUNTS(I).ACCT_LAST_UPDATE_DATE        ACCT_LAST_UPDATE_DATE,
                        P_IN_DIST_ACCOUNTS(I).ACCT_LAST_UPDATED_BY         ACCT_LAST_UPDATED_BY,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE1                   ATTRIBUTE1,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE2                   ATTRIBUTE2,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE3                   ATTRIBUTE3,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE4                   ATTRIBUTE4,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE5                   ATTRIBUTE5,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE6                   ATTRIBUTE6,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE7                   ATTRIBUTE7,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE8                   ATTRIBUTE8,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE9                   ATTRIBUTE9,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE10                  ATTRIBUTE10,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE11                  ATTRIBUTE11,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE12                  ATTRIBUTE12,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE13                  ATTRIBUTE13,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE14                  ATTRIBUTE14,
                        P_IN_DIST_ACCOUNTS(I).ATTRIBUTE15                  ATTRIBUTE15,
                        P_IN_DIST_ACCOUNTS(I).OIC_RUN_ID                   OIC_RUN_ID,
                        P_IN_DIST_ACCOUNTS(I).IS_SEEDED                    IS_SEEDED,
                        P_IN_DIST_ACCOUNTS(I).ENABLED_FLAG                 ENABLED_FLAG,
                        P_IN_DIST_ACCOUNTS(I).START_DATE_ACTIVE            START_DATE_ACTIVE,
                        P_IN_DIST_ACCOUNTS(I).END_DATE_ACTIVE              END_DATE_ACTIVE,
                        P_IN_DIST_ACCOUNTS(I).CREATED_BY                   CREATED_BY,
                        P_IN_DIST_ACCOUNTS(I).CREATION_DATE                CREATION_DATE,
                        P_IN_DIST_ACCOUNTS(I).LAST_UPDATED_BY              LAST_UPDATED_BY,
                        P_IN_DIST_ACCOUNTS(I).LAST_UPDATE_DATE             LAST_UPDATE_DATE
                    FROM
                        DUAL
                ) TMP ON ( TBL.PARTY_ID = TMP.PARTY_ID
                           AND TBL.CUST_ACCOUNT_ID = TMP.CUST_ACCOUNT_ID )
                WHEN NOT MATCHED THEN
                INSERT (
                    PARTY_ID,
                    CUST_ACCOUNT_ID,
                    PARTY_NUMBER,
                    PARTY_NAME,
                    SFDC_KEY,
                    ACCOUNT_NUMBER,
                    ACCOUNT_NAME,
                    CUSTOMER_CLASS_CODE,
                    ACCOUNT_TERMINATION_DATE,
                    PARTY_STATUS,
                    ACCOUNT_STATUS,
                    ENE_SALESPERSON,
                    ENE_SALESPERSON_EMAIL,
                    SALESOPS_OWNER_ACCOUNT_LEVEL,
                    CUST_CREDIT_LIMIT,
                    CUST_CREDIT_LIMIT_CURR,
                    CREDIT_LIMIT_USED,
                    PARTY_CREATION_DATE,
                    PARTY_CREATED_BY,
                    PARTY_LAST_UPDATE_DATE,
                    PARTY_LAST_UPDATED_BY,
                    ACCT_CREATION_DATE,
                    ACCT_CREATED_BY,
                    ACCT_LAST_UPDATE_DATE,
                    ACCT_LAST_UPDATED_BY,
                    ATTRIBUTE1,
                    ATTRIBUTE2,
                    ATTRIBUTE3,
                    ATTRIBUTE4,
                    ATTRIBUTE5,
                    ATTRIBUTE6,
                    ATTRIBUTE7,
                    ATTRIBUTE8,
                    ATTRIBUTE9,
                    ATTRIBUTE10,
                    ATTRIBUTE11,
                    ATTRIBUTE12,
                    ATTRIBUTE13,
                    ATTRIBUTE14,
                    ATTRIBUTE15,
                    OIC_RUN_ID,
                    IS_SEEDED,
                    ENABLED_FLAG,
                    START_DATE_ACTIVE,
                    END_DATE_ACTIVE,
                    CREATED_BY,
                    CREATION_DATE,
                    LAST_UPDATED_BY,
                    LAST_UPDATE_DATE )
                VALUES
                    ( TMP.PARTY_ID,
                      TMP.CUST_ACCOUNT_ID,
                      TMP.PARTY_NUMBER,
                      TMP.PARTY_NAME,
                      TMP.SFDC_KEY,
                      TMP.ACCOUNT_NUMBER,
                      TMP.ACCOUNT_NAME,
                      TMP.CUSTOMER_CLASS_CODE,
                      TMP.ACCOUNT_TERMINATION_DATE,
                      TMP.PARTY_STATUS,
                      TMP.ACCOUNT_STATUS,
                      TMP.ENE_SALESPERSON,
                      TMP.ENE_SALESPERSON_EMAIL,
                      TMP.SALESOPS_OWNER_ACCOUNT_LEVEL,
                      TMP.CUST_CREDIT_LIMIT,
                      TMP.CUST_CREDIT_LIMIT_CURR,
                      TMP.CREDIT_LIMIT_USED,
                      TMP.PARTY_CREATION_DATE,
                      TMP.PARTY_CREATED_BY,
                      TMP.PARTY_LAST_UPDATE_DATE,
                      TMP.PARTY_LAST_UPDATED_BY,
                      TMP.ACCT_CREATION_DATE,
                      TMP.ACCT_CREATED_BY,
                      TMP.ACCT_LAST_UPDATE_DATE,
                      TMP.ACCT_LAST_UPDATED_BY,
                      TMP.ATTRIBUTE1,
                      TMP.ATTRIBUTE2,
                      TMP.ATTRIBUTE3,
                      TMP.ATTRIBUTE4,
                      TMP.ATTRIBUTE5,
                      TMP.ATTRIBUTE6,
                      TMP.ATTRIBUTE7,
                      TMP.ATTRIBUTE8,
                      TMP.ATTRIBUTE9,
                      TMP.ATTRIBUTE10,
                      TMP.ATTRIBUTE11,
                      TMP.ATTRIBUTE12,
                      TMP.ATTRIBUTE13,
                      TMP.ATTRIBUTE14,
                      TMP.ATTRIBUTE15,
                      TMP.OIC_RUN_ID,
                      TMP.IS_SEEDED,
                      TMP.ENABLED_FLAG,
                      TMP.START_DATE_ACTIVE,
                      TMP.END_DATE_ACTIVE,
                      TMP.CREATED_BY,
                      TMP.CREATION_DATE,
                      TMP.LAST_UPDATED_BY,
                      TMP.LAST_UPDATE_DATE )
                WHEN MATCHED THEN UPDATE
                SET PARTY_NUMBER = TMP.PARTY_NUMBER,
                    PARTY_NAME = TMP.PARTY_NAME,
                    SFDC_KEY = TMP.SFDC_KEY,
                    ACCOUNT_NUMBER = TMP.ACCOUNT_NUMBER,
                    ACCOUNT_NAME = TMP.ACCOUNT_NAME,
                    CUSTOMER_CLASS_CODE = TMP.CUSTOMER_CLASS_CODE,
                    ACCOUNT_TERMINATION_DATE = TMP.ACCOUNT_TERMINATION_DATE,
                    PARTY_STATUS = TMP.PARTY_STATUS,
                    ACCOUNT_STATUS = TMP.ACCOUNT_STATUS,
                    ENE_SALESPERSON = TMP.ENE_SALESPERSON,
                    ENE_SALESPERSON_EMAIL = TMP.ENE_SALESPERSON_EMAIL,
                    SALESOPS_OWNER_ACCOUNT_LEVEL = TMP.SALESOPS_OWNER_ACCOUNT_LEVEL,
                    CUST_CREDIT_LIMIT = TMP.CUST_CREDIT_LIMIT,
                    CUST_CREDIT_LIMIT_CURR = TMP.CUST_CREDIT_LIMIT_CURR,
                    CREDIT_LIMIT_USED = TMP.CREDIT_LIMIT_USED,
                    PARTY_CREATION_DATE = TMP.PARTY_CREATION_DATE,
                    PARTY_CREATED_BY = TMP.PARTY_CREATED_BY,
                    PARTY_LAST_UPDATE_DATE = TMP.PARTY_LAST_UPDATE_DATE,
                    PARTY_LAST_UPDATED_BY = TMP.PARTY_LAST_UPDATED_BY,
                    ACCT_CREATION_DATE = TMP.ACCT_CREATION_DATE,
                    ACCT_CREATED_BY = TMP.ACCT_CREATED_BY,
                    ACCT_LAST_UPDATE_DATE = TMP.ACCT_LAST_UPDATE_DATE,
                    ACCT_LAST_UPDATED_BY = TMP.ACCT_LAST_UPDATED_BY,
                    ATTRIBUTE1 = TMP.ATTRIBUTE1,
                    ATTRIBUTE2 = TMP.ATTRIBUTE2,
                    ATTRIBUTE3 = TMP.ATTRIBUTE3,
                    ATTRIBUTE4 = TMP.ATTRIBUTE4,
                    ATTRIBUTE5 = TMP.ATTRIBUTE5,
                    ATTRIBUTE6 = TMP.ATTRIBUTE6,
                    ATTRIBUTE7 = TMP.ATTRIBUTE7,
                    ATTRIBUTE8 = TMP.ATTRIBUTE8,
                    ATTRIBUTE9 = TMP.ATTRIBUTE9,
                    ATTRIBUTE10 = TMP.ATTRIBUTE10,
                    ATTRIBUTE11 = TMP.ATTRIBUTE11,
                    ATTRIBUTE12 = TMP.ATTRIBUTE12,
                    ATTRIBUTE13 = TMP.ATTRIBUTE13,
                    ATTRIBUTE14 = TMP.ATTRIBUTE14,
                    ATTRIBUTE15 = TMP.ATTRIBUTE15,
                    OIC_RUN_ID = TMP.OIC_RUN_ID,
                    LAST_UPDATED_BY = TMP.LAST_UPDATED_BY,
                    LAST_UPDATE_DATE = TMP.LAST_UPDATE_DATE
                WHERE
                        1 = 1
                    AND PARTY_ID = TMP.PARTY_ID
                    AND CUST_ACCOUNT_ID = TMP.CUST_ACCOUNT_ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;


                EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;

        END LOOP;

        P_OUT_RECORDS_FETCHED := L_COUNT;
        P_OUT_RECORDS_MERGED := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE := SUBSTR(L_ERROR_MESSAGE, 1, 4000);
    END MERGE_DATA;

END CHM_DIST_ACCOUNTS_PKG;
/