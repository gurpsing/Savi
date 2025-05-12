CREATE OR REPLACE PACKAGE BODY CHM_CURRENCY_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_CURRENCY_PKG                                                                                                                      *
    * Purpose                        : Package for CHM Currencies Integrations                                                                                               *
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
         P_IN_CURRENCY			        IN      TBL_CURRENCY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2                ------------- V1.1
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
        FOR i IN P_IN_CURRENCY.FIRST .. P_IN_CURRENCY.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_CURRENCIES tbl
                USING (
                    SELECT 
                         P_IN_CURRENCY(i).CURRENCY_CODE   		          CURRENCY_CODE   		
                        ,P_IN_CURRENCY(i).NAME         			          NAME         			
                        ,P_IN_CURRENCY(i).DESCRIPTION        	          DESCRIPTION        	
                        ,P_IN_CURRENCY(i).ISSUING_TERRITORY_CODE	      ISSUING_TERRITORY_CODE	
                        ,P_IN_CURRENCY(i).SYMBOL          		          SYMBOL          		
                        ,P_IN_CURRENCY(i).CURRENCY_FLAG      	          CURRENCY_FLAG      	
                        ,P_IN_CURRENCY(i).ISO_FLAG          		      ISO_FLAG          		
                        ,P_IN_CURRENCY(i).LANGUAGE          		      LANGUAGE          		
                        ,P_IN_OIC_INSTANCE_ID                             OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.CURRENCY_CODE       = tmp.CURRENCY_CODE 
                    AND tbl.LANGUAGE            = tmp.LANGUAGE 
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         CURRENCY_CODE   		    
                        ,NAME         			    
                        ,DESCRIPTION        	    
                        ,ISSUING_TERRITORY_CODE	
                        ,SYMBOL          		    
                        ,CURRENCY_FLAG      	    
                        ,ISO_FLAG          		
                        ,LANGUAGE          		
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.CURRENCY_CODE   		  
                        ,tmp.NAME         			  
                        ,tmp.DESCRIPTION        	  
                        ,tmp.ISSUING_TERRITORY_CODE	
                        ,tmp.SYMBOL          		  
                        ,tmp.CURRENCY_FLAG      	  
                        ,tmp.ISO_FLAG          		
                        ,tmp.LANGUAGE          		
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         NAME         			        = tmp.NAME         			 
                        ,DESCRIPTION        	        = tmp.DESCRIPTION        	 
                        ,ISSUING_TERRITORY_CODE	        = tmp.ISSUING_TERRITORY_CODE	
                        ,SYMBOL          		        = tmp.SYMBOL          		 
                        ,CURRENCY_FLAG      	        = tmp.CURRENCY_FLAG      	 
                        ,ISO_FLAG          		        = tmp.ISO_FLAG          		
                        ,OIC_INSTANCE_ID			    = tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE			    = sysdate
                    WHERE	1=1
                    AND CURRENCY_CODE                   = tmp.CURRENCY_CODE
                    AND LANGUAGE                        = tmp.LANGUAGE;
                
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
    
END CHM_CURRENCY_PKG;
/
