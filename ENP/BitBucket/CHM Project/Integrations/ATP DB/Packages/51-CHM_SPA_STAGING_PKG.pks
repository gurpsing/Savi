create or replace PACKAGE CHM_SPA_STAGING_PKG
    
    /**************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE                                                                         *
    * PACKAGE NAME                   : CHM_SPA_STAGING_PKG                                                                    *
    * PURPOSE                        : Package for loading SPA data into CHM                                                  *
    * CREATED BY                     : Gurpreet Singh                                                                         *
    * CREATED DATE                   : 25-Sep-2023                                                                            *     
    ***************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                  * 
    * -----------   ---------------------------    ---------------------------      -------------    -------------------------*
    * 25-Sep-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version           *
    **************************************************************************************************************************/
AS

    --Procedure to load data into CHM table
    PROCEDURE LOAD_DATA(
         P_OUT_ERROR_MESSAGE          OUT     CLOB
        ,P_OUT_RECORDS_FETCHED        OUT     NUMBER
        ,P_OUT_RECORDS_MERGED         OUT     NUMBER
    );

END CHM_SPA_STAGING_PKG;
/
