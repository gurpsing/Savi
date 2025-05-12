CREATE OR REPLACE PACKAGE BODY CHM_LOOKUP_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_LOOKUP_PKG                                                                                                                        *
    * Purpose                        : Package Body for CHM Lookup Integrations                                                                                              *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 18-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 18-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_LOOKUP_TYPE			    IN      TBL_LOOKUP_TYPE
        ,P_IN_LOOKUP_VALUE			    IN      TBL_LOOKUP_VALUE
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2              -------- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    )
    AS
       L_COUNT              NUMBER :=0;
       L_MERGE_COUNT        NUMBER :=0;
       L_ERROR_MESSAGE      VARCHAR2(30000);
    BEGIN
    
        --For each lookup type record in input table type merge the record
        FOR i IN P_IN_LOOKUP_TYPE.FIRST .. P_IN_LOOKUP_TYPE.LAST 
        LOOP
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_LOOKUP_TYPES tbl
                USING (
                    SELECT 
                         P_IN_LOOKUP_TYPE(i).SOURCE_APPLICATION_ID      SOURCE_APPLICATION_ID
                        ,P_IN_LOOKUP_TYPE(i).ENTERPRISE_ID              ENTERPRISE_ID
                        ,P_IN_LOOKUP_TYPE(i).LANGUAGE                   LANGUAGE
                        ,P_IN_LOOKUP_TYPE(i).LOOKUP_TYPE                LOOKUP_TYPE
                        ,P_IN_LOOKUP_TYPE(i).MEANING                    MEANING
                        ,P_IN_LOOKUP_TYPE(i).DESCRIPTION                DESCRIPTION
                        ,(SELECT CHM_SOURCE_SYSTEM_ID FROM CHM_SOURCE_SYSTEMS WHERE SHORT_NAME='ORACLE') CHM_SOURCE_SYSTEM_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.SOURCE_APPLICATION_ID   = tmp.SOURCE_APPLICATION_ID 
                    AND tbl.ENTERPRISE_ID           = tmp.ENTERPRISE_ID 
                    AND tbl.LANGUAGE                = tmp.LANGUAGE 
                    AND tbl.LOOKUP_TYPE             = tmp.LOOKUP_TYPE 
                    AND tbl.CHM_SOURCE_SYSTEM_ID    = tmp.CHM_SOURCE_SYSTEM_ID 
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         CHM_SOURCE_SYSTEM_ID    
                        ,SOURCE_APPLICATION_ID   
                        ,ENTERPRISE_ID           
                        ,LANGUAGE         		 
                        ,LOOKUP_TYPE         	 
                        ,MEANING         		 
                        ,DESCRIPTION			                          
                    )
                    VALUES (
                         tmp.CHM_SOURCE_SYSTEM_ID 
                        ,tmp.SOURCE_APPLICATION_ID
                        ,tmp.ENTERPRISE_ID        
                        ,tmp.LANGUAGE         		
                        ,tmp.LOOKUP_TYPE         
                        ,tmp.MEANING         		
                        ,tmp.DESCRIPTION			
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         MEANING                    = tmp.MEANING
                        ,DESCRIPTION                = tmp.DESCRIPTION
                        ,LAST_UPDATE_DATE			= sysdate
                    WHERE	1=1
                    AND SOURCE_APPLICATION_ID       = tmp.SOURCE_APPLICATION_ID 
                    AND ENTERPRISE_ID               = tmp.ENTERPRISE_ID 
                    AND LANGUAGE                    = tmp.LANGUAGE 
                    AND LOOKUP_TYPE                 = tmp.LOOKUP_TYPE 
                    AND CHM_SOURCE_SYSTEM_ID        = tmp.CHM_SOURCE_SYSTEM_ID;
                
                
            EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||'. '||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;
        
        END LOOP;
        
        
        --For each lookup value record in input table type merge the record
        FOR i IN P_IN_LOOKUP_VALUE.FIRST .. P_IN_LOOKUP_VALUE.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_LOOKUP_VALUES tbl
                USING (
                    SELECT 
                         P_IN_LOOKUP_VALUE(i).SOURCE_APPLICATION_ID      SOURCE_APPLICATION_ID
                        ,P_IN_LOOKUP_VALUE(i).ENTERPRISE_ID              ENTERPRISE_ID
                        ,P_IN_LOOKUP_VALUE(i).SET_ID                     SET_ID
                        ,P_IN_LOOKUP_VALUE(i).LANGUAGE                   LANGUAGE
                        ,P_IN_LOOKUP_VALUE(i).DISPLAY_SEQUENCE           DISPLAY_SEQUENCE
                        ,P_IN_LOOKUP_VALUE(i).LOOKUP_CODE                LOOKUP_CODE
                        ,P_IN_LOOKUP_VALUE(i).MEANING                    MEANING
                        ,P_IN_LOOKUP_VALUE(i).DESCRIPTION                DESCRIPTION
                        ,P_IN_LOOKUP_VALUE(i).ENABLED_FLAG               ENABLED_FLAG
                        ,P_IN_LOOKUP_VALUE(i).START_DATE_ACTIVE          START_DATE_ACTIVE
                        ,P_IN_LOOKUP_VALUE(i).END_DATE_ACTIVE            END_DATE_ACTIVE
                        ,(  SELECT CHM_LOOKUP_TYPE_ID FROM CHM_LOOKUP_TYPES WHERE LOOKUP_TYPE=P_IN_LOOKUP_VALUE(i).LOOKUP_TYPE 
                            AND CHM_SOURCE_SYSTEM_ID    = (SELECT CHM_SOURCE_SYSTEM_ID FROM CHM_SOURCE_SYSTEMS WHERE SHORT_NAME='ORACLE')
                            AND SOURCE_APPLICATION_ID   = P_IN_LOOKUP_VALUE(i).SOURCE_APPLICATION_ID
                        ) CHM_LOOKUP_TYPE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.CHM_LOOKUP_TYPE_ID      = tmp.CHM_LOOKUP_TYPE_ID 
                    AND tbl.ENTERPRISE_ID           = tmp.ENTERPRISE_ID 
                    AND tbl.SET_ID                  = tmp.SET_ID 
                    AND tbl.LANGUAGE                = tmp.LANGUAGE 
                    AND tbl.LOOKUP_CODE             = tmp.LOOKUP_CODE 
                    AND tbl.MEANING                 = tmp.MEANING 
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         CHM_LOOKUP_TYPE_ID  
                        ,ENTERPRISE_ID   	
                        ,SET_ID   		    
                        ,LANGUAGE   		
                        ,DISPLAY_SEQUENCE   
                        ,LOOKUP_CODE		
                        ,MEANING			
                        ,DESCRIPTION
                        ,ENABLED_FLAG
                        ,START_DATE_ACTIVE
                        ,END_DATE_ACTIVE
                    )
                    VALUES (
                         tmp.CHM_LOOKUP_TYPE_ID 
                        ,tmp.ENTERPRISE_ID        
                        ,tmp.SET_ID        
                        ,tmp.LANGUAGE         		
                        ,tmp.DISPLAY_SEQUENCE         
                        ,tmp.LOOKUP_CODE         
                        ,tmp.MEANING         		
                        ,tmp.DESCRIPTION			
                        ,tmp.ENABLED_FLAG			
                        ,tmp.START_DATE_ACTIVE			
                        ,tmp.END_DATE_ACTIVE			
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         DESCRIPTION            = tmp.DESCRIPTION
                        ,ENABLED_FLAG           = tmp.ENABLED_FLAG
                        ,START_DATE_ACTIVE      = tmp.START_DATE_ACTIVE
                        ,END_DATE_ACTIVE        = tmp.END_DATE_ACTIVE
                        ,LAST_UPDATE_DATE		= sysdate
                    WHERE	1=1
                    AND CHM_LOOKUP_TYPE_ID      = tmp.CHM_LOOKUP_TYPE_ID 
                    AND ENTERPRISE_ID           = tmp.ENTERPRISE_ID 
                    AND SET_ID                  = tmp.SET_ID 
                    AND LANGUAGE                = tmp.LANGUAGE 
                    AND LOOKUP_CODE             = tmp.LOOKUP_CODE 
                    AND MEANING                 = tmp.MEANING ;
                
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
    
END CHM_LOOKUP_PKG;
/





