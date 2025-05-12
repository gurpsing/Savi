CREATE OR REPLACE PACKAGE CHM_LEDGER_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_LEDGER_PKG                                                                                                                        *
    * Purpose                        : Package for CHM Ledgers Integrations                                                                                                  *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 22-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 22-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_LEDGER IS RECORD (
         SOURCE_LEDGER_ID   			NUMBER          
        ,NAME							VARCHAR2(4000)	
        ,SHORT_NAME						VARCHAR2(4000)	
        ,DESCRIPTION					VARCHAR2(4000)	
        ,LEDGER_CATEGORY_CODE			VARCHAR2(4000)	
        ,ALC_LEDGER_TYPE_CODE			VARCHAR2(4000)	
        ,OBJECT_TYPE_CODE				CHAR(1)			
        ,LE_LEDGER_TYPE_CODE			CHAR(1)			
        ,COMPLETION_STATUS_CODE			VARCHAR2(4000)	
        ,CHART_OF_ACCOUNTS_ID			NUMBER          
        ,CURRENCY_CODE					VARCHAR2(4000)  
        ,PERIOD_SET_NAME				VARCHAR2(4000)  
        ,SUSPENSE_ALLOWED_FLAG			CHAR(1)         
        ,ALLOW_INTERCOMPANY_POST_FLAG	CHAR(1)         
        ,ENABLE_AVERAGE_BALANCES_FLAG	CHAR(1)         
    );
    
    TYPE TBL_LEDGER IS TABLE OF REC_LEDGER;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_LEDGER			        IN      TBL_LEDGER
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2                 -- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_LEDGER_PKG;
/
