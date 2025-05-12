CREATE OR REPLACE PACKAGE BODY CHM_PRICE_LIST_ITEM_PKG
    
    /******************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                        *
    * Package Name                   : CHM_PRICE_LIST_ITEM_PKG                                                                    *
    * Purpose                        : Package Body for CHM Price List Items Integrations                                         *
    * Created By                     : Gurpreet Singh                                                                             *
    * Created Date                   : 10-Aug-2023                                                                                *     
    *******************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                      * 
    * -----------   ---------------------------    ---------------------------      -------------    -----------------------------*
    * 10-Aug-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version               * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    ******************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_PRICE_LIST_ITEM			IN      TBL_PRICE_LIST_ITEM
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2      ------ V1.1
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
        FOR i IN P_IN_PRICE_LIST_ITEM.FIRST .. P_IN_PRICE_LIST_ITEM.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_PRICE_LIST_ITEMS tbl
                USING (
                    SELECT 
                         P_IN_PRICE_LIST_ITEM(i).PRICE_LIST_ITEM_ID	            PRICE_LIST_ITEM_ID
                        ,P_IN_PRICE_LIST_ITEM(i).PRICE_LIST_ID	                PRICE_LIST_ID
                        ,P_IN_PRICE_LIST_ITEM(i).PRICE_LIST_CHARGE_ID           PRICE_LIST_CHARGE_ID
                        ,P_IN_PRICE_LIST_ITEM(i).ITEM_ID	                    ITEM_ID
                        ,P_IN_PRICE_LIST_ITEM(i).BASE_PRICE	                    BASE_PRICE
                        ,P_IN_PRICE_LIST_ITEM(i).START_DATE	                    START_DATE
                        ,P_IN_PRICE_LIST_ITEM(i).END_DATE	                    END_DATE
                        ,P_IN_OIC_INSTANCE_ID                                   OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON ( 
                        tbl.PRICE_LIST_ITEM_ID      = tmp.PRICE_LIST_ITEM_ID 
                    AND tbl.PRICE_LIST_ID           = tmp.PRICE_LIST_ID 
                    AND tbl.PRICE_LIST_CHARGE_ID    = tmp.PRICE_LIST_CHARGE_ID 
                    AND tbl.ITEM_ID                 = tmp.ITEM_ID 
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         PRICE_LIST_ITEM_ID	
                        ,PRICE_LIST_ID	
                        ,PRICE_LIST_CHARGE_ID	
                        ,ITEM_ID	
                        ,BASE_PRICE	
                        ,START_DATE	
                        ,END_DATE	
                        ,OIC_INSTANCE_ID	
                    )
                    VALUES (
                         tmp.PRICE_LIST_ITEM_ID	
                        ,tmp.PRICE_LIST_ID	
                        ,tmp.PRICE_LIST_CHARGE_ID	
                        ,tmp.ITEM_ID	
                        ,tmp.BASE_PRICE	
                        ,tmp.START_DATE	
                        ,tmp.END_DATE	
                        ,tmp.OIC_INSTANCE_ID	
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         BASE_PRICE                     = tmp.BASE_PRICE
                        ,START_DATE                     = tmp.START_DATE
                        ,END_DATE                       = tmp.END_DATE
                        ,OIC_INSTANCE_ID			    = tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE			    = sysdate
                    WHERE	1=1
                    AND tbl.PRICE_LIST_ITEM_ID      = tmp.PRICE_LIST_ITEM_ID 
                    AND tbl.PRICE_LIST_ID           = tmp.PRICE_LIST_ID 
                    AND tbl.PRICE_LIST_CHARGE_ID    = tmp.PRICE_LIST_CHARGE_ID 
                    AND tbl.ITEM_ID                 = tmp.ITEM_ID 
                    ;
                
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
    
END CHM_PRICE_LIST_ITEM_PKG;
/





