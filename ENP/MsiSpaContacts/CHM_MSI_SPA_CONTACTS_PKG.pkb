create or replace PACKAGE BODY CHM_MSI_SPA_CONTACTS_PKG

/*******************************************************************************************************
* Type                           : PL/SQL Package Specification                                        *
* Package Name                   : CHM_MSI_SPA_CONTACTS_PKG                                            *
* Purpose                        : Package Specification for MSI SPA Contacts sync from SFDC           *
* Created By                     : Gurpreet Singh                                                      *
* Created Date                   : 15-Apr-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 15-Apr-2025   Gurpreet Singh                  1.0              Intial Version                        * 
*******************************************************************************************************/

AS

    PROCEDURE MERGE_SPA_CONTACT_DATA (
         P_IN_CHM_MSI_SPA_CONTACT       IN TBL_CHM_MSI_SPA_CONTACT
        ,P_IN_OIC_INSTANCE_ID           IN VARCHAR2
    )
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_CONTACT.FIRST..P_IN_CHM_MSI_SPA_CONTACT.LAST LOOP
            
            
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_SPA_CONTACTS TBL

                USING (
                    SELECT

                         P_IN_CHM_MSI_SPA_CONTACT(I).ID                                ID                                                 
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).IS_DELETED                        IS_DELETED             
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).NAME                              NAME                   
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).CURRENCY_ISO_CODE                 CURRENCY_ISO_CODE      
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).SFDC_CREATED_DATE                 SFDC_CREATED_DATE                                  
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).SFDC_LAST_UPDATE_DATE             SFDC_LAST_UPDATE_DATE                              
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).SFDC_CREATED_BY                   SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).SFDC_LAST_UPDATED_BY              SFDC_LAST_UPDATED_BY                               
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).SYSTEM_MOD_STAMP                  SYSTEM_MOD_STAMP       
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).LAST_ACTIVITY_DATE                LAST_ACTIVITY_DATE     
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).LAST_VIEWED_DATE                  LAST_VIEWED_DATE       
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).LAST_REFERENCED_DATE              LAST_REFERENCED_DATE   
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).CONTACT_ID                        CONTACT_ID                    
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).CONTACT_NAME                      CONTACT_NAME                
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).SPA                               SPA                    
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).EMAIL                             EMAIL           
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE_CONTEXT                 ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE1                        ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE2                        ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE3                        ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE4                        ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE5                        ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE6                        ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE7                        ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE8                        ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE9                        ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE10                       ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE11                       ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE12                       ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE13                       ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE14                       ATTRIBUTE14                           
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).ATTRIBUTE15                       ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).CREATED_BY                        CREATED_BY                            
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).CREATION_DATE                     CREATION_DATE                                              
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).LAST_UPDATED_BY                   LAST_UPDATED_BY                                            
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).LAST_UPDATED_DATE                 LAST_UPDATED_DATE                                                                
                        ,P_IN_CHM_MSI_SPA_CONTACT(I).OIC_INSTANCE_ID                   OIC_INSTANCE_ID        
					   FROM
                            DUAL
                ) TMP ON ( TBL.ID = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_SPA_CONTACTS_ID
                    ,ID                           
                    ,IS_DELETED             
                    ,NAME                   
                    ,CURRENCY_ISO_CODE      
                    ,SFDC_CREATED_DATE            
                    ,SFDC_LAST_MODIFIED_DATE        
                    ,SFDC_CREATED_BY              
                    ,SFDC_LAST_MODIFIED_BY         
                    ,SYSTEM_MOD_STAMP       
                    ,LAST_ACTIVITY_DATE     
                    ,LAST_VIEWED_DATE       
                    ,LAST_REFERENCED_DATE   
                    ,CONTACT_ID                   
                    ,CONTACT_NAME                
                    ,SPA                    
                    ,EMAIL           
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
                     CHM_SPA_CONTACTS_ID_SEQ.NEXTVAL
                    ,TMP.ID                           
                    ,TMP.IS_DELETED             
                    ,TMP.NAME                   
                    ,TMP.CURRENCY_ISO_CODE      
                    ,TMP.SFDC_CREATED_DATE            
                    ,TMP.SFDC_LAST_UPDATE_DATE        
                    ,TMP.SFDC_CREATED_BY              
                    ,TMP.SFDC_LAST_UPDATED_BY         
                    ,TMP.SYSTEM_MOD_STAMP       
                    ,TMP.LAST_ACTIVITY_DATE     
                    ,TMP.LAST_VIEWED_DATE       
                    ,TMP.LAST_REFERENCED_DATE   
                    ,TMP.CONTACT_ID                   
                    ,TMP.CONTACT_NAME                
                    ,TMP.SPA                    
                    ,TMP.EMAIL           
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
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     IS_DELETED                = TMP.IS_DELETED            
                    ,NAME                      = TMP.NAME                  
                    ,CURRENCY_ISO_CODE         = TMP.CURRENCY_ISO_CODE     
                    ,SFDC_CREATED_DATE         = TMP.SFDC_CREATED_DATE     
                    ,SFDC_LAST_MODIFIED_DATE   = TMP.SFDC_LAST_UPDATE_DATE 
                    ,SFDC_CREATED_BY           = TMP.SFDC_CREATED_BY       
                    ,SFDC_LAST_MODIFIED_BY     = TMP.SFDC_LAST_UPDATED_BY  
                    ,SYSTEM_MOD_STAMP          = TMP.SYSTEM_MOD_STAMP      
                    ,LAST_ACTIVITY_DATE        = TMP.LAST_ACTIVITY_DATE    
                    ,LAST_VIEWED_DATE          = TMP.LAST_VIEWED_DATE      
                    ,LAST_REFERENCED_DATE      = TMP.LAST_REFERENCED_DATE  
                    ,CONTACT_ID                = TMP.CONTACT_ID            
                    ,CONTACT_NAME              = TMP.CONTACT_NAME          
                    ,SPA                       = TMP.SPA                   
                    ,EMAIL                     = TMP.EMAIL           
                    ,ATTRIBUTE_CONTEXT         = TMP.ATTRIBUTE_CONTEXT     
                    ,ATTRIBUTE1                = TMP.ATTRIBUTE1            
                    ,ATTRIBUTE2                = TMP.ATTRIBUTE2            
                    ,ATTRIBUTE3                = TMP.ATTRIBUTE3            
                    ,ATTRIBUTE4                = TMP.ATTRIBUTE4            
                    ,ATTRIBUTE5                = TMP.ATTRIBUTE5            
                    ,ATTRIBUTE6                = TMP.ATTRIBUTE6            
                    ,ATTRIBUTE7                = TMP.ATTRIBUTE7            
                    ,ATTRIBUTE8                = TMP.ATTRIBUTE8            
                    ,ATTRIBUTE9                = TMP.ATTRIBUTE9            
                    ,ATTRIBUTE10               = TMP.ATTRIBUTE10           
                    ,ATTRIBUTE11               = TMP.ATTRIBUTE11           
                    ,ATTRIBUTE12               = TMP.ATTRIBUTE12           
                    ,ATTRIBUTE13               = TMP.ATTRIBUTE13           
                    ,ATTRIBUTE14               = TMP.ATTRIBUTE14           
                    ,ATTRIBUTE15               = TMP.ATTRIBUTE15           
                    ,CREATED_BY                = TMP.CREATED_BY            
                    ,CREATION_DATE             = TMP.CREATION_DATE         
                    ,LAST_UPDATED_BY           = TMP.LAST_UPDATED_BY       
                    ,LAST_UPDATED_DATE         = TMP.LAST_UPDATED_DATE     
                    ,OIC_INSTANCE_ID           = TMP.OIC_INSTANCE_ID       
				WHERE 1 = 1
                AND TBL.ID = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
				EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SPA_CONTACT(I).ID     
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
                                                    ||CHR(9)||'Total Records Fetched: '     ||(nvl(TOTAL_FETCHED_RECORDS,0)  + L_COUNT) ||' ('||L_COUNT||')'||CHR(10)
                                                    ||CHR(9)||'Total Records Merged: '      ||(nvl(TOTAL_SUCCESS_RECORDS,0)  + L_MERGE_COUNT)||' ('||L_MERGE_COUNT||')'||CHR(10)
                                                    ||CHR(9)||'Total Records Failed to Merge: '|| (nvl(TOTAL_ERROR_RECORDS,0)    + (L_COUNT - L_MERGE_COUNT)) ||' ('||(L_COUNT - L_MERGE_COUNT)||')'||CHR(10)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_SPA_CONTACT_DATA;

END CHM_MSI_SPA_CONTACTS_PKG;
/

