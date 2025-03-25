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
						,P_IN_CHM_MSI_SPA_HEADER(I).LAST_UPDATED_DATE 							LAST_UPDATED_DATE  							 
						,P_IN_CHM_MSI_SPA_HEADER(I).SOURCE_APP_ID     							SOURCE_APP_ID      							 
						,P_IN_CHM_MSI_SPA_HEADER(I).ENTERPRISE_ID     							ENTERPRISE_ID      							 
						,P_IN_CHM_MSI_SPA_HEADER(I).IP_ADDRESS        							IP_ADDRESS         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).USER_AGENT        							USER_AGENT         							 
						,P_IN_CHM_MSI_SPA_HEADER(I).OIC_INSTANCE_ID   							OIC_INSTANCE_ID 
                        FROM
                            DUAL
                ) TMP ON ( TBL.SPA_NUMBER                 = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_SPA_ID                       
                    ,SPA_NUMBER                       
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
                    ,SOURCE_APP_ID     
                    ,ENTERPRISE_ID     
                    ,IP_ADDRESS        
                    ,USER_AGENT        
                    ,OIC_INSTANCE_ID   	
                )
                VALUES
                ( 
                     CHM_MSI_SPA_HEADERS_SEQ.NEXTVAL
                    ,TMP.SPA_NUMBER                     
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
					,TMP.SOURCE_APP_ID                  
					,TMP.ENTERPRISE_ID                  
					,TMP.IP_ADDRESS                     
					,TMP.USER_AGENT                     
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
                    ,SPA_CREATED_BY                           = tmp.SPA_CREATED_BY                     
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
					,CREATED_BY       						  = tmp.CREATED_BY           
					,LAST_UPDATED_BY  						  = tmp.LAST_UPDATED_BY   
					,LAST_UPDATED_DATE						  = SYSDATE
					,SOURCE_APP_ID    						  = tmp.SOURCE_APP_ID     
					,ENTERPRISE_ID    						  = tmp.ENTERPRISE_ID     
					,IP_ADDRESS       						  = tmp.IP_ADDRESS        
					,USER_AGENT       						  = tmp.USER_AGENT        
					,OIC_INSTANCE_ID  						  = tmp.OIC_INSTANCE_ID   	
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
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_HEADER_DATA;


 PROCEDURE MERGE_SPA_PRODUCTS_DATA (P_IN_CHM_MSI_SPA_PRODUCTS IN TBL_CHM_MSI_SPA_PRODUCTS
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_PRODUCTS.FIRST..P_IN_CHM_MSI_SPA_PRODUCTS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_PRODUCTS TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_PRODUCTS(I).CHM_PRODUCTS_ID                                    CHM_PRODUCTS_ID                                           
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ID                                                 ID                                                   
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).MSI_ELIGIBLE                                       MSI_ELIGIBLE                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).MSI_SYSTEM_ATTACHMENT_ELIGIBLE                     MSI_SYSTEM_ATTACHMENT_ELIGIBLE                                
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE_CONTEXT                                  ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE1                                         ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE2                                         ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE3                                         ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE4                                         ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE5                                         ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE6                                         ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE7                                         ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE8                                         ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE9                                         ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE10                                        ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE11                                        ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE12                                       	ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE13                                        ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE14                                        ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ATTRIBUTE15                                        ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).CREATED_BY                                         CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).CREATION_DATE                         	            CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).LAST_UPDATED_BY                                    LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).LAST_UPDATED_DATE                     	            LAST_UPDATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).SOURCE_APP_ID                                      SOURCE_APP_ID                                              
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).ENTERPRISE_ID                                      ENTERPRISE_ID                                              
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).IP_ADDRESS                                         IP_ADDRESS                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).USER_AGENT                                         USER_AGENT                                         
                        ,P_IN_CHM_MSI_SPA_PRODUCTS(I).OIC_INSTANCE_ID	                                OIC_INSTANCE_ID

                        FROM
                            DUAL
                ) TMP ON ( TBL.ID                 = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_PRODUCTS_ID                                                           
                    ,ID                                                              
                    ,MSI_ELIGIBLE                                                           
                    ,MSI_SYSTEM_ATTACHMENT_ELIGIBLE
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
                    ,SOURCE_APP_ID                                              
                    ,ENTERPRISE_ID                                              
                    ,IP_ADDRESS                                         
                    ,USER_AGENT                                         
                    ,OIC_INSTANCE_ID

                )
                VALUES
                ( 
                     CHM_MSI_SPA_PRODUCTS_SEQ.NEXTVAL
                    ,TMP.ID                                                 
                    ,TMP.MSI_ELIGIBLE                                       
                    ,TMP.MSI_SYSTEM_ATTACHMENT_ELIGIBLE                                                                                                                                                                          
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
                    ,TMP.SOURCE_APP_ID                                              
                    ,TMP.ENTERPRISE_ID                                              
                    ,TMP.IP_ADDRESS                                         
                    ,TMP.USER_AGENT                                         
                    ,TMP.OIC_INSTANCE_ID      				
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     ID                                           =TMP.ID                         
                    ,MSI_ELIGIBLE                                 =TMP.MSI_ELIGIBLE                
                    ,MSI_SYSTEM_ATTACHMENT_ELIGIBLE               =TMP.MSI_SYSTEM_ATTACHMENT_ELIGIBLE                                                     
                    ,ATTRIBUTE_CONTEXT                            =TMP.ATTRIBUTE_CONTEXT          
                    ,ATTRIBUTE1                                   =TMP.ATTRIBUTE1                 
                    ,ATTRIBUTE2                                   =TMP.ATTRIBUTE2                 
                    ,ATTRIBUTE3                                   =TMP.ATTRIBUTE3                 
                    ,ATTRIBUTE4                                   =TMP.ATTRIBUTE4                 
                    ,ATTRIBUTE5                                   =TMP.ATTRIBUTE5                 
                    ,ATTRIBUTE6                                   =TMP.ATTRIBUTE6                 
                    ,ATTRIBUTE7                                   =TMP.ATTRIBUTE7                 
                    ,ATTRIBUTE8                                   =TMP.ATTRIBUTE8                 
                    ,ATTRIBUTE9                                   =TMP.ATTRIBUTE9                 
                    ,ATTRIBUTE10                                  =TMP.ATTRIBUTE10                
                    ,ATTRIBUTE11                                  =TMP.ATTRIBUTE11                
                    ,ATTRIBUTE12                                  =TMP.ATTRIBUTE12                
                    ,ATTRIBUTE13                                  =TMP.ATTRIBUTE13                
                    ,ATTRIBUTE14                                  =TMP.ATTRIBUTE14                
                    ,ATTRIBUTE15                                  =TMP.ATTRIBUTE15                
                    ,CREATED_BY                                   =TMP.CREATED_BY                              
                    ,LAST_UPDATED_BY                              =TMP.LAST_UPDATED_BY            
                    ,LAST_UPDATED_DATE                            =SYSDATE              
                    ,SOURCE_APP_ID                                =TMP.SOURCE_APP_ID                      
                    ,ENTERPRISE_ID                                =TMP.ENTERPRISE_ID                      
                    ,IP_ADDRESS                                   =TMP.IP_ADDRESS                 
                    ,USER_AGENT                                   =TMP.USER_AGENT                 
                    ,OIC_INSTANCE_ID                              =TMP.OIC_INSTANCE_ID      
					 WHERE 1 = 1
					 AND TBL.ID                       = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;

            END;


        END LOOP;

        UPDATE CHM_INTEGRATION_RUNS
        SET      TOTAL_FETCHED_RECORDS      = nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT
                ,TOTAL_SUCCESS_RECORDS      = nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT
                ,TOTAL_ERROR_RECORDS        = nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)
                ,LOG                        = LOG   ||CHR(10)||'Data Merged Successfully.'   ||CHR(10)  
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_PRODUCTS_DATA;

	PROCEDURE MERGE_SPA_SYSTEM_ATTACHMENTS_DATA (P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS IN TBL_CHM_MSI_SPA_SYSTEM_ATTACHMENTS
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS.FIRST..P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_SYSTEM_ATTACHMENTS TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).CHM_MSI_SPA_SYS_ATTACHMENT_ID                     CHM_MSI_SPA_SYS_ATTACHMEN                            
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ID                                                 ID                                                 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ITEM_NUMBER                                        ITEM_NUMBER                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).MIN_QUANTITY                                       MIN_QUANTITY                                               
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).UNIT_REBATE_AMOUNT                                 UNIT_REBATE_AMOUNT                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SPA_NUMBER                                        	SPA_NUMBER                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SPA_ID                                             SPA_ID                                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).STATUS                                             STATUS                                             
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_CREATED_DATE                     	            SFDC_CREATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_LAST_UPDATE_DATE                 	            SFDC_LAST_UPDATE_DATE                 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_CREATED_BY                                    SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_LAST_UPDATED_BY                               SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE_CONTEXT                                  ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE1                                         ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE2                                         ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE3                                         ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE4                                         ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE5                                         ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE6                                         ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE7                                         ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE8                                         ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE9                                         ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE10                                        ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE11                                        ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE12                                       	ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE13                                        ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE14                                        ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE15                                        ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).CREATED_BY                                         CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).CREATION_DATE                         	            CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).LAST_UPDATED_BY                                    LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).LAST_UPDATED_DATE                     	            LAST_UPDATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SOURCE_APP_ID                                      SOURCE_APP_ID                                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ENTERPRISE_ID                                      ENTERPRISE_ID                                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).IP_ADDRESS                                         IP_ADDRESS                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).USER_AGENT                                         USER_AGENT                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).OIC_INSTANCE_ID	                                OIC_INSTANCE_ID

                        FROM
                            DUAL
                ) TMP ON ( TBL.SPA_NUMBER                 = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_SYS_ATTACHMENT_ID                             
                    ,ID                                                 
                    ,ITEM_NUMBER                                        
                    ,MIN_QUANTITY                                               
                    ,UNIT_REBATE_AMOUNT                                         
                    ,SPA_NUMBER                                          
                    ,SPA_ID                                             
                    ,STATUS                                             
                    ,SFDC_CREATED_DATE                     
                    ,SFDC_LAST_UPDATE_DATE                 
                    ,SFDC_CREATED_BY                                    
                    ,SFDC_LAST_UPDATED_BY                               
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
                    ,SOURCE_APP_ID                                              
                    ,ENTERPRISE_ID                                              
                    ,IP_ADDRESS                                         
                    ,USER_AGENT                                         
                    ,OIC_INSTANCE_ID

                )
                VALUES
                ( 
                     CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES_SEQ.NEXTVAL
                    ,TMP.ID                                                 
                    ,TMP.ITEM_NUMBER                                       
                    ,TMP.MIN_QUANTITY                                               
                    ,TMP.UNIT_REBATE_AMOUNT                                         
                    ,TMP.SPA_NUMBER                                          
                    ,TMP.SPA_ID                                             
                    ,TMP.STATUS                                             
                    ,TMP.SFDC_CREATED_DATE                     
                    ,TMP.SFDC_LAST_UPDATE_DATE                 
                    ,TMP.SFDC_CREATED_BY                                    
                    ,TMP.SFDC_LAST_UPDATED_BY                               
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
                    ,TMP.SOURCE_APP_ID                                              
                    ,TMP.ENTERPRISE_ID                                              
                    ,TMP.IP_ADDRESS                                         
                    ,TMP.USER_AGENT                                         
                    ,TMP.OIC_INSTANCE_ID      				
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     ID                                           =TMP.ID                         
                    ,ITEM_NUMBER                                  =TMP.ITEM_NUMBER                
                    ,MIN_QUANTITY                                 =TMP.MIN_QUANTITY                       
                    ,UNIT_REBATE_AMOUNT                           =TMP.UNIT_REBATE_AMOUNT                 
                    ,SPA_NUMBER                                   =TMP.SPA_NUMBER                  
                    ,SPA_ID                                       =TMP.SPA_ID                     
                    ,STATUS                                       =TMP.STATUS                     
                    ,SFDC_CREATED_DATE                            =TMP.SFDC_CREATED_DATE    
                    ,SFDC_LAST_UPDATE_DATE                        =TMP.SFDC_LAST_UPDATE_DATE
                    ,SFDC_CREATED_BY                              =TMP.SFDC_CREATED_BY            
                    ,SFDC_LAST_UPDATED_BY                         =TMP.SFDC_LAST_UPDATED_BY       
                    ,ATTRIBUTE_CONTEXT                            =TMP.ATTRIBUTE_CONTEXT          
                    ,ATTRIBUTE1                                   =TMP.ATTRIBUTE1                 
                    ,ATTRIBUTE2                                   =TMP.ATTRIBUTE2                 
                    ,ATTRIBUTE3                                   =TMP.ATTRIBUTE3                 
                    ,ATTRIBUTE4                                   =TMP.ATTRIBUTE4                 
                    ,ATTRIBUTE5                                   =TMP.ATTRIBUTE5                 
                    ,ATTRIBUTE6                                   =TMP.ATTRIBUTE6                 
                    ,ATTRIBUTE7                                   =TMP.ATTRIBUTE7                 
                    ,ATTRIBUTE8                                   =TMP.ATTRIBUTE8                 
                    ,ATTRIBUTE9                                   =TMP.ATTRIBUTE9                 
                    ,ATTRIBUTE10                                  =TMP.ATTRIBUTE10                
                    ,ATTRIBUTE11                                  =TMP.ATTRIBUTE11                
                    ,ATTRIBUTE12                                  =TMP.ATTRIBUTE12                
                    ,ATTRIBUTE13                                  =TMP.ATTRIBUTE13                
                    ,ATTRIBUTE14                                  =TMP.ATTRIBUTE14                
                    ,ATTRIBUTE15                                  =TMP.ATTRIBUTE15                
                    ,CREATED_BY                                   =TMP.CREATED_BY                              
                    ,LAST_UPDATED_BY                              =TMP.LAST_UPDATED_BY            
                    ,LAST_UPDATED_DATE                            =SYSDATE              
                    ,SOURCE_APP_ID                                =TMP.SOURCE_APP_ID                      
                    ,ENTERPRISE_ID                                =TMP.ENTERPRISE_ID                      
                    ,IP_ADDRESS                                   =TMP.IP_ADDRESS                 
                    ,USER_AGENT                                   =TMP.USER_AGENT                 
                    ,OIC_INSTANCE_ID                              =TMP.OIC_INSTANCE_ID      
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
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_SYSTEM_ATTACHMENTS_DATA;

 PROCEDURE MERGE_SPA_UNIT_ACTIVATION_DATA (P_IN_CHM_MSI_SPA_UNIT_ACTIVATION IN TBL_CHM_MSI_SPA_UNIT_ACTIVATION
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_UNIT_ACTIVATION.FIRST..P_IN_CHM_MSI_SPA_UNIT_ACTIVATION.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_UNIT_ACTIVATION TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).CHM_MSI_SPA_UNIT_ACTIVATION_ID                     CHM_MSI_SPA_UNIT_ACTIVATION_ID                             
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ID                                                 ID                                                 
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ITEM_NUMBER                                        ITEM_NUMBER                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).MIN_QUANTITY                                       MIN_QUANTITY                                               
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).UNIT_REBATE_AMOUNT                                 UNIT_REBATE_AMOUNT                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).SPA_NUMBER                                        	SPA_NUMBER                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).SPA_ID                                             SPA_ID                                              
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).STATUS                                             STATUS                                             
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).SFDC_CREATED_DATE                     	            SFDC_CREATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).SFDC_LAST_UPDATE_DATE                 	            SFDC_LAST_UPDATE_DATE                 
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).SFDC_CREATED_BY                                    SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).SFDC_LAST_UPDATED_BY                               SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE_CONTEXT                                  ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE1                                         ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE2                                         ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE3                                         ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE4                                         ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE5                                         ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE6                                         ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE7                                         ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE8                                         ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE9                                         ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE10                                        ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE11                                        ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE12                                       	ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE13                                        ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE14                                        ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ATTRIBUTE15                                        ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).CREATED_BY                                         CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).CREATION_DATE                         	            CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).LAST_UPDATED_BY                                    LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).LAST_UPDATED_DATE                     	            LAST_UPDATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).SOURCE_APP_ID                                      SOURCE_APP_ID                                              
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).ENTERPRISE_ID                                      ENTERPRISE_ID                                              
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).IP_ADDRESS                                         IP_ADDRESS                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).USER_AGENT                                         USER_AGENT                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATION(I).OIC_INSTANCE_ID	                                OIC_INSTANCE_ID

                        FROM
                            DUAL
                ) TMP ON ( TBL.SPA_NUMBER                 = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_UNIT_ACTIVATION_ID                             
                    ,ID                                                 
                    ,ITEM_NUMBER                                        
                    ,MIN_QUANTITY                                               
                    ,UNIT_REBATE_AMOUNT                                         
                    ,SPA_NUMBER                                          
                    ,SPA_ID                                             
                    ,STATUS                                             
                    ,SFDC_CREATED_DATE                     
                    ,SFDC_LAST_UPDATE_DATE                 
                    ,SFDC_CREATED_BY                                    
                    ,SFDC_LAST_UPDATED_BY                               
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
                    ,SOURCE_APP_ID                                              
                    ,ENTERPRISE_ID                                              
                    ,IP_ADDRESS                                         
                    ,USER_AGENT                                         
                    ,OIC_INSTANCE_ID

                )
                VALUES
                ( 
                     CHM_MSI_SPA_UNIT_ACTIVATION_INCENTIVES_SEQ.NEXTVAL
                    ,TMP.ID                                                 
                    ,TMP.ITEM_NUMBER                                       
                    ,TMP.MIN_QUANTITY                                               
                    ,TMP.UNIT_REBATE_AMOUNT                                         
                    ,TMP.SPA_NUMBER                                          
                    ,TMP.SPA_ID                                             
                    ,TMP.STATUS                                             
                    ,TMP.SFDC_CREATED_DATE                     
                    ,TMP.SFDC_LAST_UPDATE_DATE                 
                    ,TMP.SFDC_CREATED_BY                                    
                    ,TMP.SFDC_LAST_UPDATED_BY                               
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
                    ,TMP.SOURCE_APP_ID                                              
                    ,TMP.ENTERPRISE_ID                                              
                    ,TMP.IP_ADDRESS                                         
                    ,TMP.USER_AGENT                                         
                    ,TMP.OIC_INSTANCE_ID      				
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     ID                                           =TMP.ID                         
                    ,ITEM_NUMBER                                  =TMP.ITEM_NUMBER                
                    ,MIN_QUANTITY                                 =TMP.MIN_QUANTITY                       
                    ,UNIT_REBATE_AMOUNT                           =TMP.UNIT_REBATE_AMOUNT                 
                    ,SPA_NUMBER                                   =TMP.SPA_NUMBER                  
                    ,SPA_ID                                       =TMP.SPA_ID                     
                    ,STATUS                                       =TMP.STATUS                     
                    ,SFDC_CREATED_DATE                            =TMP.SFDC_CREATED_DATE    
                    ,SFDC_LAST_UPDATE_DATE                        =TMP.SFDC_LAST_UPDATE_DATE
                    ,SFDC_CREATED_BY                              =TMP.SFDC_CREATED_BY            
                    ,SFDC_LAST_UPDATED_BY                         =TMP.SFDC_LAST_UPDATED_BY       
                    ,ATTRIBUTE_CONTEXT                            =TMP.ATTRIBUTE_CONTEXT          
                    ,ATTRIBUTE1                                   =TMP.ATTRIBUTE1                 
                    ,ATTRIBUTE2                                   =TMP.ATTRIBUTE2                 
                    ,ATTRIBUTE3                                   =TMP.ATTRIBUTE3                 
                    ,ATTRIBUTE4                                   =TMP.ATTRIBUTE4                 
                    ,ATTRIBUTE5                                   =TMP.ATTRIBUTE5                 
                    ,ATTRIBUTE6                                   =TMP.ATTRIBUTE6                 
                    ,ATTRIBUTE7                                   =TMP.ATTRIBUTE7                 
                    ,ATTRIBUTE8                                   =TMP.ATTRIBUTE8                 
                    ,ATTRIBUTE9                                   =TMP.ATTRIBUTE9                 
                    ,ATTRIBUTE10                                  =TMP.ATTRIBUTE10                
                    ,ATTRIBUTE11                                  =TMP.ATTRIBUTE11                
                    ,ATTRIBUTE12                                  =TMP.ATTRIBUTE12                
                    ,ATTRIBUTE13                                  =TMP.ATTRIBUTE13                
                    ,ATTRIBUTE14                                  =TMP.ATTRIBUTE14                
                    ,ATTRIBUTE15                                  =TMP.ATTRIBUTE15                
                    ,CREATED_BY                                   =TMP.CREATED_BY                              
                    ,LAST_UPDATED_BY                              =TMP.LAST_UPDATED_BY            
                    ,LAST_UPDATED_DATE                            =SYSDATE              
                    ,SOURCE_APP_ID                                =TMP.SOURCE_APP_ID                      
                    ,ENTERPRISE_ID                                =TMP.ENTERPRISE_ID                      
                    ,IP_ADDRESS                                   =TMP.IP_ADDRESS                 
                    ,USER_AGENT                                   =TMP.USER_AGENT                 
                    ,OIC_INSTANCE_ID                              =TMP.OIC_INSTANCE_ID      
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
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_UNIT_ACTIVATION_DATA;

	 PROCEDURE MERGE_SPA_SYSTEM_SIZE_INCENTIVES_DATA (P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES IN TBL_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES.FIRST..P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).CHM_MSI_SPA_SYS_SIZE_ID           CHM_MSI_SPA_SYS_SIZE_ID                          
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ID                                ID                                                 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SPA_NUMBER                        SPA_NUMBER                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SPA_ID                            SPA_ID                                                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ITEM_NUMBER                       ITEM_NUMBER                                                
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).TIER1_REBATE_AMOUNT               TIER1_REBATE_AMOUNT                               
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).TIER2_REABTE_AMOUNT               TIER2_REABTE_AMOUNT                                 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).TIER3_REABTE_AMOUNT               TIER3_REABTE_AMOUNT                                
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).TIER4_REBATE_AMOUNT               TIER4_REBATE_AMOUNT                   
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).TIER5_REBATE_AMOUNT               TIER5_REBATE_AMOUNT                 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).STATUS                            STATUS                                             
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SFDC_CREATED_DATE                 SFDC_CREATED_DATE                                  
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SFDC_LAST_UPDATE_DATE             SFDC_LAST_UPDATE_DATE                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SFDC_CREATED_BY                   SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SFDC_LAST_UPDATED_BY              SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE_CONTEXT                 ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE1                        ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE2                        ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE3                        ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE4                        ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE5                        ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE6                        ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE7                        ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE8                        ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE9                        ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE10                       ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE11                       ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE12                       ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE13                       ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE14                       ATTRIBUTE14                           
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ATTRIBUTE15                       ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).CREATED_BY                        CREATED_BY                            
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).CREATION_DATE                     CREATION_DATE                                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).LAST_UPDATED_BY                   LAST_UPDATED_BY                                            
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).LAST_UPDATED_DATE                 LAST_UPDATED_DATE                                  
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SOURCE_APP_ID                     SOURCE_APP_ID                                      
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).ENTERPRISE_ID                     ENTERPRISE_ID          
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).IP_ADDRESS                        IP_ADDRESS             
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).USER_AGENT                        USER_AGENT             
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).OIC_INSTANCE_ID                   OIC_INSTANCE_ID        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).IS_DELETED                        IS_DELETED             
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).NAME                              NAME                   
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).CURRENCY_ISO_CODE                 CURRENCY_ISO_CODE      
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SYSTEM_MOD_STAMP                  SYSTEM_MOD_STAMP       
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).LAST_ACTIVITY_DATE                LAST_ACTIVITY_DATE     
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).LAST_VIEWED_DATE                  LAST_VIEWED_DATE       
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).LAST_REFERENCED_DATE              LAST_REFERENCED_DATE   
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).SPA                               SPA                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).UNIQUE_KEY                        UNIQUE_KEY             
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES(I).PRODUCT                           PRODUCT                

					   FROM
                            DUAL
                ) TMP ON ( TBL.SPA_NUMBER                 = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
				 CHM_MSI_SPA_SYS_SIZE_ID
                ,ID                       
				,SPA_NUMBER              
				,SPA_ID                  
				,ITEM_NUMBER             
				,TIER1_REBATE_AMOUNT     
				,TIER2_REABTE_AMOUNT     
				,TIER3_REABTE_AMOUNT     
				,TIER4_REBATE_AMOUNT     
				,TIER5_REBATE_AMOUNT     
				,STATUS                  
				,SFDC_CREATED_DATE       
				,SFDC_LAST_UPDATE_DATE   
				,SFDC_CREATED_BY         
				,SFDC_LAST_UPDATED_BY    
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
				,SOURCE_APP_ID           
				,ENTERPRISE_ID           
				,IP_ADDRESS              
				,USER_AGENT              
				,OIC_INSTANCE_ID         
				,IS_DELETED              
				,NAME                    
				,CURRENCY_ISO_CODE       
				,SYSTEM_MOD_STAMP        
				,LAST_ACTIVITY_DATE      
				,LAST_VIEWED_DATE        
				,LAST_REFERENCED_DATE    
				,SPA                     
				,UNIQUE_KEY              
				,PRODUCT                 
                )
                VALUES
                ( 
                     CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES_SEQ.NEXTVAL
                    ,TMP.ID                                                    
                    ,TMP.SPA_NUMBER                                          
                    ,TMP.SPA_ID                                                       
                    ,TMP.ITEM_NUMBER                                                  
                    ,TMP.TIER1_REBATE_AMOUNT                                   
                    ,TMP.TIER2_REABTE_AMOUNT                                  
                    ,TMP.TIER3_REABTE_AMOUNT                                  
                    ,TMP.TIER4_REBATE_AMOUNT                     
                    ,TMP.TIER5_REBATE_AMOUNT                     
                    ,TMP.STATUS                                               
                    ,TMP.SFDC_CREATED_DATE                                    
                    ,TMP.SFDC_LAST_UPDATE_DATE                                
                    ,TMP.SFDC_CREATED_BY                                      
                    ,TMP.SFDC_LAST_UPDATED_BY                                 
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
                    ,TMP.CREATION_DATE                                                
                    ,TMP.LAST_UPDATED_BY                                              
                    ,TMP.LAST_UPDATED_DATE                                    
                    ,TMP.SOURCE_APP_ID                                        
                    ,TMP.ENTERPRISE_ID           
                    ,TMP.IP_ADDRESS              
                    ,TMP.USER_AGENT              
                    ,TMP.OIC_INSTANCE_ID         
                    ,TMP.IS_DELETED              
                    ,TMP.NAME                    
                    ,TMP.CURRENCY_ISO_CODE       
                    ,TMP.SYSTEM_MOD_STAMP        
                    ,TMP.LAST_ACTIVITY_DATE      
                    ,TMP.LAST_VIEWED_DATE        
                    ,TMP.LAST_REFERENCED_DATE    
                    ,TMP.SPA                     
                    ,TMP.UNIQUE_KEY              
                    ,TMP.PRODUCT                 	
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     ID                                              =TMP.ID                               
                    ,SPA_NUMBER                                      =TMP.SPA_NUMBER                       
                    ,SPA_ID                                          =TMP.SPA_ID                                   
                    ,ITEM_NUMBER                                     =TMP.ITEM_NUMBER                              
                    ,TIER1_REBATE_AMOUNT                             =TMP.TIER1_REBATE_AMOUNT               
                    ,TIER2_REABTE_AMOUNT                             =TMP.TIER2_REABTE_AMOUNT              
                    ,TIER3_REABTE_AMOUNT                             =TMP.TIER3_REABTE_AMOUNT              
                    ,TIER4_REBATE_AMOUNT                             =TMP.TIER4_REBATE_AMOUNT        
                    ,TIER5_REBATE_AMOUNT                             =TMP.TIER5_REBATE_AMOUNT        
                    ,STATUS                                          =TMP.STATUS                           
                    ,SFDC_CREATED_DATE                               =TMP.SFDC_CREATED_DATE                
                    ,SFDC_LAST_UPDATE_DATE                           =TMP.SFDC_LAST_UPDATE_DATE            
                    ,SFDC_CREATED_BY                                 =TMP.SFDC_CREATED_BY                  
                    ,SFDC_LAST_UPDATED_BY                            =TMP.SFDC_LAST_UPDATED_BY             
                    ,ATTRIBUTE_CONTEXT                               =TMP.ATTRIBUTE_CONTEXT                
                    ,ATTRIBUTE1                                      =TMP.ATTRIBUTE1                       
                    ,ATTRIBUTE2                                      =TMP.ATTRIBUTE2                       
                    ,ATTRIBUTE3                                      =TMP.ATTRIBUTE3                       
                    ,ATTRIBUTE4                                      =TMP.ATTRIBUTE4                       
                    ,ATTRIBUTE5                                      =TMP.ATTRIBUTE5                       
                    ,ATTRIBUTE6                                      =TMP.ATTRIBUTE6                       
                    ,ATTRIBUTE7                                      =TMP.ATTRIBUTE7                       
                    ,ATTRIBUTE8                                      =TMP.ATTRIBUTE8                       
                    ,ATTRIBUTE9                                      =TMP.ATTRIBUTE9                       
                    ,ATTRIBUTE10                                     =TMP.ATTRIBUTE10                      
                    ,ATTRIBUTE11                                     =TMP.ATTRIBUTE11                      
                    ,ATTRIBUTE12                                     =TMP.ATTRIBUTE12                      
                    ,ATTRIBUTE13                                     =TMP.ATTRIBUTE13                                   
                    ,ATTRIBUTE14                                     =TMP.ATTRIBUTE14                      
                    ,ATTRIBUTE15                                     =TMP.ATTRIBUTE15                
                    ,CREATED_BY                                      =TMP.CREATED_BY                                                         
                    ,LAST_UPDATED_BY                                 =TMP.LAST_UPDATED_BY                  
                    ,LAST_UPDATED_DATE                               =SYSDATE                
                    ,SOURCE_APP_ID                                   =TMP.SOURCE_APP_ID              
					,ENTERPRISE_ID                                   =TMP.ENTERPRISE_ID        
                    ,IP_ADDRESS                                      =TMP.IP_ADDRESS           
                    ,USER_AGENT                                      =TMP.USER_AGENT           
                    ,OIC_INSTANCE_ID                                 =TMP.OIC_INSTANCE_ID      
                    ,IS_DELETED                                      =TMP.IS_DELETED           
                    ,NAME                                            =TMP.NAME                 
                    ,CURRENCY_ISO_CODE                               =TMP.CURRENCY_ISO_CODE    
                    ,SYSTEM_MOD_STAMP                                =TMP.SYSTEM_MOD_STAMP     
                    ,LAST_ACTIVITY_DATE                              =TMP.LAST_ACTIVITY_DATE   
                    ,LAST_VIEWED_DATE                                =TMP.LAST_VIEWED_DATE     
                    ,LAST_REFERENCED_DATE                            =TMP.LAST_REFERENCED_DATE 
                    ,SPA                                             =TMP.SPA                  
                    ,UNIQUE_KEY                                      =TMP.UNIQUE_KEY           
                    ,PRODUCT                                         =TMP.PRODUCT              
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
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_SYSTEM_SIZE_INCENTIVES_DATA;

PROCEDURE MERGE_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL_DATA (P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL IN TBL_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL.FIRST..P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).CHM_MSI_SPA_SYS_SIZE_DETAIL_ID    CHM_MSI_SPA_SYS_SIZE_DETAIL_ID                            
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ID                                ID                                                   
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).SPA_NUMBER                        SPA_NUMBER                                           
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).SPA_ID                            SPA_ID                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ITEM_NUMBER                       ITEM_NUMBER                           
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).TIER_NAME                         TIER_NAME                             
						,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).MIN_QTY                           MIN_QTY              
						,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).MAX_QTY                           MAX_QTY              
						,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).UNIT_REBATE_AMOUNT                UNIT_REBATE_AMOUNT   
						,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).SFDC_CREATED_DATE                 SFDC_CREATED_DATE    
						,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).SFDC_LAST_UPDATE_DATE             SFDC_LAST_UPDATE_DATE
						,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).SFDC_CREATED_BY                   SFDC_CREATED_BY      
						,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).SFDC_LAST_UPDATED_BY              SFDC_LAST_UPDATED_BY 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE_CONTEXT                 ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE1                        ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE2                        ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE3                        ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE4                        ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE5                        ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE6                        ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE7                        ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE8                        ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE9                        ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE10                       ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE11                       ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE12                       ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE13                       ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE14                       ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ATTRIBUTE15                       ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).CREATED_BY                        CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).CREATION_DATE                     CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).LAST_UPDATED_BY                   LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).LAST_UPDATED_DATE                 LAST_UPDATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).SOURCE_APP_ID                     SOURCE_APP_ID                                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).ENTERPRISE_ID                        ENTERPRISE_ID                                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).IP_ADDRESS                           IP_ADDRESS                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).USER_AGENT                           USER_AGENT                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL(I).OIC_INSTANCE_ID	                     OIC_INSTANCE_ID

                        FROM
                            DUAL
                ) TMP ON ( TBL.ID                 = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
				     CHM_MSI_SPA_SYS_SIZE_DETAIL_ID
				    ,ID                            
				    ,SPA_NUMBER                    
				    ,SPA_ID                        
				    ,ITEM_NUMBER                   
				    ,TIER_NAME                     
				    ,MIN_QTY                       
				    ,MAX_QTY                       
				    ,UNIT_REBATE_AMOUNT            
				    ,SFDC_CREATED_DATE             
				    ,SFDC_LAST_UPDATE_DATE         
				    ,SFDC_CREATED_BY               
                    ,SFDC_LAST_UPDATED_BY              
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
                    ,SOURCE_APP_ID                                              
                    ,ENTERPRISE_ID                                              
                    ,IP_ADDRESS                                         
                    ,USER_AGENT                                         
                    ,OIC_INSTANCE_ID

                )
                VALUES
                ( 
                     CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES_DETAIL_SEQ.NEXTVAL
                    ,TMP.ID                                        
                    ,TMP.SPA_NUMBER                                
                    ,TMP.SPA_ID               
                    ,TMP.ITEM_NUMBER          
                    ,TMP.TIER_NAME            
                    ,TMP.MIN_QTY              
                    ,TMP.MAX_QTY              
                    ,TMP.UNIT_REBATE_AMOUNT   
                    ,TMP.SFDC_CREATED_DATE    
                    ,TMP.SFDC_LAST_UPDATE_DATE
                    ,TMP.SFDC_CREATED_BY      
                    ,TMP.SFDC_LAST_UPDATED_BY 
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
                    ,TMP.SOURCE_APP_ID                                              
                    ,TMP.ENTERPRISE_ID                                              
                    ,TMP.IP_ADDRESS                                         
                    ,TMP.USER_AGENT                                         
                    ,TMP.OIC_INSTANCE_ID      				
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     CHM_MSI_SPA_SYS_SIZE_DETAIL_ID               =TMP.CHM_MSI_SPA_SYS_SIZE_DETAIL_ID
                    ,ID                                           =TMP.ID                            
                    ,SPA_NUMBER                                   =TMP.SPA_NUMBER                     
                    ,SPA_ID                                       =TMP.SPA_ID                        
                    ,ITEM_NUMBER                                  =TMP.ITEM_NUMBER                   
                    ,TIER_NAME                                    =TMP.TIER_NAME                     
                    ,MIN_QTY                                      =TMP.MIN_QTY                       
                    ,MAX_QTY                                      =TMP.MAX_QTY                       
                    ,UNIT_REBATE_AMOUNT                           =TMP.UNIT_REBATE_AMOUNT            
                    ,SFDC_CREATED_DATE                            =TMP.SFDC_CREATED_DATE             
                    ,SFDC_LAST_UPDATE_DATE                        =TMP.SFDC_LAST_UPDATE_DATE         
                    ,SFDC_CREATED_BY                              =TMP.SFDC_CREATED_BY               
					,SFDC_LAST_UPDATED_BY                         =TMP.SFDC_LAST_UPDATED_BY          
                    ,ATTRIBUTE_CONTEXT                            =TMP.ATTRIBUTE_CONTEXT          
                    ,ATTRIBUTE1                                   =TMP.ATTRIBUTE1                 
                    ,ATTRIBUTE2                                   =TMP.ATTRIBUTE2                 
                    ,ATTRIBUTE3                                   =TMP.ATTRIBUTE3                 
                    ,ATTRIBUTE4                                   =TMP.ATTRIBUTE4                 
                    ,ATTRIBUTE5                                   =TMP.ATTRIBUTE5                 
                    ,ATTRIBUTE6                                   =TMP.ATTRIBUTE6                 
                    ,ATTRIBUTE7                                   =TMP.ATTRIBUTE7                 
                    ,ATTRIBUTE8                                   =TMP.ATTRIBUTE8                 
                    ,ATTRIBUTE9                                   =TMP.ATTRIBUTE9                 
                    ,ATTRIBUTE10                                  =TMP.ATTRIBUTE10                
                    ,ATTRIBUTE11                                  =TMP.ATTRIBUTE11                
                    ,ATTRIBUTE12                                  =TMP.ATTRIBUTE12                
                    ,ATTRIBUTE13                                  =TMP.ATTRIBUTE13                
                    ,ATTRIBUTE14                                  =TMP.ATTRIBUTE14                
                    ,ATTRIBUTE15                                  =TMP.ATTRIBUTE15                
                    ,CREATED_BY                                   =TMP.CREATED_BY                              
                    ,LAST_UPDATED_BY                              =TMP.LAST_UPDATED_BY            
                    ,LAST_UPDATED_DATE                            =SYSDATE              
                    ,SOURCE_APP_ID                                =TMP.SOURCE_APP_ID                      
                    ,ENTERPRISE_ID                                =TMP.ENTERPRISE_ID                      
                    ,IP_ADDRESS                                   =TMP.IP_ADDRESS                 
                    ,USER_AGENT                                   =TMP.USER_AGENT                 
                    ,OIC_INSTANCE_ID                              =TMP.OIC_INSTANCE_ID      
					 WHERE 1 = 1
					 AND TBL.ID                       = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;

            END;


        END LOOP;

        UPDATE CHM_INTEGRATION_RUNS
        SET      TOTAL_FETCHED_RECORDS      = nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT
                ,TOTAL_SUCCESS_RECORDS      = nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT
                ,TOTAL_ERROR_RECORDS        = nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)
                ,LOG                        = LOG   ||CHR(10)||'Data Merged Successfully.'   ||CHR(10)  
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL_DATA;

PROCEDURE MERGE_SPA_GEO_DETAILS_DATA (P_IN_CHM_MSI_SPA_GEO_DETAILS IN TBL_CHM_MSI_SPA_GEO_DETAILS
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_GEO_DETAILS.FIRST..P_IN_CHM_MSI_SPA_GEO_DETAILS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_GEO_DETAILS TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_GEO_DETAILS(I).CHM_MSI_SPA_GEO_DETAIL_ID                 CHM_MSI_SPA_SYS_ATTACHMENT_ID                            
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ID                                         ID                                                 
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SPA_NUMBER                                 SPA_NUMBER                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SPA_ID                                     SPA_ID                                              
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).COUNTRY                                    COUNTRY                                       
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).STATE                                     	STATE                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ZIP                                        ZIP                                              
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).STATUS                                     STATUS                                             
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_CREATED_DATE             	            SFDC_CREATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_LAST_UPDATE_DATE         	            SFDC_LAST_UPDATE_DATE                 
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_CREATED_BY                            SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_LAST_UPDATED_BY                       SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE_CONTEXT                          ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE1                                 ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE2                                 ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE3                                 ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE4                                 ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE5                                 ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE6                                 ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE7                                 ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE8                                 ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE9                                 ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE10                                ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE11                                ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE12                               	ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE13                                ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE14                                ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE15                                ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).CREATED_BY                                 CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).CREATION_DATE                 	            CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_UPDATED_BY                            LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_UPDATED_DATE             	            LAST_UPDATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SOURCE_APP_ID                              SOURCE_APP_ID                                           
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ENTERPRISE_ID                              ENTERPRISE_ID                                           
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).IP_ADDRESS                                 IP_ADDRESS                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).USER_AGENT                                 USER_AGENT                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).OIC_INSTANCE_ID          			        OIC_INSTANCE_ID
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).IS_DELETED                                 IS_DELETED          
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).NAME                                       NAME                
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).CURRENCY_ISO_CODE                          CURRENCY_ISO_CODE   
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SYSTEM_MOD_STAMP                           SYSTEM_MOD_STAMP    
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_VIEWED_DATE                           LAST_VIEWED_DATE    
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_REFERENCED_DATE                       LAST_REFERENCED_DATE
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SPA                                        SPA                 

                        FROM
                            DUAL
                ) TMP ON ( TBL.SPA_NUMBER = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_GEO_DETAIL_ID                             
                    ,ID                                             
                    ,SPA_NUMBER                                     
                    ,SPA_ID                                                 
                    ,COUNTRY                                                
                    ,STATE                                           
                    ,ZIP                                            
                    ,STATUS                                         
                    ,SFDC_CREATED_DATE                 
                    ,SFDC_LAST_UPDATE_DATE             
                    ,SFDC_CREATED_BY                                
                    ,SFDC_LAST_UPDATED_BY                           
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
                    ,SOURCE_APP_ID                                          
                    ,ENTERPRISE_ID                                          
                    ,IP_ADDRESS                                     
                    ,USER_AGENT                                     
                    ,OIC_INSTANCE_ID          
					,IS_DELETED               
					,NAME                     
					,CURRENCY_ISO_CODE 
                    ,SYSTEM_MOD_STAMP    					
                    ,LAST_VIEWED_DATE    
                    ,LAST_REFERENCED_DATE
                    ,SPA                 					
                )
                VALUES
                ( 
                     CHM_MSI_SPA_GEO_DETAILS_SEQ.NEXTVAL
                    ,TMP.ID                                                       
                    ,TMP.SPA_NUMBER                                              
                    ,TMP.SPA_ID                                                           
                    ,TMP.COUNTRY                                                          
                    ,TMP.STATE                                                     
                    ,TMP.ZIP                                                      
                    ,TMP.STATUS                                                   
                    ,TMP.SFDC_CREATED_DATE                           
                    ,TMP.SFDC_LAST_UPDATE_DATE                       
                    ,TMP.SFDC_CREATED_BY                                          
                    ,TMP.SFDC_LAST_UPDATED_BY                                     
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
                    ,TMP.CREATION_DATE                         
                    ,TMP.LAST_UPDATED_BY                                          
                    ,TMP.LAST_UPDATED_DATE                 
                    ,TMP.SOURCE_APP_ID                                                    
                    ,TMP.ENTERPRISE_ID                                                    
                    ,TMP.IP_ADDRESS                                               
                    ,TMP.USER_AGENT                                               
                    ,TMP.OIC_INSTANCE_ID          
                    ,TMP.IS_DELETED               
                    ,TMP.NAME                     
                    ,TMP.CURRENCY_ISO_CODE 
					,TMP.SYSTEM_MOD_STAMP    		
                    ,TMP.LAST_VIEWED_DATE    
                    ,TMP.LAST_REFERENCED_DATE
                    ,TMP.SPA                 		

			   )
                WHEN MATCHED THEN UPDATE
                SET 
                 ID                                                 =TMP.ID                           
                ,SPA_NUMBER                                         =TMP.SPA_NUMBER                   
                ,SPA_ID                                             =TMP.SPA_ID                               
                ,COUNTRY                                            =TMP.COUNTRY                              
                ,STATE                                              =TMP.STATE                         
                ,ZIP                                                =TMP.ZIP                          
                ,STATUS                                             =TMP.STATUS                       
                ,SFDC_CREATED_DATE                                  =TMP.SFDC_CREATED_DATE      
                ,SFDC_LAST_UPDATE_DATE                              =TMP.SFDC_LAST_UPDATE_DATE  
                ,SFDC_CREATED_BY                                    =TMP.SFDC_CREATED_BY              
                ,SFDC_LAST_UPDATED_BY                               =TMP.SFDC_LAST_UPDATED_BY         
                ,ATTRIBUTE_CONTEXT                                  =TMP.ATTRIBUTE_CONTEXT            
                ,ATTRIBUTE1                                         =TMP.ATTRIBUTE1                   
                ,ATTRIBUTE2                                         =TMP.ATTRIBUTE2                   
                ,ATTRIBUTE3                                         =TMP.ATTRIBUTE3                   
                ,ATTRIBUTE4                                         =TMP.ATTRIBUTE4                   
                ,ATTRIBUTE5                                         =TMP.ATTRIBUTE5                   
                ,ATTRIBUTE6                                         =TMP.ATTRIBUTE6                   
                ,ATTRIBUTE7                                         =TMP.ATTRIBUTE7                   
                ,ATTRIBUTE8                                         =TMP.ATTRIBUTE8                   
                ,ATTRIBUTE9                                         =TMP.ATTRIBUTE9                   
                ,ATTRIBUTE10                                        =TMP.ATTRIBUTE10                  
                ,ATTRIBUTE11                                        =TMP.ATTRIBUTE11                  
                ,ATTRIBUTE12                                        =TMP.ATTRIBUTE12                  
                ,ATTRIBUTE13                                        =TMP.ATTRIBUTE13                  
                ,ATTRIBUTE14                                        =TMP.ATTRIBUTE14                  
                ,ATTRIBUTE15                                        =TMP.ATTRIBUTE15                  
                ,CREATED_BY                                         =TMP.CREATED_BY                                               
                ,LAST_UPDATED_BY                                    =TMP.LAST_UPDATED_BY        
                ,LAST_UPDATED_DATE                                  =SYSDATE                   
                ,SOURCE_APP_ID                                      =TMP.SOURCE_APP_ID                        
                ,ENTERPRISE_ID                                      =TMP.ENTERPRISE_ID                
                ,IP_ADDRESS                                         =TMP.IP_ADDRESS                   
                ,USER_AGENT                                         =TMP.USER_AGENT             
                ,OIC_INSTANCE_ID                                    =TMP.OIC_INSTANCE_ID        
                ,IS_DELETED                                         =TMP.IS_DELETED             
                ,NAME                                               =TMP.NAME                   
                ,CURRENCY_ISO_CODE                                  =TMP.CURRENCY_ISO_CODE 
                ,SYSTEM_MOD_STAMP    	                            =TMP.SYSTEM_MOD_STAMP    	
                ,LAST_VIEWED_DATE                                   =TMP.LAST_VIEWED_DATE    
                ,LAST_REFERENCED_DATE                               =TMP.LAST_REFERENCED_DATE
                ,SPA                 	                            =TMP.SPA                 	

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
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_GEO_DETAILS_DATA;

PROCEDURE MERGE_SPA_INSTALLERS_DATA (P_IN_CHM_MSI_SPA_INSTALLERS IN TBL_CHM_MSI_SPA_INSTALLERS
                                    ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2)
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_INSTALLERS.FIRST..P_IN_CHM_MSI_SPA_INSTALLERS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_INSTALLERS TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_INSTALLERS(I).CHM_MSI_SPA_INSTALLER_ID       CHM_MSI_SPA_INSTALLER_ID                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ID                             ID                                               
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).INSTALLER_ACCOUNT_NAME         INSTALLER_ACCOUNT_NAME                           
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).INSTALLER_ENLIGHTEN_ID         INSTALLER_ENLIGHTEN_ID                                  
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SPA_NUMBER                     SPA_NUMBER                                               
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SPA_ID                         SPA_ID                                          
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).STATUS                         STATUS                                            
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_CREATED_DATE              SFDC_CREATED_DATE                                
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_LAST_UPDATE_DATE          SFDC_LAST_UPDATE_DATE               
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_CREATED_BY                SFDC_CREATED_BY                   
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_LAST_UPDATED_BY           SFDC_LAST_UPDATED_BY                             
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE_CONTEXT              ATTRIBUTE_CONTEXT                                
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE1                     ATTRIBUTE1                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE2                     ATTRIBUTE2                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE3                     ATTRIBUTE3                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE4                     ATTRIBUTE4                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE5                     ATTRIBUTE5                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE6                     ATTRIBUTE6                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE7                     ATTRIBUTE7                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE8                     ATTRIBUTE8                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE9                     ATTRIBUTE9                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE10                    ATTRIBUTE10                                      
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE11                    ATTRIBUTE11                                      
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE12                    ATTRIBUTE12                                      
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE13                    ATTRIBUTE13                                      
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE14                    ATTRIBUTE14                                      
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ATTRIBUTE15                    ATTRIBUTE15                                      
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).CREATED_BY                     CREATED_BY                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).CREATION_DATE                  CREATION_DATE                                    
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_UPDATED_BY                LAST_UPDATED_BY                     
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_UPDATED_DATE              LAST_UPDATED_DATE                                
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SOURCE_APP_ID                  SOURCE_APP_ID                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).ENTERPRISE_ID                  ENTERPRISE_ID                                            
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).IP_ADDRESS                     IP_ADDRESS                                               
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).USER_AGENT                     USER_AGENT                                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).INSTALLER_SFDC_ACCOUNT_ID      INSTALLER_SFDC_ACCOUNT_ID                        
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).OIC_INSTANCE_ID                OIC_INSTANCE_ID            
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).IS_DELETED                     IS_DELETED                 
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).NAME                           NAME                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).CURRENCY_ISO_CODE              CURRENCY_ISO_CODE          
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SYSTEM_MOD_STAMP               SYSTEM_MOD_STAMP           
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_ACTIVITY_DATE             LAST_ACTIVITY_DATE         
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_VIEWED_DATE               LAST_VIEWED_DATE           
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_REFERENCED_DATE           LAST_REFERENCED_DATE       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).INSTALLER_NAME                 INSTALLER_NAME             
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SPA                            SPA                        


					   FROM
                            DUAL
                ) TMP ON ( TBL.SPA_NUMBER                 = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
				 CHM_MSI_SPA_INSTALLER_ID   
                ,ID                         
				,INSTALLER_ACCOUNT_NAME     
				,INSTALLER_ENLIGHTEN_ID     
				,SPA_NUMBER                 
				,SPA_ID                     
				,STATUS                     
				,SFDC_CREATED_DATE          
				,SFDC_LAST_UPDATE_DATE      
				,SFDC_CREATED_BY            
				,SFDC_LAST_UPDATED_BY       
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
				,SOURCE_APP_ID              
				,ENTERPRISE_ID              
				,IP_ADDRESS                 
				,USER_AGENT                 
				,INSTALLER_SFDC_ACCOUNT_ID  
				,OIC_INSTANCE_ID            
				,IS_DELETED                 
				,NAME                       
				,CURRENCY_ISO_CODE          
				,SYSTEM_MOD_STAMP           
				,LAST_ACTIVITY_DATE         
				,LAST_VIEWED_DATE           
				,LAST_REFERENCED_DATE       
				,INSTALLER_NAME             
				,SPA                        	
                )
                VALUES
                ( 
                     CHM_MSI_SPA_INSTALLERS_SEQ.NEXTVAL
                    ,TMP.ID                                                
                    ,TMP.INSTALLER_ACCOUNT_NAME                          
                    ,TMP.INSTALLER_ENLIGHTEN_ID                                   
                    ,TMP.SPA_NUMBER                                               
                    ,TMP.SPA_ID                                            
                    ,TMP.STATUS                                           
                    ,TMP.SFDC_CREATED_DATE                                
                    ,TMP.SFDC_LAST_UPDATE_DATE               
                    ,TMP.SFDC_CREATED_BY                     
                    ,TMP.SFDC_LAST_UPDATED_BY                             
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
                    ,TMP.CREATION_DATE                                    
                    ,TMP.LAST_UPDATED_BY               
                    ,TMP.LAST_UPDATED_DATE                                
                    ,TMP.SOURCE_APP_ID              
                    ,TMP.ENTERPRISE_ID                                            
                    ,TMP.IP_ADDRESS                                               
                    ,TMP.USER_AGENT                                       
                    ,TMP.INSTALLER_SFDC_ACCOUNT_ID                        
                    ,TMP.OIC_INSTANCE_ID            
                    ,TMP.IS_DELETED                 
                    ,TMP.NAME                       
                    ,TMP.CURRENCY_ISO_CODE          
                    ,TMP.SYSTEM_MOD_STAMP           
                    ,TMP.LAST_ACTIVITY_DATE         
                    ,TMP.LAST_VIEWED_DATE           
                    ,TMP.LAST_REFERENCED_DATE       
                    ,TMP.INSTALLER_NAME             
                    ,TMP.SPA                        	
                    )
                    WHEN MATCHED THEN UPDATE
                    SET 
                     ID                                              =TMP.ID                                  
                    ,INSTALLER_ACCOUNT_NAME                          =TMP.INSTALLER_ACCOUNT_NAME              
                    ,INSTALLER_ENLIGHTEN_ID                          =TMP.INSTALLER_ENLIGHTEN_ID                      
                    ,SPA_NUMBER                                      =TMP.SPA_NUMBER                                  
                    ,SPA_ID                                          =TMP.SPA_ID                               
                    ,STATUS                                          =TMP.STATUS                              
                    ,SFDC_CREATED_DATE                               =TMP.SFDC_CREATED_DATE                   
                    ,SFDC_LAST_UPDATE_DATE                           =TMP.SFDC_LAST_UPDATE_DATE         
                    ,SFDC_CREATED_BY                                 =TMP.SFDC_CREATED_BY               
                    ,SFDC_LAST_UPDATED_BY                            =TMP.SFDC_LAST_UPDATED_BY                
                    ,ATTRIBUTE_CONTEXT                               =TMP.ATTRIBUTE_CONTEXT                   
                    ,ATTRIBUTE1                                      =TMP.ATTRIBUTE1                          
                    ,ATTRIBUTE2                                      =TMP.ATTRIBUTE2                          
                    ,ATTRIBUTE3                                      =TMP.ATTRIBUTE3                          
                    ,ATTRIBUTE4                                      =TMP.ATTRIBUTE4                          
                    ,ATTRIBUTE5                                      =TMP.ATTRIBUTE5                          
                    ,ATTRIBUTE6                                      =TMP.ATTRIBUTE6                          
                    ,ATTRIBUTE7                                      =TMP.ATTRIBUTE7                          
                    ,ATTRIBUTE8                                      =TMP.ATTRIBUTE8                          
                    ,ATTRIBUTE9                                      =TMP.ATTRIBUTE9                          
                    ,ATTRIBUTE10                                     =TMP.ATTRIBUTE10                         
                    ,ATTRIBUTE11                                     =TMP.ATTRIBUTE11                         
                    ,ATTRIBUTE12                                     =TMP.ATTRIBUTE12                         
                    ,ATTRIBUTE13                                     =TMP.ATTRIBUTE13                         
                    ,ATTRIBUTE14                                     =TMP.ATTRIBUTE14                         
                    ,ATTRIBUTE15                                     =TMP.ATTRIBUTE15                         
                    ,CREATED_BY                                      =TMP.CREATED_BY                                                            
                    ,LAST_UPDATED_BY                                 =TMP.LAST_UPDATED_BY                     
                    ,LAST_UPDATED_DATE                               =SYSDATE             
                    ,SOURCE_APP_ID                                   =TMP.SOURCE_APP_ID                               
                    ,ENTERPRISE_ID                                   =TMP.ENTERPRISE_ID                               
                    ,IP_ADDRESS                                      =TMP.IP_ADDRESS                          
                    ,USER_AGENT                                      =TMP.USER_AGENT                          
                    ,INSTALLER_SFDC_ACCOUNT_ID                       =TMP.INSTALLER_SFDC_ACCOUNT_ID     
					,OIC_INSTANCE_ID                                 =TMP.OIC_INSTANCE_ID            
                    ,IS_DELETED                                      =TMP.IS_DELETED                 
                    ,NAME                                            =TMP.NAME                       
                    ,CURRENCY_ISO_CODE                               =TMP.CURRENCY_ISO_CODE          
                    ,SYSTEM_MOD_STAMP                                =TMP.SYSTEM_MOD_STAMP           
                    ,LAST_ACTIVITY_DATE                              =TMP.LAST_ACTIVITY_DATE         
                    ,LAST_VIEWED_DATE                                =TMP.LAST_VIEWED_DATE           
                    ,LAST_REFERENCED_DATE                            =TMP.LAST_REFERENCED_DATE       
                    ,INSTALLER_NAME                                  =TMP.INSTALLER_NAME             
                    ,SPA                        	                 =TMP.SPA                        	         
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
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT) ||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_INSTALLERS_DATA;

END CHM_MSI_SPA_HEADER_PKG;