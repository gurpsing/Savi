CREATE OR REPLACE PACKAGE BODY CHM_EXCHANGE_RATE_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_EXCHANGE_RATE_PKG                                                                                                                 *
    * Purpose                        : Package for CHM Exchange Rate Integrations                                                                                            *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 19-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 19-Jun-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_EXCHANGE_RATE			    IN      TBL_EXCHANGE_RATE
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2          ------ V1.1
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
        FOR i IN P_IN_EXCHANGE_RATE.FIRST .. P_IN_EXCHANGE_RATE.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_EXCHANGE_RATES tbl
                USING (
                    SELECT 
                         P_IN_EXCHANGE_RATE(i).FROM_CURRENCY            FROM_CURRENCY
                        ,P_IN_EXCHANGE_RATE(i).TO_CURRENCY              TO_CURRENCY
                        ,P_IN_EXCHANGE_RATE(i).CONVERSION_DATE          CONVERSION_DATE
                        ,P_IN_EXCHANGE_RATE(i).CONVERSION_TYPE          CONVERSION_TYPE
                        ,P_IN_EXCHANGE_RATE(i).USER_CONVERSION_TYPE     USER_CONVERSION_TYPE
                        ,P_IN_EXCHANGE_RATE(i).CONVERSION_RATE          CONVERSION_RATE
                        ,P_IN_EXCHANGE_RATE(i).STATUS_CODE              STATUS_CODE
                        ,P_IN_OIC_INSTANCE_ID                           OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.FROM_CURRENCY           = tmp.FROM_CURRENCY  
                    AND tbl.TO_CURRENCY             = tmp.TO_CURRENCY  
                    AND tbl.CONVERSION_DATE         = tmp.CONVERSION_DATE  
                    AND tbl.CONVERSION_TYPE         = tmp.CONVERSION_TYPE  
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         FROM_CURRENCY
                        ,TO_CURRENCY
                        ,CONVERSION_DATE
                        ,CONVERSION_TYPE
                        ,USER_CONVERSION_TYPE
                        ,CONVERSION_RATE
                        ,STATUS_CODE
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.FROM_CURRENCY
                        ,tmp.TO_CURRENCY
                        ,tmp.CONVERSION_DATE
                        ,tmp.CONVERSION_TYPE
                        ,tmp.USER_CONVERSION_TYPE
                        ,tmp.CONVERSION_RATE
                        ,tmp.STATUS_CODE
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         USER_CONVERSION_TYPE	    = tmp.USER_CONVERSION_TYPE	
                        ,CONVERSION_RATE	        = tmp.CONVERSION_RATE		
                        ,STATUS_CODE			    = tmp.STATUS_CODE
                        ,OIC_INSTANCE_ID			= tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE			= sysdate
                    WHERE	1=1
                    AND FROM_CURRENCY               = tmp.FROM_CURRENCY  
                    AND TO_CURRENCY                 = tmp.TO_CURRENCY  
                    AND CONVERSION_DATE             = tmp.CONVERSION_DATE  
                    AND CONVERSION_TYPE             = tmp.CONVERSION_TYPE ;
                
                L_MERGE_COUNT:= L_MERGE_COUNT+1;
                
            EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||'. '||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;
        
        END LOOP;
        
        --Update the out variables
        P_OUT_RECORDS_FETCHED   := L_COUNT;
        P_OUT_RECORDS_MERGED    := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE     := substr(L_ERROR_MESSAGE,1,4000);
        
    END MERGE_DATA;
    
END CHM_EXCHANGE_RATE_PKG;
/
