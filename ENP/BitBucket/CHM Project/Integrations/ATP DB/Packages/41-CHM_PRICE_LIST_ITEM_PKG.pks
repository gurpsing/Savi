CREATE OR REPLACE PACKAGE CHM_PRICE_LIST_ITEM_PKG
    
    /******************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                               *
    * Package Name                   : CHM_PRICE_LIST_ITEM_PKG                                                                    *
    * Purpose                        : Package Specification for CHM Price List Items Integrations                                *
    * Created By                     : Gurpreet Singh                                                                             *
    * Created Date                   : 10-Aug-2023                                                                                *     
    *******************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                      * 
    * -----------   ---------------------------    ---------------------------      -------------    -----------------------------*
    * 10-Aug-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version               * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    ******************************************************************************************************************************/

AS
    
    TYPE REC_PRICE_LIST_ITEM IS RECORD (
         PRICE_LIST_ITEM_ID	    NUMBER
        ,PRICE_LIST_ID	        NUMBER
        ,PRICE_LIST_CHARGE_ID	NUMBER
        ,ITEM_ID	            NUMBER
        ,BASE_PRICE	            NUMBER
        ,START_DATE	            DATE
        ,END_DATE	            DATE         
    );
    
    TYPE TBL_PRICE_LIST_ITEM IS TABLE OF REC_PRICE_LIST_ITEM;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_PRICE_LIST_ITEM			IN      TBL_PRICE_LIST_ITEM
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2        ----- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_PRICE_LIST_ITEM_PKG;
/
