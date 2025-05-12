CREATE OR REPLACE PACKAGE CHM_ITEM_CATEGORY_ASSIGNMENTS_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE SPECIFICATION                                                                                                          *
    * PACKAGE NAME                   : CHM_ITEM_CATEGORY_ASSIGNMENTS_PKG                                                                                                            *
    * PURPOSE                        : PACKAGE SPECIFICATION FOR CHM ITEM CATEGORIES ASSIGNMENTS SYNC FROM FUSION                                                                   *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 06-AUG-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 06-AUG-2023  MAHENDER KUMAR                  TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    TYPE REC_ITEM_CATEGORY_ASSIGNMENTS IS RECORD (
            ITEM_NUMBER       VARCHAR2(4000),
            INVENTORY_ITEM_ID NUMBER,
            ORGANIZATION_NAME VARCHAR2(4000),
            ORGANIZATION_CODE VARCHAR2(4000),
            CATEGORY_CODE     VARCHAR2(4000),
            CATEGORY_SET_CODE VARCHAR2(4000),
            CAT_ENABLED_FLAG  VARCHAR2(4000),
            ATTRIBUTE1        VARCHAR2(4000),
            ATTRIBUTE2        VARCHAR2(4000),
            ATTRIBUTE3        VARCHAR2(4000),
            ATTRIBUTE4        VARCHAR2(4000),
            ATTRIBUTE5        VARCHAR2(4000),
            ATTRIBUTE6        VARCHAR2(4000),
            ATTRIBUTE7        VARCHAR2(4000),
            ATTRIBUTE8        VARCHAR2(4000),
            ATTRIBUTE9        VARCHAR2(4000),
            ATTRIBUTE10       VARCHAR2(4000),
            ATTRIBUTE11       VARCHAR2(4000),
            ATTRIBUTE12       VARCHAR2(4000),
            ATTRIBUTE13       VARCHAR2(4000),
            ATTRIBUTE14       VARCHAR2(4000),
            ATTRIBUTE15       VARCHAR2(4000),
            OIC_RUN_ID        VARCHAR2(4000),
            IS_SEEDED         CHAR(1),
            ENABLED_FLAG      CHAR(1),
            START_DATE_ACTIVE DATE,
            END_DATE_ACTIVE   DATE,
            CREATED_BY        VARCHAR2(4000),
            CREATION_DATE     DATE,
            LAST_UPDATED_BY   VARCHAR2(4000),
            LAST_UPDATE_DATE  DATE
    );
    TYPE TBL_ITEM_CATEGORY_ASSIGNMENTS IS
        TABLE OF REC_ITEM_CATEGORY_ASSIGNMENTS;
--PROCEDURE TO MERGE ITEM CATEGORIES ASSIGNMENTS DATA RECEIVED FROM FUSION
    PROCEDURE MERGE_DATA (
        P_IN_ITEM_CATEGORY_ASSIGNMENTS IN TBL_ITEM_CATEGORY_ASSIGNMENTS,
        P_IN_OIC_INSTANCE_ID           IN VARCHAR2,            ------ V1.1
        P_OUT_RECORDS_FETCHED          OUT NUMBER,
        P_OUT_RECORDS_MERGED           OUT NUMBER,
        P_OUT_ERROR_MESSAGE            OUT VARCHAR2
    );

END CHM_ITEM_CATEGORY_ASSIGNMENTS_PKG;
/