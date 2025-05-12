CREATE OR REPLACE PACKAGE CHM_CURRENCY_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_CURRENCY_PKG                                                                                                                      *
    * Purpose                        : Package for CHM Currencies Integrations                                                                                               *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 25-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 25-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_CURRENCY IS RECORD (
         CURRENCY_CODE   		VARCHAR2(4000)  
        ,NAME         			VARCHAR2(4000)  
        ,DESCRIPTION        	VARCHAR2(4000)	
        ,ISSUING_TERRITORY_CODE	VARCHAR2(4000)
        ,SYMBOL          		VARCHAR2(4000)  
        ,CURRENCY_FLAG      	CHAR(1)   		
        ,ISO_FLAG          		CHAR(1)         
        ,LANGUAGE          		VARCHAR2(4000)     
    );
    
    TYPE TBL_CURRENCY IS TABLE OF REC_CURRENCY;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_CURRENCY			        IN      TBL_CURRENCY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2               ----------- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_CURRENCY_PKG;
/
