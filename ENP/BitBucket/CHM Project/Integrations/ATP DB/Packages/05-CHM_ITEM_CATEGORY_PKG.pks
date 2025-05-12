CREATE OR REPLACE PACKAGE CHM_ITEM_CATEGORY_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_ITEM_CATEGORY_PKG                                                                                                                 *
    * Purpose                        : Package Specification for CHM Item Category Integrations                                                                              *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 29-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 29-Jun-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_ITEM_CATEGORY IS RECORD (
         SOURCE_CATEGORY_ID	                NUMBER            
        ,LANGUAGE	                        VARCHAR2(4000)
        ,CATEGORY_NAME 	                    VARCHAR2(4000)               
        ,DESCRIPTION	                    VARCHAR2(4000)              
        ,CATEGORY_CONTENT_CODE	            VARCHAR2(4000)
        ,CATEGORY_CODE	                    VARCHAR2(4000)
        ,DISABLE_DATE	                    DATE
        ,SUMMARY_FLAG	                    CHAR(1)
        ,ATTRIBUTE_CATEGORY	                VARCHAR2(4000)
        ,ATTRIBUTE1	                        VARCHAR2(4000)
        ,ATTRIBUTE2	                        VARCHAR2(4000)
        ,ATTRIBUTE3	                        VARCHAR2(4000)
        ,ATTRIBUTE4	                        VARCHAR2(4000)
        ,ATTRIBUTE5	                        VARCHAR2(4000)
        ,ATTRIBUTE6	                        VARCHAR2(4000)
        ,ATTRIBUTE7	                        VARCHAR2(4000)
        ,ATTRIBUTE8	                        VARCHAR2(4000)
        ,ATTRIBUTE9	                        VARCHAR2(4000)
        ,ATTRIBUTE10	                    VARCHAR2(4000)
        ,ATTRIBUTE11	                    VARCHAR2(4000)
        ,ATTRIBUTE12	                    VARCHAR2(4000)
        ,ATTRIBUTE13	                    VARCHAR2(4000)
        ,ATTRIBUTE14	                    VARCHAR2(4000)
        ,ATTRIBUTE15	                    VARCHAR2(4000)  
        ,ENABLED_FLAG        		        CHAR(1)
        ,START_DATE_ACTIVE  		        DATE   
        ,END_DATE_ACTIVE    		        DATE     
    );
    
    TYPE TBL_ITEM_CATEGORY IS TABLE OF REC_ITEM_CATEGORY;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_ITEM_CATEGORY			    IN      TBL_ITEM_CATEGORY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2               -------- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_ITEM_CATEGORY_PKG;
/
