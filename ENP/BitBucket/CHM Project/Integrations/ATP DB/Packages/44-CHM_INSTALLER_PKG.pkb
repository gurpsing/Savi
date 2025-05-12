create or replace PACKAGE BODY CHM_INSTALLER_PKG
    
    /**************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                         *
    * Package Name                   : CHM_INSTALLER_PKG                                                                      *
    * Purpose                        : Package for CHM Installer Integrations                                                 *
    * Created By                     : Gurpreet Singh                                                                         *
    * Created Date                   : 30-Aug-2023                                                                            *     
    ***************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                  * 
    * -----------   ---------------------------    ---------------------------      -------------    -------------------------*
    * 30-Aug-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version           * 
    * 11-Sep-2024   Gurpreet Singh                 Transform Edge                   2.0              For Setting Merge Status *  
    * 25-Sep-2024   Gurpreet Singh                 Transform Edge                   3.0              Addition of new fields   *
    * 20-Nov-2024   Dhivagar                        Transform Edge                  3.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar 
    * 05-March-2025  Raja                                                           4.0             Adding New Field Bank_Details_Flag
    **************************************************************************************************************************/


AS

    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_ACCOUNT			        IN      TBL_ACCOUNT
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2     ----- V3.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
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
        FOR i IN P_IN_ACCOUNT.FIRST .. P_IN_ACCOUNT.LAST 
        LOOP
            L_COUNT := L_COUNT +2;
            L_CUSTOMER_KEY := P_IN_ACCOUNT(i).CUSTOMER_KEY;

            --INSTALLER ACCOUNT MERGE
            BEGIN

                SELECT  CHM_SFDC_ACCOUNT_MASTER_SEQ.NEXTVAL 
                INTO    L_CHM_ACCOUNT_ID 
                FROM    DUAL;

                L_SFDC_ACCOUNT_ID := P_IN_ACCOUNT(i).SFDC_ACCOUNT_ID;

                --Merge in CHM table
                MERGE INTO CHM_SFDC_ACCOUNT_MASTER tbl
                USING (
                    SELECT 
                         P_IN_ACCOUNT(i).SFDC_ACCOUNT_ID             SFDC_ACCOUNT_ID         
                        ,P_IN_ACCOUNT(i).ACCOUNT_NAME                ACCOUNT_NAME            
                        ,P_IN_ACCOUNT(i).ACCOUNT_STATUS              ACCOUNT_STATUS            
                        ,P_IN_ACCOUNT(i).CUSTOMER_KEY                CUSTOMER_KEY            
                        ,P_IN_ACCOUNT(i).ACCOUNT_TYPE                ACCOUNT_TYPE            
                        ,P_IN_ACCOUNT(i).ACCOUNT_OWNER               ACCOUNT_OWNER           
                        ,P_IN_ACCOUNT(i).ENLIGHTEN_INSTALLER_ID      ENLIGHTEN_INSTALLER_ID  
                        ,P_IN_ACCOUNT(i).PARENT_ACCOUNT              PARENT_ACCOUNT          
                        ,P_IN_ACCOUNT(i).PARENT_ACCOUNT_ID           PARENT_ACCOUNT_ID       
                        ,P_IN_ACCOUNT(i).ACCOUNT_RECORD_TYPE         ACCOUNT_RECORD_TYPE     
                        ,P_IN_ACCOUNT(i).ACCOUNT_OWNER_ALIAS         ACCOUNT_OWNER_ALIAS     
                        ,P_IN_ACCOUNT(i).GEOGRAPHY                   GEOGRAPHY               
                        ,P_IN_ACCOUNT(i).TERRITORY                   TERRITORY               
                        ,P_IN_ACCOUNT(i).SUB_TERRITORY               SUB_TERRITORY           
                        ,P_IN_ACCOUNT(i).ENLIGHTEN_COMPANY_ID        ENLIGHTEN_COMPANY_ID    
                        ,P_IN_ACCOUNT(i).ENLIGHTEN_INSTALLER_FLAG    ENLIGHTEN_INSTALLER_FLAG
                        ,P_IN_ACCOUNT(i).COUNTRY                     COUNTRY
                        ,P_IN_ACCOUNT(i).ACCOUNT_CURRENCY            ACCOUNT_CURRENCY
                        ,P_IN_ACCOUNT(i).ORACLE_CUSTOMER_NUMBER      ORACLE_CUSTOMER_NUMBER
                        ,P_IN_ACCOUNT(i).ACCOUNT_OWNER_ID            ACCOUNT_OWNER_ID
                        ,P_IN_ACCOUNT(i).RELATIONSHIP                RELATIONSHIP
                        ,P_IN_ACCOUNT(i).CI_SYNC_FLAG                CI_SYNC_FLAG
                        ,P_IN_ACCOUNT(i).REGION                      REGION
                        ,P_IN_ACCOUNT(i).APPROVAL_GEOGRAPHY          APPROVAL_GEOGRAPHY
                        ,P_IN_ACCOUNT(i).FORECASTABLE_ACCOUNT        FORECASTABLE_ACCOUNT
                        ,P_IN_ACCOUNT(i).CHM_C                       CHM_C                          --added for v3.0
                        ,P_IN_ACCOUNT(i).MERGE_ID_C                  MERGE_ID_C                     --added for v3.0
                        ,P_IN_ACCOUNT(i).ENLIGHTEN_COMPANY_DUP_KEY_C ENLIGHTEN_COMPANY_DUP_KEY_C    --added for v3.0
                        ,P_IN_ACCOUNT(i).SFDC_CREATED_BY             SFDC_CREATED_BY
                        ,P_IN_ACCOUNT(i).SFDC_CREATION_DATE          SFDC_CREATION_DATE
                        ,P_IN_ACCOUNT(i).SFDC_LAST_UPDATED_BY        SFDC_LAST_UPDATED_BY
                        ,P_IN_ACCOUNT(i).SFDC_LAST_UPDATE_DATE       SFDC_LAST_UPDATE_DATE
                        ,P_IN_ACCOUNT(i).CREATED_BY                  CREATED_BY
                        ,P_IN_ACCOUNT(i).CREATION_DATE               CREATION_DATE
                        ,P_IN_ACCOUNT(i).LAST_UPDATED_BY             LAST_UPDATED_BY
                        ,P_IN_ACCOUNT(i).LAST_UPDATE_DATE            LAST_UPDATE_DATE
						,P_IN_ACCOUNT(i).BANK_DETAILS_FLAG           BANK_DETAILS_FLAG                --added for v4.0
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
                        ,CHM_C                              --added for v3.0
                        ,MERGE_ID_C                         --added for v3.0
                        ,ENLIGHTEN_COMPANY_DUP_KEY_C        --added for v3.0
						,BANK_DETAILS_FLAG                  --added for v4.0
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
                        ,P_IN_OIC_INSTANCE_ID
                        ,tmp.RELATIONSHIP        
                        ,tmp.CI_SYNC_FLAG
                        ,tmp.REGION              
                        ,tmp.APPROVAL_GEOGRAPHY  
                        ,tmp.FORECASTABLE_ACCOUNT
                        ,tmp.CHM_C                              --added for v3.0
                        ,tmp.MERGE_ID_C                         --added for v3.0
                        ,tmp.ENLIGHTEN_COMPANY_DUP_KEY_C        --added for v3.0
						,tmp.BANK_DETAILS_FLAG                  --added for v4.0
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
                        ,ATTRIBUTE1			            = P_IN_OIC_INSTANCE_ID
                        ,RELATIONSHIP                   = tmp.RELATIONSHIP        
                        ,CI_SYNC_FLAG                   = tmp.CI_SYNC_FLAG
                        ,REGION                         = tmp.REGION              
                        ,APPROVAL_GEOGRAPHY             = tmp.APPROVAL_GEOGRAPHY  
                        ,FORECASTABLE_ACCOUNT           = tmp.FORECASTABLE_ACCOUNT
                        ,CHM_C                          = tmp.CHM_C                              --added for v3.0
                        ,MERGE_ID_C                     = tmp.MERGE_ID_C                         --added for v3.0
                        ,ENLIGHTEN_COMPANY_DUP_KEY_C    = tmp.ENLIGHTEN_COMPANY_DUP_KEY_C        --added for v3.0
						,BANK_DETAILS_FLAG              = tmp.BANK_DETAILS_FLAG                  --added for v4.0
                    WHERE	1=1
                    AND SFDC_ACCOUNT_ID                 = tmp.SFDC_ACCOUNT_ID;



                L_MERGE_COUNT:= L_MERGE_COUNT+2;


            --EXCEPTION             --commented for v2.0
            --WHEN OTHERS THEN      --commented for v2.0

                --BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||'Installer Account ['||L_SFDC_ACCOUNT_ID||']'||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;       --commented for v2.0
            END;

            COMMIT; --To commit Accounte Master Records

            --INSTALLER SITES MERGE FOR BILLING
            BEGIN


                --Merge in CHM table
                MERGE INTO CHM_SFDC_ACCOUNT_SITES tbl
                USING (
                    SELECT 
                         P_IN_ACCOUNT(i).SFDC_ACCOUNT_ID            SFDC_ACCOUNT_ID
                        ,(SELECT CHM_ACCOUNT_ID FROM CHM_SFDC_ACCOUNT_MASTER WHERE SFDC_ACCOUNT_ID = P_IN_ACCOUNT(i).SFDC_ACCOUNT_ID) CHM_ACCOUNT_ID
                        ,'BILLING'                                  SITE_USE_CODE
                        ,P_IN_ACCOUNT(i).BILLING_STREET             BILLING_STREET            
                        ,P_IN_ACCOUNT(i).BILLING_CITY               BILLING_CITY      
                        ,P_IN_ACCOUNT(i).BILLING_STATE              BILLING_STATE     
                        ,P_IN_ACCOUNT(i).BILLING_ZIP                BILLING_ZIP       
                        ,P_IN_ACCOUNT(i).SHIPPING_STREET            SHIPPING_STREET   
                        ,P_IN_ACCOUNT(i).SHIPPING_CITY              SHIPPING_CITY     
                        ,P_IN_ACCOUNT(i).SHIPPING_STATE             SHIPPING_STATE    
                        ,P_IN_ACCOUNT(i).SHIPPING_ZIP               SHIPPING_ZIP      
                        ,P_IN_ACCOUNT(i).COUNTRY                    COUNTRY
                        ,P_IN_ACCOUNT(i).BILLING_COUNTRY            BILLING_COUNTRY
                        ,P_IN_ACCOUNT(i).SHIPPING_COUNTRY           SHIPPING_COUNTRY
                        ,P_IN_ACCOUNT(i).SFDC_CREATED_BY            SFDC_CREATED_BY
                        ,P_IN_ACCOUNT(i).SFDC_CREATION_DATE         SFDC_CREATION_DATE
                        ,P_IN_ACCOUNT(i).SFDC_LAST_UPDATED_BY       SFDC_LAST_UPDATED_BY
                        ,P_IN_ACCOUNT(i).SFDC_LAST_UPDATE_DATE      SFDC_LAST_UPDATE_DATE
                        ,P_IN_ACCOUNT(i).CREATED_BY                 CREATED_BY
                        ,P_IN_ACCOUNT(i).CREATION_DATE              CREATION_DATE
                        ,P_IN_ACCOUNT(i).LAST_UPDATED_BY            LAST_UPDATED_BY
                        ,P_IN_ACCOUNT(i).LAST_UPDATE_DATE           LAST_UPDATE_DATE
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
                        ,P_IN_OIC_INSTANCE_ID 
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
                        ,ATTRIBUTE1     			    = P_IN_OIC_INSTANCE_ID
                    WHERE	1=1
                    AND     SFDC_ACCOUNT_ID             = tmp.SFDC_ACCOUNT_ID 
                    AND     SITE_USE_CODE               = tmp.SITE_USE_CODE;


            --EXCEPTION                     --commented for v2.0
            --WHEN OTHERS THEN              --commented for v2.0
                --BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||'Billing Installer Site ['||L_SFDC_ACCOUNT_ID||']'||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;      --commented for v2.0
            END;
            COMMIT;

            --INSTALLER SITES MERGE FOR SHIPPING
            BEGIN

                --Merge in CHM table
                MERGE INTO CHM_SFDC_ACCOUNT_SITES tbl
                USING (
                    SELECT 
                         P_IN_ACCOUNT(i).SFDC_ACCOUNT_ID            SFDC_ACCOUNT_ID
                        ,(SELECT CHM_ACCOUNT_ID FROM CHM_SFDC_ACCOUNT_MASTER WHERE SFDC_ACCOUNT_ID = P_IN_ACCOUNT(i).SFDC_ACCOUNT_ID) CHM_ACCOUNT_ID
                        ,'SHIPPING'                                 SITE_USE_CODE
                        ,P_IN_ACCOUNT(i).BILLING_STREET             BILLING_STREET            
                        ,P_IN_ACCOUNT(i).BILLING_CITY               BILLING_CITY      
                        ,P_IN_ACCOUNT(i).BILLING_STATE              BILLING_STATE     
                        ,P_IN_ACCOUNT(i).BILLING_ZIP                BILLING_ZIP       
                        ,P_IN_ACCOUNT(i).SHIPPING_STREET            SHIPPING_STREET   
                        ,P_IN_ACCOUNT(i).SHIPPING_CITY              SHIPPING_CITY     
                        ,P_IN_ACCOUNT(i).SHIPPING_STATE             SHIPPING_STATE    
                        ,P_IN_ACCOUNT(i).SHIPPING_ZIP               SHIPPING_ZIP      
                        ,P_IN_ACCOUNT(i).COUNTRY                    COUNTRY
                        ,P_IN_ACCOUNT(i).BILLING_COUNTRY            BILLING_COUNTRY
                        ,P_IN_ACCOUNT(i).SHIPPING_COUNTRY           SHIPPING_COUNTRY
                        ,P_IN_ACCOUNT(i).SFDC_CREATED_BY            SFDC_CREATED_BY
                        ,P_IN_ACCOUNT(i).SFDC_CREATION_DATE         SFDC_CREATION_DATE
                        ,P_IN_ACCOUNT(i).SFDC_LAST_UPDATED_BY       SFDC_LAST_UPDATED_BY
                        ,P_IN_ACCOUNT(i).SFDC_LAST_UPDATE_DATE      SFDC_LAST_UPDATE_DATE
                        ,P_IN_ACCOUNT(i).CREATED_BY                 CREATED_BY
                        ,P_IN_ACCOUNT(i).CREATION_DATE              CREATION_DATE
                        ,P_IN_ACCOUNT(i).LAST_UPDATED_BY            LAST_UPDATED_BY
                        ,P_IN_ACCOUNT(i).LAST_UPDATE_DATE           LAST_UPDATE_DATE
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
                        ,tmp.BILLING_STREET            
                        ,tmp.BILLING_STREET            
                        ,tmp.BILLING_CITY            
                        ,tmp.BILLING_STATE           
                        ,tmp.BILLING_ZIP  
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
                        ,P_IN_OIC_INSTANCE_ID 
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
                        ,SHIPPING_COUNTRY               = tmp.SHIPPING_COUNTRY   
                        ,SFDC_CREATED_BY                = tmp.SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE             = tmp.SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY           = tmp.SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE          = tmp.SFDC_LAST_UPDATE_DATE
                        ,LAST_UPDATED_BY			    = tmp.LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE			    = tmp.LAST_UPDATE_DATE
                        ,ATTRIBUTE1			            = P_IN_OIC_INSTANCE_ID
                    WHERE	1=1
                    AND     SFDC_ACCOUNT_ID             = tmp.SFDC_ACCOUNT_ID 
                    AND     SITE_USE_CODE               = tmp.SITE_USE_CODE;


            --EXCEPTION                 --commented for v2.0
            --WHEN OTHERS THEN          --commented for v2.0
                --BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||'Shipping Installer Site ['||L_SFDC_ACCOUNT_ID||']'||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;     --commented for v2.0
            END;
            COMMIT;

        END LOOP;

        P_OUT_RECORDS_FETCHED   := L_COUNT;
        P_OUT_RECORDS_MERGED    := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE     := substr(L_ERROR_MESSAGE,1,30000);

    END MERGE_DATA;


    /* Changes for v2.0 starts */

    --Procedure to merge data into CHM table
    PROCEDURE TRUNCATE_MASTER_KEY_TBL(
         P_IN_OIC_INSTANCE_ID            IN      VARCHAR2         ----- V3.1
        ,P_OUT_ERROR_MESSAGE             OUT     VARCHAR2
    )
    AS
        v_sql   VARCHAR2(4000) :='TRUNCATE TABLE CHM_SFDC_ACCOUNT_MASTER_KEYS';

    BEGIN    
        EXECUTE IMMEDIATE v_sql;
        P_OUT_ERROR_MESSAGE := 'Table truncated successfully';
        UPDATE CHM_INTEGRATION_RUNS
        SET  LAST_COMPLETED_STAGE       = 'Truncate Master Key table'
            ,LOG                        = LOG||' Master Key table truncated.'
            ,LAST_UPDATE_DATE           = SYSDATE
        WHERE   CHM_INTEGRATION_RUN_ID  = P_IN_OIC_INSTANCE_ID; 

        COMMIT;
    END TRUNCATE_MASTER_KEY_TBL;

    --Procedure to merge data into CHM table
    PROCEDURE MERGE_ACCOUNT_KEY_DATA(
         P_IN_ACCOUNT_KEYS			    IN      TBL_ACCOUNT_KEY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    )
    AS
    BEGIN
        --For each record in input table type merge the record
        FOR i IN P_IN_ACCOUNT_KEYS.FIRST .. P_IN_ACCOUNT_KEYS.LAST 
        LOOP
            --Merge in CHM table
                MERGE INTO CHM_SFDC_ACCOUNT_MASTER_KEYS tbl
                USING (
                    SELECT 
                         P_IN_ACCOUNT_KEYS(i).SFDC_ACCOUNT_ID             SFDC_ACCOUNT_ID
                        ,P_IN_ACCOUNT_KEYS(i).SFDC_CREATED_BY             SFDC_CREATED_BY
                        ,P_IN_ACCOUNT_KEYS(i).SFDC_CREATION_DATE          SFDC_CREATION_DATE
                        ,P_IN_ACCOUNT_KEYS(i).SFDC_LAST_UPDATED_BY        SFDC_LAST_UPDATED_BY
                        ,P_IN_ACCOUNT_KEYS(i).SFDC_LAST_UPDATE_DATE       SFDC_LAST_UPDATE_DATE
                        ,P_IN_ACCOUNT_KEYS(i).CREATED_BY                  CREATED_BY
                        ,P_IN_ACCOUNT_KEYS(i).CREATION_DATE               CREATION_DATE
                        ,P_IN_ACCOUNT_KEYS(i).LAST_UPDATED_BY             LAST_UPDATED_BY
                        ,P_IN_ACCOUNT_KEYS(i).LAST_UPDATE_DATE            LAST_UPDATE_DATE
                        ,P_IN_OIC_INSTANCE_ID                             OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON ( tbl.SFDC_ACCOUNT_ID = tmp.SFDC_ACCOUNT_ID )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SFDC_ACCOUNT_ID 
                        ,SFDC_CREATED_BY      
                        ,SFDC_CREATION_DATE   
                        ,SFDC_LAST_UPDATED_BY 
                        ,SFDC_LAST_UPDATE_DATE
                        ,CREATED_BY           
                        ,CREATION_DATE        
                        ,LAST_UPDATED_BY          
                        ,LAST_UPDATE_DATE         
                        ,OIC_INSTANCE_ID         
                    )
                    VALUES (
                         tmp.SFDC_ACCOUNT_ID         
                        ,tmp.SFDC_CREATED_BY        
                        ,tmp.SFDC_CREATION_DATE       
                        ,tmp.SFDC_LAST_UPDATED_BY   
                        ,tmp.SFDC_LAST_UPDATE_DATE  
                        ,tmp.CREATED_BY             
                        ,tmp.CREATION_DATE          
                        ,tmp.LAST_UPDATED_BY        
                        ,tmp.LAST_UPDATE_DATE       
                        ,tmp.OIC_INSTANCE_ID  
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         SFDC_CREATED_BY                = tmp.SFDC_CREATED_BY
                        ,SFDC_CREATION_DATE             = tmp.SFDC_CREATION_DATE
                        ,SFDC_LAST_UPDATED_BY           = tmp.SFDC_LAST_UPDATED_BY
                        ,SFDC_LAST_UPDATE_DATE          = tmp.SFDC_LAST_UPDATE_DATE
                        ,CREATED_BY                     = tmp.CREATED_BY
                        ,CREATION_DATE                  = tmp.CREATION_DATE
                        ,LAST_UPDATED_BY			    = tmp.LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE			    = tmp.LAST_UPDATE_DATE
                        ,OIC_INSTANCE_ID			    = tmp.OIC_INSTANCE_ID
                    WHERE	1=1
                    AND SFDC_ACCOUNT_ID                 = tmp.SFDC_ACCOUNT_ID;
                    COMMIT;
        END LOOP;

    END MERGE_ACCOUNT_KEY_DATA;

    --Procedure to setting Merged status
    PROCEDURE SET_MERGED_STATUS(
         P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_SYNCED_RECORDS           OUT     NUMBER
        ,P_OUT_MERGED_INSTALLERS        OUT     NUMBER
        ,P_OUT_UNIQUE_INSTALLERS        OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    )
    AS
        L_COUNT NUMBER;
    BEGIN
        UPDATE  CHM_SFDC_ACCOUNT_MASTER tbl
        SET     ACCOUNT_STATUS      = 'Inactive',
                ATTRIBUTE2          = SYSDATE,
                LAST_UPDATE_DATE    = SYSDATE
        WHERE NOT EXISTS (
            SELECT SFDC_ACCOUNT_ID 
            FROM CHM_SFDC_ACCOUNT_MASTER_KEYS tbl_keys 
            WHERE tbl.SFDC_ACCOUNT_ID = tbl_keys.SFDC_ACCOUNT_ID
        )
        AND account_status<>'Inactive';

        L_COUNT := SQL%ROWCOUNT;
        P_OUT_MERGED_INSTALLERS:=L_COUNT;

        SELECT  COUNT(*) INTO P_OUT_SYNCED_RECORDS
        FROM    CHM_SFDC_ACCOUNT_MASTER
        WHERE   ATTRIBUTE1  =   P_IN_OIC_INSTANCE_ID;

        SELECT  COUNT(*) INTO P_OUT_UNIQUE_INSTALLERS
        FROM    CHM_SFDC_ACCOUNT_MASTER_KEYS;

        UPDATE CHM_INTEGRATION_RUNS
        SET  LAST_COMPLETED_STAGE       = 'Installer Sync and Status Update'
            ,LOG                        = LOG||' Installer Keys sync completed and status updated for merged installer'
            ,LAST_UPDATE_DATE           = SYSDATE
        WHERE   CHM_INTEGRATION_RUN_ID  = P_IN_OIC_INSTANCE_ID; 

        COMMIT;

    END SET_MERGED_STATUS;

    /* Changes for v2.0 ends */

END CHM_INSTALLER_PKG;