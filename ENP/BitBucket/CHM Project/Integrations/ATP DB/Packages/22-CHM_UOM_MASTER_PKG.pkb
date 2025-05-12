CREATE OR REPLACE PACKAGE BODY CHM_UOM_MASTER_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_UOM_MASTER_PKG                                                                                                                    *
    * Purpose                        : Package Body for CHM Master UOM sync from fusion                                                                                      *
    * Created By                     : Mahender Kumar                                                                                                                        *
    * Created Date                   : 06-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 06-Jul-2023   Mahender Kumar                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
--Procedure to merge Master UOM data received from fusion
    PROCEDURE MERGE_DATA (
        P_IN_UOM_MASTER       IN TBL_UOM_MASTER,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,         -------- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_UOM_MASTER.FIRST..P_IN_UOM_MASTER.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_UOM_MASTER TBL
                USING (
                    SELECT
                        P_IN_UOM_MASTER(I).UNIT_OF_MEASURE_ID         UNIT_OF_MEASURE_ID,
                        P_IN_UOM_MASTER(I).UOM_CODE                   UOM_CODE,
                        P_IN_UOM_MASTER(I).DESCRIPTION                DESCRIPTION,
                        P_IN_UOM_MASTER(I).BASE_UOM_FLAG              BASE_UOM_FLAG,
                        P_IN_UOM_MASTER(I).UOM_CLASS                  UOM_CLASS,
                        P_IN_UOM_MASTER(I).UOM_CLASS_CODE             UOM_CLASS_CODE,
                        P_IN_UOM_MASTER(I).DISABLE_DATE               DISABLE_DATE,
                        P_IN_UOM_MASTER(I).UOM_LAST_UPDATE_DATE       UOM_LAST_UPDATE_DATE,
                        P_IN_UOM_MASTER(I).UOM_CLASS_LAST_UPDATE_DATE UOM_CLASS_LAST_UPDATE_DATE,
                        P_IN_UOM_MASTER(I).ATTRIBUTE1                 ATTRIBUTE1,
                        P_IN_UOM_MASTER(I).ATTRIBUTE2                 ATTRIBUTE2,
                        P_IN_UOM_MASTER(I).ATTRIBUTE3                 ATTRIBUTE3,
                        P_IN_UOM_MASTER(I).ATTRIBUTE4                 ATTRIBUTE4,
                        P_IN_UOM_MASTER(I).ATTRIBUTE5                 ATTRIBUTE5,
                        P_IN_UOM_MASTER(I).ATTRIBUTE6                 ATTRIBUTE6,
                        P_IN_UOM_MASTER(I).ATTRIBUTE7                 ATTRIBUTE7,
                        P_IN_UOM_MASTER(I).ATTRIBUTE8                 ATTRIBUTE8,
                        P_IN_UOM_MASTER(I).ATTRIBUTE9                 ATTRIBUTE9,
                        P_IN_UOM_MASTER(I).ATTRIBUTE10                ATTRIBUTE10,
                        P_IN_UOM_MASTER(I).ATTRIBUTE11                ATTRIBUTE11,
                        P_IN_UOM_MASTER(I).ATTRIBUTE12                ATTRIBUTE12,
                        P_IN_UOM_MASTER(I).ATTRIBUTE13                ATTRIBUTE13,
                        P_IN_UOM_MASTER(I).ATTRIBUTE14                ATTRIBUTE14,
                        P_IN_UOM_MASTER(I).ATTRIBUTE15                ATTRIBUTE15,
                        P_IN_UOM_MASTER(I).OIC_RUN_ID                 OIC_RUN_ID,
                        P_IN_UOM_MASTER(I).IS_SEEDED                  IS_SEEDED,
                        P_IN_UOM_MASTER(I).ENABLED_FLAG               ENABLED_FLAG,
                        P_IN_UOM_MASTER(I).START_DATE_ACTIVE          START_DATE_ACTIVE,
                        P_IN_UOM_MASTER(I).END_DATE_ACTIVE            END_DATE_ACTIVE,
                        P_IN_UOM_MASTER(I).CREATED_BY                 CREATED_BY,
                        P_IN_UOM_MASTER(I).CREATION_DATE              CREATION_DATE,
                        P_IN_UOM_MASTER(I).LAST_UPDATED_BY            LAST_UPDATED_BY,
                        P_IN_UOM_MASTER(I).LAST_UPDATE_DATE           LAST_UPDATE_DATE
                    FROM
                        DUAL
                ) TMP ON ( TBL.UNIT_OF_MEASURE_ID = TMP.UNIT_OF_MEASURE_ID )
                WHEN NOT MATCHED THEN
                INSERT (
                    UNIT_OF_MEASURE_ID,
                    UOM_CODE,
                    DESCRIPTION,
                    BASE_UOM_FLAG,
                    UOM_CLASS,
                    UOM_CLASS_CODE,
                    DISABLE_DATE,
                    UOM_LAST_UPDATE_DATE,
                    UOM_CLASS_LAST_UPDATE_DATE,
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
                    (
                      TMP.UNIT_OF_MEASURE_ID,
                      TMP.UOM_CODE,
                      TMP.DESCRIPTION,
                      TMP.BASE_UOM_FLAG,
                      TMP.UOM_CLASS,
                      TMP.UOM_CLASS_CODE,
                      TMP.DISABLE_DATE,
                      TMP.UOM_LAST_UPDATE_DATE,
                      TMP.UOM_CLASS_LAST_UPDATE_DATE,
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
                SET UOM_CODE = TMP.UOM_CODE,
                    DESCRIPTION = TMP.DESCRIPTION,
                    BASE_UOM_FLAG = TMP.BASE_UOM_FLAG,
                    UOM_CLASS = TMP.UOM_CLASS,
                    UOM_CLASS_CODE = TMP.UOM_CLASS_CODE,
                    DISABLE_DATE = TMP.DISABLE_DATE,
                    UOM_LAST_UPDATE_DATE = TMP.UOM_LAST_UPDATE_DATE,
                    UOM_CLASS_LAST_UPDATE_DATE = TMP.UOM_CLASS_LAST_UPDATE_DATE,
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
                    AND UNIT_OF_MEASURE_ID = TMP.UNIT_OF_MEASURE_ID;

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

END CHM_UOM_MASTER_PKG;
/