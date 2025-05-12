CREATE OR REPLACE PACKAGE BODY CHM_VALUE_SETS_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL Package Body                                                                                                                        *
    * PACKAGE NAME                   : CHM_VALUE_SETS_PKG                                                                                                                 *
    * PURPOSE                        : Package Body FOR CHM VALUE SETSSYNC FROM FUSION                                                                                  *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 06-JUL-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 06-JUL-2023   MAHENDER KUMAR                 TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
--PROCEDURE TO MERGE VALUE SETS DATA RECEIVED FROM FUSION    
    PROCEDURE MERGE_DATA (
        P_IN_VALUE_SETS       IN TBL_VALUE_SETS,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,                ---------- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_VALUE_SETS.FIRST..P_IN_VALUE_SETS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_VALUE_SETS TBL
                USING (
                    SELECT
                        P_IN_VALUE_SETS(I).FLEX_VALUE_SET_ID    FLEX_VALUE_SET_ID,
                        P_IN_VALUE_SETS(I).FLEX_VALUE_SET_NAME  FLEX_VALUE_SET_NAME,
                        P_IN_VALUE_SETS(I).VALUESET_DESCRIPTION VALUESET_DESCRIPTION,
                        P_IN_VALUE_SETS(I).VALIDATION_TYPE      VALIDATION_TYPE,
                        P_IN_VALUE_SETS(I).FLEX_VALUE           FLEX_VALUE,
                        P_IN_VALUE_SETS(I).VALUE_DESCRIPTION    VALUE_DESCRIPTION,
                        P_IN_VALUE_SETS(I).VALUE_ENABLED_FLAG   VALUE_ENABLED_FLAG,
                        P_IN_VALUE_SETS(I).FLEX_VALUE_ID        FLEX_VALUE_ID,
                        P_IN_VALUE_SETS(I).ATTRIBUTE1           ATTRIBUTE1,
                        P_IN_VALUE_SETS(I).ATTRIBUTE2           ATTRIBUTE2,
                        P_IN_VALUE_SETS(I).ATTRIBUTE3           ATTRIBUTE3,
                        P_IN_VALUE_SETS(I).ATTRIBUTE4           ATTRIBUTE4,
                        P_IN_VALUE_SETS(I).ATTRIBUTE5           ATTRIBUTE5,
                        P_IN_VALUE_SETS(I).ATTRIBUTE6           ATTRIBUTE6,
                        P_IN_VALUE_SETS(I).ATTRIBUTE7           ATTRIBUTE7,
                        P_IN_VALUE_SETS(I).ATTRIBUTE8           ATTRIBUTE8,
                        P_IN_VALUE_SETS(I).ATTRIBUTE9           ATTRIBUTE9,
                        P_IN_VALUE_SETS(I).ATTRIBUTE10          ATTRIBUTE10,
                        P_IN_VALUE_SETS(I).ATTRIBUTE11          ATTRIBUTE11,
                        P_IN_VALUE_SETS(I).ATTRIBUTE12          ATTRIBUTE12,
                        P_IN_VALUE_SETS(I).ATTRIBUTE13          ATTRIBUTE13,
                        P_IN_VALUE_SETS(I).ATTRIBUTE14          ATTRIBUTE14,
                        P_IN_VALUE_SETS(I).ATTRIBUTE15          ATTRIBUTE15,
                        P_IN_VALUE_SETS(I).OIC_RUN_ID           OIC_RUN_ID,
                        P_IN_VALUE_SETS(I).IS_SEEDED            IS_SEEDED,
                        P_IN_VALUE_SETS(I).ENABLED_FLAG         ENABLED_FLAG,
                        P_IN_VALUE_SETS(I).START_DATE_ACTIVE    START_DATE_ACTIVE,
                        P_IN_VALUE_SETS(I).END_DATE_ACTIVE      END_DATE_ACTIVE,
                        P_IN_VALUE_SETS(I).CREATED_BY           CREATED_BY,
                        P_IN_VALUE_SETS(I).CREATION_DATE        CREATION_DATE,
                        P_IN_VALUE_SETS(I).LAST_UPDATED_BY      LAST_UPDATED_BY,
                        P_IN_VALUE_SETS(I).LAST_UPDATE_DATE     LAST_UPDATE_DATE
                    FROM
                        DUAL
                ) TMP ON ( TBL.FLEX_VALUE_ID = TMP.FLEX_VALUE_ID )
                WHEN NOT MATCHED THEN
                INSERT (
                    FLEX_VALUE_SET_ID,
                    FLEX_VALUE_SET_NAME,
                    VALUESET_DESCRIPTION,
                    VALIDATION_TYPE,
                    FLEX_VALUE,
                    VALUE_DESCRIPTION,
                    VALUE_ENABLED_FLAG,
                    FLEX_VALUE_ID,
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
                    ( TMP.FLEX_VALUE_SET_ID,
                      TMP.FLEX_VALUE_SET_NAME,
                      TMP.VALUESET_DESCRIPTION,
                      TMP.VALIDATION_TYPE,
                      TMP.FLEX_VALUE,
                      TMP.VALUE_DESCRIPTION,
                      TMP.VALUE_ENABLED_FLAG,
                      TMP.FLEX_VALUE_ID,
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
                SET FLEX_VALUE_SET_ID = TMP.FLEX_VALUE_SET_ID,
                    FLEX_VALUE_SET_NAME = TMP.FLEX_VALUE_SET_NAME,
                    VALUESET_DESCRIPTION = TMP.VALUESET_DESCRIPTION,
                    VALIDATION_TYPE = TMP.VALIDATION_TYPE,
                    FLEX_VALUE = TMP.FLEX_VALUE,
                    VALUE_DESCRIPTION = TMP.VALUE_DESCRIPTION,
                    VALUE_ENABLED_FLAG = TMP.VALUE_ENABLED_FLAG,
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
                    AND TBL.FLEX_VALUE_ID = TMP.FLEX_VALUE_ID;

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

END CHM_VALUE_SETS_PKG;
/
