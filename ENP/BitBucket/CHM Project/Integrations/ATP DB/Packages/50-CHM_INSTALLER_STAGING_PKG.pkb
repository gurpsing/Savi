create or replace PACKAGE BODY CHM_INSTALLER_STAGING_PKG
    
    /**************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                         *
    * Package Name                   : CHM_INSTALLER_STAGING_PKG                                                              *
    * Purpose                        : Package for loading installer data into CHM                                            *
    * Created By                     : Gurpreet Singh                                                                         *
    * Created Date                   : 22-Sep-2023                                                                            *     
    ***************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                  * 
    * -----------   ---------------------------    ---------------------------      -------------    -------------------------*
    * 22-Sep-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version           * 
    **************************************************************************************************************************/

AS

     --Procedure to load data into CHM table
    PROCEDURE LOAD_DATA(
         P_OUT_ERROR_MESSAGE          OUT     CLOB
        ,P_OUT_RECORDS_FETCHED        OUT     NUMBER
        ,P_OUT_RECORDS_MERGED         OUT     NUMBER
    )
    AS
       L_COUNT                  NUMBER :=0;
       L_MERGE_COUNT            NUMBER :=0;
       L_ERROR_MESSAGE          VARCHAR2(30000);
       L_CHM_ACCOUNT_ID         NUMBER;
       L_SFDC_ACCOUNT_ID        VARCHAR2(4000);
       L_CUSTOMER_KEY           VARCHAR2(250);
    BEGIN

        --For each record in input table type merge the record
        FOR rec IN (SELECT * FROM CHM_INSTALLER_STAGING where  sfdc_account_id <> '0013m00002Mq5RJAAZ') 
        LOOP
            L_COUNT := L_COUNT +2;
            L_CUSTOMER_KEY := rec.CUSTOMER_KEY;

            BEGIN

                SELECT  CHM_SFDC_ACCOUNT_MASTER_SEQ.NEXTVAL 
                INTO    L_CHM_ACCOUNT_ID 
                FROM    DUAL;

                L_SFDC_ACCOUNT_ID := rec.SFDC_ACCOUNT_ID;

                --Merge in CHM table
                MERGE INTO CHM_SFDC_ACCOUNT_MASTER tbl
                USING (
                    SELECT 
                         rec.SFDC_ACCOUNT_ID             SFDC_ACCOUNT_ID         
                        ,rec.ACCOUNT_NAME                ACCOUNT_NAME            
                        ,rec.ACCOUNT_STATUS              ACCOUNT_STATUS            
                        ,rec.CUSTOMER_KEY                CUSTOMER_KEY            
                        ,rec.ACCOUNT_TYPE                ACCOUNT_TYPE            
                        ,rec.ACCOUNT_OWNER               ACCOUNT_OWNER           
                        ,rec.ENLIGHTEN_INSTALLER_ID      ENLIGHTEN_INSTALLER_ID  
                        ,rec.PARENT_ACCOUNT              PARENT_ACCOUNT          
                        ,rec.PARENT_ACCOUNT_ID           PARENT_ACCOUNT_ID       
                        ,rec.ACCOUNT_RECORD_TYPE         ACCOUNT_RECORD_TYPE     
                        ,rec.ACCOUNT_OWNER_ALIAS         ACCOUNT_OWNER_ALIAS     
                        ,rec.GEOGRAPHY                   GEOGRAPHY               
                        ,rec.TERRITORY                   TERRITORY               
                        ,rec.SUB_TERRITORY               SUB_TERRITORY           
                        ,rec.ENLIGHTEN_COMPANY_ID        ENLIGHTEN_COMPANY_ID    
                        ,rec.ENLIGHTEN_INSTALLER_FLAG    ENLIGHTEN_INSTALLER_FLAG
                        ,rec.COUNTRY                     COUNTRY
                        ,rec.ACCOUNT_CURRENCY            ACCOUNT_CURRENCY
                        ,rec.ORACLE_CUSTOMER_NUMBER      ORACLE_CUSTOMER_NUMBER
                        ,rec.ACCOUNT_OWNER_ID            ACCOUNT_OWNER_ID
                        ,rec.RELATIONSHIP                RELATIONSHIP
                        ,rec.CI_SYNC_FLAG                CI_SYNC_FLAG
                        ,rec.REGION                      REGION
                        ,rec.APPROVAL_GEOGRAPHY          APPROVAL_GEOGRAPHY
                        ,rec.FORECASTABLE_ACCOUNT        FORECASTABLE_ACCOUNT
                        ,rec.SFDC_CREATED_BY             SFDC_CREATED_BY
                        ,TO_TIMESTAMP_TZ(to_timestamp(rec.SFDC_CREATION_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SFDC_CREATION_DATE
                        ,rec.SFDC_LAST_UPDATED_BY        SFDC_LAST_UPDATED_BY
                        ,TO_TIMESTAMP_TZ(to_timestamp(rec.SFDC_LAST_UPDATE_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SFDC_LAST_UPDATE_DATE
                        ,'DATA_LOAD'                     CREATED_BY
                        ,sysdate                         CREATION_DATE
                        ,'DATA_LOAD'                     LAST_UPDATED_BY
                        ,sysdate                         LAST_UPDATE_DATE
                    FROM DUAL
                ) tmp
                ON ( tbl.SFDC_ACCOUNT_ID = tmp.SFDC_ACCOUNT_ID )
                WHEN NOT MATCHED THEN
                    INSERT (
                         CHM_ACCOUNT_ID
                        ,SFDC_ACCOUNT_ID         
                        ,ACCOUNT_NAME            
                        ,ACCOUNT_STATUS            
                        ,CUSTOMER_KEY            
                        ,ACCOUNT_TYPE            
                        ,ACCOUNT_OWNER           
                        ,ENLIGHTEN_INSTALLER_ID  
                        ,PARENT_ACCOUNT          
                        ,PARENT_ACCOUNT_ID       
                        ,ACCOUNT_RECORD_TYPE     
                        ,ACCOUNT_OWNER_ALIAS     
                        ,GEOGRAPHY               
                        ,TERRITORY               
                        ,SUB_TERRITORY           
                        ,ENLIGHTEN_COMPANY_ID    
                        ,ENLIGHTEN_INSTALLER_FLAG
                        ,COUNTRY
                        ,ACCOUNT_CURRENCY
                        ,ORACLE_CUSTOMER_NUMBER
                        ,ACCOUNT_OWNER_ID
                        ,SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        ,ATTRIBUTE1
                        ,RELATIONSHIP        
                        ,CI_SYNC_FLAG        
                        ,REGION              
                        ,APPROVAL_GEOGRAPHY  
                        ,FORECASTABLE_ACCOUNT
                    )
                    VALUES (
                         L_CHM_ACCOUNT_ID
                        ,tmp.SFDC_ACCOUNT_ID         
                        ,tmp.ACCOUNT_NAME            
                        ,tmp.ACCOUNT_STATUS            
                        ,tmp.CUSTOMER_KEY            
                        ,tmp.ACCOUNT_TYPE            
                        ,tmp.ACCOUNT_OWNER           
                        ,tmp.ENLIGHTEN_INSTALLER_ID  
                        ,tmp.PARENT_ACCOUNT          
                        ,tmp.PARENT_ACCOUNT_ID       
                        ,tmp.ACCOUNT_RECORD_TYPE     
                        ,tmp.ACCOUNT_OWNER_ALIAS     
                        ,tmp.GEOGRAPHY               
                        ,tmp.TERRITORY               
                        ,tmp.SUB_TERRITORY           
                        ,tmp.ENLIGHTEN_COMPANY_ID    
                        ,tmp.ENLIGHTEN_INSTALLER_FLAG
                        ,tmp.COUNTRY
                        ,tmp.ACCOUNT_CURRENCY
                        ,tmp.ORACLE_CUSTOMER_NUMBER
                        ,tmp.ACCOUNT_OWNER_ID
                        ,tmp.SFDC_CREATED_BY
                        ,tmp.SFDC_CREATION_DATE
                        ,tmp.SFDC_LAST_UPDATED_BY
                        ,tmp.SFDC_LAST_UPDATE_DATE
                        ,tmp.CREATED_BY        
                        ,tmp.CREATION_DATE    
                        ,tmp.LAST_UPDATED_BY  
                        ,tmp.LAST_UPDATE_DATE
                        ,'0'
                        ,tmp.RELATIONSHIP        
                        ,tmp.CI_SYNC_FLAG
                        ,tmp.REGION              
                        ,tmp.APPROVAL_GEOGRAPHY  
                        ,tmp.FORECASTABLE_ACCOUNT
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         ACCOUNT_NAME                   = tmp.ACCOUNT_NAME            
                        ,ACCOUNT_STATUS                 = tmp.ACCOUNT_STATUS            
                        ,ACCOUNT_TYPE                   = tmp.ACCOUNT_TYPE            
                        ,ACCOUNT_OWNER                  = tmp.ACCOUNT_OWNER           
                        ,ENLIGHTEN_INSTALLER_ID         = tmp.ENLIGHTEN_INSTALLER_ID  
                        ,PARENT_ACCOUNT                 = tmp.PARENT_ACCOUNT          
                        ,PARENT_ACCOUNT_ID              = tmp.PARENT_ACCOUNT_ID       
                        ,ACCOUNT_RECORD_TYPE            = tmp.ACCOUNT_RECORD_TYPE     
                        ,ACCOUNT_OWNER_ALIAS            = tmp.ACCOUNT_OWNER_ALIAS     
                        ,GEOGRAPHY                      = tmp.GEOGRAPHY               
                        ,TERRITORY                      = tmp.TERRITORY               
                        ,SUB_TERRITORY                  = tmp.SUB_TERRITORY           
                        ,ENLIGHTEN_COMPANY_ID           = tmp.ENLIGHTEN_COMPANY_ID    
                        ,ENLIGHTEN_INSTALLER_FLAG       = tmp.ENLIGHTEN_INSTALLER_FLAG
                        ,COUNTRY                        = tmp.COUNTRY
                        ,ACCOUNT_CURRENCY               = tmp.ACCOUNT_CURRENCY
                        ,ORACLE_CUSTOMER_NUMBER         = tmp.ORACLE_CUSTOMER_NUMBER
                        ,ACCOUNT_OWNER_ID               = tmp.ACCOUNT_OWNER_ID
                        ,SFDC_CREATED_BY                = tmp.SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE             = tmp.SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY           = tmp.SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE          = tmp.SFDC_LAST_UPDATE_DATE
                        ,LAST_UPDATED_BY			    = tmp.LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE			    = tmp.LAST_UPDATE_DATE
                        ,ATTRIBUTE1			            = '0'
                        ,RELATIONSHIP                   = tmp.RELATIONSHIP        
                        ,CI_SYNC_FLAG                   = tmp.CI_SYNC_FLAG
                        ,REGION                         = tmp.REGION              
                        ,APPROVAL_GEOGRAPHY             = tmp.APPROVAL_GEOGRAPHY  
                        ,FORECASTABLE_ACCOUNT           = tmp.FORECASTABLE_ACCOUNT
                    WHERE	1=1
                    AND SFDC_ACCOUNT_ID                 = tmp.SFDC_ACCOUNT_ID;

                L_MERGE_COUNT:= L_MERGE_COUNT+2;


            EXCEPTION
            WHEN OTHERS THEN 

                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||'Installer Account ['||L_SFDC_ACCOUNT_ID||']'||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;

            COMMIT; --To commit Accounte Master Records

            --INSTALLER SITES MERGE FOR BILLING
            BEGIN


                --Merge in CHM table
                MERGE INTO CHM_SFDC_ACCOUNT_SITES tbl
                USING (
                    SELECT 
                         rec.SFDC_ACCOUNT_ID            SFDC_ACCOUNT_ID
                        ,(SELECT CHM_ACCOUNT_ID FROM CHM_SFDC_ACCOUNT_MASTER WHERE SFDC_ACCOUNT_ID = rec.SFDC_ACCOUNT_ID) CHM_ACCOUNT_ID
                        ,'BILLING'                      SITE_USE_CODE
                        ,rec.BILLING_STREET             BILLING_STREET            
                        ,rec.BILLING_CITY               BILLING_CITY      
                        ,rec.BILLING_STATE              BILLING_STATE     
                        ,rec.BILLING_POSTAL_CODE        BILLING_ZIP       
                        ,rec.SHIPPING_STREET            SHIPPING_STREET   
                        ,rec.SHIPPING_CITY              SHIPPING_CITY     
                        ,rec.SHIPPING_STATE             SHIPPING_STATE    
                        ,rec.SHIPPING_POSTAL_CODE       SHIPPING_ZIP      
                        ,rec.COUNTRY                    COUNTRY
                        ,rec.BILLING_COUNTRY            BILLING_COUNTRY
                        ,rec.SHIPPING_COUNTRY           SHIPPING_COUNTRY
                        ,rec.SFDC_CREATED_BY             SFDC_CREATED_BY
                        ,TO_TIMESTAMP_TZ(to_timestamp(rec.SFDC_CREATION_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SFDC_CREATION_DATE
                        ,rec.SFDC_LAST_UPDATED_BY        SFDC_LAST_UPDATED_BY
                        ,TO_TIMESTAMP_TZ(to_timestamp(rec.SFDC_LAST_UPDATE_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SFDC_LAST_UPDATE_DATE
                        ,'DATA_LOAD'                    CREATED_BY
                        ,sysdate                        CREATION_DATE
                        ,'DATA_LOAD'                    LAST_UPDATED_BY
                        ,sysdate                        LAST_UPDATE_DATE
                    FROM DUAL
                ) tmp
                ON ( tbl.SFDC_ACCOUNT_ID = tmp.SFDC_ACCOUNT_ID AND tbl.SITE_USE_CODE = tmp.SITE_USE_CODE)
                WHEN NOT MATCHED THEN
                    INSERT (
                         CHM_ACCOUNT_SITE_ID
                        ,SFDC_ACCOUNT_ID         
                        ,CHM_ACCOUNT_ID         
                        ,SITE_USE_CODE            
                        ,ADDRESS1            
                        ,ADDRESS2            
                        ,CITY           
                        ,STATE  
                        ,ZIP          
                        ,COUNTRY       
                        ,BILLING_COUNTRY       
                        ,SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        ,ATTRIBUTE1
                    )
                    VALUES (
                         CHM_SFDC_ACCOUNT_SITES_SEQ.NEXTVAL
                        ,tmp.SFDC_ACCOUNT_ID
                        ,tmp.CHM_ACCOUNT_ID
                        ,tmp.SITE_USE_CODE
                        ,tmp.BILLING_STREET            
                        ,tmp.BILLING_STREET            
                        ,tmp.BILLING_CITY            
                        ,tmp.BILLING_STATE           
                        ,tmp.BILLING_ZIP  
                        ,tmp.COUNTRY          
                        ,tmp.BILLING_COUNTRY          
                        ,tmp.SFDC_CREATED_BY
                        ,tmp.SFDC_CREATION_DATE
                        ,tmp.SFDC_LAST_UPDATED_BY
                        ,tmp.SFDC_LAST_UPDATE_DATE
                        ,tmp.CREATED_BY        
                        ,tmp.CREATION_DATE    
                        ,tmp.LAST_UPDATED_BY  
                        ,tmp.LAST_UPDATE_DATE 
                        ,'0' 
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         CHM_ACCOUNT_ID                 = tmp.CHM_ACCOUNT_ID  
                        ,ADDRESS1                       = tmp.BILLING_STREET  
                        ,ADDRESS2                       = tmp.BILLING_STREET  
                        ,CITY                           = tmp.BILLING_CITY      
                        ,STATE                          = tmp.BILLING_STATE   
                        ,ZIP                            = tmp.BILLING_ZIP       
                        ,COUNTRY                        = tmp.COUNTRY   
                        ,BILLING_COUNTRY                = tmp.BILLING_COUNTRY   
                        ,SFDC_CREATED_BY                = tmp.SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE             = tmp.SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY           = tmp.SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE          = tmp.SFDC_LAST_UPDATE_DATE
                        ,LAST_UPDATED_BY			    = tmp.LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE			    = tmp.LAST_UPDATE_DATE
                        ,ATTRIBUTE1     			    = '0'
                    WHERE	1=1
                    AND     SFDC_ACCOUNT_ID             = tmp.SFDC_ACCOUNT_ID 
                    AND     SITE_USE_CODE               = tmp.SITE_USE_CODE;


            EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||'Billing Installer Site ['||L_SFDC_ACCOUNT_ID||']'||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;

            --INSTALLER SITES MERGE FOR SHIPPING
            BEGIN

                --Merge in CHM table
                MERGE INTO CHM_SFDC_ACCOUNT_SITES tbl
                USING (
                    SELECT 
                         rec.SFDC_ACCOUNT_ID            SFDC_ACCOUNT_ID
                        ,(SELECT CHM_ACCOUNT_ID FROM CHM_SFDC_ACCOUNT_MASTER WHERE SFDC_ACCOUNT_ID = rec.SFDC_ACCOUNT_ID) CHM_ACCOUNT_ID
                        ,'SHIPPING'                     SITE_USE_CODE
                        ,rec.BILLING_STREET             BILLING_STREET            
                        ,rec.BILLING_CITY               BILLING_CITY      
                        ,rec.BILLING_STATE              BILLING_STATE     
                        ,rec.BILLING_POSTAL_CODE        BILLING_ZIP       
                        ,rec.SHIPPING_STREET            SHIPPING_STREET   
                        ,rec.SHIPPING_CITY              SHIPPING_CITY     
                        ,rec.SHIPPING_STATE             SHIPPING_STATE    
                        ,rec.SHIPPING_POSTAL_CODE       SHIPPING_ZIP      
                        ,rec.COUNTRY                    COUNTRY
                        ,rec.BILLING_COUNTRY            BILLING_COUNTRY
                        ,rec.SHIPPING_COUNTRY           SHIPPING_COUNTRY
                        ,rec.SFDC_CREATED_BY             SFDC_CREATED_BY
                        ,TO_TIMESTAMP_TZ(to_timestamp(rec.SFDC_CREATION_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SFDC_CREATION_DATE
                        ,rec.SFDC_LAST_UPDATED_BY        SFDC_LAST_UPDATED_BY
                        ,TO_TIMESTAMP_TZ(to_timestamp(rec.SFDC_LAST_UPDATE_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SFDC_LAST_UPDATE_DATE
                        ,'DATA_LOAD'                    CREATED_BY
                        ,sysdate                        CREATION_DATE
                        ,'DATA_LOAD'                    LAST_UPDATED_BY
                        ,sysdate                        LAST_UPDATE_DATE
                    FROM DUAL
                ) tmp
                ON ( tbl.SFDC_ACCOUNT_ID = tmp.SFDC_ACCOUNT_ID AND tbl.SITE_USE_CODE = tmp.SITE_USE_CODE)
                WHEN NOT MATCHED THEN
                    INSERT (
                         CHM_ACCOUNT_SITE_ID
                        ,SFDC_ACCOUNT_ID         
                        ,CHM_ACCOUNT_ID         
                        ,SITE_USE_CODE            
                        ,ADDRESS1            
                        ,ADDRESS2            
                        ,CITY           
                        ,STATE  
                        ,ZIP          
                        ,COUNTRY       
                        ,SHIPPING_COUNTRY       
                        ,SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        ,ATTRIBUTE1
                    )
                    VALUES (
                         CHM_SFDC_ACCOUNT_SITES_SEQ.NEXTVAL
                        ,tmp.SFDC_ACCOUNT_ID
                        ,tmp.CHM_ACCOUNT_ID
                        ,tmp.SITE_USE_CODE
                        ,tmp.SHIPPING_STREET            
                        ,tmp.SHIPPING_STREET            
                        ,tmp.SHIPPING_CITY            
                        ,tmp.SHIPPING_STATE           
                        ,tmp.SHIPPING_ZIP  
                        ,tmp.COUNTRY          
                        ,tmp.SHIPPING_COUNTRY          
                        ,tmp.SFDC_CREATED_BY
                        ,tmp.SFDC_CREATION_DATE
                        ,tmp.SFDC_LAST_UPDATED_BY
                        ,tmp.SFDC_LAST_UPDATE_DATE
                        ,tmp.CREATED_BY        
                        ,tmp.CREATION_DATE    
                        ,tmp.LAST_UPDATED_BY  
                        ,tmp.LAST_UPDATE_DATE 
                        ,'0' 
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         CHM_ACCOUNT_ID                 = tmp.CHM_ACCOUNT_ID  
                        ,ADDRESS1                       = tmp.SHIPPING_STREET  
                        ,ADDRESS2                       = tmp.SHIPPING_STREET  
                        ,CITY                           = tmp.SHIPPING_CITY      
                        ,STATE                          = tmp.SHIPPING_STATE   
                        ,ZIP                            = tmp.SHIPPING_ZIP       
                        ,COUNTRY                        = tmp.COUNTRY   
                        ,SHIPPING_COUNTRY               = tmp.SHIPPING_COUNTRY   
                        ,SFDC_CREATED_BY                = tmp.SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE             = tmp.SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY           = tmp.SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE          = tmp.SFDC_LAST_UPDATE_DATE
                        ,LAST_UPDATED_BY			    = tmp.LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE			    = tmp.LAST_UPDATE_DATE
                        ,ATTRIBUTE1			            = '0'
                    WHERE	1=1
                    AND     SFDC_ACCOUNT_ID             = tmp.SFDC_ACCOUNT_ID 
                    AND     SITE_USE_CODE               = tmp.SITE_USE_CODE;


            EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||'Shipping Installer Site ['||L_SFDC_ACCOUNT_ID||']'||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;

        END LOOP;

        P_OUT_RECORDS_FETCHED   := L_COUNT;
        P_OUT_RECORDS_MERGED    := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE     := substr(L_ERROR_MESSAGE,1,30000);

    END LOAD_DATA;

END CHM_INSTALLER_STAGING_PKG;
/
