create or replace PACKAGE CHM_INSTALLER_STAGING_PKG

    /**************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                         *
    * Package Name                   : CHM_INSTALLER_STAGING_PKG                                                              *
    * Purpose                        : Package for loading installer data into CHM                                            *
    * Created By                     : Gurpreet Singh                                                                         *
    * Created Date                   : 22-Sep-2023                                                                            *     
    ***************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                  * 
    * -----------   ---------------------------    ---------------------------      -------------    -------------------------*
    * 22-Sep-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version           * 
    **************************************************************************************************************************/
AS
    --Procedure to load data into CHM table
    PROCEDURE LOAD_DATA(
         P_OUT_ERROR_MESSAGE          OUT     CLOB
        ,P_OUT_RECORDS_FETCHED        OUT     NUMBER
        ,P_OUT_RECORDS_MERGED         OUT     NUMBER
    );

END CHM_INSTALLER_STAGING_PKG;
/
