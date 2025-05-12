CREATE OR REPLACE PACKAGE BODY CHM_COUNTRY_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_COUNTRY_PKG                                                                                                                      *
    * Purpose                        : Package for CHM Countries Integrations                                                                                               *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 27-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 27-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_COUNTRY			        IN      TBL_COUNTRY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2                      --------- V1.1
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
        FOR i IN P_IN_COUNTRY.FIRST .. P_IN_COUNTRY.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_TERRITORIES tbl
                USING (
                    SELECT 
                         P_IN_COUNTRY(i).ENTERPRISE_ID                ENTERPRISE_ID            	
                        ,P_IN_COUNTRY(i).LANGUAGE                     LANGUAGE                 	
                        ,P_IN_COUNTRY(i).TERRITORY_CODE               TERRITORY_CODE            	
                        ,P_IN_COUNTRY(i).TERRITORY_SHORT_NAME         TERRITORY_SHORT_NAME     	
                        ,P_IN_COUNTRY(i).NLS_TERRITORY                NLS_TERRITORY            	
                        ,P_IN_COUNTRY(i).DESCRIPTION                  DESCRIPTION               	
                        ,P_IN_COUNTRY(i).ALTERNATE_TERRITORY_CODE     ALTERNATE_TERRITORY_CODE 	
                        ,P_IN_COUNTRY(i).ISO_TERRITORY_CODE           ISO_TERRITORY_CODE       	
                        ,P_IN_COUNTRY(i).CURRENCY_CODE                CURRENCY_CODE            	
                        ,P_IN_COUNTRY(i).EU_CODE                      EU_CODE                  	
                        ,P_IN_COUNTRY(i).ISO_NUMERIC_CODE             ISO_NUMERIC_CODE         	
                        ,P_IN_COUNTRY(i).OBSOLETE_FLAG                OBSOLETE_FLAG            	
                        ,P_IN_COUNTRY(i).ENABLED_FLAG                 ENABLED_FLAG             	
                        ,P_IN_OIC_INSTANCE_ID                         OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.ENTERPRISE_ID       = tmp.ENTERPRISE_ID 
                    AND tbl.LANGUAGE            = tmp.LANGUAGE 
                    AND tbl.TERRITORY_CODE      = tmp.TERRITORY_CODE 
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         ENTERPRISE_ID               
                        ,LANGUAGE                    
                        ,TERRITORY_CODE              
                        ,TERRITORY_SHORT_NAME     
                        ,NLS_TERRITORY               
                        ,DESCRIPTION                 
                        ,ALTERNATE_TERRITORY_CODE 
                        ,ISO_TERRITORY_CODE       
                        ,CURRENCY_CODE            
                        ,EU_CODE                  
                        ,ISO_NUMERIC_CODE         
                        ,OBSOLETE_FLAG            
                        ,ENABLED_FLAG             
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.ENTERPRISE_ID            
                        ,tmp.LANGUAGE                 
                        ,tmp.TERRITORY_CODE           
                        ,tmp.TERRITORY_SHORT_NAME     
                        ,tmp.NLS_TERRITORY            
                        ,tmp.DESCRIPTION              
                        ,tmp.ALTERNATE_TERRITORY_CODE 
                        ,tmp.ISO_TERRITORY_CODE       
                        ,tmp.CURRENCY_CODE            
                        ,tmp.EU_CODE                  
                        ,tmp.ISO_NUMERIC_CODE         
                        ,tmp.OBSOLETE_FLAG            
                        ,tmp.ENABLED_FLAG             
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         TERRITORY_SHORT_NAME           = tmp.TERRITORY_SHORT_NAME     
                        ,NLS_TERRITORY                  = tmp.NLS_TERRITORY            
                        ,DESCRIPTION                    = tmp.DESCRIPTION              
                        ,ALTERNATE_TERRITORY_CODE       = tmp.ALTERNATE_TERRITORY_CODE 
                        ,ISO_TERRITORY_CODE             = tmp.ISO_TERRITORY_CODE       
                        ,CURRENCY_CODE                  = tmp.CURRENCY_CODE            
                        ,EU_CODE                        = tmp.EU_CODE                  
                        ,ISO_NUMERIC_CODE               = tmp.ISO_NUMERIC_CODE         
                        ,OBSOLETE_FLAG                  = tmp.OBSOLETE_FLAG            
                        ,ENABLED_FLAG                   = tmp.ENABLED_FLAG             
                        ,OIC_INSTANCE_ID			    = tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE			    = sysdate
                    WHERE	1=1
                    AND tbl.ENTERPRISE_ID               = tmp.ENTERPRISE_ID 
                    AND tbl.LANGUAGE                    = tmp.LANGUAGE 
                    AND tbl.TERRITORY_CODE              = tmp.TERRITORY_CODE;
                
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
    
END CHM_COUNTRY_PKG;
/
