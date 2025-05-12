create or replace PACKAGE CHM_SPA_MASTER_DIST_PKG
    
    /*************************************************************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE                                                                                                                        *
    * PACKAGE NAME                   : CHM_SPA_MASTER_DIST_PKG                                                                                                                 *
    * PURPOSE                        : PACKAGE FOR CHM SPA MASTER DISTRIBUTOR SYNC FROM SALES FORCE                                                                                  *
    * CREATED BY                     : MAHENDER KUMAR                                                                                                                        *
    * CREATED DATE                   : 29-AUG-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 29-AUG-2023   MAHENDER KUMAR                  TRANSFORM EDGE                   1.0              INTIAL VERSION                                                          * 
    * 20-Nov-2024   Dhivagar                        Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    TYPE REC_SPA_MASTER_DIST_NEW IS RECORD (
            CHM_SPA_ADD_DIST_ID      NUMBER,
            CHM_SPA_ID               NUMBER,
            SPA_NUMBER               VARCHAR2(4000),
            DISTRIBUTOR_ACCOUNT_NAME VARCHAR2(4000),
            SPA_DISTRIBUTOR_NAME     VARCHAR2(4000),
            DISTI_CUSTOMER_KEY       VARCHAR2(4000),
            SPA_NAME                 VARCHAR2(4000),
            STATUS                   VARCHAR2(4000),
            SFDC_CREATED_BY          VARCHAR2(4000),
            SPA_START_DATE           VARCHAR2(4000),
            SPA_EXPIRATION_DATE      VARCHAR2(4000),
            ATTRIBUTE_CONTEXT        VARCHAR2(4000),
            ATTRIBUTE1               VARCHAR2(4000),
            ATTRIBUTE2               VARCHAR2(4000),
            ATTRIBUTE3               VARCHAR2(4000),
            ATTRIBUTE4               VARCHAR2(4000),
            ATTRIBUTE5               VARCHAR2(4000),
            ATTRIBUTE6               VARCHAR2(4000),
            ATTRIBUTE7               VARCHAR2(4000),
            ATTRIBUTE8               VARCHAR2(4000),
            ATTRIBUTE9               VARCHAR2(4000),
            ATTRIBUTE10              VARCHAR2(4000),
            ATTRIBUTE11              VARCHAR2(4000),
            ATTRIBUTE12              VARCHAR2(4000),
            ATTRIBUTE13              VARCHAR2(4000),
            ATTRIBUTE14              VARCHAR2(4000),
            ATTRIBUTE15              VARCHAR2(4000),
            CREATED_BY               VARCHAR2(4000),
            CREATION_DATE            VARCHAR2(4000),
            LAST_UPDATED_BY          VARCHAR2(4000),
            LAST_UPDATE_DATE         VARCHAR2(4000)
    );
    TYPE TBL_SPA_MASTER_DIST_NEW IS
        TABLE OF REC_SPA_MASTER_DIST_NEW;
--PROCEDURE TO MERGE DISTRIBUTOR ACCOUNT DATA RECEIVED FROM FUSION
    PROCEDURE MERGE_DATA (
        P_IN_SPA_MASTER_DIST  IN TBL_SPA_MASTER_DIST_NEW,
        P_IN_OIC_INSTANCE_ID  IN VARCHAR2,        --------- V1.1
        P_OUT_RECORDS_FETCHED OUT NUMBER,
        P_OUT_RECORDS_MERGED  OUT NUMBER,
        P_OUT_ERROR_MESSAGE   OUT VARCHAR2
    );

END CHM_SPA_MASTER_DIST_PKG;
/
