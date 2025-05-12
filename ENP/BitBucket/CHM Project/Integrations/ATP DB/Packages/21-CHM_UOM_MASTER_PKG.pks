CREATE OR REPLACE PACKAGE CHM_UOM_MASTER_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_UOM_MASTER_PKG                                                                                                                    *
    * Purpose                        : Package Specification for CHM Master UOM sync from fusion                                                                             *
    * Created By                     : Mahender Kumar                                                                                                                        *
    * Created Date                   : 06-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 06-Jul-2023   Mahender Kumar                  Transform Edge                   1.0              Intial Version                                                         * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    TYPE REC_UOM_MASTER IS RECORD (
            UNIT_OF_MEASURE_ID         VARCHAR2(4000),
            UOM_CODE                   VARCHAR2(4000),
            DESCRIPTION                VARCHAR2(4000),
            BASE_UOM_FLAG              VARCHAR2(4000),
            UOM_CLASS                  VARCHAR2(4000),
            UOM_CLASS_CODE             VARCHAR2(4000),
            DISABLE_DATE               VARCHAR2(4000),
            UOM_LAST_UPDATE_DATE       VARCHAR2(4000),
            UOM_CLASS_LAST_UPDATE_DATE VARCHAR2(4000),
            ATTRIBUTE1                 VARCHAR2(4000),
            ATTRIBUTE2                 VARCHAR2(4000),
            ATTRIBUTE3                 VARCHAR2(4000),
            ATTRIBUTE4                 VARCHAR2(4000),
            ATTRIBUTE5                 VARCHAR2(4000),
            ATTRIBUTE6                 VARCHAR2(4000),
            ATTRIBUTE7                 VARCHAR2(4000),
            ATTRIBUTE8                 VARCHAR2(4000),
            ATTRIBUTE9                 VARCHAR2(4000),
            ATTRIBUTE10                VARCHAR2(4000),
            ATTRIBUTE11                VARCHAR2(4000),
            ATTRIBUTE12                VARCHAR2(4000),
            ATTRIBUTE13                VARCHAR2(4000),
            ATTRIBUTE14                VARCHAR2(4000),
            ATTRIBUTE15                VARCHAR2(4000),
            OIC_RUN_ID                 VARCHAR2(4000),
            IS_SEEDED                  CHAR(1),
            ENABLED_FLAG               CHAR(1),
            START_DATE_ACTIVE          DATE,
            END_DATE_ACTIVE            DATE,
            CREATED_BY                 VARCHAR2(4000),
            CREATION_DATE              DATE,
            LAST_UPDATED_BY            VARCHAR2(4000),
            LAST_UPDATE_DATE           DATE
    );
    
    TYPE TBL_UOM_MASTER IS  TABLE OF REC_UOM_MASTER;
    --Procedure to merge Master UOM data received from fusion
    PROCEDURE MERGE_DATA (
        P_IN_UOM_MASTER       IN TBL_UOM_MASTER,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,           --------- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    );

END CHM_UOM_MASTER_PKG;
/
