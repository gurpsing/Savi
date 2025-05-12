CREATE OR REPLACE PACKAGE BODY CHM_CALENDAR_PKG
    
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
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_CALENDAR                  IN      TBL_CALENDAR
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2                --------- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    )
    AS
       L_COUNT              NUMBER :=0;
       L_MERGE_COUNT        NUMBER :=0;
       L_ERROR_MESSAGE      VARCHAR2(30000);
    BEGIN
    
        --For each record in input table type merge the record
        FOR i IN P_IN_CALENDAR.FIRST .. P_IN_CALENDAR.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_CALENDARS tbl
                USING (
                    SELECT 
                         P_IN_CALENDAR(i).SOURCE_CALENDAR_ID				SOURCE_CALENDAR_ID				
                        ,P_IN_CALENDAR(i).PERIOD_SET_NAME				    PERIOD_SET_NAME				
                        ,P_IN_CALENDAR(i).PERIOD_TYPE					    PERIOD_TYPE					
                        ,P_IN_CALENDAR(i).USER_PERIOD_SET_NAME			    USER_PERIOD_SET_NAME			
                        ,P_IN_CALENDAR(i).DESCRIPTION					    DESCRIPTION					
                        ,P_IN_CALENDAR(i).PERIOD_SET_ID					    PERIOD_SET_ID					
                        ,P_IN_CALENDAR(i).PERIOD_TYPE_ID					PERIOD_TYPE_ID					
                        ,P_IN_CALENDAR(i).NON_ADJ_PERIOD_FREQ_CODE		    NON_ADJ_PERIOD_FREQ_CODE		
                        ,P_IN_CALENDAR(i).ADJ_PERIOD_FREQ_CODE			    ADJ_PERIOD_FREQ_CODE			
                        ,P_IN_CALENDAR(i).ADJ_PERIODS_NUM				    ADJ_PERIODS_NUM				
                        ,P_IN_CALENDAR(i).LEGACY_RULES_ENABLED_FLAG		    LEGACY_RULES_ENABLED_FLAG		
                        ,P_IN_CALENDAR(i).NON_ADJ_PERIODS_NUM			    NON_ADJ_PERIODS_NUM			
                        ,P_IN_CALENDAR(i).USER_PERIOD_NAME_PREFIX		    USER_PERIOD_NAME_PREFIX		
                        ,P_IN_CALENDAR(i).PERIOD_NAME_FORMAT_CODE		    PERIOD_NAME_FORMAT_CODE		
                        ,P_IN_CALENDAR(i).PERIOD_NAME_SEPARATOR_CODE		PERIOD_NAME_SEPARATOR_CODE		
                        ,P_IN_CALENDAR(i).LATEST_YEAR_START_DATE			LATEST_YEAR_START_DATE			
                        ,P_IN_CALENDAR(i).CALENDAR_START_DATE			    CALENDAR_START_DATE			
                        ,P_IN_CALENDAR(i).CALENDAR_TYPE_CODE				CALENDAR_TYPE_CODE				
                        ,P_IN_CALENDAR(i).LEGACY_CALENDAR_FLAG			    LEGACY_CALENDAR_FLAG			
                        ,P_IN_CALENDAR(i).DEFAULT_PARTITION_GROUP_CODE	    DEFAULT_PARTITION_GROUP_CODE	
                        ,P_IN_OIC_INSTANCE_ID                               OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.PERIOD_SET_NAME     = tmp.PERIOD_SET_NAME 
                    AND tbl.PERIOD_TYPE         = tmp.PERIOD_TYPE 
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SOURCE_CALENDAR_ID			
                        ,PERIOD_SET_NAME				
                        ,PERIOD_TYPE					  
                        ,USER_PERIOD_SET_NAME		
                        ,DESCRIPTION					
                        ,PERIOD_SET_ID				
                        ,PERIOD_TYPE_ID				
                        ,NON_ADJ_PERIOD_FREQ_CODE	
                        ,ADJ_PERIOD_FREQ_CODE		  
                        ,ADJ_PERIODS_NUM				
                        ,LEGACY_RULES_ENABLED_FLAG	 
                        ,NON_ADJ_PERIODS_NUM			
                        ,USER_PERIOD_NAME_PREFIX		 
                        ,PERIOD_NAME_FORMAT_CODE		
                        ,PERIOD_NAME_SEPARATOR_CODE	
                        ,LATEST_YEAR_START_DATE		
                        ,CALENDAR_START_DATE			
                        ,CALENDAR_TYPE_CODE			
                        ,LEGACY_CALENDAR_FLAG		
                        ,DEFAULT_PARTITION_GROUP_CODE
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.SOURCE_CALENDAR_ID			
                        ,tmp.PERIOD_SET_NAME				
                        ,tmp.PERIOD_TYPE					
                        ,tmp.USER_PERIOD_SET_NAME		
                        ,tmp.DESCRIPTION					
                        ,tmp.PERIOD_SET_ID				
                        ,tmp.PERIOD_TYPE_ID				
                        ,tmp.NON_ADJ_PERIOD_FREQ_CODE	
                        ,tmp.ADJ_PERIOD_FREQ_CODE		
                        ,tmp.ADJ_PERIODS_NUM				
                        ,tmp.LEGACY_RULES_ENABLED_FLAG	
                        ,tmp.NON_ADJ_PERIODS_NUM			
                        ,tmp.USER_PERIOD_NAME_PREFIX		
                        ,tmp.PERIOD_NAME_FORMAT_CODE		
                        ,tmp.PERIOD_NAME_SEPARATOR_CODE	
                        ,tmp.LATEST_YEAR_START_DATE		
                        ,tmp.CALENDAR_START_DATE			
                        ,tmp.CALENDAR_TYPE_CODE			
                        ,tmp.LEGACY_CALENDAR_FLAG		
                        ,tmp.DEFAULT_PARTITION_GROUP_CODE
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         SOURCE_CALENDAR_ID				= tmp.SOURCE_CALENDAR_ID				
                        ,USER_PERIOD_SET_NAME		    = tmp.USER_PERIOD_SET_NAME		
                        ,DESCRIPTION					= tmp.DESCRIPTION					
                        ,PERIOD_SET_ID				    = tmp.PERIOD_SET_ID				
                        ,PERIOD_TYPE_ID				    = tmp.PERIOD_TYPE_ID				
                        ,NON_ADJ_PERIOD_FREQ_CODE	    = tmp.NON_ADJ_PERIOD_FREQ_CODE	
                        ,ADJ_PERIOD_FREQ_CODE		    = tmp.ADJ_PERIOD_FREQ_CODE		
                        ,ADJ_PERIODS_NUM				= tmp.ADJ_PERIODS_NUM				
                        ,LEGACY_RULES_ENABLED_FLAG	    = tmp.LEGACY_RULES_ENABLED_FLAG	
                        ,NON_ADJ_PERIODS_NUM			= tmp.NON_ADJ_PERIODS_NUM			
                        ,USER_PERIOD_NAME_PREFIX		= tmp.USER_PERIOD_NAME_PREFIX		
                        ,PERIOD_NAME_FORMAT_CODE		= tmp.PERIOD_NAME_FORMAT_CODE		
                        ,PERIOD_NAME_SEPARATOR_CODE	    = tmp.PERIOD_NAME_SEPARATOR_CODE	
                        ,LATEST_YEAR_START_DATE		    = tmp.LATEST_YEAR_START_DATE		
                        ,CALENDAR_START_DATE			= tmp.CALENDAR_START_DATE			
                        ,CALENDAR_TYPE_CODE			    = tmp.CALENDAR_TYPE_CODE			
                        ,LEGACY_CALENDAR_FLAG		    = tmp.LEGACY_CALENDAR_FLAG		
                        ,DEFAULT_PARTITION_GROUP_CODE   = tmp.DEFAULT_PARTITION_GROUP_CODE
                        ,OIC_INSTANCE_ID                = tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE               = sysdate
                    WHERE    1=1
                    AND PERIOD_SET_NAME                 = tmp.PERIOD_SET_NAME
                    AND PERIOD_TYPE                     = tmp.PERIOD_TYPE;
                
                L_MERGE_COUNT:= L_MERGE_COUNT+1;
                
            EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;
        
        END LOOP;
        
        P_OUT_RECORDS_FETCHED   := L_COUNT;
        P_OUT_RECORDS_MERGED    := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE     := substr(L_ERROR_MESSAGE,1,4000);
        
    END MERGE_DATA;
    
END CHM_CALENDAR_PKG;
/
