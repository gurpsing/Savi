CREATE OR REPLACE PACKAGE BODY CHM_ACCOUNTING_PERIODS_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL Package Body                                                                                                                   *
    * PACKAGE NAME                   : CHM_ACCOUNTING_PERIODS_PKG                                                                                                            *
    * PURPOSE                        : Package Body FOR CHM VALUE SETSSYNC FROM FUSION                                                                                       *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 06-JUL-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 06-JUL-2023   MAHENDER KUMAR                 TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
 --PROCEDURE TO MERGE ACCOUNTING PERIODS DATA RECEIVED FROM FUSION   
    PROCEDURE MERGE_DATA (
        P_IN_ACCOUNTING_PERIODS IN TBL_ACCOUNTING_PERIODS,
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2,                     -------------- V1.1
        P_OUT_RECORDS_FETCHED   OUT NUMBER,
        P_OUT_RECORDS_MERGED    OUT NUMBER,
        P_OUT_ERROR_MESSAGE     OUT VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_ACCOUNTING_PERIODS.FIRST..P_IN_ACCOUNTING_PERIODS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_ACCOUNTING_PERIODS TBL
                USING (
                    SELECT
                        P_IN_ACCOUNTING_PERIODS(I).SET_OF_BOOKS_NAME SET_OF_BOOKS_NAME,
                        P_IN_ACCOUNTING_PERIODS(I).PRODUCT_CODE      PRODUCT_CODE,
                        P_IN_ACCOUNTING_PERIODS(I).PERIOD_NAME       PERIOD_NAME,
                        P_IN_ACCOUNTING_PERIODS(I).PERIOD_START_DATE PERIOD_START_DATE,
                        P_IN_ACCOUNTING_PERIODS(I).PERIOD_END_DATE   PERIOD_END_DATE,
                        P_IN_ACCOUNTING_PERIODS(I).PERIOD_STATUS     PERIOD_STATUS,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE1        ATTRIBUTE1,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE2        ATTRIBUTE2,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE3        ATTRIBUTE3,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE4        ATTRIBUTE4,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE5        ATTRIBUTE5,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE6        ATTRIBUTE6,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE7        ATTRIBUTE7,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE8        ATTRIBUTE8,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE9        ATTRIBUTE9,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE10       ATTRIBUTE10,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE11       ATTRIBUTE11,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE12       ATTRIBUTE12,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE13       ATTRIBUTE13,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE14       ATTRIBUTE14,
                        P_IN_ACCOUNTING_PERIODS(I).ATTRIBUTE15       ATTRIBUTE15,
                        P_IN_ACCOUNTING_PERIODS(I).OIC_RUN_ID        OIC_RUN_ID,
                        P_IN_ACCOUNTING_PERIODS(I).IS_SEEDED         IS_SEEDED,
                        P_IN_ACCOUNTING_PERIODS(I).ENABLED_FLAG      ENABLED_FLAG,
                        P_IN_ACCOUNTING_PERIODS(I).START_DATE_ACTIVE START_DATE_ACTIVE,
                        P_IN_ACCOUNTING_PERIODS(I).END_DATE_ACTIVE   END_DATE_ACTIVE,
                        P_IN_ACCOUNTING_PERIODS(I).CREATED_BY        CREATED_BY,
                        P_IN_ACCOUNTING_PERIODS(I).CREATION_DATE     CREATION_DATE,
                        P_IN_ACCOUNTING_PERIODS(I).LAST_UPDATED_BY   LAST_UPDATED_BY,
                        P_IN_ACCOUNTING_PERIODS(I).LAST_UPDATE_DATE  LAST_UPDATE_DATE
                    FROM
                        DUAL
                ) TMP ON ( TBL.SET_OF_BOOKS_NAME = TMP.SET_OF_BOOKS_NAME
                           AND TBL.PRODUCT_CODE = TMP.PRODUCT_CODE
                           AND TBL.PERIOD_NAME = TMP.PERIOD_NAME )
                WHEN NOT MATCHED THEN
                INSERT (
                    SET_OF_BOOKS_NAME,
                    PRODUCT_CODE,
                    PERIOD_NAME,
                    PERIOD_START_DATE,
                    PERIOD_END_DATE,
                    PERIOD_STATUS,
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
                    ( TMP.SET_OF_BOOKS_NAME,
                      TMP.PRODUCT_CODE,
                      TMP.PERIOD_NAME,
                      TMP.PERIOD_START_DATE,
                      TMP.PERIOD_END_DATE,
                      TMP.PERIOD_STATUS,
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
                SET PERIOD_START_DATE = TMP.PERIOD_START_DATE,
                    PERIOD_END_DATE = TMP.PERIOD_END_DATE,
                    PERIOD_STATUS = TMP.PERIOD_STATUS,
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
                    IS_SEEDED = TMP.IS_SEEDED,
                    ENABLED_FLAG = TMP.ENABLED_FLAG,
                    START_DATE_ACTIVE = TMP.START_DATE_ACTIVE,
                    END_DATE_ACTIVE = TMP.END_DATE_ACTIVE,
                    LAST_UPDATED_BY = TMP.LAST_UPDATED_BY,
                    LAST_UPDATE_DATE = TMP.LAST_UPDATE_DATE
                WHERE
                        1 = 1
                    AND TBL.SET_OF_BOOKS_NAME = TMP.SET_OF_BOOKS_NAME
                    AND TBL.PRODUCT_CODE = TMP.PRODUCT_CODE
                    AND TBL.PERIOD_NAME = TMP.PERIOD_NAME;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    BEGIN
                        L_ERROR_MESSAGE := L_ERROR_MESSAGE
                                           || CHR(10)
                                           || CHR(9)
                                           || SQLERRM;

                    EXCEPTION
                        WHEN OTHERS THEN
                            NULL;
                    END;
            END;

        END LOOP;

        P_OUT_RECORDS_FETCHED := L_COUNT;
        P_OUT_RECORDS_MERGED := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE := SUBSTR(L_ERROR_MESSAGE, 1, 4000);
    END MERGE_DATA;

END CHM_ACCOUNTING_PERIODS_PKG;
/