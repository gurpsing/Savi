CREATE OR REPLACE PACKAGE BODY CHM_LEDGER_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_LEDGER_PKG                                                                                                                        *
    * Purpose                        : Package for CHM Ledger Integrations                                                                                                   *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 22-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 22-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_LEDGER			        IN      TBL_LEDGER
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2          ---- V1.1
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
        FOR i IN P_IN_LEDGER.FIRST .. P_IN_LEDGER.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_LEDGERS tbl
                USING (
                    SELECT 
                         P_IN_LEDGER(i).SOURCE_LEDGER_ID                SOURCE_LEDGER_ID
                        ,P_IN_LEDGER(i).NAME                            NAME
                        ,P_IN_LEDGER(i).SHORT_NAME                      SHORT_NAME
                        ,P_IN_LEDGER(i).DESCRIPTION                     DESCRIPTION
                        ,P_IN_LEDGER(i).LEDGER_CATEGORY_CODE            LEDGER_CATEGORY_CODE
                        ,P_IN_LEDGER(i).ALC_LEDGER_TYPE_CODE            ALC_LEDGER_TYPE_CODE
                        ,P_IN_LEDGER(i).OBJECT_TYPE_CODE                OBJECT_TYPE_CODE
                        ,P_IN_LEDGER(i).LE_LEDGER_TYPE_CODE             LE_LEDGER_TYPE_CODE
                        ,P_IN_LEDGER(i).COMPLETION_STATUS_CODE          COMPLETION_STATUS_CODE
                        ,P_IN_LEDGER(i).CHART_OF_ACCOUNTS_ID            CHART_OF_ACCOUNTS_ID
                        ,P_IN_LEDGER(i).CURRENCY_CODE                   CURRENCY_CODE
                        ,P_IN_LEDGER(i).PERIOD_SET_NAME                 PERIOD_SET_NAME
                        ,P_IN_LEDGER(i).SUSPENSE_ALLOWED_FLAG           SUSPENSE_ALLOWED_FLAG
                        ,P_IN_LEDGER(i).ALLOW_INTERCOMPANY_POST_FLAG    ALLOW_INTERCOMPANY_POST_FLAG
                        ,P_IN_LEDGER(i).ENABLE_AVERAGE_BALANCES_FLAG    ENABLE_AVERAGE_BALANCES_FLAG
                        ,P_IN_OIC_INSTANCE_ID                           OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.SOURCE_LEDGER_ID      = tmp.SOURCE_LEDGER_ID )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SOURCE_LEDGER_ID   		
                        ,NAME						
                        ,SHORT_NAME					
                        ,DESCRIPTION				
                        ,LEDGER_CATEGORY_CODE		
                        ,ALC_LEDGER_TYPE_CODE		
                        ,OBJECT_TYPE_CODE			
                        ,LE_LEDGER_TYPE_CODE		
                        ,COMPLETION_STATUS_CODE		
                        ,CHART_OF_ACCOUNTS_ID		
                        ,CURRENCY_CODE				
                        ,PERIOD_SET_NAME			
                        ,SUSPENSE_ALLOWED_FLAG		
                        ,ALLOW_INTERCOMPANY_POST_FLAG
                        ,ENABLE_AVERAGE_BALANCES_FLAG
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.SOURCE_LEDGER_ID
                        ,tmp.NAME
                        ,tmp.SHORT_NAME
                        ,tmp.DESCRIPTION
                        ,tmp.LEDGER_CATEGORY_CODE
                        ,tmp.ALC_LEDGER_TYPE_CODE
                        ,tmp.OBJECT_TYPE_CODE
                        ,tmp.LE_LEDGER_TYPE_CODE
                        ,tmp.COMPLETION_STATUS_CODE
                        ,tmp.CHART_OF_ACCOUNTS_ID
                        ,tmp.CURRENCY_CODE
                        ,tmp.PERIOD_SET_NAME
                        ,tmp.SUSPENSE_ALLOWED_FLAG
                        ,tmp.ALLOW_INTERCOMPANY_POST_FLAG
                        ,tmp.ENABLE_AVERAGE_BALANCES_FLAG
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         NAME                           = tmp.NAME
                        ,SHORT_NAME                     = tmp.SHORT_NAME
                        ,DESCRIPTION                    = tmp.DESCRIPTION
                        ,LEDGER_CATEGORY_CODE           = tmp.LEDGER_CATEGORY_CODE
                        ,ALC_LEDGER_TYPE_CODE           = tmp.ALC_LEDGER_TYPE_CODE
                        ,OBJECT_TYPE_CODE               = tmp.OBJECT_TYPE_CODE
                        ,LE_LEDGER_TYPE_CODE            = tmp.LE_LEDGER_TYPE_CODE
                        ,COMPLETION_STATUS_CODE         = tmp.COMPLETION_STATUS_CODE
                        ,CHART_OF_ACCOUNTS_ID           = tmp.CHART_OF_ACCOUNTS_ID
                        ,CURRENCY_CODE                  = tmp.CURRENCY_CODE
                        ,PERIOD_SET_NAME                = tmp.PERIOD_SET_NAME
                        ,SUSPENSE_ALLOWED_FLAG          = tmp.SUSPENSE_ALLOWED_FLAG
                        ,ALLOW_INTERCOMPANY_POST_FLAG   = tmp.ALLOW_INTERCOMPANY_POST_FLAG
                        ,ENABLE_AVERAGE_BALANCES_FLAG   = tmp.ENABLE_AVERAGE_BALANCES_FLAG
                        ,OIC_INSTANCE_ID			    = tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE			    = sysdate
                    WHERE	1=1
                    AND SOURCE_LEDGER_ID                = tmp.SOURCE_LEDGER_ID;
                
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
    
END CHM_LEDGER_PKG;
/
