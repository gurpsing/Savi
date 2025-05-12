CREATE OR REPLACE PACKAGE CHM_ITEM_CATEGORY_SETS_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE SPECIFICATION                                                                                                          *
    * PACKAGE NAME                   : CHM_ITEM_CATEGORY_SETS_PKG                                                                                                            *
    * PURPOSE                        : PACKAGE SPECIFICATION FOR CHM ITEM CATEGORIES SETS SYNC FROM FUSION                                                                   *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 06-AUG-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 06-AUG-2023  MAHENDER KUMAR                  TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    TYPE REC_ITEM_CATEGORY_SETS IS RECORD (
    SOURCE_CATEGORY_SET_ID        NUMBER,
    DEFAULT_CATEGORY_ID           NUMBER,
    LANGUAGE                      VARCHAR2(4000),
    CATEGORY_SET_NAME             VARCHAR2(4000),
    DESCRIPTION                   VARCHAR2(4000),
    CATALOG_CONTENT_CODE          VARCHAR2(4000),
    CATALOG_CODE                  VARCHAR2(4000),
    CONTROL_LEVEL                 NUMBER,
    VALIDATE_FLAG                 CHAR(1),
    MULT_ITEM_CAT_ASSIGN_FLAG     CHAR(1),
    CONTROL_LEVEL_UPDATEABLE_FLAG CHAR(1),
    MULT_ITEM_CAT_UPDATEABLE_FLAG CHAR(1),
    HIERARCHY_ENABLED             CHAR(1),
    VALIDATE_FLAG_UPDATEABLE_FLAG CHAR(1),
    STATUS_FLAG                   CHAR(1),
    START_DATE                    VARCHAR2(4000),
    END_DATE                      VARCHAR2(4000),
    ATTRIBUTE1                    VARCHAR2(4000),
    ATTRIBUTE2                    VARCHAR2(4000),
    ATTRIBUTE3                    VARCHAR2(4000),
    ATTRIBUTE4                    VARCHAR2(4000),
    ATTRIBUTE5                    VARCHAR2(4000),
    ATTRIBUTE6                    VARCHAR2(4000),
    ATTRIBUTE7                    VARCHAR2(4000),
    ATTRIBUTE8                    VARCHAR2(4000),
    ATTRIBUTE9                    VARCHAR2(4000),
    ATTRIBUTE10                   VARCHAR2(4000),
    ATTRIBUTE11                   VARCHAR2(4000),
    ATTRIBUTE12                   VARCHAR2(4000),
    ATTRIBUTE13                   VARCHAR2(4000),
    ATTRIBUTE14                   VARCHAR2(4000),
    ATTRIBUTE15                   VARCHAR2(4000),
    OIC_RUN_ID                    VARCHAR2(4000),
    IS_SEEDED                     CHAR(1),
    ENABLED_FLAG                  CHAR(1),
    START_DATE_ACTIVE             DATE,
    END_DATE_ACTIVE               DATE,
    CREATED_BY                    VARCHAR2(4000),
    CREATION_DATE                 DATE,
    LAST_UPDATED_BY               VARCHAR2(4000),
    LAST_UPDATE_DATE              DATE
    );
   
    TYPE TBL_ITEM_CATEGORY_SETS IS TABLE OF REC_ITEM_CATEGORY_SETS;
--PROCEDURE TO MERGE ITEM CATEGORIES SETS DATA RECEIVED FROM FUSION
    PROCEDURE MERGE_DATA (
        P_IN_ITEM_CATEGORY_SETS    IN TBL_ITEM_CATEGORY_SETS,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,                    --------- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    );

END CHM_ITEM_CATEGORY_SETS_PKG;

/