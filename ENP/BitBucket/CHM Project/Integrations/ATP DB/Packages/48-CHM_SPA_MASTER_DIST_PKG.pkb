create or replace PACKAGE BODY CHM_SPA_MASTER_DIST_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE BODY                                                                                                                      *
    * PACKAGE NAME                   : CHM_SPA_MASTER_DIST_PKG                                                                                                                 *
    * PURPOSE                        : PACKAGE BODY FOR CHM SPA MASTER DISTRIBUTOR SYNC FROM SALES FORCE                                                                                     *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 29-AUG-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 29-AUG-2023   MAHENDER KUMAR                 TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    --PROCEDURE TO MERGE DISTRIBUTOR ACCOUNT DATA RECEIVED FROM FUSION
    PROCEDURE MERGE_DATA (
        P_IN_SPA_MASTER_DIST  IN TBL_SPA_MASTER_DIST_NEW,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,           ----------- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_SPA_MASTER_DIST.FIRST..P_IN_SPA_MASTER_DIST.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_SPA_ADDITIONAL_DIST TBL
                USING (
                    SELECT
                        P_IN_SPA_MASTER_DIST(I).CHM_SPA_ADD_DIST_ID       CHM_SPA_ADD_DIST_ID,
                        P_IN_SPA_MASTER_DIST(I).CHM_SPA_ID               CHM_SPA_ID,
                        P_IN_SPA_MASTER_DIST(I).SPA_NUMBER               SPA_NUMBER,
                        P_IN_SPA_MASTER_DIST(I).DISTRIBUTOR_ACCOUNT_NAME DISTRIBUTOR_ACCOUNT_NAME,
                        P_IN_SPA_MASTER_DIST(I).SPA_DISTRIBUTOR_NAME     SPA_DISTRIBUTOR_NAME,
                        P_IN_SPA_MASTER_DIST(I).DISTI_CUSTOMER_KEY       DISTI_CUSTOMER_KEY,
                        P_IN_SPA_MASTER_DIST(I).SPA_NAME                 SPA_NAME,
                        P_IN_SPA_MASTER_DIST(I).STATUS                   STATUS,
                        P_IN_SPA_MASTER_DIST(I).SFDC_CREATED_BY          SFDC_CREATED_BY,
                        P_IN_SPA_MASTER_DIST(I).SPA_START_DATE           SPA_START_DATE,
                        P_IN_SPA_MASTER_DIST(I).SPA_EXPIRATION_DATE      SPA_EXPIRATION_DATE,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE_CONTEXT        ATTRIBUTE_CONTEXT,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE1               ATTRIBUTE1,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE2               ATTRIBUTE2,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE3               ATTRIBUTE3,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE4               ATTRIBUTE4,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE5               ATTRIBUTE5,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE6               ATTRIBUTE6,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE7               ATTRIBUTE7,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE8               ATTRIBUTE8,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE9               ATTRIBUTE9,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE10              ATTRIBUTE10,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE11              ATTRIBUTE11,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE12              ATTRIBUTE12,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE13              ATTRIBUTE13,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE14              ATTRIBUTE14,
                        P_IN_SPA_MASTER_DIST(I).ATTRIBUTE15              ATTRIBUTE15,
                        P_IN_SPA_MASTER_DIST(I).CREATED_BY               CREATED_BY,
                        P_IN_SPA_MASTER_DIST(I).CREATION_DATE            CREATION_DATE,
                        P_IN_SPA_MASTER_DIST(I).LAST_UPDATED_BY          LAST_UPDATED_BY,
                        P_IN_SPA_MASTER_DIST(I).LAST_UPDATE_DATE         LAST_UPDATE_DATE
                    FROM
                        DUAL
                ) TMP ON ( 1=1
                            AND TBL.DISTI_CUSTOMER_KEY = TMP.DISTI_CUSTOMER_KEY
                            AND TBL.SPA_NUMBER = TMP.SPA_NUMBER 
                )
                WHEN NOT MATCHED THEN
                INSERT (
                    CHM_SPA_ADD_DIST_ID,
                    CHM_SPA_ID,
                    SPA_NUMBER,
                    DISTRIBUTOR_ACCOUNT_NAME,
                    SPA_DISTRIBUTOR_NAME,
                    DISTI_CUSTOMER_KEY,
                    SPA_NAME,
                    STATUS,
                    SFDC_CREATED_BY,
                    SPA_START_DATE,
                    SPA_EXPIRATION_DATE,
                    ATTRIBUTE_CONTEXT,
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
                    CREATED_BY,
                    CREATION_DATE,
                    LAST_UPDATED_BY,
                    LAST_UPDATE_DATE )
                VALUES
                    ( CHM_SPA_DIST_S.NEXTVAL,
                    (SELECT CHM_SPA_ID FROM CHM_SPA_HEADER WHERE SPA_NUMBER=TMP.SPA_NUMBER),
                    TMP.SPA_NUMBER,
                    TMP.DISTRIBUTOR_ACCOUNT_NAME,
                    TMP.SPA_DISTRIBUTOR_NAME,
                    TMP.DISTI_CUSTOMER_KEY,
                    TMP.SPA_NAME,
                    TMP.STATUS,
                    TMP.SFDC_CREATED_BY,
                    TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA_START_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA_EXPIRATION_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    TMP.ATTRIBUTE_CONTEXT,
                    P_IN_OIC_INSTANCE_ID,
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
                    TMP.CREATED_BY,
                    TO_TIMESTAMP_TZ(to_timestamp(TMP.CREATION_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    TMP.LAST_UPDATED_BY,
                    TO_TIMESTAMP_TZ(to_timestamp(TMP.LAST_UPDATE_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') )
                WHEN MATCHED THEN UPDATE
                SET 
                    CHM_SPA_ID = (SELECT CHM_SPA_ID FROM CHM_SPA_HEADER WHERE SPA_NUMBER=TMP.SPA_NUMBER),
                    DISTRIBUTOR_ACCOUNT_NAME = TMP.DISTRIBUTOR_ACCOUNT_NAME,
                    SPA_DISTRIBUTOR_NAME = TMP.SPA_DISTRIBUTOR_NAME,
--                    DISTI_CUSTOMER_KEY = TMP.DISTI_CUSTOMER_KEY,
                    SPA_NAME = TMP.SPA_NAME,
                    STATUS = TMP.STATUS,
--                    SFDC_CREATED_BY = TMP.SFDC_CREATED_BY,
                    SPA_START_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA_START_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    SPA_EXPIRATION_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.SPA_EXPIRATION_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    ATTRIBUTE_CONTEXT = TMP.ATTRIBUTE_CONTEXT,
                    ATTRIBUTE1 = P_IN_OIC_INSTANCE_ID,
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
                    CREATED_BY = TMP.CREATED_BY,
                   -- CREATION_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.CREATION_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR'),
                    LAST_UPDATED_BY = TMP.LAST_UPDATED_BY,
                    LAST_UPDATE_DATE = TO_TIMESTAMP_TZ(to_timestamp(TMP.LAST_UPDATE_DATE, 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR')
                WHERE
                        1 = 1
                    AND DISTI_CUSTOMER_KEY = TMP.DISTI_CUSTOMER_KEY
                    AND SPA_NUMBER = TMP.SPA_NUMBER
                    ;

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
            COMMIT;

        END LOOP;

        P_OUT_RECORDS_FETCHED := L_COUNT;
        P_OUT_RECORDS_MERGED := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE := SUBSTR(L_ERROR_MESSAGE, 1, 4000);
    END MERGE_DATA;

END CHM_SPA_MASTER_DIST_PKG;
/
