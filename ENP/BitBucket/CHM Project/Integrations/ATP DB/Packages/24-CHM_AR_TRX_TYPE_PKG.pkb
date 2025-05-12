CREATE OR REPLACE PACKAGE BODY CHM_AR_TRX_TYPE_PKG
    
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
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_TRX_TYPE			        IN      TBL_TRX_TYPE
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2        -------- V1.1
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
        FOR i IN P_IN_TRX_TYPE.FIRST .. P_IN_TRX_TYPE.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_AR_TRX_TYPES tbl
                USING (
                    SELECT 
                         P_IN_TRX_TYPE(i).SOURCE_TRX_TYPE_ID	        SOURCE_TRX_TYPE_ID	          
                        ,P_IN_TRX_TYPE(i).TRX_TYPE_SEQ_ID	            TRX_TYPE_SEQ_ID	          
                        ,P_IN_TRX_TYPE(i).ORG_ID	                    ORG_ID	                      
                        ,P_IN_TRX_TYPE(i).NAME	                        NAME	                      
                        ,P_IN_TRX_TYPE(i).DESCRIPTION	                DESCRIPTION	              
                        ,P_IN_TRX_TYPE(i).TYPE	                        TYPE	                      
                        ,P_IN_TRX_TYPE(i).DEFAULT_PRINTING_OPTION	    DEFAULT_PRINTING_OPTION	  
                        ,P_IN_TRX_TYPE(i).DEFAULT_STATUS	            DEFAULT_STATUS	              
                        ,P_IN_TRX_TYPE(i).ALLOW_FREIGHT_FLAG	        ALLOW_FREIGHT_FLAG	          
                        ,P_IN_TRX_TYPE(i).ALLOW_OVERAPPLICATION_FLAG	ALLOW_OVERAPPLICATION_FLAG	  
                        ,P_IN_TRX_TYPE(i).TAX_CALCULATION_FLAG	        TAX_CALCULATION_FLAG	      
                        ,P_IN_TRX_TYPE(i).STATUS	                    STATUS	                      
                        ,P_IN_TRX_TYPE(i).START_DATE	                START_DATE	                  
                        ,P_IN_TRX_TYPE(i).END_DATE	                    END_DATE	                  
                        ,P_IN_OIC_INSTANCE_ID                           OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.SOURCE_TRX_TYPE_ID      = tmp.SOURCE_TRX_TYPE_ID )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SOURCE_TRX_TYPE_ID	         
                        ,TRX_TYPE_SEQ_ID	          
                        ,ORG_ID	                     
                        ,NAME	                     
                        ,DESCRIPTION	              
                        ,TYPE	                     
                        ,DEFAULT_PRINTING_OPTION	  
                        ,DEFAULT_STATUS	             
                        ,ALLOW_FREIGHT_FLAG	         
                        ,ALLOW_OVERAPPLICATION_FLAG	 
                        ,TAX_CALCULATION_FLAG	     
                        ,STATUS	                     
                        ,START_DATE	                 
                        ,END_DATE	                 
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.SOURCE_TRX_TYPE_ID	        
                        ,tmp.TRX_TYPE_SEQ_ID	        
                        ,tmp.ORG_ID	                    
                        ,tmp.NAME	                    
                        ,tmp.DESCRIPTION	            
                        ,tmp.TYPE	                    
                        ,tmp.DEFAULT_PRINTING_OPTION	
                        ,tmp.DEFAULT_STATUS	            
                        ,tmp.ALLOW_FREIGHT_FLAG	        
                        ,tmp.ALLOW_OVERAPPLICATION_FLAG	
                        ,tmp.TAX_CALCULATION_FLAG	    
                        ,tmp.STATUS	                    
                        ,tmp.START_DATE	                
                        ,tmp.END_DATE	                
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         TRX_TYPE_SEQ_ID	            = tmp.TRX_TYPE_SEQ_ID	        
                        ,ORG_ID	                        = tmp.ORG_ID	                    
                        ,NAME	                        = tmp.NAME	                    
                        ,DESCRIPTION	                = tmp.DESCRIPTION	            
                        ,TYPE	                        = tmp.TYPE	                    
                        ,DEFAULT_PRINTING_OPTION	    = tmp.DEFAULT_PRINTING_OPTION	
                        ,DEFAULT_STATUS	                = tmp.DEFAULT_STATUS	            
                        ,ALLOW_FREIGHT_FLAG	            = tmp.ALLOW_FREIGHT_FLAG	        
                        ,ALLOW_OVERAPPLICATION_FLAG	    = tmp.ALLOW_OVERAPPLICATION_FLAG	
                        ,TAX_CALCULATION_FLAG	        = tmp.TAX_CALCULATION_FLAG	    
                        ,STATUS	                        = tmp.STATUS	                    
                        ,START_DATE	                    = tmp.START_DATE	                
                        ,END_DATE	                    = tmp.END_DATE	                
                        ,OIC_INSTANCE_ID			    = tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE			    = sysdate
                    WHERE	1=1
                    AND SOURCE_TRX_TYPE_ID                = tmp.SOURCE_TRX_TYPE_ID;
                
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
    
END CHM_AR_TRX_TYPE_PKG;
/
