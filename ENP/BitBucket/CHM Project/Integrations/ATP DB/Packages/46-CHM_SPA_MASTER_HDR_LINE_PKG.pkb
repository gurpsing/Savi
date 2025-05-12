create or replace PACKAGE BODY CHM_SPA_MASTER_HDR_LINE_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE BODY                                                                                                                   *
    * PACKAGE NAME                   : CHM_SPA_MASTER_HDR_LINE_PKG                                                                                                           *
    * PURPOSE                        : PACKAGE BODY FOR CHM SPA MASTER HEADER SYNC FROM SALES FORCE                                                                          *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 29-AUG-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 29-AUG-2023   MAHENDER KUMAR                 TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-JUN-2023   GURPREET SINGH                 TRANSFORM EDGE                   1.1              Fix for failing lines due foreign key and raising tickets               *
    *                                                                                                when merge fails                                                        *    
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    --PROCEDURE TO MERGE SPA MASTER HEADER DATA RECEIVED FROM FUSION
    PROCEDURE MERGE_DATA (
        P_IN_SPA_MASTER_HDR   IN TBL_SPA_MASTER_HDR_NEW,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,             ------------ V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    ) AS

        L_COUNT               NUMBER := 0;
        L_MERGE_COUNT         NUMBER := 0;
        L_ERROR_MESSAGE       VARCHAR2(30000);
        L_CHM_SPA_ID          NUMBER;
        L_CHM_SPA_LINE_ID     NUMBER;
        L_SPA_MASTER_LINE_TBL TBL_SPA_MASTER_LINE_NEW := TBL_SPA_MASTER_LINE_NEW();
        L_SPA_NUMBER VARCHAR2(4000); 
        L_LINE_NUMBER VARCHAR2(4000); 
    BEGIN
        FOR I IN P_IN_SPA_MASTER_HDR.FIRST..P_IN_SPA_MASTER_HDR.LAST LOOP
            L_SPA_MASTER_LINE_TBL := TBL_SPA_MASTER_LINE_NEW();
            L_SPA_MASTER_LINE_TBL := P_IN_SPA_MASTER_HDR(I).SPA_MASTER_LINE;
           -- L_COUNT := L_COUNT + 1;
          L_SPA_NUMBER:= P_IN_SPA_MASTER_HDR(I).SPA_NUMBER ;
            BEGIN
                SELECT
                    CHM_SPA_HEADER_S.NEXTVAL
                INTO L_CHM_SPA_ID
                FROM
                    DUAL;

                MERGE INTO CHM_SPA_HEADER TBL
                USING (
                    SELECT
                        P_IN_SPA_MASTER_HDR(I).SPA_NUMBER                    SPA_NUMBER,
                        P_IN_SPA_MASTER_HDR(I).SPA_NAME                      SPA_NAME,
                        P_IN_SPA_MASTER_HDR(I).OPPORTUNITY_NAME              OPPORTUNITY_NAME,
                        P_IN_SPA_MASTER_HDR(I).OPPORTUNITY_OWNER             OPPORTUNITY_OWNER,
                        P_IN_SPA_MASTER_HDR(I).ACCOUNT_NAME                  ACCOUNT_NAME,
                        P_IN_SPA_MASTER_HDR(I).CUSTOMER_KEY                  CUSTOMER_KEY,
                        P_IN_SPA_MASTER_HDR(I).GEOGRAPHY                     GEOGRAPHY,
                        P_IN_SPA_MASTER_HDR(I).STAGE                         STAGE,
                        P_IN_SPA_MASTER_HDR(I).STATUS                        STATUS,
                        P_IN_SPA_MASTER_HDR(I).SPECIAL_PRICING_TYPE          SPECIAL_PRICING_TYPE,
                        P_IN_SPA_MASTER_HDR(I).DEAL_CATEGORY                 DEAL_CATEGORY,
                        P_IN_SPA_MASTER_HDR(I).SPA_BACK_DATED                SPA_BACK_DATED,
                        P_IN_SPA_MASTER_HDR(I).SPA_START_DATE                SPA_START_DATE,
                        P_IN_SPA_MASTER_HDR(I).EXPIRATION_DATE               EXPIRATION_DATE,
                        P_IN_SPA_MASTER_HDR(I).SPA__CREATED_DATE             SPA__CREATED_DATE,
                        P_IN_SPA_MASTER_HDR(I).SPA__TOTAL_PRICE              SPA__TOTAL_PRICE,
                        P_IN_SPA_MASTER_HDR(I).SPA__TOTAL_PRICE_CURRENCY     SPA__TOTAL_PRICE_CURRENCY,
                        P_IN_SPA_MASTER_HDR(I).CREATED_DATE                  CREATED_DATE,
                        P_IN_SPA_MASTER_HDR(I).CREATED_BY                    CREATED_BY,
                        P_IN_SPA_MASTER_HDR(I).UPDATE_DATE                   UPDATE_DATE,
                        P_IN_SPA_MASTER_HDR(I).UPDATE_BY                     UPDATE_BY,
                        P_IN_SPA_MASTER_HDR(I).PRIMARY_PARTNER               PRIMARY_PARTNER,
                        P_IN_SPA_MASTER_HDR(I).DEAL_LOGISTICS                DEAL_LOGISTICS,
                        P_IN_SPA_MASTER_HDR(I).FINAL_APPROVAL_TIME           FINAL_APPROVAL_TIME,
                        P_IN_SPA_MASTER_HDR(I).SPA_TYPE                      SPA_TYPE,
                        P_IN_SPA_MASTER_HDR(I).ID                            ID,
                        P_IN_SPA_MASTER_HDR(I).OPPORTUNITY_OWNER_ID          OPPORTUNITY_OWNER_ID,
                        P_IN_SPA_MASTER_HDR(I).SPA_OPPORTUNITY_ID            SPA_OPPORTUNITY_ID,
                        P_IN_SPA_MASTER_HDR(I).ACCOUNT_ID                    ACCOUNT_ID,
                        P_IN_SPA_MASTER_HDR(I).NEW_RENEWAL                   NEW_RENEWAL,
                        P_IN_SPA_MASTER_HDR(I).DISTRIBUTOR_ACCOUNT_NAME      DISTRIBUTOR_ACCOUNT_NAME,
                        P_IN_SPA_MASTER_HDR(I).DISTRIBUTOR_SFDC_ID           DISTRIBUTOR_SFDC_ID,
                        P_IN_SPA_MASTER_HDR(I).DISTRIBUTOR_ORACLE_ACCOUNT_ID DISTRIBUTOR_ORACLE_ACCOUNT_ID,
                        P_IN_SPA_MASTER_HDR(I).DISTRIBUTOR_SFDC_CUSTOMER_KEY DISTRIBUTOR_SFDC_CUSTOMER_KEY,
                        P_IN_SPA_MASTER_HDR(I).SPA_LAST_UPDATE_DATE          SPA_LAST_UPDATE_DATE,
                        P_IN_SPA_MASTER_HDR(I).SPA_CREATED_BY                SPA_CREATED_BY,
                        P_IN_SPA_MASTER_HDR(I).SPA_LAST_UPDATED_BY           SPA_LAST_UPDATED_BY,
                        P_IN_SPA_MASTER_HDR(I).SPA_FINAL_APPROVAL_DATE_TIME  SPA_FINAL_APPROVAL_DATE_TIME
                    FROM
                        DUAL
                ) TMP ON ( TBL.SPA_NUMBER = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
                    CHM_SPA_ID,
                    SPA_NUMBER,
                    SPA_NAME,
                    OPPORTUNITY_NAME,
                    OPPORTUNITY_OWNER,
                    INSTALLER_ACCOUNT_NAME,
                    INSTALLER_CUSTOMER_KEY,
                    GEOGRAPHY,
                    STAGE,
                    STATUS,
                    SPECIAL_PRICING_TYPE,
                    DEAL_CATEGORY,
                    SPA_BACK_DATED,
                    SPA_START_DATE,
                    SPA_EXPIRATION_DATE,
                    SPA_CREATED_DATE,
                    SPA_TOTAL_PRICE,
                    SPA_TOTAL_PRICE_CURRENCY,
                    CREATION_DATE,
                    CREATED_BY,
                    LAST_UPDATE_DATE,
                    LAST_UPDATED_BY,
                    PRIMARY_PARTNER,
                    DEAL_LOGISTICS,
                    FINAL_APPROVAL_TIME,
                    SPA_TYPE,
                    ID,
                    OPPORTUNITY_OWNER_ID,
                    SPA_OPPORTUNITY_ID,
                    ACCOUNT_ID,
                    NEW_RENEWAL,
                    DISTRIBUTOR_ACCOUNT_NAME,
                    DISTRIBUTOR_SFDC_ID,
                    DISTRIBUTOR_ORACLE_ACCOUNT_ID,
                    DISTRIBUTOR_SFDC_CUSTOMER_KEY,
                    SPA_LAST_UPDATE_DATE,
                    SPA_CREATED_BY,
                    SPA_LAST_UPDATED_BY,
                    SPA_FINAL_APPROVAL_DATE_TIME,
                    ATTRIBUTE1

                    )
                VALUES
                    ( L_CHM_SPA_ID,
                      TMP.SPA_NUMBER,
                      TMP.SPA_NAME,
                      TMP.OPPORTUNITY_NAME,
                      TMP.OPPORTUNITY_OWNER,
                      TMP.ACCOUNT_NAME,
                      TMP.CUSTOMER_KEY,
                      TMP.GEOGRAPHY,
                      TMP.STAGE,
                      TMP.STATUS,
                      TMP.SPECIAL_PRICING_TYPE,
                      TMP.DEAL_CATEGORY,
                      TMP.SPA_BACK_DATED,
                      TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA_START_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                      TO_TIMESTAMP_TZ(to_timestamp(TMP.EXPIRATION_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                      TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA__CREATED_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                      to_number(TMP.SPA__TOTAL_PRICE),
                      TMP.SPA__TOTAL_PRICE_CURRENCY,
                      TO_TIMESTAMP_TZ(to_timestamp(TMP.CREATED_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                      TMP.CREATED_BY,
                      TO_TIMESTAMP_TZ(to_timestamp(TMP.UPDATE_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                      TMP.UPDATE_BY,
                      TMP.PRIMARY_PARTNER,
                      TMP.DEAL_LOGISTICS,
                      TO_TIMESTAMP_TZ(to_timestamp(TMP.FINAL_APPROVAL_TIME , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                      TMP.SPA_TYPE,
                      TMP.ID,
                      TMP.OPPORTUNITY_OWNER_ID,
                      TMP.SPA_OPPORTUNITY_ID,
                      TMP.ACCOUNT_ID,
                      TMP.NEW_RENEWAL,
                      TMP.DISTRIBUTOR_ACCOUNT_NAME,
                      TMP.DISTRIBUTOR_SFDC_ID,
                      TMP.DISTRIBUTOR_ORACLE_ACCOUNT_ID,
                      TMP.DISTRIBUTOR_SFDC_CUSTOMER_KEY,
                      TMP.SPA_LAST_UPDATE_DATE,
                      TMP.SPA_CREATED_BY,
                      TMP.SPA_LAST_UPDATED_BY,
                      TMP.SPA_FINAL_APPROVAL_DATE_TIME,
                      P_IN_OIC_INSTANCE_ID)

                WHEN MATCHED THEN UPDATE
                SET SPA_NAME = TMP.SPA_NAME,
                    OPPORTUNITY_NAME = TMP.OPPORTUNITY_NAME,
                    OPPORTUNITY_OWNER = TMP.OPPORTUNITY_OWNER,
                    INSTALLER_ACCOUNT_NAME = TMP.ACCOUNT_NAME,
                    INSTALLER_CUSTOMER_KEY = TMP.CUSTOMER_KEY,
                    GEOGRAPHY = TMP.GEOGRAPHY,
                    STAGE = TMP.STAGE,
                    STATUS = TMP.STATUS,
                    SPECIAL_PRICING_TYPE = TMP.SPECIAL_PRICING_TYPE,
                    DEAL_CATEGORY = TMP.DEAL_CATEGORY,
                    SPA_BACK_DATED = TMP.SPA_BACK_DATED,
                    SPA_START_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA_START_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    SPA_EXPIRATION_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.EXPIRATION_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    SPA_CREATED_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA__CREATED_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    SPA_TOTAL_PRICE = to_number(TMP.SPA__TOTAL_PRICE),
                    SPA_TOTAL_PRICE_CURRENCY = TMP.SPA__TOTAL_PRICE_CURRENCY,
--                    CREATION_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.CREATED_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
--                    CREATED_BY = TMP.CREATED_BY,
                    LAST_UPDATE_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.UPDATE_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    LAST_UPDATED_BY = TMP.UPDATE_BY,
                    PRIMARY_PARTNER = TMP.PRIMARY_PARTNER,
                    DEAL_LOGISTICS = TMP.DEAL_LOGISTICS,
                    FINAL_APPROVAL_TIME = TO_TIMESTAMP_TZ(to_timestamp(TMP.FINAL_APPROVAL_TIME , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    SPA_TYPE = TMP.SPA_TYPE,
                    ID = TMP.ID,
                    OPPORTUNITY_OWNER_ID = TMP.OPPORTUNITY_OWNER_ID,
                    SPA_OPPORTUNITY_ID = TMP.SPA_OPPORTUNITY_ID,
                    ACCOUNT_ID = TMP.ACCOUNT_ID,
                    NEW_RENEWAL = TMP.NEW_RENEWAL,
                    DISTRIBUTOR_ACCOUNT_NAME = TMP.DISTRIBUTOR_ACCOUNT_NAME,
                    DISTRIBUTOR_SFDC_ID = TMP.DISTRIBUTOR_SFDC_ID,
                    DISTRIBUTOR_ORACLE_ACCOUNT_ID = TMP.DISTRIBUTOR_ORACLE_ACCOUNT_ID,
                    DISTRIBUTOR_SFDC_CUSTOMER_KEY = TMP.DISTRIBUTOR_SFDC_CUSTOMER_KEY,
                    SPA_LAST_UPDATE_DATE = TMP.SPA_LAST_UPDATE_DATE,
                    SPA_CREATED_BY = TMP.SPA_CREATED_BY,
                    SPA_LAST_UPDATED_BY = TMP.SPA_LAST_UPDATED_BY,
                    SPA_FINAL_APPROVAL_DATE_TIME = TMP.SPA_FINAL_APPROVAL_DATE_TIME,
                    ATTRIBUTE1 = P_IN_OIC_INSTANCE_ID
                WHERE
                        1 = 1
                    AND SPA_NUMBER = TMP.SPA_NUMBER;

                SELECT CHM_SPA_ID INTO L_CHM_SPA_ID FROM CHM_SPA_HEADER WHERE SPA_NUMBER = P_IN_SPA_MASTER_HDR(I).SPA_NUMBER;  --added for v1.1

            EXCEPTION
                WHEN OTHERS THEN
                    BEGIN
                        L_ERROR_MESSAGE := L_ERROR_MESSAGE
                                           || CHR(10)
                                           || CHR(9)
                                           ||'SPA Header ['||L_SPA_NUMBER||']'
                                           || SQLERRM;


                    EXCEPTION
                        WHEN OTHERS THEN
                            NULL;
                    END;
                    RAISE_APPLICATION_ERROR(-20001,'Error occurred while merging SPA Header:  '||substr(L_ERROR_MESSAGE,1,4000));   --added for v1.1
            END;
            COMMIT;

            IF L_SPA_MASTER_LINE_TBL.COUNT > 0 THEN
                FOR J IN L_SPA_MASTER_LINE_TBL.FIRST..L_SPA_MASTER_LINE_TBL.LAST LOOP
                L_COUNT := L_COUNT + 1;
                L_LINE_NUMBER := L_SPA_MASTER_LINE_TBL(J).LINE_ITEM_NUMBER ;
                    BEGIN
                        SELECT
                            CHM_SPA_LINES_S.NEXTVAL
                        INTO L_CHM_SPA_LINE_ID
                        FROM
                            DUAL;

                        MERGE INTO CHM_SPA_LINES TBL
                        USING (
                            SELECT
                                L_SPA_MASTER_LINE_TBL(J).LINE_ITEM_NUMBER                     LINE_ITEM_NUMBER,
                                L_SPA_MASTER_LINE_TBL(J).QUANTITY                             QUANTITY,
                                L_SPA_MASTER_LINE_TBL(J).SALES_PRICE                          SALES_PRICE,
                                L_SPA_MASTER_LINE_TBL(J).SALES_PRICE_CURRENCY                 SALES_PRICE_CURRENCY,
                                L_SPA_MASTER_LINE_TBL(J).REBATE                               REBATE,
                                L_SPA_MASTER_LINE_TBL(J).REBATE_CURRENCY                      REBATE_CURRENCY,
                                L_SPA_MASTER_LINE_TBL(J).LIST_PRICE                           LIST_PRICE,
                                L_SPA_MASTER_LINE_TBL(J).LIST_PRICE_CURRENCY                  LIST_PRICE_CURRENCY,
                                L_SPA_MASTER_LINE_TBL(J).RECOMMENDED_INSTALLER_PRICE          RECOMMENDED_INSTALLER_PRICE,
                                L_SPA_MASTER_LINE_TBL(J).RECOMMENDED_INSTALLER_PRICE_CURRENCY RECOMMENDED_INSTALLER_PRICE_CURRENCY,
                                L_SPA_MASTER_LINE_TBL(J).DISTRIBUTOR_MARGIN                   DISTRIBUTOR_MARGIN,
                                L_SPA_MASTER_LINE_TBL(J).APPROVED_LIST_PRICE_CURRENCY         APPROVED_LIST_PRICE_CURRENCY,
                                L_SPA_MASTER_LINE_TBL(J).APPROVED_LIST_PRICE                  APPROVED_LIST_PRICE,
                                L_SPA_MASTER_LINE_TBL(J).CREATED_DATE                         CREATED_DATE,        
                                L_SPA_MASTER_LINE_TBL(J).CREATED_BY                           CREATED_BY,
                                L_SPA_MASTER_LINE_TBL(J).UPDATE_DATE                          UPDATE_DATE,
                                L_SPA_MASTER_LINE_TBL(J).UPDATE_BY                            UPDATE_BY,
                                L_SPA_MASTER_LINE_TBL(J).PRODUCT_NUMBER                       PRODUCT_NUMBER,
                                L_SPA_MASTER_LINE_TBL(J).ENPHASE_PART_NUMBER                  ENPHASE_PART_NUMBER,
                                L_SPA_MASTER_LINE_TBL(J).RECOMMENDED_INSTALLER_PRICING        RECOMMENDED_INSTALLER_PRICING,
                                L_SPA_MASTER_LINE_TBL(J).UOM_CODE                             UOM_CODE,
                                L_SPA_MASTER_LINE_TBL(J).PRODUCT_NAME                         PRODUCT_NAME,
                                L_SPA_MASTER_LINE_TBL(J).SPA_LINE_CREATION_DATE               SPA_LINE_CREATION_DATE,
                                L_SPA_MASTER_LINE_TBL(J).SPA_LINE_CREATED_BY                  SPA_LINE_CREATED_BY,
                                L_SPA_MASTER_LINE_TBL(J).SPA_LINE_LAST_UPDATED_BY             SPA_LINE_LAST_UPDATED_BY,
                                L_SPA_MASTER_LINE_TBL(J).SPA_LINE_LAST_MODIFIED_DATE          SPA_LINE_LAST_MODIFIED_DATE
                            FROM
                                DUAL
                        ) TMP ON ( TBL.LINE_ITEM_NUMBER = TMP.LINE_ITEM_NUMBER )
                        WHEN NOT MATCHED THEN
                        INSERT (
                            CHM_SPA_LINE_ID,
                            CHM_SPA_ID,
                            LINE_ITEM_NUMBER,
                            QUANTITY,
                            SALES_PRICE,
                            SALES_PRICE_CURRENCY,
                            REBATE,
                            REBATE_CURRENCY,
                            LIST_PRICE,
                            LIST_PRICE_CURRENCY,
                            RECOMMENDED_INSTALLER_PRICE,
                            DISTRIBUTOR_MARGIN,
                            APPROVED_LIST_PRICE_CURRENCY,
                            APPROVED_LIST_PRICE,
                            CREATION_DATE,
                            CREATED_BY,
                            LAST_UPDATE_DATE,
                            LAST_UPDATED_BY,
                            PRODUCT_NUMBER,
                            ENPHASE_PART_NUMBER,
                            RECOMMENDED_INSTALLER_PRICING,
                            RECOMMENDED_INSTALLER_PRICE_CURRENCY,
                            UOM_CODE,
                            PRODUCT_NAME,
                            SPA_LINE_CREATION_DATE,
                            SPA_LINE_CREATED_BY,
                            SPA_LINE_LAST_UPDATED_BY,
                            SPA_LINE_LAST_MODIFIED_DATE,
                            ATTRIBUTE1
                            )
                        VALUES
                            ( L_CHM_SPA_LINE_ID,
                              L_CHM_SPA_ID,
                              to_number(TMP.LINE_ITEM_NUMBER),
                              to_number(TMP.QUANTITY),
                              to_number(TMP.SALES_PRICE),
                              TMP.SALES_PRICE_CURRENCY,
                              to_number(TMP.REBATE),
                              TMP.REBATE_CURRENCY,
                              to_number(TMP.LIST_PRICE),
                              TMP.LIST_PRICE_CURRENCY,
                              to_number(TMP.RECOMMENDED_INSTALLER_PRICE),
                              to_number(TMP.DISTRIBUTOR_MARGIN),
                              TMP.APPROVED_LIST_PRICE_CURRENCY,
                              to_number(TMP.APPROVED_LIST_PRICE),
                              TO_TIMESTAMP_TZ(to_timestamp(TMP.CREATED_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                              TMP.CREATED_BY,
                              TO_TIMESTAMP_TZ(to_timestamp(TMP.UPDATE_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                              TMP.UPDATE_BY,
                              TMP.PRODUCT_NUMBER,
                              TMP.ENPHASE_PART_NUMBER,
                              TMP.RECOMMENDED_INSTALLER_PRICING,
                              TMP.RECOMMENDED_INSTALLER_PRICE_CURRENCY,
                              TMP.UOM_CODE,
                              TMP.PRODUCT_NAME,
                              TMP.SPA_LINE_CREATION_DATE,
                              TMP.SPA_LINE_CREATED_BY,
                              TMP.SPA_LINE_LAST_UPDATED_BY,
                              TMP.SPA_LINE_LAST_MODIFIED_DATE,
                              P_IN_OIC_INSTANCE_ID)
                        WHEN MATCHED THEN UPDATE
                        SET QUANTITY = to_number(TMP.QUANTITY),
                            SALES_PRICE = to_number(TMP.SALES_PRICE),
                            SALES_PRICE_CURRENCY = TMP.SALES_PRICE_CURRENCY,
                            REBATE = to_number(TMP.REBATE),
                            REBATE_CURRENCY = TMP.REBATE_CURRENCY,
                            LIST_PRICE = to_number(TMP.LIST_PRICE),
                            LIST_PRICE_CURRENCY = TMP.LIST_PRICE_CURRENCY,
                            RECOMMENDED_INSTALLER_PRICE = to_number(TMP.RECOMMENDED_INSTALLER_PRICE),
                            DISTRIBUTOR_MARGIN = to_number(TMP.DISTRIBUTOR_MARGIN),
                            APPROVED_LIST_PRICE_CURRENCY = TMP.APPROVED_LIST_PRICE_CURRENCY,
                            APPROVED_LIST_PRICE = to_number(TMP.APPROVED_LIST_PRICE),
--                            CREATION_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.CREATED_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
--                            CREATED_BY = TMP.CREATED_BY,
                            LAST_UPDATE_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.UPDATE_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                            LAST_UPDATED_BY = TMP.UPDATE_BY,
                            PRODUCT_NUMBER = TMP.PRODUCT_NUMBER,
                            ENPHASE_PART_NUMBER = TMP.ENPHASE_PART_NUMBER,
                            RECOMMENDED_INSTALLER_PRICING = TMP.RECOMMENDED_INSTALLER_PRICING,
                            RECOMMENDED_INSTALLER_PRICE_CURRENCY = TMP.RECOMMENDED_INSTALLER_PRICE_CURRENCY,
                            UOM_CODE = TMP.UOM_CODE,
                            PRODUCT_NAME = TMP.PRODUCT_NAME,
                            SPA_LINE_CREATION_DATE = TMP.SPA_LINE_CREATION_DATE,
                            SPA_LINE_CREATED_BY = TMP.SPA_LINE_CREATED_BY,
                            SPA_LINE_LAST_UPDATED_BY = TMP.SPA_LINE_LAST_UPDATED_BY,
                            SPA_LINE_LAST_MODIFIED_DATE = TMP.SPA_LINE_LAST_MODIFIED_DATE,
                            ATTRIBUTE1 = P_IN_OIC_INSTANCE_ID
                        WHERE
                                1 = 1
                            AND LINE_ITEM_NUMBER = TMP.LINE_ITEM_NUMBER;

                    L_MERGE_COUNT := L_MERGE_COUNT + 1;


                    EXCEPTION
                        WHEN OTHERS THEN
                            BEGIN
                                L_ERROR_MESSAGE := L_ERROR_MESSAGE
                                                   || CHR(10)
                                                   || CHR(9)
                                                   ||'SPA Line Number ['||L_LINE_NUMBER||']'
                                                   || SQLERRM;



                            EXCEPTION
                                WHEN OTHERS THEN
                                    NULL;
                            END;
                            RAISE_APPLICATION_ERROR(-20001,'Error occurred while merging SPA Line:  '||substr(L_ERROR_MESSAGE,1,4000)); --added for v1.1
                    END;
                    COMMIT;
                    
                END LOOP;
            END IF;

        END LOOP;

        P_OUT_RECORDS_FETCHED := L_COUNT;
        P_OUT_RECORDS_MERGED := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE := SUBSTR(L_ERROR_MESSAGE, 1, 4000);
        
        
        
    END;

END CHM_SPA_MASTER_HDR_LINE_PKG;
/
