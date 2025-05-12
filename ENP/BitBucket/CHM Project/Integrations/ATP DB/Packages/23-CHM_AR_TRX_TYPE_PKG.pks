CREATE OR REPLACE PACKAGE CHM_AR_TRX_TYPE_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_AR_TRX_TYPE_PKG                                                                                                                   *
    * Purpose                        : Package for CHM AR Transaction Types Integrations                                                                                     *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 27-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 27-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_TRX_TYPE IS RECORD (
         SOURCE_TRX_TYPE_ID	                NUMBER              
        ,TRX_TYPE_SEQ_ID	                NUMBER              
        ,ORG_ID	                            NUMBER              
        ,NAME	                            VARCHAR2(4000)      
        ,DESCRIPTION	                    VARCHAR2(4000)      
        ,TYPE	                            VARCHAR2(4000)      
        ,DEFAULT_PRINTING_OPTION	        VARCHAR2(4000)      
        ,DEFAULT_STATUS	                    VARCHAR2(4000)      
        ,ALLOW_FREIGHT_FLAG	                CHAR(1)             
        ,ALLOW_OVERAPPLICATION_FLAG	        CHAR(1)             
        ,TAX_CALCULATION_FLAG	            CHAR(1)             
        ,STATUS	                            VARCHAR2(4000)      
        ,START_DATE	                        DATE                
        ,END_DATE	                        DATE         
    );
    
    TYPE TBL_TRX_TYPE IS TABLE OF REC_TRX_TYPE;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_TRX_TYPE			        IN      TBL_TRX_TYPE
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2           ----------- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_AR_TRX_TYPE_PKG;
/
