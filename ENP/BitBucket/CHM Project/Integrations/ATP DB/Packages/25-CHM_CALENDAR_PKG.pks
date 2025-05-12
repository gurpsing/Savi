CREATE OR REPLACE PACKAGE CHM_CALENDAR_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_CALENDAR_PKG                                                                                                                      *
    * Purpose                        : Package for CHM Calendars Integrations                                                                                                *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 25-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 25-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_CALENDAR IS RECORD (
         SOURCE_CALENDAR_ID					NUMBER			 
        ,PERIOD_SET_NAME					VARCHAR2(4000)		
        ,PERIOD_TYPE						VARCHAR2(4000)	
        ,USER_PERIOD_SET_NAME				VARCHAR2(4000)	 
        ,DESCRIPTION						VARCHAR2(4000)		
        ,PERIOD_SET_ID						NUMBER			
        ,PERIOD_TYPE_ID						NUMBER			
        ,NON_ADJ_PERIOD_FREQ_CODE			VARCHAR2(4000)	
        ,ADJ_PERIOD_FREQ_CODE				VARCHAR2(4000)	
        ,ADJ_PERIODS_NUM					NUMBER		
        ,LEGACY_RULES_ENABLED_FLAG			CHAR(1)			
        ,NON_ADJ_PERIODS_NUM				NUMBER			
        ,USER_PERIOD_NAME_PREFIX			VARCHAR2(4000)	
        ,PERIOD_NAME_FORMAT_CODE			VARCHAR2(4000)	
        ,PERIOD_NAME_SEPARATOR_CODE			VARCHAR2(4000)	
        ,LATEST_YEAR_START_DATE				DATE			
        ,CALENDAR_START_DATE				DATE			
        ,CALENDAR_TYPE_CODE					VARCHAR2(4000)	
        ,LEGACY_CALENDAR_FLAG				CHAR(1)			
        ,DEFAULT_PARTITION_GROUP_CODE		VARCHAR2(4000)        
    );
    
    TYPE TBL_CALENDAR IS TABLE OF REC_CALENDAR;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_CALENDAR                  IN      TBL_CALENDAR
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_CALENDAR_PKG;
/
