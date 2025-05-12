CREATE OR REPLACE PACKAGE BODY CHM_PRICE_LIST_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_PRICE_LIST_PKG                                                                                                                    *
    * Purpose                        : Package Body for CHM Item Integration                                                                                                 *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 05-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 05-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_PRICE_LIST			    IN      TBL_PRICE_LIST
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2        --- V1.1
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
        FOR i IN P_IN_PRICE_LIST.FIRST .. P_IN_PRICE_LIST.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_PRICE_LISTS tbl
                USING (
                    SELECT 
                         P_IN_PRICE_LIST(i).SOURCE_PRICE_LIST_ID	        SOURCE_PRICE_LIST_ID	      
                        ,P_IN_PRICE_LIST(i).LANGUAGE	                    LANGUAGE	                  
                        ,P_IN_PRICE_LIST(i).NAME	                        NAME	                      
                        ,P_IN_PRICE_LIST(i).DESCRIPTION	                    DESCRIPTION	              
                        ,P_IN_PRICE_LIST(i).ORG_ID	                        ORG_ID	                      
                        ,P_IN_PRICE_LIST(i).CATALOG_ID	                    CATALOG_ID	                  
                        ,P_IN_PRICE_LIST(i).CHARGE_DEFINITION_ID	        CHARGE_DEFINITION_ID	      
                        ,P_IN_PRICE_LIST(i).CURRENCY_CODE	                CURRENCY_CODE	              
                        ,P_IN_PRICE_LIST(i).CALCULATION_METHOD_CODE	        CALCULATION_METHOD_CODE	  
                        ,P_IN_PRICE_LIST(i).PRICE_LIST_TYPE_CODE	        PRICE_LIST_TYPE_CODE	              
                        ,P_IN_PRICE_LIST(i).LINE_TYPE_CODE	                LINE_TYPE_CODE	                          
                        ,P_IN_PRICE_LIST(i).STATUS_CODE	                    STATUS_CODE	              
                        ,P_IN_PRICE_LIST(i).START_DATE_ACTIVE  		        START_DATE_ACTIVE  		  
                        ,P_IN_PRICE_LIST(i).END_DATE_ACTIVE    		        END_DATE_ACTIVE    		  
                        ,P_IN_OIC_INSTANCE_ID                               OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.SOURCE_PRICE_LIST_ID      = tmp.SOURCE_PRICE_LIST_ID )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SOURCE_PRICE_LIST_ID	 
                        ,LANGUAGE	             
                        ,NAME	                 
                        ,DESCRIPTION	             
                        ,ORG_ID	                 
                        ,CATALOG_ID	             
                        ,CHARGE_DEFINITION_ID	 
                        ,CURRENCY_CODE	         
                        ,CALCULATION_METHOD_CODE	 
                        ,PRICE_LIST_TYPE_CODE	         
                        ,LINE_TYPE_CODE	                 
                        ,STATUS_CODE	             
                        ,START_DATE_ACTIVE  		 
                        ,END_DATE_ACTIVE    		 
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.SOURCE_PRICE_LIST_ID	
                        ,tmp.LANGUAGE	            
                        ,tmp.NAME	                
                        ,tmp.DESCRIPTION	        
                        ,tmp.ORG_ID	                
                        ,tmp.CATALOG_ID	            
                        ,tmp.CHARGE_DEFINITION_ID	
                        ,tmp.CURRENCY_CODE	        
                        ,tmp.CALCULATION_METHOD_CODE
                        ,tmp.PRICE_LIST_TYPE_CODE	          
                        ,tmp.LINE_TYPE_CODE	                  
                        ,tmp.STATUS_CODE	        
                        ,tmp.START_DATE_ACTIVE  	
                        ,tmp.END_DATE_ACTIVE    	
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         LANGUAGE	                        = tmp.LANGUAGE	                 
                        ,NAME	                            = tmp.NAME	                     
                        ,DESCRIPTION	                    = tmp.DESCRIPTION	                        
                        ,ORG_ID	                            = tmp.ORG_ID	                                
                        ,CATALOG_ID	                        = tmp.CATALOG_ID	                            
                        ,CHARGE_DEFINITION_ID	            = tmp.CHARGE_DEFINITION_ID	                
                        ,CURRENCY_CODE	                    = tmp.CURRENCY_CODE	                        
                        ,CALCULATION_METHOD_CODE	        = tmp.CALCULATION_METHOD_CODE	            
                        ,PRICE_LIST_TYPE_CODE	            = tmp.PRICE_LIST_TYPE_CODE	                
                        ,LINE_TYPE_CODE	                    = tmp.LINE_TYPE_CODE	                        
                        ,STATUS_CODE	                    = tmp.STATUS_CODE	                        
                        ,START_DATE_ACTIVE  		        = tmp.START_DATE_ACTIVE  		            
                        ,END_DATE_ACTIVE    		        = tmp.END_DATE_ACTIVE    		            
                        ,OIC_INSTANCE_ID                    = tmp.OIC_INSTANCE_ID                        
                        ,LAST_UPDATE_DATE			        = sysdate
                    WHERE	1=1
                    AND SOURCE_PRICE_LIST_ID                = tmp.SOURCE_PRICE_LIST_ID;
                
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
    
END CHM_PRICE_LIST_PKG;
/





