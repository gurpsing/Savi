create or replace PACKAGE BODY CHM_MSI_SPA_DIST_INSTALLER_PKG
/**********************************************************************************************************************
* Type                           : PL/SQL Package Body                                                                *
* Package Name                   : CHM_MSI_SPA_DIST_INSTALLER_PKG                                                     *
* Purpose                        : Package Body for MSI SPA Distributor, Installer & Geo Restriction Sync from SFDC   *
* Created By                     : Gurpreet Singh                                                                     *
* Created Date                   : 22-Mar-2025                                                                        *
***********************************************************************************************************************
* Date          By                             Version          Details                                               *
* -----------   ---------------------------    -------------    ------------------------------------------------------*
* 22-Mar-2025   Gurpreet Singh                 1.0              Intial Version                                        *
**********************************************************************************************************************/
as
    
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
                         P_IN_CHM_MSI_SPA_INSTALLERS(I).ID                             ID                                               
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).IS_DELETED                     IS_DELETED                 
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).NAME                           NAME                       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).CURRENCY_ISO_CODE              CURRENCY_ISO_CODE          
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_CREATED_DATE              SFDC_CREATED_DATE                                
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_CREATED_BY                SFDC_CREATED_BY                   
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_LAST_UPDATE_DATE          SFDC_LAST_UPDATE_DATE               
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SFDC_LAST_UPDATED_BY           SFDC_LAST_UPDATED_BY                             
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SYSTEM_MOD_STAMP               SYSTEM_MOD_STAMP           
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_ACTIVITY_DATE             LAST_ACTIVITY_DATE         
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_VIEWED_DATE               LAST_VIEWED_DATE           
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).LAST_REFERENCED_DATE           LAST_REFERENCED_DATE       
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).INSTALLER_NAME                 INSTALLER_NAME             
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).SPA                            SPA                        
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).STATUS                         STATUS                                            
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).INSTALLER_ENLIGHTEN_ID         INSTALLER_ENLIGHTEN_ID                                  
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
                        ,P_IN_CHM_MSI_SPA_INSTALLERS(I).OIC_INSTANCE_ID                OIC_INSTANCE_ID            
					   FROM
                            DUAL
                ) TMP ON ( TBL.ID                 = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_INSTALLER_ID   
                    ,ID                           
                    ,IS_DELETED                   
                    ,NAME                         
                    ,CURRENCY_ISO_CODE            
                    ,SFDC_CREATED_DATE            
                    ,SFDC_CREATED_BY              
                    ,SFDC_LAST_UPDATE_DATE        
                    ,SFDC_LAST_UPDATED_BY         
                    ,SYSTEM_MOD_STAMP             
                    ,LAST_ACTIVITY_DATE      
                    ,LAST_VIEWED_DATE        
                    ,LAST_REFERENCED_DATE    
                    ,INSTALLER_NAME          
                    ,SPA                     
                    ,STATUS                  
                    ,INSTALLER_ENLIGHTEN_ID  
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
                     CHM_MSI_SPA_INSTALLERS_SEQ.NEXTVAL
                    ,TMP.ID                                        
                    ,TMP.IS_DELETED                              
                    ,TMP.NAME                                             
                    ,TMP.CURRENCY_ISO_CODE                                
                    ,TMP.SFDC_CREATED_DATE                         
                    ,TMP.SFDC_CREATED_BY                          
                    ,TMP.SFDC_LAST_UPDATE_DATE                    
                    ,TMP.SFDC_LAST_UPDATED_BY        
                    ,TMP.SYSTEM_MOD_STAMP            
                    ,TMP.LAST_ACTIVITY_DATE                    
                    ,TMP.LAST_VIEWED_DATE                      
                    ,TMP.LAST_REFERENCED_DATE                  
                    ,TMP.INSTALLER_NAME                        
                    ,TMP.SPA                                   
                    ,TMP.STATUS                                
                    ,TMP.INSTALLER_ENLIGHTEN_ID                
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
                     IS_DELETED                         = TMP.IS_DELETED                            
                    ,NAME                               = TMP.NAME                                          
                    ,CURRENCY_ISO_CODE                  = TMP.CURRENCY_ISO_CODE                             
                    ,SFDC_CREATED_DATE                  = TMP.SFDC_CREATED_DATE                      
                    ,SFDC_CREATED_BY                    = TMP.SFDC_CREATED_BY                       
                    ,SFDC_LAST_UPDATE_DATE              = TMP.SFDC_LAST_UPDATE_DATE                 
                    ,SFDC_LAST_UPDATED_BY               = TMP.SFDC_LAST_UPDATED_BY        
                    ,SYSTEM_MOD_STAMP                   = TMP.SYSTEM_MOD_STAMP            
                    ,LAST_ACTIVITY_DATE                 = TMP.LAST_ACTIVITY_DATE                    
                    ,LAST_VIEWED_DATE                   = TMP.LAST_VIEWED_DATE                      
                    ,LAST_REFERENCED_DATE               = TMP.LAST_REFERENCED_DATE                  
                    ,INSTALLER_NAME                     = TMP.INSTALLER_NAME                        
                    ,SPA                                = TMP.SPA                                   
                    ,STATUS                             = TMP.STATUS                                
                    ,INSTALLER_ENLIGHTEN_ID             = TMP.INSTALLER_ENLIGHTEN_ID                
                    ,ATTRIBUTE_CONTEXT                  = TMP.ATTRIBUTE_CONTEXT                     
                    ,ATTRIBUTE1                         = TMP.ATTRIBUTE1                            
                    ,ATTRIBUTE2                         = TMP.ATTRIBUTE2                            
                    ,ATTRIBUTE3                         = TMP.ATTRIBUTE3                            
                    ,ATTRIBUTE4                         = TMP.ATTRIBUTE4                            
                    ,ATTRIBUTE5                         = TMP.ATTRIBUTE5                            
                    ,ATTRIBUTE6                         = TMP.ATTRIBUTE6                            
                    ,ATTRIBUTE7                         = TMP.ATTRIBUTE7                            
                    ,ATTRIBUTE8                         = TMP.ATTRIBUTE8                            
                    ,ATTRIBUTE9                         = TMP.ATTRIBUTE9                            
                    ,ATTRIBUTE10                        = TMP.ATTRIBUTE10                                                             
                    ,ATTRIBUTE11                        = TMP.ATTRIBUTE11                           
                    ,ATTRIBUTE12                        = TMP.ATTRIBUTE12                
                    ,ATTRIBUTE13                        = TMP.ATTRIBUTE13                                   
                    ,ATTRIBUTE14                        = TMP.ATTRIBUTE14                            
                    ,ATTRIBUTE15                        = TMP.ATTRIBUTE15                           
                    ,CREATED_BY                         = TMP.CREATED_BY                            
                    ,CREATION_DATE                      = TMP.CREATION_DATE                     
					,LAST_UPDATED_BY                    = TMP.LAST_UPDATED_BY                   
                    ,LAST_UPDATED_DATE                  = TMP.LAST_UPDATED_DATE          
                    ,OIC_INSTANCE_ID                    = TMP.OIC_INSTANCE_ID            
					WHERE 1 = 1
					AND TBL.ID                          = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
                
            EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SPA_INSTALLERS(I).ID ||'-'     
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

    END MERGE_SPA_INSTALLERS_DATA;



    PROCEDURE MERGE_SPA_DISTRIBUTOR_DATA (
         P_IN_CHM_MSI_SPA_DISTRIBUTORS  IN TBL_CHM_MSI_SPA_DISTRIBUTORS
        ,P_IN_OIC_INSTANCE_ID           IN VARCHAR2
    )
	AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SPA_DISTRIBUTORS.FIRST..P_IN_CHM_MSI_SPA_DISTRIBUTORS.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SPA_DISTRIBUTOR TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ID                                       ID                             
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).IS_DELETED                               IS_DELETED                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).NAME                                     NAME                           
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).CURRENCY_ISO_CODE                        CURRENCY_ISO_CODE              
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SFDC_CREATED_DATE                        SFDC_CREATED_DATE              
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SFDC_CREATED_BY                          SFDC_CREATED_BY                
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SFDC_LAST_UPDATE_DATE                    SFDC_LAST_UPDATE_DATE          
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SFDC_LAST_UPDATED_BY                     SFDC_LAST_UPDATED_BY           
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SYSTEM_MOD_STAMP                         SYSTEM_MOD_STAMP               
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).LAST_VIEWED_DATE                         LAST_VIEWED_DATE               
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).LAST_REFERENCED_DATE                     LAST_REFERENCED_DATE           
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SPA_TEST                                 SPA_TEST                       
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).DISTRIBUTOR_ACCOUNT_NAME                 DISTRIBUTOR_ACCOUNT_NAME       
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SPA_STATUS                               SPA_STATUS                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ORACLE_CUSTOMER_NUMBER                   ORACLE_CUSTOMER_NUMBER          
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).SPA_AND_OPPORTUNITIES                    SPA_AND_OPPORTUNITIES                 
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).LINE_STATUS                              LINE_STATUS                    
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE_CONTEXT                        ATTRIBUTE_CONTEXT              
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE1                               ATTRIBUTE1                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE2                               ATTRIBUTE2                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE3                               ATTRIBUTE3                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE4                               ATTRIBUTE4                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE5                               ATTRIBUTE5                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE6                               ATTRIBUTE6                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE7                               ATTRIBUTE7                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE8                               ATTRIBUTE8                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE9                               ATTRIBUTE9                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE10                              ATTRIBUTE10                    
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE11                              ATTRIBUTE11                    
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE12                              ATTRIBUTE12                    
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE13                              ATTRIBUTE13                    
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE14                              ATTRIBUTE14                    
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ATTRIBUTE15                              ATTRIBUTE15                    
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).CREATED_BY                               CREATED_BY                     
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).CREATION_DATE                            CREATION_DATE                  
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).LAST_UPDATED_BY                          LAST_UPDATED_BY                
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).LAST_UPDATED_DATE                        LAST_UPDATED_DATE              
                        ,P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).OIC_INSTANCE_ID                          OIC_INSTANCE_ID                
                    FROM  DUAL
                ) TMP ON ( TBL.ID = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_DISTRIBUTOR_ID   
                    ,ID                        
                    ,IS_DELETED                
                    ,NAME                      
                    ,CURRENCY_ISO_CODE         
                    ,SFDC_CREATED_DATE         
                    ,SFDC_CREATED_BY           
                    ,SFDC_LAST_UPDATE_DATE     
                    ,SFDC_LAST_UPDATED_BY      
                    ,SYSTEM_MOD_STAMP          
                    ,LAST_VIEWED_DATE          
                    ,LAST_REFERENCED_DATE      
                    ,SPA_TEST                  
                    ,DISTRIBUTOR_ACCOUNT_NAME  
                    ,SPA_STATUS                
                    ,ORACLE_CUSTOMER_NUMBER    
                    ,SPA_AND_OPPORTUNITIES     
                    ,LINE_STATUS               
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
                     CHM_MSI_SPA_DISTRIBUTOR_SEQ.NEXTVAL
                    ,TMP.ID                        
                    ,TMP.IS_DELETED                
                    ,TMP.NAME                      
                    ,TMP.CURRENCY_ISO_CODE         
                    ,TMP.SFDC_CREATED_DATE         
                    ,TMP.SFDC_CREATED_BY           
                    ,TMP.SFDC_LAST_UPDATE_DATE     
                    ,TMP.SFDC_LAST_UPDATED_BY      
                    ,TMP.SYSTEM_MOD_STAMP          
                    ,TMP.LAST_VIEWED_DATE          
                    ,TMP.LAST_REFERENCED_DATE      
                    ,TMP.SPA_TEST                  
                    ,TMP.DISTRIBUTOR_ACCOUNT_NAME  
                    ,TMP.SPA_STATUS                
                    ,TMP.ORACLE_CUSTOMER_NUMBER    
                    ,TMP.SPA_AND_OPPORTUNITIES     
                    ,TMP.LINE_STATUS               
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
                     IS_DELETED                 = TMP.IS_DELETED                            
                    ,NAME                       = TMP.NAME                                  
                    ,CURRENCY_ISO_CODE          = TMP.CURRENCY_ISO_CODE              
                    ,SFDC_CREATED_DATE          = TMP.SFDC_CREATED_DATE             
                    ,SFDC_CREATED_BY            = TMP.SFDC_CREATED_BY               
                    ,SFDC_LAST_UPDATE_DATE      = TMP.SFDC_LAST_UPDATE_DATE      
                    ,SFDC_LAST_UPDATED_BY       = TMP.SFDC_LAST_UPDATED_BY       
                    ,SYSTEM_MOD_STAMP           = TMP.SYSTEM_MOD_STAMP              
                    ,LAST_VIEWED_DATE           = TMP.LAST_VIEWED_DATE              
                    ,LAST_REFERENCED_DATE       = TMP.LAST_REFERENCED_DATE          
                    ,SPA_TEST                   = TMP.SPA_TEST                      
                    ,DISTRIBUTOR_ACCOUNT_NAME   = TMP.DISTRIBUTOR_ACCOUNT_NAME      
                    ,SPA_STATUS                 = TMP.SPA_STATUS                    
                    ,ORACLE_CUSTOMER_NUMBER     = TMP.ORACLE_CUSTOMER_NUMBER        
                    ,SPA_AND_OPPORTUNITIES      = TMP.SPA_AND_OPPORTUNITIES         
                    ,LINE_STATUS                = TMP.LINE_STATUS                   
                    ,ATTRIBUTE_CONTEXT          = TMP.ATTRIBUTE_CONTEXT             
                    ,ATTRIBUTE1                 = TMP.ATTRIBUTE1                    
                    ,ATTRIBUTE2                 = TMP.ATTRIBUTE2                    
                    ,ATTRIBUTE3                 = TMP.ATTRIBUTE3                    
                    ,ATTRIBUTE4                 = TMP.ATTRIBUTE4                    
                    ,ATTRIBUTE5                 = TMP.ATTRIBUTE5                    
                    ,ATTRIBUTE6                 = TMP.ATTRIBUTE6                    
                    ,ATTRIBUTE7                 = TMP.ATTRIBUTE7                    
                    ,ATTRIBUTE8                 = TMP.ATTRIBUTE8                                                      
                    ,ATTRIBUTE9                 = TMP.ATTRIBUTE9                    
                    ,ATTRIBUTE10                = TMP.ATTRIBUTE10                
                    ,ATTRIBUTE11                = TMP.ATTRIBUTE11                           
                    ,ATTRIBUTE12                = TMP.ATTRIBUTE12                    
                    ,ATTRIBUTE13                = TMP.ATTRIBUTE13                   
                    ,ATTRIBUTE14                = TMP.ATTRIBUTE14                   
                    ,ATTRIBUTE15                = TMP.ATTRIBUTE15                
					,CREATED_BY                 = TMP.CREATED_BY                 
                    ,CREATION_DATE              = TMP.CREATION_DATE              
                    ,LAST_UPDATED_BY            = TMP.LAST_UPDATED_BY            
                    ,LAST_UPDATED_DATE          = TMP.LAST_UPDATED_DATE          
                    ,OIC_INSTANCE_ID            = TMP.OIC_INSTANCE_ID                
				WHERE 1 = 1
				AND TBL.ID                      = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
                
            EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SPA_DISTRIBUTORS(I).ID ||'-'     
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

    END MERGE_SPA_DISTRIBUTOR_DATA;


    PROCEDURE MERGE_SPA_GEO_DETAILS_DATA (
         P_IN_CHM_MSI_SPA_GEO_DETAILS IN TBL_CHM_MSI_SPA_GEO_DETAILS
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
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
                         P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ID                              ID                                                 
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).IS_DELETED                      IS_DELETED          
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).NAME                            NAME                
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).CURRENCY_ISO_CODE               CURRENCY_ISO_CODE   
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_CREATED_DATE             	 SFDC_CREATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_LAST_UPDATE_DATE         	 SFDC_LAST_UPDATE_DATE                 
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_CREATED_BY                 SFDC_CREATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SFDC_LAST_UPDATED_BY            SFDC_LAST_UPDATED_BY                               
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SYSTEM_MOD_STAMP                SYSTEM_MOD_STAMP    
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_ACTIVITY_DATE              LAST_ACTIVITY_DATE    
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_VIEWED_DATE                LAST_VIEWED_DATE    
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_REFERENCED_DATE            LAST_REFERENCED_DATE
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).COUNTRY                         COUNTRY                                       
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ZIP                             ZIP                                              
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).STATUS                          STATUS                                             
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).STATE                           STATE                                        
						,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).SPA                             SPA                 
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE_CONTEXT               ATTRIBUTE_CONTEXT                                  
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE1                      ATTRIBUTE1                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE2                      ATTRIBUTE2                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE3                      ATTRIBUTE3                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE4                      ATTRIBUTE4                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE5                      ATTRIBUTE5                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE6                      ATTRIBUTE6                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE7                      ATTRIBUTE7                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE8                      ATTRIBUTE8                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE9                      ATTRIBUTE9                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE10                     ATTRIBUTE10                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE11                     ATTRIBUTE11                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE12                     ATTRIBUTE12                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE13                     ATTRIBUTE13                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE14                     ATTRIBUTE14                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ATTRIBUTE15                     ATTRIBUTE15                                        
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).CREATED_BY                      CREATED_BY                                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).CREATION_DATE                 	 CREATION_DATE                         
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_UPDATED_BY                 LAST_UPDATED_BY                                    
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).LAST_UPDATED_DATE             	 LAST_UPDATED_DATE                     
                        ,P_IN_CHM_MSI_SPA_GEO_DETAILS(I).OIC_INSTANCE_ID          		 OIC_INSTANCE_ID
                    FROM
                        DUAL
                ) TMP ON ( TBL.ID = TMP.ID )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_MSI_SPA_GEO_DETAIL_ID                             
                    ,ID                          
                    ,IS_DELETED           
                    ,NAME                         
                    ,CURRENCY_ISO_CODE            
                    ,SFDC_CREATED_DATE            
                    ,SFDC_LAST_UPDATE_DATE       
                    ,SFDC_CREATED_BY             
                    ,SFDC_LAST_UPDATED_BY       
                    ,SYSTEM_MOD_STAMP    
                    ,LAST_ACTIVITY_DATE     
                    ,LAST_VIEWED_DATE     
                    ,LAST_REFERENCED_DATE 
                    ,COUNTRY                     
                    ,ZIP                         
                    ,STATUS                      
                    ,STATE                       
                    ,SPA                  
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
                     CHM_MSI_SPA_GEO_DETAILS_SEQ.NEXTVAL
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
                    ,TMP.COUNTRY                     
                    ,TMP.ZIP                         
                    ,TMP.STATUS                      
                    ,TMP.STATE                       
                    ,TMP.SPA                  
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
                    ,SFDC_LAST_UPDATE_DATE     = TMP.SFDC_LAST_UPDATE_DATE     
                    ,SFDC_CREATED_BY           = TMP.SFDC_CREATED_BY           
                    ,SFDC_LAST_UPDATED_BY      = TMP.SFDC_LAST_UPDATED_BY      
                    ,SYSTEM_MOD_STAMP          = TMP.SYSTEM_MOD_STAMP    
                    ,LAST_ACTIVITY_DATE        = TMP.LAST_ACTIVITY_DATE     
                    ,LAST_VIEWED_DATE          = TMP.LAST_VIEWED_DATE     
                    ,LAST_REFERENCED_DATE      = TMP.LAST_REFERENCED_DATE 
                    ,COUNTRY                   = TMP.COUNTRY                   
                    ,ZIP                       = TMP.ZIP                       
                    ,STATUS                    = TMP.STATUS                    
                    ,STATE                     = TMP.STATE                     
                    ,SPA                       = TMP.SPA                  
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
                AND TBL.ID                     = TMP.ID;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
            
            EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SPA_GEO_DETAILS(I).ID ||'-'     
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

    END MERGE_SPA_GEO_DETAILS_DATA;


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
             LAST_RUN_STATUS        = 'Success'
        WHERE LAST_RUN_ID = P_IN_OIC_INSTANCE_ID;
        COMMIT;
        
        OPEN P_OUT_DATA FOR
        SELECT NVL(TOTAL_SUCCESS_RECORDS,0) TOTAL_SUCCESS_RECORDS, NVL(TOTAL_ERROR_RECORDS,0) TOTAL_ERROR_RECORDS, NVL(TOTAL_FETCHED_RECORDS,0) TOTAL_FETCHED_RECORDS
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

END CHM_MSI_SPA_DIST_INSTALLER_PKG;