CREATE OR REPLACE PACKAGE CHM_ORGANIZATION_UNIT_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_ORGANIZATION_UNIT_PKG                                                                                                             *
    * Purpose                        : Package for CHM Organization Units Integrations                                                                                       *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 23-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 23-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_BUSINESS_UNIT IS RECORD (
         SOURCE_ORG_ID              NUMBER        
        ,NAME                       VARCHAR2(4000)
        ,SHORT_CODE                 VARCHAR2(4000)
        ,SET_OF_BOOKS_ID            NUMBER        
        ,DEFAULT_LEGAL_CONTEXT_ID   NUMBER        
        ,DATE_FROM                  DATE          
        ,DATE_TO                    DATE          
    );
    
    TYPE TBL_BUSINESS_UNIT IS TABLE OF REC_BUSINESS_UNIT;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_BUSINESS_UNIT             IN      TBL_BUSINESS_UNIT
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_ORGANIZATION_UNIT_PKG;
/
