CREATE OR REPLACE PACKAGE CHM_LOOKUP_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_LOOKUP_PKG                                                                                                                        *
    * Purpose                        : Package Specification for CHM Lookup Integrations                                                                                     *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 18-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 18-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_LOOKUP_TYPE IS RECORD (
         SOURCE_APPLICATION_ID      NUMBER    		 
        ,ENTERPRISE_ID              NUMBER    		
        ,LANGUAGE         		    VARCHAR2(4000)
        ,LOOKUP_TYPE         		VARCHAR2(4000)
        ,MEANING         		    VARCHAR2(4000)
        ,DESCRIPTION				VARCHAR2(4000)
    );
    
    TYPE REC_LOOKUP_VALUE IS RECORD (
         SOURCE_APPLICATION_ID      NUMBER    		
        ,ENTERPRISE_ID   		    NUMBER    		
        ,SET_ID   		            NUMBER    		
        ,LANGUAGE   		        VARCHAR2(4000)
        ,DISPLAY_SEQUENCE   		NUMBER    		
        ,LOOKUP_TYPE				VARCHAR2(4000)
        ,LOOKUP_CODE				VARCHAR2(4000)
        ,MEANING					VARCHAR2(4000)
        ,DESCRIPTION				VARCHAR2(4000)
        ,ENABLED_FLAG				CHAR(1)
        ,START_DATE_ACTIVE		    DATE
        ,END_DATE_ACTIVE		    DATE
    );
    
    TYPE TBL_LOOKUP_TYPE IS TABLE OF REC_LOOKUP_TYPE;
    
    TYPE TBL_LOOKUP_VALUE IS TABLE OF REC_LOOKUP_VALUE;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_LOOKUP_TYPE			    IN      TBL_LOOKUP_TYPE
        ,P_IN_LOOKUP_VALUE			    IN      TBL_LOOKUP_VALUE
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2               ------------ V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_LOOKUP_PKG;
/
