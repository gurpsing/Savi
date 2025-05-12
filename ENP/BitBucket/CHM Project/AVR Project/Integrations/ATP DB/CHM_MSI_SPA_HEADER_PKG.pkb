create or replace PACKAGE BODY CHM_MSI_SPA_HEADER_PKG
/*******************************************************************************************************
* Type                           : PL/SQL Package Body                                        *
* Package Name                   : CHM_MSI_SPA_HEADER_PKG                                         *
* Purpose                        : Package Body for MSI SPA HEADER sync from fusion  *
* Created By                     : Raja Ratnakar Reddy                                                      *
* Created Date                   : 10-Mar-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 10-Mar-2025   Raja Ratnakar Reddy                  1.0              Intial Version                         * 
*******************************************************************************************************/
as
PROCEDURE MERGE_SPA_HEADER_DATA (P_IN_CHM_MSI_SPA_HEADER IN TBL_CHM_MSI_SPA_HEADER
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_HEADER.FIRST..P_IN_CHM_MSI_SPA_HEADER.LAST LOOP
            L_COUNT := L_COUNT + 1;
                        
            BEGIN
                MERGE INTO CHM_MSI_SPA_HEADER TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_HEADER(I).SPA_NUMBER                                  SPA_NUMBER            
                        ,P_IN_CHM_MSI_SPA_HEADER(I).OPPORTUNITY_OWNER              	            OPPORTUNITY_OWNER             	    
                        ,P_IN_CHM_MSI_SPA_HEADER(I).INSTALLER_ACCOUNT_NAME         	            INSTALLER_ACCOUNT_NAME               	    
                        ,P_IN_CHM_MSI_SPA_HEADER(I).INSTALLER_CUSTOMER_KEY                   INSTALLER_CUSTOMER_KEY	        
                        ,P_IN_CHM_MSI_SPA_HEADER(I).PRIMARY_PARTNER                          PRIMARY_PARTNER    	        
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_NAME                       	            SPA_NAME    	    
                        ,P_IN_CHM_MSI_SPA_HEADER(I).GEOGRAPHY                          	        GEOGRAPHY    	
                        ,P_IN_CHM_MSI_SPA_HEADER(I).STAGE                                       STAGE       
                        ,P_IN_CHM_MSI_SPA_HEADER(I).OPPORTUNITY_NAME                            OPPORTUNITY_NAME          
                        ,P_IN_CHM_MSI_SPA_HEADER(I).DEAL_LOGISTICS                 	            DEAL_LOGISTICS           	    
                        ,P_IN_CHM_MSI_SPA_HEADER(I).STATUS                          	        STATUS           	
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPECIAL_PRICING_TYPE            	        SPECIAL_PRICING_TYPE           	
                        ,P_IN_CHM_MSI_SPA_HEADER(I).FINAL_APPROVAL_TIME                         FINAL_APPROVAL_TIME                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_START_DATE                              SPA_START_DATE           
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_EXPIRATION_DATE                         SPA_EXPIRATION_DATE                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).DEAL_CATEGORY                               DEAL_CATEGORY      
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_TOTAL_PRICE_CURRENCY                    SPA_TOTAL_PRICE_CURRENCY          
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_TOTAL_PRICE                             SPA_TOTAL_PRICE       
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_CREATED_DATE                            SPA_CREATED_DATE              
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_TYPE                                    SPA_TYPE           
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_BACK_DATED                              SPA_BACK_DATED              
                        ,P_IN_CHM_MSI_SPA_HEADER(I).ID                                          ID            
                        ,P_IN_CHM_MSI_SPA_HEADER(I).OPPORTUNITY_OWNER_ID                        OPPORTUNITY_OWNER_ID        
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_OPPORTUNITY_ID                          SPA_OPPORTUNITY_ID           
                        ,P_IN_CHM_MSI_SPA_HEADER(I).ACCOUNT_ID                                  ACCOUNT_ID          
                        ,P_IN_CHM_MSI_SPA_HEADER(I).NEW_RENEWAL                                 NEW_RENEWAL                    
                        ,P_IN_CHM_MSI_SPA_HEADER(I).DISTRIBUTOR_ACCOUNT_NAME                    DISTRIBUTOR_ACCOUNT_NAME                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).DISTRIBUTOR_SFDC_ID                         DISTRIBUTOR_SFDC_ID                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).DISTRIBUTOR_ORACLE_ACCOUNT_ID               DISTRIBUTOR_ORACLE_ACCOUNT_ID                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).DISTRIBUTOR_SFDC_CUSTOMER_KEY               DISTRIBUTOR_SFDC_CUSTOMER_KEY                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_LAST_UPDATE_DATE                        SPA_LAST_UPDATE_DATE                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_CREATED_BY                              SPA_CREATED_BY                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_LAST_UPDATED_BY                         SPA_LAST_UPDATED_BY                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_FINAL_APPROVAL_DATE_TIME                SPA_FINAL_APPROVAL_DATE_TIME                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_CONTACT                                 SPA_CONTACT                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).SPA_TIERS                                   SPA_TIERS                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER1_MIN                                   TIER1_MIN                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER2_MIN                                   TIER2_MIN                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER3_MIN                                   TIER3_MIN                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER4_MIN                                   TIER4_MIN                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER5_MIN                                   TIER5_MIN                
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER1_MAX                                   TIER1_MAX            
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER2_MAX                                   TIER2_MAX                 
                        ,P_IN_CHM_MSI_SPA_HEADER(I).TIER3_MAX                                   TIER3_MAX    
						,P_IN_CHM_MSI_SPA_HEADER(I).TIER4_MAX         							TIER4_MAX          							 
						,P_IN_CHM_MSI_SPA_HEADER(I).TIER5_MAX         							TIER5_MAX          							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE_CONTEXT 							ATTRIBUTE_CONTEXT  							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE1        							ATTRIBUTE1         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE2        							ATTRIBUTE2         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE3        							ATTRIBUTE3         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE4        							ATTRIBUTE4         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE5        							ATTRIBUTE5         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE6        							ATTRIBUTE6         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE7        							ATTRIBUTE7         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE8        							ATTRIBUTE8         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE9        							ATTRIBUTE9         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE10       							ATTRIBUTE10        							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE11       							ATTRIBUTE11        							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE12       							ATTRIBUTE12        							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE13       							ATTRIBUTE13        							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE14       							ATTRIBUTE14        							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ATTRIBUTE15       							ATTRIBUTE15        							 
						,P_IN_CHM_MSI_SPA_HEADER(I).CREATED_BY        							CREATED_BY         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).CREATION_DATE     							CREATION_DATE      							 
						,P_IN_CHM_MSI_SPA_HEADER(I).LAST_UPDATED_BY   							LAST_UPDATED_BY    							 
						,P_IN_CHM_MSI_SPA_HEADER(I).LAST_UPDATED_DATE 							LAST_UPDATED_DAT   							 
						,P_IN_CHM_MSI_SPA_HEADER(I).OIC_INSTANCE_ID   							OIC_INSTANCE_ID 
                        FROM
                            DUAL
                ) TMP ON ( TBL.SPA_NUMBER                 = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (

                     SPA_NUMBER                       
                    ,OPPORTUNITY_OWNER               
                    ,INSTALLER_ACCOUNT_NAME          
                    ,INSTALLER_CUSTOMER_KEY             
                    ,PRIMARY_PARTNER                    
                    ,SPA_NAME                        
                    ,GEOGRAPHY                        
                    ,STAGE                            
                    ,OPPORTUNITY_NAME                 
                    ,DEAL_LOGISTICS                  
                    ,STATUS                         	
                    ,SPECIAL_PRICING_TYPE           	
                    ,FINAL_APPROVAL_TIME              
                    ,SPA_START_DATE                   
                    ,SPA_EXPIRATION_DATE              
                    ,DEAL_CATEGORY                    
                    ,SPA_TOTAL_PRICE_CURRENCY         
                    ,SPA_TOTAL_PRICE                  
                    ,SPA_CREATED_DATE                 
                    ,SPA_TYPE                         
                    ,SPA_BACK_DATED                   
                    ,ID                               
                    ,OPPORTUNITY_OWNER_ID             
                    ,SPA_OPPORTUNITY_ID               
                    ,ACCOUNT_ID                       
                    ,NEW_RENEWAL                      
                    ,DISTRIBUTOR_ACCOUNT_NAME         
                    ,DISTRIBUTOR_SFDC_ID              
                    ,DISTRIBUTOR_ORACLE_ACCOUNT_ID    
                    ,DISTRIBUTOR_SFDC_CUSTOMER_KEY    
                    ,SPA_LAST_UPDATE_DATE             
                    ,SPA_CREATED_BY                   
                    ,SPA_LAST_UPDATED_BY              
                    ,SPA_FINAL_APPROVAL_DATE_TIME     
                    ,SPA_CONTACT                      
                    ,SPA_TIERS                        
                    ,TIER1_MIN                        
                    ,TIER2_MIN                        
                    ,TIER3_MIN                        
                    ,TIER4_MIN                        
                    ,TIER5_MIN                        
                    ,TIER1_MAX                        
                    ,TIER2_MAX                        
                    ,TIER3_MAX                      
                    ,TIER4_MAX                      
                    ,TIER5_MAX  
					,ATTRIBUTE_CONTEXT 
                    ,ATTRIBUTE1        
                    ,ATTRIBUTE2        
                    ,ATTRIBUTE3        
                    ,ATTRIBUTE4        
                    ,ATTRIBUTE5        
                    ,ATTRIBUTE6        
                    ,ATTRIBUTE7        
                    ,ATTRIBUTE8        
                    ,ATTRIBUTE9        
                    ,ATTRIBUTE10       
                    ,ATTRIBUTE11       
                    ,ATTRIBUTE12       
                    ,ATTRIBUTE13       
                    ,ATTRIBUTE14       
                    ,ATTRIBUTE15       
                    ,CREATED_BY        
                    ,CREATION_DATE     
                    ,LAST_UPDATED_BY   
                    ,LAST_UPDATED_DATE                         
                    ,OIC_INSTANCE_ID   	
                )
                VALUES
                ( 
                    TMP.SPA_NUMBER                     
					,TMP.OPPORTUNITY_OWNER              
					,TMP.INSTALLER_ACCOUNT_NAME         
					,TMP.INSTALLER_CUSTOMER_KEY         
					,TMP.PRIMARY_PARTNER                
					,TMP.SPA_NAME                       
					,TMP.GEOGRAPHY                      
					,TMP.STAGE                          
					,TMP.OPPORTUNITY_NAME               
					,TMP.DEAL_LOGISTICS                 
					,TMP.STATUS                         
					,TMP.SPECIAL_PRICING_TYPE           
					,TMP.FINAL_APPROVAL_TIME            
					,TMP.SPA_START_DATE                 
					,TMP.SPA_EXPIRATION_DATE            
					,TMP.DEAL_CATEGORY                  
					,TMP.SPA_TOTAL_PRICE_CURRENCY       
					,TMP.SPA_TOTAL_PRICE                
					,TMP.SPA_CREATED_DATE               
					,TMP.SPA_TYPE                       
					,TMP.SPA_BACK_DATED                 
					,TMP.ID                             
					,TMP.OPPORTUNITY_OWNER_ID           
					,TMP.SPA_OPPORTUNITY_ID             
					,TMP.ACCOUNT_ID                     
					,TMP.NEW_RENEWAL                    
					,TMP.DISTRIBUTOR_ACCOUNT_NAME       
					,TMP.DISTRIBUTOR_SFDC_ID            
					,TMP.DISTRIBUTOR_ORACLE_ACCOUNT_ID  
					,TMP.DISTRIBUTOR_SFDC_CUSTOMER_KEY  
					,TMP.SPA_LAST_UPDATE_DATE           
					,TMP.SPA_CREATED_BY                 
					,TMP.SPA_LAST_UPDATED_BY            
					,TMP.SPA_FINAL_APPROVAL_DATE_TIME   
					,TMP.SPA_CONTACT                    
					,TMP.SPA_TIERS                      
					,TMP.TIER1_MIN                      
					,TMP.TIER2_MIN                      
					,TMP.TIER3_MIN                      
					,TMP.TIER4_MIN                      
					,TMP.TIER5_MIN                      
					,TMP.TIER1_MAX                      
					,TMP.TIER2_MAX                      
					,TMP.TIER3_MAX                      
					,TMP.TIER4_MAX                      
					,TMP.TIER5_MAX                      
					,TMP.ATTRIBUTE_CONTEXT              
					,TMP.ATTRIBUTE1                     
					,TMP.ATTRIBUTE2                     
					,TMP.ATTRIBUTE3                     
					,TMP.ATTRIBUTE4                     
					,TMP.ATTRIBUTE5                     
					,TMP.ATTRIBUTE6                     
					,TMP.ATTRIBUTE7                     
					,TMP.ATTRIBUTE8                     
					,TMP.ATTRIBUTE9                     
					,TMP.ATTRIBUTE10                    
					,TMP.ATTRIBUTE11                    
					,TMP.ATTRIBUTE12                    
					,TMP.ATTRIBUTE13                    
					,TMP.ATTRIBUTE14                    
					,TMP.ATTRIBUTE15                    
					,TMP.CREATED_BY                     
					,SYSDATE                  
					,TMP.LAST_UPDATED_BY                
					,SYSDATE                                 
					,TMP.OIC_INSTANCE_ID       				
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     OPPORTUNITY_OWNER                        = tmp.OPPORTUNITY_OWNER                  
                    ,INSTALLER_ACCOUNT_NAME                   = tmp.INSTALLER_ACCOUNT_NAME             
                    ,INSTALLER_CUSTOMER_KEY         	      = tmp.INSTALLER_CUSTOMER_KEY          	 
                    ,PRIMARY_PARTNER                  	   	  = tmp.PRIMARY_PARTNER                  	
                    ,SPA_NAME                         	      = tmp.SPA_NAME                         	
                    ,GEOGRAPHY                                = tmp.GEOGRAPHY                          
                    ,STAGE                                    = tmp.STAGE                              
                    ,OPPORTUNITY_NAME                         = tmp.OPPORTUNITY_NAME                   
                    ,DEAL_LOGISTICS                           = tmp.DEAL_LOGISTICS                     
                    ,STATUS                                   = tmp.STATUS                            
                    ,SPECIAL_PRICING_TYPE                     = tmp.SPECIAL_PRICING_TYPE              
                    ,FINAL_APPROVAL_TIME                      = tmp.FINAL_APPROVAL_TIME                
                    ,SPA_START_DATE                           = tmp.SPA_START_DATE                     
                    ,SPA_EXPIRATION_DATE                      = tmp.SPA_EXPIRATION_DATE                
                    ,DEAL_CATEGORY                            = tmp.DEAL_CATEGORY                      
                    ,SPA_TOTAL_PRICE_CURRENCY                 = tmp.SPA_TOTAL_PRICE_CURRENCY           
                    ,SPA_TOTAL_PRICE                          = tmp.SPA_TOTAL_PRICE                    
                    ,SPA_CREATED_DATE                         = tmp.SPA_CREATED_DATE                   
                    ,SPA_TYPE                                 = tmp.SPA_TYPE                           
                    ,SPA_BACK_DATED                           = tmp.SPA_BACK_DATED                     
                    ,ID                                       = tmp.ID                                 
                    ,OPPORTUNITY_OWNER_ID                     = tmp.OPPORTUNITY_OWNER_ID               
                    ,SPA_OPPORTUNITY_ID                       = tmp.SPA_OPPORTUNITY_ID                 
                    ,ACCOUNT_ID                               = tmp.ACCOUNT_ID                         
                    ,NEW_RENEWAL                              = tmp.NEW_RENEWAL                        
                    ,DISTRIBUTOR_ACCOUNT_NAME                 = tmp.DISTRIBUTOR_ACCOUNT_NAME           
                    ,DISTRIBUTOR_SFDC_ID                      = tmp.DISTRIBUTOR_SFDC_ID                
                    ,DISTRIBUTOR_ORACLE_ACCOUNT_ID            = tmp.DISTRIBUTOR_ORACLE_ACCOUNT_ID      
                    ,DISTRIBUTOR_SFDC_CUSTOMER_KEY            = tmp.DISTRIBUTOR_SFDC_CUSTOMER_KEY      
                    ,SPA_LAST_UPDATE_DATE                     = tmp.SPA_LAST_UPDATE_DATE               

                    ,SPA_LAST_UPDATED_BY                      = tmp.SPA_LAST_UPDATED_BY                
                    ,SPA_FINAL_APPROVAL_DATE_TIME             = tmp.SPA_FINAL_APPROVAL_DATE_TIME       
                    ,SPA_CONTACT                              = tmp.SPA_CONTACT                        
                    ,SPA_TIERS                                = tmp.SPA_TIERS                          
                    ,TIER1_MIN                                = tmp.TIER1_MIN                          
                    ,TIER2_MIN                                = tmp.TIER2_MIN                       
					,TIER3_MIN        						  = tmp.TIER3_MIN                       
					,TIER4_MIN        						  = tmp.TIER4_MIN                       
					,TIER5_MIN        						  = tmp.TIER5_MIN                       
					,TIER1_MAX        						  = tmp.TIER1_MAX                       
					,TIER2_MAX        						  = tmp.TIER2_MAX                       
					,TIER3_MAX        						  = tmp.TIER3_MAX                      
					,TIER4_MAX        						  = tmp.TIER4_MAX                      
					,TIER5_MAX        						  = tmp.TIER5_MAX  
					,ATTRIBUTE_CONTEXT						  = tmp.ATTRIBUTE_CONTEXT 
					,ATTRIBUTE1       						  = tmp.ATTRIBUTE1        
					,ATTRIBUTE2       						  = tmp.ATTRIBUTE2        
					,ATTRIBUTE3       						  = tmp.ATTRIBUTE3        
					,ATTRIBUTE4       						  = tmp.ATTRIBUTE4        
					,ATTRIBUTE5       						  = tmp.ATTRIBUTE5        
					,ATTRIBUTE6       						  = tmp.ATTRIBUTE6        
					,ATTRIBUTE7       						  = tmp.ATTRIBUTE7        
					,ATTRIBUTE8       						  = tmp.ATTRIBUTE8        
					,ATTRIBUTE9       						  = tmp.ATTRIBUTE9        
					,ATTRIBUTE10      						  = tmp.ATTRIBUTE10       
					,ATTRIBUTE11      						  = tmp.ATTRIBUTE11       
					,ATTRIBUTE12      						  = tmp.ATTRIBUTE12       
					,ATTRIBUTE13      						  = tmp.ATTRIBUTE13       
					,ATTRIBUTE14      						  = tmp.ATTRIBUTE14       
					,ATTRIBUTE15      						  = tmp.ATTRIBUTE15                
					,LAST_UPDATED_BY  						  = tmp.LAST_UPDATED_BY   
					,LAST_UPDATED_DATE						  = SYSDATE						
					 WHERE 1 = 1
					 AND TBL.SPA_NUMBER                       = TMP.SPA_NUMBER;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
       
            END;

        END LOOP;

        UPDATE CHM_INTEGRATION_RUNS
        SET      TOTAL_FETCHED_RECORDS      = nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT
                ,TOTAL_SUCCESS_RECORDS      = nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT
                ,TOTAL_ERROR_RECORDS        = nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)
                ,LOG                        = LOG   ||CHR(10)||'Data Merged Successfully.'   ||CHR(10)  
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||' ('||L_COUNT||')'||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||' ('||L_MERGE_COUNT||')'||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||' ('||(L_COUNT - L_MERGE_COUNT)||')'||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_HEADER_DATA;

END CHM_MSI_SPA_HEADER_PKG;
/
