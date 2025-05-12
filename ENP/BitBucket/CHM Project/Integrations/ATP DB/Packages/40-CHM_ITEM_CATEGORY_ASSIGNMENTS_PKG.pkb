create or replace PACKAGE BODY "CHM_ITEM_CATEGORY_ASSIGNMENTS_PKG" 
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE BODY                                                                                                                     *
    * PACKAGE NAME                   : CHM_ITEM_CATEGORY_ASSIGNMENTS_PKG                                                                                                                 *
    * PURPOSE                        : PACKAGE BODY SPECIFICATION FOR CHM ITEM CATEGORIES ASSIGNMENTS SYNC FROM FUSION                                                                                  *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 06-AUG-2023                                                                                                                          *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 06-AUG-2023  MAHENDER KUMAR                 TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
	* 03-APR-2024  Harisha P S  				  Enphase						   1.1				Replacing Primary Key Column CATEGORY_CODE to  CATEGORY_SET_CODE    	*
	* 24-APR-2024  Gurpreet Singh  				  Transform Edge				   1.2				Replacing Key Column CATEGORY_CODE to  CATEGORY_SET_CODE    	        *
    * 20-Nov-2024   Dhivagar                      Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    --PROCEDURE TO MERGE ITEM CATEGORIES ASSIGNMENTS DATA RECEIVED FROM FUSION
    PROCEDURE MERGE_DATA (
        P_IN_ITEM_CATEGORY_ASSIGNMENTS IN TBL_ITEM_CATEGORY_ASSIGNMENTS,
        P_IN_OIC_INSTANCE_ID           IN VARCHAR2,       -------- V1.1
        P_OUT_RECORDS_FETCHED          OUT NUMBER,
        P_OUT_RECORDS_MERGED           OUT NUMBER,
        P_OUT_ERROR_MESSAGE            OUT VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_ITEM_CATEGORY_ASSIGNMENTS.FIRST..P_IN_ITEM_CATEGORY_ASSIGNMENTS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_ITEM_CATEGORY_ASSIGNMENTS TBL
                USING (
                    SELECT
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ITEM_NUMBER       ITEM_NUMBER,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).INVENTORY_ITEM_ID INVENTORY_ITEM_ID,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ORGANIZATION_NAME ORGANIZATION_NAME,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ORGANIZATION_CODE ORGANIZATION_CODE,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).CATEGORY_CODE     CATEGORY_CODE,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).CATEGORY_SET_CODE CATEGORY_SET_CODE,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).CAT_ENABLED_FLAG  CAT_ENABLED_FLAG,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE1        ATTRIBUTE1,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE2        ATTRIBUTE2,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE3        ATTRIBUTE3,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE4        ATTRIBUTE4,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE5        ATTRIBUTE5,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE6        ATTRIBUTE6,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE7        ATTRIBUTE7,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE8        ATTRIBUTE8,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE9        ATTRIBUTE9,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE10       ATTRIBUTE10,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE11       ATTRIBUTE11,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE12       ATTRIBUTE12,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE13       ATTRIBUTE13,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE14       ATTRIBUTE14,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ATTRIBUTE15       ATTRIBUTE15,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).OIC_RUN_ID        OIC_RUN_ID,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).IS_SEEDED         IS_SEEDED,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).ENABLED_FLAG      ENABLED_FLAG,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).START_DATE_ACTIVE START_DATE_ACTIVE,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).END_DATE_ACTIVE   END_DATE_ACTIVE,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).CREATED_BY        CREATED_BY,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).CREATION_DATE     CREATION_DATE,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).LAST_UPDATED_BY   LAST_UPDATED_BY,
                        P_IN_ITEM_CATEGORY_ASSIGNMENTS(I).LAST_UPDATE_DATE  LAST_UPDATE_DATE
                    FROM
                        DUAL
                ) TMP ON ( TBL.ITEM_NUMBER = TMP.ITEM_NUMBER
                           AND TBL.INVENTORY_ITEM_ID = TMP.INVENTORY_ITEM_ID 
                           --AND TBL.CATEGORY_CODE = TMP.CATEGORY_CODE )            --commented for 1.2
                           AND TBL.CATEGORY_SET_CODE = TMP.CATEGORY_SET_CODE )      --added for 1.2
                WHEN NOT MATCHED THEN
                INSERT (
                    ITEM_NUMBER,
                    INVENTORY_ITEM_ID,
                    ORGANIZATION_NAME,
                    ORGANIZATION_CODE,
                    CATEGORY_CODE,
                    CATEGORY_SET_CODE,
                    CAT_ENABLED_FLAG,
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
                    ( TMP.ITEM_NUMBER,
                      TMP.INVENTORY_ITEM_ID,
                      TMP.ORGANIZATION_NAME,
                      TMP.ORGANIZATION_CODE,
                      TMP.CATEGORY_CODE,
                      TMP.CATEGORY_SET_CODE,
                      TMP.CAT_ENABLED_FLAG,
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
                SET ORGANIZATION_NAME = TMP.ORGANIZATION_NAME,
                    ORGANIZATION_CODE = TMP.ORGANIZATION_CODE,
                    --CATEGORY_SET_CODE = TMP.CATEGORY_SET_CODE,    --commented for v1.2
                    CATEGORY_CODE = TMP.CATEGORY_CODE,              --added for v1.2
                    CAT_ENABLED_FLAG = TMP.CAT_ENABLED_FLAG,
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
                    AND ITEM_NUMBER = TMP.ITEM_NUMBER
                    AND INVENTORY_ITEM_ID = TMP.INVENTORY_ITEM_ID
--                    AND CATEGORY_CODE = TMP.CATEGORY_CODE;
					AND CATEGORY_SET_CODE = TMP.CATEGORY_SET_CODE; --1.1

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

END CHM_ITEM_CATEGORY_ASSIGNMENTS_PKG;
/
