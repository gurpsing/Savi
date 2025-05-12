create or replace PACKAGE BODY CHM_SPA_STAGING_PKG
    
    /**************************************************************************************************************************
    * TYPE                           : PL/SQL PACKAGE                                                                         *
    * PACKAGE NAME                   : CHM_SPA_STAGING_PKG                                                                    *
    * PURPOSE                        : Package for loading SPA data into CHM                                                  *
    * CREATED BY                     : Gurpreet Singh                                                                         *
    * CREATED DATE                   : 25-Sep-2023                                                                            *     
    ***************************************************************************************************************************
    * DATE          BY                             COMPANY NAME                     VERSION          DETAILS                  * 
    * -----------   ---------------------------    ---------------------------      -------------    -------------------------*
    * 25-Sep-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version           *
    **************************************************************************************************************************/
AS

    --Procedure to load data into CHM table
    PROCEDURE LOAD_DATA(
         P_OUT_ERROR_MESSAGE          OUT     CLOB
        ,P_OUT_RECORDS_FETCHED        OUT     NUMBER
        ,P_OUT_RECORDS_MERGED         OUT     NUMBER
    ) AS

        L_COUNT                     NUMBER := 0;
        L_IN_OIC_INSTANCE_ID        NUMBER := -1;
        L_MERGE_COUNT               NUMBER := 0;
        L_ERROR_MESSAGE             VARCHAR2(30000);
        L_CHM_SPA_ID                NUMBER;
        L_CHM_SPA_LINE_ID           NUMBER;
        L_SPA_NUMBER                VARCHAR2(4000); 
        L_LINE_NUMBER               VARCHAR2(4000); 
    BEGIN

        -------------------------------------------------------------------------------------
        --SPA HEADER
        -------------------------------------------------------------------------------------
        FOR hdr IN (SELECT DISTINCT ID ,SPA_NUMBER ,SPA_NAME ,OPPORTUNITY_NAME ,OPPORTUNITY_OWNER ,OPPORTUNITY_OWNER_ID ,SPA_OPPORTUNITY_ID   ,INSTALLER_ACCOUNT_NAME     ,ACCOUNT_ID ,INSTALLER_CUSTOMER_KEY     ,GEOGRAPHY  ,STAGE    ,STATUS  ,SPECIAL_PRICING_TYPE ,DEAL_CATEGORY ,QUOTE_TO_BUY_BUDGETARY ,SPA_BACK_DATED ,NEW_RENEWAL ,DISTRIBUTOR_ACCOUNT_NAME ,DISTRIBUTOR_SFDC_ID  ,DISTRIBUTOR_SFDC_CUSTOMER_KEY ,SPA_START_DATE ,SPA_EXPIRATION_DATE  ,SPA_CREATED_DATE ,SPA_LAST_UPDATE_DATE ,SPA_CREATED_BY ,SPA_LAST_UPDATED_BY  ,FINAL_APPROVAL_TIME  ,SPA_TOTAL_PRICE  ,SPA_TOTAL_PRICE_CURRENCY  ,DEAL_LOGISTICS ,DISTRIBUTOR_ORACLE_ACCOUNT_ID FROM CHM_SPA_STAGING)
        LOOP
            L_SPA_NUMBER:= hdr.SPA_NUMBER ;
            BEGIN
                SELECT
                    CHM_SPA_HEADER_S.NEXTVAL
                INTO L_CHM_SPA_ID
                FROM
                    DUAL;

                MERGE INTO CHM_SPA_HEADER TBL
                USING (
                    SELECT 
                         hdr.ID                                                     ID    
                        ,hdr.SPA_NUMBER                                             SPA_NUMBER        
                        ,hdr.SPA_NAME                                               SPA_NAME   
                        ,hdr.OPPORTUNITY_NAME                                       OPPORTUNITY_NAME   
                        ,hdr.OPPORTUNITY_OWNER                                      OPPORTUNITY_OWNER   
                        ,hdr.OPPORTUNITY_OWNER_ID                                   OPPORTUNITY_OWNER_ID   
                        ,hdr.SPA_OPPORTUNITY_ID                                     SPA_OPPORTUNITY_ID   
                        ,hdr.INSTALLER_ACCOUNT_NAME                                 INSTALLER_ACCOUNT_NAME   
                        ,hdr.ACCOUNT_ID                                             ACCOUNT_ID   
                        ,hdr.INSTALLER_CUSTOMER_KEY                                 INSTALLER_CUSTOMER_KEY   
                        ,hdr.GEOGRAPHY                                              GEOGRAPHY   
                        ,hdr.STAGE                                                  STAGE   
                        ,hdr.STATUS                                                 STATUS   
                        ,hdr.SPECIAL_PRICING_TYPE                                   SPECIAL_PRICING_TYPE   
                        ,hdr.DEAL_CATEGORY                                          DEAL_CATEGORY   
                        ,hdr.SPA_BACK_DATED                                         SPA_BACK_DATED   
                        ,hdr.NEW_RENEWAL                                            NEW_RENEWAL   
                        ,hdr.DISTRIBUTOR_ACCOUNT_NAME                               DISTRIBUTOR_ACCOUNT_NAME         
                        ,hdr.DISTRIBUTOR_SFDC_ID                                    DISTRIBUTOR_SFDC_ID              
                        ,hdr.DISTRIBUTOR_SFDC_CUSTOMER_KEY                          DISTRIBUTOR_SFDC_CUSTOMER_KEY    
                        ,to_date(hdr.SPA_START_DATE,'DD-MM-YYYY')                   SPA_START_DATE                   
                        ,to_date(hdr.SPA_EXPIRATION_DATE ,'DD-MM-YYYY')             SPA_EXPIRATION_DATE
                        ,TO_TIMESTAMP_TZ(to_timestamp(hdr.SPA_CREATED_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SPA_CREATED_DATE
                        ,TO_TIMESTAMP_TZ(to_timestamp(hdr.SPA_LAST_UPDATE_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SPA_LAST_UPDATE_DATE
                        ,hdr.SPA_CREATED_BY                                         SPA_CREATED_BY                   
                        ,hdr.SPA_LAST_UPDATED_BY                                    SPA_LAST_UPDATED_BY              
                        ,DECODE (hdr.FINAL_APPROVAL_TIME, null,null, TO_TIMESTAMP_TZ(to_timestamp(hdr.FINAL_APPROVAL_TIME , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR')) FINAL_APPROVAL_TIME
                        ,hdr.SPA_TOTAL_PRICE                                        SPA_TOTAL_PRICE                  
                        ,hdr.SPA_TOTAL_PRICE_CURRENCY                               SPA_TOTAL_PRICE_CURRENCY         
                        ,hdr.DEAL_LOGISTICS                                         DEAL_LOGISTICS                   
                        ,hdr.DISTRIBUTOR_ORACLE_ACCOUNT_ID                          DISTRIBUTOR_ORACLE_ACCOUNT_ID    
                    FROM
                        DUAL
                ) TMP ON ( TBL.SPA_NUMBER = TMP.SPA_NUMBER )
                WHEN NOT MATCHED THEN
                INSERT (
                     CHM_SPA_ID
                    ,ID 
                    ,SPA_NUMBER
                    ,SPA_NAME
                    ,OPPORTUNITY_NAME
                    ,OPPORTUNITY_OWNER
                    ,OPPORTUNITY_OWNER_ID
                    ,SPA_OPPORTUNITY_ID
                    ,INSTALLER_ACCOUNT_NAME
                    ,ACCOUNT_ID
                    ,INSTALLER_CUSTOMER_KEY
                    ,GEOGRAPHY
                    ,STAGE
                    ,STATUS
                    ,SPECIAL_PRICING_TYPE
                    ,SPA_TYPE
                    ,DEAL_CATEGORY
                    ,SPA_BACK_DATED
                    ,NEW_RENEWAL
                    ,DISTRIBUTOR_ACCOUNT_NAME          
                    ,DISTRIBUTOR_SFDC_ID               
                    ,DISTRIBUTOR_SFDC_CUSTOMER_KEY     
                    ,SPA_START_DATE                    
                    ,SPA_EXPIRATION_DATE                   
                    ,SPA_CREATED_DATE                  
                    ,SPA_LAST_UPDATE_DATE              
                    ,SPA_CREATED_BY                    
                    ,SPA_LAST_UPDATED_BY               
                    ,FINAL_APPROVAL_TIME               
                    ,SPA_FINAL_APPROVAL_DATE_TIME               
                    ,SPA_TOTAL_PRICE                   
                    ,SPA_TOTAL_PRICE_CURRENCY                      
                    ,DEAL_LOGISTICS                    
                    ,DISTRIBUTOR_ORACLE_ACCOUNT_ID  
                    ,CREATED_BY  
                    ,CREATION_DATE  
                    ,LAST_UPDATED_BY  
                    ,LAST_UPDATE_DATE  
                    ,ATTRIBUTE1
                    )
                VALUES(   
                         L_CHM_SPA_ID
                        ,tmp.ID        
                        ,tmp.SPA_NUMBER            
                        ,tmp.SPA_NAME       
                        ,tmp.OPPORTUNITY_NAME       
                        ,tmp.OPPORTUNITY_OWNER       
                        ,tmp.OPPORTUNITY_OWNER_ID       
                        ,tmp.SPA_OPPORTUNITY_ID       
                        ,tmp.INSTALLER_ACCOUNT_NAME       
                        ,tmp.ACCOUNT_ID       
                        ,tmp.INSTALLER_CUSTOMER_KEY       
                        ,tmp.GEOGRAPHY       
                        ,tmp.STAGE       
                        ,tmp.STATUS       
                        ,tmp.SPECIAL_PRICING_TYPE       
                        ,tmp.SPECIAL_PRICING_TYPE       
                        ,tmp.DEAL_CATEGORY       
                        ,tmp.SPA_BACK_DATED       
                        ,tmp.NEW_RENEWAL       
                        ,tmp.DISTRIBUTOR_ACCOUNT_NAME            
                        ,tmp.DISTRIBUTOR_SFDC_ID                 
                        ,tmp.DISTRIBUTOR_SFDC_CUSTOMER_KEY       
                        ,tmp.SPA_START_DATE                      
                        ,tmp.SPA_EXPIRATION_DATE                 
                        ,tmp.SPA_CREATED_DATE                    
                        ,tmp.SPA_LAST_UPDATE_DATE                
                        ,tmp.SPA_CREATED_BY                      
                        ,tmp.SPA_LAST_UPDATED_BY                 
                        ,tmp.FINAL_APPROVAL_TIME                 
                        ,tmp.FINAL_APPROVAL_TIME                 
                        ,tmp.SPA_TOTAL_PRICE                     
                        ,tmp.SPA_TOTAL_PRICE_CURRENCY            
                        ,tmp.DEAL_LOGISTICS                      
                        ,tmp.DISTRIBUTOR_ORACLE_ACCOUNT_ID       
                        ,'DATA_LOAD'       
                        ,SYSDATE       
                        ,'DATA_LOAD'       
                        ,SYSDATE       
                        ,L_IN_OIC_INSTANCE_ID
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     ID                                                = tmp.ID        
                    ,SPA_NAME                                          = tmp.SPA_NAME       
                    ,OPPORTUNITY_NAME                                  = tmp.OPPORTUNITY_NAME       
                    ,OPPORTUNITY_OWNER                                 = tmp.OPPORTUNITY_OWNER       
                    ,OPPORTUNITY_OWNER_ID                              = tmp.OPPORTUNITY_OWNER_ID       
                    ,SPA_OPPORTUNITY_ID                                = tmp.SPA_OPPORTUNITY_ID       
                    ,INSTALLER_ACCOUNT_NAME                            = tmp.INSTALLER_ACCOUNT_NAME       
                    ,ACCOUNT_ID                                        = tmp.ACCOUNT_ID       
                    ,INSTALLER_CUSTOMER_KEY                            = tmp.INSTALLER_CUSTOMER_KEY       
                    ,GEOGRAPHY                                         = tmp.GEOGRAPHY       
                    ,STAGE                                             = tmp.STAGE       
                    ,STATUS                                            = tmp.STATUS       
                    ,SPECIAL_PRICING_TYPE                              = tmp.SPECIAL_PRICING_TYPE       
                    ,SPA_TYPE                                          = tmp.SPECIAL_PRICING_TYPE       
                    ,DEAL_CATEGORY                                     = tmp.DEAL_CATEGORY       
                    ,SPA_BACK_DATED                                    = tmp.SPA_BACK_DATED       
                    ,NEW_RENEWAL                                       = tmp.NEW_RENEWAL       
                    ,DISTRIBUTOR_ACCOUNT_NAME                          = tmp.DISTRIBUTOR_ACCOUNT_NAME        
                    ,DISTRIBUTOR_SFDC_ID                               = tmp.DISTRIBUTOR_SFDC_ID             
                    ,DISTRIBUTOR_SFDC_CUSTOMER_KEY                     = tmp.DISTRIBUTOR_SFDC_CUSTOMER_KEY   
                    ,SPA_START_DATE                                    = tmp.SPA_START_DATE                  
                    ,SPA_EXPIRATION_DATE                               = tmp.SPA_EXPIRATION_DATE             
                    ,SPA_CREATED_DATE                                  = tmp.SPA_CREATED_DATE                
                    ,SPA_LAST_UPDATE_DATE                              = tmp.SPA_LAST_UPDATE_DATE            
                    ,SPA_CREATED_BY                                    = tmp.SPA_CREATED_BY                  
                    ,SPA_LAST_UPDATED_BY                               = tmp.SPA_LAST_UPDATED_BY             
                    ,FINAL_APPROVAL_TIME                               = tmp.FINAL_APPROVAL_TIME             
                    ,SPA_FINAL_APPROVAL_DATE_TIME                      = tmp.FINAL_APPROVAL_TIME             
                    ,SPA_TOTAL_PRICE                                   = tmp.SPA_TOTAL_PRICE                 
                    ,SPA_TOTAL_PRICE_CURRENCY                          = tmp.SPA_TOTAL_PRICE_CURRENCY        
                    ,DEAL_LOGISTICS                                    = tmp.DEAL_LOGISTICS                  
                    ,DISTRIBUTOR_ORACLE_ACCOUNT_ID                     = tmp.DISTRIBUTOR_ORACLE_ACCOUNT_ID   
                    ,LAST_UPDATED_BY                                   = 'DATA_LOAD'
                    ,LAST_UPDATE_DATE                                  = SYSDATE
                    ,ATTRIBUTE1                                        = L_IN_OIC_INSTANCE_ID
                WHERE
                        1 = 1
                    AND SPA_NUMBER = TMP.SPA_NUMBER;

            EXCEPTION
                WHEN OTHERS THEN
                    BEGIN
                        L_ERROR_MESSAGE := L_ERROR_MESSAGE
                                           || CHR(10)
                                           || CHR(9)
                                           ||'SPA Header ['||L_SPA_NUMBER||']: '
                                           || SQLERRM;


                    EXCEPTION
                        WHEN OTHERS THEN
                            NULL;
                    END;
            END;

            COMMIT;

            -------------------------------------------------------------------------------------
            --SPA LINE
            -------------------------------------------------------------------------------------
            FOR line IN (SELECT LINE_ITEM_NUMBER ,QUANTITY ,UNIT_PRICE ,REBATE ,FINAL_LIST_PRICE ,TOTAL_PRICE ,RECOMMENDED_INSTALLER_PRICE ,DISTRIBUTOR_MARGIN ,SALES_PRICE_CURRENCY ,APPROVED_LIST_PRICE  ,SPA_LINE_CREATION_DATE ,SPA_LINE_CREATED_BY  ,SPA_LINE_LAST_UPDATED_BY ,SPA_LINE_LAST_MODIFIED_DATE ,PRODUCT_NAME  ,PRODUCT_NUMBER FROM CHM_SPA_STAGING WHERE SPA_NUMBER = L_SPA_NUMBER)
            LOOP
                L_COUNT := L_COUNT + 1;
                L_LINE_NUMBER := line.LINE_ITEM_NUMBER ;
                BEGIN
                    SELECT
                        CHM_SPA_LINES_S.NEXTVAL
                    INTO L_CHM_SPA_LINE_ID
                    FROM
                        DUAL;

                    MERGE INTO CHM_SPA_LINES TBL
                    USING (
                        SELECT
                             line.LINE_ITEM_NUMBER                  LINE_ITEM_NUMBER              
                            ,line.QUANTITY                          QUANTITY                
                            ,line.UNIT_PRICE                        UNIT_PRICE         
                            ,line.REBATE                            REBATE           
                            ,line.FINAL_LIST_PRICE                  FINAL_LIST_PRICE          
                            ,line.TOTAL_PRICE                       TOTAL_PRICE                       
                            ,line.RECOMMENDED_INSTALLER_PRICE       RECOMMENDED_INSTALLER_PRICE      
                            ,line.DISTRIBUTOR_MARGIN                DISTRIBUTOR_MARGIN               
                            ,line.SALES_PRICE_CURRENCY              SALES_PRICE_CURRENCY              
                            ,line.APPROVED_LIST_PRICE               APPROVED_LIST_PRICE               
                            ,TO_TIMESTAMP_TZ(to_timestamp(line.SPA_LINE_CREATION_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SPA_LINE_CREATION_DATE                 
                            ,line.SPA_LINE_CREATED_BY               SPA_LINE_CREATED_BY               
                            ,TO_TIMESTAMP_TZ(to_timestamp(line.SPA_LINE_LAST_MODIFIED_DATE , 'YYYY-MM-DD"T"HH24:MI:SS.ff3"Z"'), 'DD-MM-RR fmHH12:fmMI:SSXFF AM TZR') SPA_LINE_LAST_MODIFIED_DATE
                            ,line.SPA_LINE_LAST_UPDATED_BY          SPA_LINE_LAST_UPDATED_BY          
                            ,line.PRODUCT_NAME                      PRODUCT_NAME                    
                            ,line.PRODUCT_NUMBER                    PRODUCT_NUMBER
                        FROM
                            DUAL
                    ) TMP 
                    ON ( TBL.LINE_ITEM_NUMBER = TMP.LINE_ITEM_NUMBER )
                    WHEN NOT MATCHED THEN
                    INSERT (
                        CHM_SPA_LINE_ID
                        ,CHM_SPA_ID
                        ,LINE_ITEM_NUMBER
                        ,QUANTITY
                        ,SALES_PRICE
                        ,SALES_PRICE_CURRENCY
                        ,REBATE
                        ,REBATE_CURRENCY
                        ,LIST_PRICE
                        ,LIST_PRICE_CURRENCY
                        ,RECOMMENDED_INSTALLER_PRICE
                        ,DISTRIBUTOR_MARGIN
                        ,APPROVED_LIST_PRICE_CURRENCY
                        ,APPROVED_LIST_PRICE
                        ,CREATION_DATE
                        ,CREATED_BY
                        ,LAST_UPDATE_DATE
                        ,LAST_UPDATED_BY
                        ,PRODUCT_NUMBER
                        ,ENPHASE_PART_NUMBER
                        ,RECOMMENDED_INSTALLER_PRICING
                        ,RECOMMENDED_INSTALLER_PRICE_CURRENCY
                        ,PRODUCT_NAME
                        ,SPA_LINE_CREATION_DATE
                        ,SPA_LINE_CREATED_BY
                        ,SPA_LINE_LAST_UPDATED_BY
                        ,SPA_LINE_LAST_MODIFIED_DATE
                        ,ATTRIBUTE1
                    )
                    VALUES ( 
                        L_CHM_SPA_LINE_ID
                        ,L_CHM_SPA_ID
                        ,to_number(TMP.LINE_ITEM_NUMBER)
                        ,to_number(TMP.QUANTITY)
                        ,to_number(TMP.UNIT_PRICE)
                        ,TMP.SALES_PRICE_CURRENCY
                        ,to_number(TMP.REBATE)
                        ,TMP.SALES_PRICE_CURRENCY
                        ,to_number(TMP.FINAL_LIST_PRICE)
                        ,TMP.SALES_PRICE_CURRENCY
                        ,to_number(TMP.RECOMMENDED_INSTALLER_PRICE)
                        ,to_number(TMP.DISTRIBUTOR_MARGIN)
                        ,TMP.SALES_PRICE_CURRENCY
                        ,to_number(TMP.APPROVED_LIST_PRICE)
                        ,SYSDATE
                        ,'DATA_LOAD'
                        ,SYSDATE
                        ,'DATA_LOAD'
                        ,TMP.PRODUCT_NUMBER
                        ,TMP.PRODUCT_NUMBER
                        ,to_number(TMP.RECOMMENDED_INSTALLER_PRICE)
                        ,TMP.SALES_PRICE_CURRENCY
                        ,TMP.PRODUCT_NAME
                        ,TMP.SPA_LINE_CREATION_DATE 
                        ,TMP.SPA_LINE_CREATED_BY      
                        ,TMP.SPA_LINE_LAST_UPDATED_BY   
                        ,TMP.SPA_LINE_LAST_MODIFIED_DATE
                        ,L_IN_OIC_INSTANCE_ID
                    )
                    WHEN MATCHED THEN 
                    UPDATE SET 
                         QUANTITY                                   = to_number(TMP.QUANTITY)
                        ,SALES_PRICE                                = to_number(TMP.UNIT_PRICE)
                        ,SALES_PRICE_CURRENCY                       = TMP.SALES_PRICE_CURRENCY
                        ,REBATE                                     = to_number(TMP.REBATE)
                        ,REBATE_CURRENCY                            = TMP.SALES_PRICE_CURRENCY
                        ,LIST_PRICE                                 = to_number(TMP.FINAL_LIST_PRICE)
                        ,LIST_PRICE_CURRENCY                        = TMP.SALES_PRICE_CURRENCY
                        ,RECOMMENDED_INSTALLER_PRICE                = to_number(TMP.RECOMMENDED_INSTALLER_PRICE)
                        ,DISTRIBUTOR_MARGIN                         = to_number(TMP.DISTRIBUTOR_MARGIN)
                        ,APPROVED_LIST_PRICE_CURRENCY               = TMP.SALES_PRICE_CURRENCY
                        ,APPROVED_LIST_PRICE                        = to_number(TMP.APPROVED_LIST_PRICE)
                        ,LAST_UPDATE_DATE                           = SYSDATE
                        ,LAST_UPDATED_BY                            = 'DATA_LOAD'
                        ,PRODUCT_NUMBER                             = TMP.PRODUCT_NUMBER
                        ,ENPHASE_PART_NUMBER                        = TMP.PRODUCT_NUMBER
                        ,RECOMMENDED_INSTALLER_PRICING              = to_number(TMP.RECOMMENDED_INSTALLER_PRICE)
                        ,RECOMMENDED_INSTALLER_PRICE_CURRENCY       = TMP.SALES_PRICE_CURRENCY
                        ,PRODUCT_NAME                               = TMP.PRODUCT_NAME
                        ,SPA_LINE_CREATION_DATE                     = TMP.SPA_LINE_CREATION_DATE 
                        ,SPA_LINE_CREATED_BY                        = TMP.SPA_LINE_CREATED_BY      
                        ,SPA_LINE_LAST_UPDATED_BY                   = TMP.SPA_LINE_LAST_UPDATED_BY   
                        ,SPA_LINE_LAST_MODIFIED_DATE                = TMP.SPA_LINE_LAST_MODIFIED_DATE
                        ,ATTRIBUTE1                                 = L_IN_OIC_INSTANCE_ID
                    WHERE
                            1 = 1
                        AND LINE_ITEM_NUMBER = TMP.LINE_ITEM_NUMBER;

                L_MERGE_COUNT := L_MERGE_COUNT + 1;


                EXCEPTION
                    WHEN OTHERS THEN
                        BEGIN
                            L_ERROR_MESSAGE := L_ERROR_MESSAGE
                                               || CHR(10)
                                               || CHR(9)
                                               ||'SPA Line Number ['||L_LINE_NUMBER||']: '
                                               || SQLERRM;



                        EXCEPTION
                            WHEN OTHERS THEN
                                NULL;
                        END;
                END;

                COMMIT;

            END LOOP;

        END LOOP;





        P_OUT_RECORDS_FETCHED   := L_COUNT;
        P_OUT_RECORDS_MERGED    := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE     := substr(L_ERROR_MESSAGE,1,30000);
    END;

END CHM_SPA_STAGING_PKG;
/
