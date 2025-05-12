CREATE OR REPLACE PACKAGE CHM_PRICE_LIST_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_PRICE_LIST_PKG                                                                                                                    *
    * Purpose                        : Package Specification for CHM Price List Integration                                                                                  *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 05-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 05-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_PRICE_LIST IS RECORD (
         SOURCE_PRICE_LIST_ID	            NUMBER              
        ,LANGUAGE	                        VARCHAR2(4000)
        ,NAME	                            VARCHAR2(4000)
        ,DESCRIPTION	                    VARCHAR2(4000)
        ,ORG_ID	                            NUMBER              
        ,CATALOG_ID	                        NUMBER
        ,CHARGE_DEFINITION_ID	            NUMBER
        ,CURRENCY_CODE	                    VARCHAR2(4000)
        ,CALCULATION_METHOD_CODE	        VARCHAR2(4000)
        ,PRICE_LIST_TYPE_CODE	            VARCHAR2(4000)
        ,LINE_TYPE_CODE	                    VARCHAR2(4000)
        ,STATUS_CODE	                    VARCHAR2(4000)
        ,START_DATE_ACTIVE  		        DATE                
        ,END_DATE_ACTIVE    		        DATE
    );
    
    TYPE TBL_PRICE_LIST IS TABLE OF REC_PRICE_LIST;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_PRICE_LIST			    IN      TBL_PRICE_LIST
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2       ----- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_PRICE_LIST_PKG;
/
