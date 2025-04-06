create or replace PACKAGE BODY CHM_MSI_SPA_OBJECTS_PKG
/*******************************************************************************************************
* Type                           : PL/SQL Package Body                                        *
* Package Name                   : CHM_MSI_SPA_OBJECTS_PKG                                         *
* Purpose                        : Package Body for MSI SPA OBJECTS sync from SFDC  *
* Created By                     : Raja Ratnakar Reddy                                                      *
* Created Date                   : 21-Mar-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 21-Mar-2025   Raja Ratnakar Reddy                  1.0              Intial Version                         * 
*******************************************************************************************************/
as

    PROCEDURE MERGE_SPA_UNIT_ACTIVATION_DATA (
        P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS IN TBL_CHM_MSI_SPA_UNIT_ACTIVATIONS
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS.FIRST..P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_UNIT_ACTIVATIONS TBL
                USING (
                    SELECT

                         P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ID                                          ID                                                 
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).MIN_QUANTITY                                MIN_QUANTITY                                               
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).SPA                                         SPA                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).STATUS                                      STATUS                                             
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).SFDC_CREATED_DATE                     	  SFDC_CREATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).SFDC_LAST_UPDATE_DATE                 	  SFDC_LAST_UPDATE_DATE                 
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).SFDC_CREATED_BY                             SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).SFDC_LAST_UPDATED_BY                        SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE_CONTEXT                           ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE1                                  ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE2                                  ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE3                                  ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE4                                  ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE5                                  ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE6                                  ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE7                                  ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE8                                  ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE9                                  ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE10                                 ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE11                                 ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE12                                 ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE13                                 ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE14                                 ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ATTRIBUTE15                                 ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).CREATED_BY                                  CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).CREATION_DATE                         	  CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).LAST_UPDATED_BY                             LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).LAST_UPDATED_DATE                     	  LAST_UPDATED_DATE                                                                              
                        ,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).OIC_INSTANCE_ID	                          OIC_INSTANCE_ID
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).IS_DELETED                                  IS_DELETED           
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).NAME                                        NAME                 
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).CURRENCY_ISO_CODE                           CURRENCY_ISO_CODE    
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).SYSTEM_MOD_STAMP                            SYSTEM_MOD_STAMP     
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).LAST_ACTIVITY_DATE                          LAST_ACTIVITY_DATE   
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).LAST_VIEWED_DATE                            LAST_VIEWED_DATE     
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).LAST_REFERENCED_DATE                        LAST_REFERENCED_DATE 
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).PER_UNIT_INCENTIVE                          PER_UNIT_INCENTIVE   
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).PRODUCT                                     PRODUCT              
						,P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).UNIQUE_KEY                                  UNIQUE_KEY           


                        FROM
                            DUAL
                ) TMP ON ( TBL.ID = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_UNIT_ACTIVATION_ID                           
                    ,ID                                                 
                    ,MIN_QUANTITY                                               
                    ,SPA                                          
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
                    ,OIC_INSTANCE_ID
					,IS_DELETED          
					,NAME                
					,CURRENCY_ISO_CODE   
					,SYSTEM_MOD_STAMP    
					,LAST_ACTIVITY_DATE  
					,LAST_VIEWED_DATE    
					,LAST_REFERENCED_DATE
					,PER_UNIT_INCENTIVE  
					,PRODUCT             
					,UNIQUE_KEY          



                )
                VALUES
                ( 
                     CHM_MSI_SPA_UNIT_ACTIVATION_INCENTIVES_SEQ.NEXTVAL
                    ,TMP.ID                                                 
                    ,TMP.MIN_QUANTITY                                               
                    ,TMP.SPA                                     
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
                    ,TMP.OIC_INSTANCE_ID
					,TMP.IS_DELETED          
                    ,TMP.NAME                
                    ,TMP.CURRENCY_ISO_CODE   
                    ,TMP.SYSTEM_MOD_STAMP    
                    ,TMP.LAST_ACTIVITY_DATE  
                    ,TMP.LAST_VIEWED_DATE    
                    ,TMP.LAST_REFERENCED_DATE
                    ,TMP.PER_UNIT_INCENTIVE  
                    ,TMP.PRODUCT             
                    ,TMP.UNIQUE_KEY          


                )
                WHEN MATCHED THEN UPDATE
                SET 
                     MIN_QUANTITY                                 =TMP.MIN_QUANTITY                       
                    ,SPA                                          =TMP.SPA
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
                    ,LAST_UPDATED_BY                              =TMP.LAST_UPDATED_BY            
                    ,LAST_UPDATED_DATE                            =SYSDATE                                              
                    ,OIC_INSTANCE_ID                              =TMP.OIC_INSTANCE_ID    
                    ,IS_DELETED                                   =TMP.IS_DELETED
					,NAME                                         =TMP.NAME                
					,CURRENCY_ISO_CODE                            =TMP.CURRENCY_ISO_CODE   
					,SYSTEM_MOD_STAMP                             =TMP.SYSTEM_MOD_STAMP    
					,LAST_ACTIVITY_DATE                           =TMP.LAST_ACTIVITY_DATE  
					,LAST_VIEWED_DATE                             =TMP.LAST_VIEWED_DATE    
					,LAST_REFERENCED_DATE                         =TMP.LAST_REFERENCED_DATE
					,PER_UNIT_INCENTIVE                           =TMP.PER_UNIT_INCENTIVE  
					,PRODUCT                                      =TMP.PRODUCT             
					,UNIQUE_KEY                                   =TMP.UNIQUE_KEY          
					 WHERE 1 = 1
					 AND TBL.ID = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;

			EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SPA_UNIT_ACTIVATIONS(I).ID  ||'-'     
                                    ||'] '
                                    ||L_ERROR_MESSAGE 
                            ,LAST_UPDATE_DATE           = SYSDATE
                    WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
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

    PROCEDURE MERGE_SPA_SYSTEM_ATTACHMENTS_DATA (
        P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS IN TBL_CHM_MSI_SPA_SYSTEM_ATTACHMENTS
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
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

                         P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ID                                         ID                                                 
                        --,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ITEM_NUMBER                                ITEM_NUMBER                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).MIN_QUANTITY                              MIN_QUANTITY                                               
                        --,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).UNIT_REBATE_AMOUNT                        UNIT_REBATE_AMOUNT                                         
                        --,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SPA_NUMBER                                SPA_NUMBER                                        
                        --,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SPA_ID                                    SPA_ID                                              
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).STATUS                                    STATUS                                             
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_CREATED_DATE                     	  SFDC_CREATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_LAST_UPDATE_DATE                 	  SFDC_LAST_UPDATE_DATE                 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_CREATED_BY                           SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SFDC_LAST_UPDATED_BY                      SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE_CONTEXT                         ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE1                                ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE2                                ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE3                                ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE4                                ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE5                                ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE6                                ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE7                                ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE8                                ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE9                                ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE10                               ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE11                               ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE12                               ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE13                               ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE14                               ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ATTRIBUTE15                               ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).CREATED_BY                                CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).CREATION_DATE                         	  CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).LAST_UPDATED_BY                           LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).LAST_UPDATED_DATE                     	  LAST_UPDATED_DATE                                                                                 
                        ,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).OIC_INSTANCE_ID	                          OIC_INSTANCE_ID
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).IS_DELETED                                IS_DELETED          
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).NAME                                      NAME                
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).CURRENCY_ISO_CODE                         CURRENCY_ISO_CODE   
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SYSTEM_MOD_STAMP                          SYSTEM_MOD_STAMP    
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).LAST_ACTIVITY_DATE                        LAST_ACTIVITY_DATE  
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).LAST_VIEWED_DATE                          LAST_VIEWED_DATE    
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).LAST_REFERENCED_DATE                      LAST_REFERENCED_DATE
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).PER_UNIT_INCENTIVE                        PER_UNIT_INCENTIVE  
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).SPA                                       SPA                 
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).UNIQUE_KEY                                UNIQUE_KEY          
						,P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).PRODUCT                                   PRODUCT             

                        FROM
                            DUAL
                ) TMP ON ( TBL.ID = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_SYS_ATTACHMENT_ID                             
                    ,ID                                                 
                    --,ITEM_NUMBER                                        
                    ,MIN_QUANTITY                                               
                    --,UNIT_REBATE_AMOUNT                                         
                    --,SPA_NUMBER                                          
                    --,SPA_ID                                             
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
                    ,OIC_INSTANCE_ID
					,IS_DELETED          
					,NAME                
					,CURRENCY_ISO_CODE   
					,SYSTEM_MOD_STAMP    
					,LAST_ACTIVITY_DATE  
					,LAST_VIEWED_DATE    
					,LAST_REFERENCED_DATE
					,PER_UNIT_INCENTIVE  
					,SPA                 
					,UNIQUE_KEY          
					,PRODUCT             

                )
                VALUES
                ( 
                     CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES_SEQ.NEXTVAL
                    ,TMP.ID                                                 
                    --,TMP.ITEM_NUMBER                                       
                    ,TMP.MIN_QUANTITY                                               
                    --,TMP.UNIT_REBATE_AMOUNT                                         
                    --,TMP.SPA_NUMBER                                          
                    --,TMP.SPA_ID                                             
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
                    ,TMP.OIC_INSTANCE_ID  
                    ,TMP.IS_DELETED          
                    ,TMP.NAME                
                    ,TMP.CURRENCY_ISO_CODE   
                    ,TMP.SYSTEM_MOD_STAMP    
                    ,TMP.LAST_ACTIVITY_DATE  
                    ,TMP.LAST_VIEWED_DATE    
                    ,TMP.LAST_REFERENCED_DATE
                    ,TMP.PER_UNIT_INCENTIVE  
                    ,TMP.SPA                 
                    ,TMP.UNIQUE_KEY          
                    ,TMP.PRODUCT             

                )
                WHEN MATCHED THEN UPDATE
                SET 
                     --ID                                           =TMP.ID                         
                     --ITEM_NUMBER                                  =TMP.ITEM_NUMBER                
                     MIN_QUANTITY                                 =TMP.MIN_QUANTITY                       
                    --,UNIT_REBATE_AMOUNT                           =TMP.UNIT_REBATE_AMOUNT                                                   
                    --,SPA_ID                                       =TMP.SPA_ID                     
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
                    ,OIC_INSTANCE_ID                              =TMP.OIC_INSTANCE_ID 
                    ,IS_DELETED                                   =TMP.IS_DELETED          
					,NAME                                         =TMP.NAME                
					,CURRENCY_ISO_CODE                            =TMP.CURRENCY_ISO_CODE   
					,SYSTEM_MOD_STAMP                             =TMP.SYSTEM_MOD_STAMP    
					,LAST_ACTIVITY_DATE                           =TMP.LAST_ACTIVITY_DATE  
					,LAST_VIEWED_DATE                             =TMP.LAST_VIEWED_DATE    
					,LAST_REFERENCED_DATE                         =TMP.LAST_REFERENCED_DATE
					,PER_UNIT_INCENTIVE                           =TMP.PER_UNIT_INCENTIVE  
					,SPA                                          =TMP.SPA             
					,UNIQUE_KEY                                   =TMP.UNIQUE_KEY          
					,PRODUCT                                      =TMP.PRODUCT             

					 WHERE 1 = 1
					 AND TBL.ID = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
				EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SPA_SYSTEM_ATTACHMENTS(I).ID ||'-'     
                                    ||'] '
                                    ||L_ERROR_MESSAGE 
                            ,LAST_UPDATE_DATE           = SYSDATE
                    WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
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

    PROCEDURE MERGE_SPA_SYS_SIZE_INCENTIVE_DATA (
        P_IN_CHM_MSI_SYS_SIZE_INCENTIVE IN TBL_CHM_MSI_SYS_SIZE_INCENTIVE
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SYS_SIZE_INCENTIVE.FIRST..P_IN_CHM_MSI_SYS_SIZE_INCENTIVE.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SYS_SIZE_INCENTIVE TBL

                USING (
                    SELECT

                         P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ID                                ID                                                 
                        --,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SPA_NUMBER                        SPA_NUMBER                                         
                        --,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SPA_ID                            SPA_ID                                                    
                        --,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ITEM_NUMBER                       ITEM_NUMBER                                                
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).TIER1_REBATE_AMOUNT               TIER1_REBATE_AMOUNT                               
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).TIER2_REABTE_AMOUNT               TIER2_REABTE_AMOUNT                                 
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).TIER3_REABTE_AMOUNT               TIER3_REABTE_AMOUNT                                
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).TIER4_REBATE_AMOUNT               TIER4_REBATE_AMOUNT                   
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).TIER5_REBATE_AMOUNT               TIER5_REBATE_AMOUNT                 
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).STATUS                            STATUS                                             
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SFDC_CREATED_DATE                 SFDC_CREATED_DATE                                  
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SFDC_LAST_UPDATE_DATE             SFDC_LAST_UPDATE_DATE                              
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SFDC_CREATED_BY                   SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SFDC_LAST_UPDATED_BY              SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE_CONTEXT                 ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE1                        ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE2                        ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE3                        ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE4                        ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE5                        ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE6                        ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE7                        ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE8                        ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE9                        ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE10                       ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE11                       ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE12                       ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE13                       ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE14                       ATTRIBUTE14                           
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ATTRIBUTE15                       ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).CREATED_BY                        CREATED_BY                            
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).CREATION_DATE                     CREATION_DATE                                              
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).LAST_UPDATED_BY                   LAST_UPDATED_BY                                            
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).LAST_UPDATED_DATE                 LAST_UPDATED_DATE                                                                
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).OIC_INSTANCE_ID                   OIC_INSTANCE_ID        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).IS_DELETED                        IS_DELETED             
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).NAME                              NAME                   
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).CURRENCY_ISO_CODE                 CURRENCY_ISO_CODE      
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SYSTEM_MOD_STAMP                  SYSTEM_MOD_STAMP       
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).LAST_ACTIVITY_DATE                LAST_ACTIVITY_DATE     
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).LAST_VIEWED_DATE                  LAST_VIEWED_DATE       
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).LAST_REFERENCED_DATE              LAST_REFERENCED_DATE   
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).SPA                               SPA                    
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).UNIQUE_KEY                        UNIQUE_KEY             
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).PRODUCT                           PRODUCT                

					   FROM
                            DUAL
                ) TMP ON ( TBL.ID = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
		         CHM_MSI_SPA_SYS_SIZE_ID
                ,ID                       
				--,SPA_NUMBER              
				--,SPA_ID                  
				--,ITEM_NUMBER             
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
                    --,TMP.SPA_NUMBER                                          
                    --,TMP.SPA_ID                                                       
                    --,TMP.ITEM_NUMBER                                                  
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
                     --ID                                              =TMP.ID                                                                   
                     --SPA_ID                                          =TMP.SPA_ID                                   
                     --ITEM_NUMBER                                     =TMP.ITEM_NUMBER                              
                     TIER1_REBATE_AMOUNT                             =TMP.TIER1_REBATE_AMOUNT               
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
                    ,LAST_UPDATED_BY                                 =TMP.LAST_UPDATED_BY                  
                    ,LAST_UPDATED_DATE                               =SYSDATE                                           
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
					 AND TBL.ID = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
				EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SYS_SIZE_INCENTIVE(I).ID ||'-'     
                                    ||'] '
                                    ||L_ERROR_MESSAGE 
                            ,LAST_UPDATE_DATE           = SYSDATE
                    WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
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

    END MERGE_SPA_SYS_SIZE_INCENTIVE_DATA;

    PROCEDURE MERGE_CHM_MSI_SYS_SIZE_INCENTIVE_CHM_DATA (
        P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM IN TBL_CHM_MSI_SYS_SIZE_INCENTIVE_CHM
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM.FIRST..P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SYS_SIZE_INCENTIVE_CHM TBL
                USING (
                    SELECT

                         P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ID                                ID                                                   
                        --,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SPA_NUMBER                        SPA_NUMBER                                           
                        --,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SPA_ID                            SPA_ID                         
                        --,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ITEM_NUMBER                       ITEM_NUMBER                           
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).TIER_NAME                         TIER_NAME                             
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).MIN_QTY                           MIN_QTY              
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).MAX_QTY                           MAX_QTY              
						--,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).UNIT_REBATE_AMOUNT                UNIT_REBATE_AMOUNT   
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SFDC_CREATED_DATE                 SFDC_CREATED_DATE    
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SFDC_LAST_UPDATE_DATE             SFDC_LAST_UPDATE_DATE
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SFDC_CREATED_BY                   SFDC_CREATED_BY      
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SFDC_LAST_UPDATED_BY              SFDC_LAST_UPDATED_BY 
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE_CONTEXT                 ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE1                        ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE2                        ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE3                        ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE4                        ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE5                        ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE6                        ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE7                        ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE8                        ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE9                        ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE10                       ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE11                       ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE12                       ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE13                       ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE14                       ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ATTRIBUTE15                       ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).CREATED_BY                        CREATED_BY                                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).CREATION_DATE                     CREATION_DATE                         
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).LAST_UPDATED_BY                   LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).LAST_UPDATED_DATE                 LAST_UPDATED_DATE                                                                               
                        ,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).OIC_INSTANCE_ID	                  OIC_INSTANCE_ID
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).IS_DELETED          			  IS_DELETED
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).NAME                			  NAME
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).CURRENCY_ISO_CODE   			  CURRENCY_ISO_CODE
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SYSTEM_MOD_STAMP  				  SYSTEM_MOD_STAMP  
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).LAST_ACTIVITY_DATE				  LAST_ACTIVITY_DATE  
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).LAST_VIEWED_DATE  				  LAST_VIEWED_DATE  
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).LAST_REFERENCED_DATE			  LAST_REFERENCED_DATE
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).SPA 							  SPA                
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).TIER_INCENTIVE    				  TIER_INCENTIVE  
						,P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).PRODUCT     					  PRODUCT        
						FROM
                            DUAL
                ) TMP ON ( TBL.ID = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
				     CHM_MSI_SPA_SYS_SIZE_DETAIL_ID
				    ,ID                            
				    --,SPA_NUMBER                    
				    --,SPA_ID                        
				    --,ITEM_NUMBER                   
				    ,TIER_NAME                     
				    ,MIN_QTY                       
				    ,MAX_QTY                       
				    --,UNIT_REBATE_AMOUNT            
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
                    ,OIC_INSTANCE_ID
					,IS_DELETED          
					,NAME                
					,CURRENCY_ISO_CODE   
					,SYSTEM_MOD_STAMP    
					,LAST_ACTIVITY_DATE  
					,LAST_VIEWED_DATE    
					,LAST_REFERENCED_DATE
					,SPA                 
					,TIER_INCENTIVE      
					,PRODUCT             

                )
                VALUES
                ( 
                     CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES_DETAIL_SEQ.NEXTVAL
                    ,TMP.ID                                        
                    --,TMP.SPA_NUMBER                                
                    --,TMP.SPA_ID               
                    --,TMP.ITEM_NUMBER          
                    ,TMP.TIER_NAME            
                    ,TMP.MIN_QTY              
                    ,TMP.MAX_QTY              
                    --,TMP.UNIT_REBATE_AMOUNT   
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
                    ,TMP.OIC_INSTANCE_ID 
					,TMP.IS_DELETED          
					,TMP.NAME                
					,TMP.CURRENCY_ISO_CODE   
					,TMP.SYSTEM_MOD_STAMP    
					,TMP.LAST_ACTIVITY_DATE  
					,TMP.LAST_VIEWED_DATE    
					,TMP.LAST_REFERENCED_DATE
					,TMP.SPA                 
					,TMP.TIER_INCENTIVE      
                    ,TMP.PRODUCT             

                )
                WHEN MATCHED THEN UPDATE
                SET 

                     --ID                                           =TMP.ID                                                                   
                     --SPA_ID                                       =TMP.SPA_ID                        
                     --ITEM_NUMBER                                  =TMP.ITEM_NUMBER                   
                     TIER_NAME                                    =TMP.TIER_NAME                     
                    ,MIN_QTY                                      =TMP.MIN_QTY                       
                    ,MAX_QTY                                      =TMP.MAX_QTY                       
                    --,UNIT_REBATE_AMOUNT                           =TMP.UNIT_REBATE_AMOUNT            
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
                    ,LAST_UPDATED_BY                              =TMP.LAST_UPDATED_BY            
                    ,LAST_UPDATED_DATE                            =SYSDATE                                              
                    ,OIC_INSTANCE_ID                              =TMP.OIC_INSTANCE_ID 
					,IS_DELETED          						  =TMP.PRODUCT                  
					,NAME                						  =TMP.TIER_INCENTIVE      
					,CURRENCY_ISO_CODE   						  =TMP.SPA                 
					,SYSTEM_MOD_STAMP    						  =TMP.LAST_REFERENCED_DATE
					,LAST_ACTIVITY_DATE  						  =TMP.LAST_VIEWED_DATE    
					,LAST_VIEWED_DATE    						  =TMP.LAST_ACTIVITY_DATE  
					,LAST_REFERENCED_DATE						  =TMP.SYSTEM_MOD_STAMP    
					,SPA                 						  =TMP.CURRENCY_ISO_CODE   
					,TIER_INCENTIVE      						  =TMP.NAME                
					,PRODUCT             						  =TMP.IS_DELETED          
					 WHERE 1 = 1
					 AND TBL.ID = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;

				EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SYS_SIZE_INCENTIVE_CHM(I).ID ||'-'     
                                    ||'] '
                                    ||L_ERROR_MESSAGE 
                            ,LAST_UPDATE_DATE           = SYSDATE
                    WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
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
        WHERE   CHM_INTEGRATION_RUN_ID = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_CHM_MSI_SYS_SIZE_INCENTIVE_CHM_DATA;

	  --Procedure to update integration run table   
    PROCEDURE FINISH_INTEGRATION_RUN (
         P_IN_OIC_INSTANCE_ID       IN VARCHAR2
        ,P_OUT_DATA                 OUT    SYS_REFCURSOR
    )
    AS
    BEGIN

        UPDATE CHM_INTEGRATION_RUNS
        SET 
             PHASE                  = 'Completed'
            ,STATUS                 = 'Success'
            ,LAST_COMPLETED_STAGE   = 'Data Merge'
            ,LOG                    = LOG || CHR(10) ||'Integration completed successfully'
            ,LAST_UPDATE_DATE       = SYSDATE
            ,COMPLETION_DATE        = SYSDATE
        WHERE CHM_INTEGRATION_RUN_ID = P_IN_OIC_INSTANCE_ID;
        COMMIT;

        UPDATE CHM_INTEGRATIONS
        SET 
             LAST_RUN_STATUS = 'Success'
        WHERE LAST_RUN_ID = P_IN_OIC_INSTANCE_ID;
        COMMIT;

        OPEN P_OUT_DATA FOR
        SELECT NVL(TOTAL_SUCCESS_RECORDS,0) TOTAL_SUCCESS_RECORDS, NVL(TOTAL_ERROR_RECORDS,0) TOTAL_ERROR_RECORDS
        FROM CHM_INTEGRATION_RUNS 
        WHERE CHM_INTEGRATION_RUN_ID = P_IN_OIC_INSTANCE_ID;

    END FINISH_INTEGRATION_RUN;

    --Procedure to update log
    PROCEDURE UPDATE_LOG (
         P_IN_LOG                IN VARCHAR2
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
    AS

    BEGIN
        UPDATE CHM_INTEGRATION_RUNS
        SET 
             LOG                        = LOG || CHR(10) || P_IN_LOG
            ,LAST_UPDATE_DATE           = SYSDATE
        WHERE CHM_INTEGRATION_RUN_ID    = P_IN_OIC_INSTANCE_ID;
        COMMIT;
    END UPDATE_LOG;

    --Procedure to check if any record failed
    PROCEDURE CHECK_FAILED_RECORDS (
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
    AS
        L_COUNT NUMBER;
    BEGIN
        SELECT NVL(TOTAL_ERROR_RECORDS,0) INTO L_COUNT
        FROM CHM_INTEGRATION_RUNS
        WHERE CHM_INTEGRATION_RUN_ID = P_IN_OIC_INSTANCE_ID;

        IF L_COUNT > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Few Records failed to merge');
        END IF;

    END CHECK_FAILED_RECORDS;


END CHM_MSI_SPA_OBJECTS_PKG;
/
