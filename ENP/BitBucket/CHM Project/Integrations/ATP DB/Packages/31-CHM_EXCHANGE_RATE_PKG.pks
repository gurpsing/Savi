CREATE OR REPLACE PACKAGE CHM_EXCHANGE_RATE_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_EXCHANGE_RATE_PKG                                                                                                                 *
    * Purpose                        : Package for CHM Exchange Rate Integrations                                                                                            *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 19-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 19-Jun-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                      Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_EXCHANGE_RATE IS RECORD (
         FROM_CURRENCY			    VARCHAR2(4000)
        ,TO_CURRENCY			    VARCHAR2(4000)
        ,CONVERSION_DATE		    DATE
        ,CONVERSION_TYPE		    VARCHAR2(4000)
        ,USER_CONVERSION_TYPE	    VARCHAR2(4000)
        ,CONVERSION_RATE		    NUMBER
        ,STATUS_CODE			    CHAR(1)
    );
    
    TYPE TBL_EXCHANGE_RATE IS TABLE OF REC_EXCHANGE_RATE;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_EXCHANGE_RATE			    IN      TBL_EXCHANGE_RATE
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2            ------- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_EXCHANGE_RATE_PKG;
/
