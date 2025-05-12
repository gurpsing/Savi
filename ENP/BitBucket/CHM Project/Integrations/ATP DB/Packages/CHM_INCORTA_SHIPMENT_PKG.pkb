create or replace PACKAGE BODY CHM_INCORTA_SHIPMENT_PKG
    
    /*******************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                               
    * Package Name                   : CHM_INCORTA_SHIPMENT_PKG                                                                     
    * Purpose                        : Package for CHM Incorta Shipment Integrations                                                
    * Created By                     : Gurpreet Singh                                                                               
    * Created Date                   : 11-Oct-2024                                                                                       
    ********************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                         
    * -----------   ---------------------------    ---------------------------      -------------    -------------------------------
    * 11-Oct-2024   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                  
    ********************************************************************************************************************************/

AS

    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_SHIPMENT_DATA			    IN      TBL_SHIPMENT_DATA
        ,P_IN_TOTAL_ROWS                IN      NUMBER
        ,P_IN_NEXT_FETCH_POS            IN      NUMBER
        ,P_OUT_HAS_MORE                 OUT     VARCHAR2
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
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
        FOR i IN P_IN_SHIPMENT_DATA.FIRST .. P_IN_SHIPMENT_DATA.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN


                --Merge in CHM table
                MERGE INTO CHM_INCORTA_SHIP_DETAILS_TBL tbl
                USING (
                    SELECT 
                         P_IN_SHIPMENT_DATA(i).SHIPPED_DATE   		        SHIPPED_DATE   		
                        ,P_IN_SHIPMENT_DATA(i).SHIPPING_WAREHOUSE		    SHIPPING_WAREHOUSE		
                        ,P_IN_SHIPMENT_DATA(i).ORDER_TYPE                   ORDER_TYPE             
                        ,P_IN_SHIPMENT_DATA(i).PLNUMBER                     PLNUMBER               
                        ,P_IN_SHIPMENT_DATA(i).SALES_ORDER_NUMBER           SALES_ORDER_NUMBER     
                        ,P_IN_SHIPMENT_DATA(i).SHIPTO_CUSTOMER_NAME         SHIPTO_CUSTOMER_NAME   
                        ,P_IN_SHIPMENT_DATA(i).ADDRESS                      ADDRESS
                        ,P_IN_SHIPMENT_DATA(i).CITY                         CITY                   
                        ,P_IN_SHIPMENT_DATA(i).STATE                        STATE                  
                        ,P_IN_SHIPMENT_DATA(i).COUNTRYCODE                  COUNTRYCODE            
                        ,P_IN_SHIPMENT_DATA(i).SHIPMENT_CARRIER             SHIPMENT_CARRIER       
                        ,P_IN_SHIPMENT_DATA(i).TRACKING_NUMBER              TRACKING_NUMBER        
                        ,P_IN_SHIPMENT_DATA(i).EXPECTED_DELIVERY_DATE       EXPECTED_DELIVERY_DATE 
                        ,P_IN_SHIPMENT_DATA(i).COUNTRY_NAME                 COUNTRY_NAME           
                        ,P_IN_SHIPMENT_DATA(i).DELIVERY_STATUS              DELIVERY_STATUS        
                        ,P_IN_SHIPMENT_DATA(i).LATEST_MILESTONE_STATUS      LATEST_MILESTONE_STATUS
                        ,P_IN_SHIPMENT_DATA(i).CUSTOMER_PO_NUMBER           CUSTOMER_PO_NUMBER     
                        ,P_IN_SHIPMENT_DATA(i).DELIVERED_DATE               DELIVERED_DATE
                        ,P_IN_SHIPMENT_DATA(i).CREATION_DATE                CREATION_DATE                 
                        ,P_IN_SHIPMENT_DATA(i).CREATED_BY                   CREATED_BY        
                        ,P_IN_SHIPMENT_DATA(i).LAST_UPDATE_DATE             LAST_UPDATE_DATE 
                        ,P_IN_SHIPMENT_DATA(i).LAST_UPDATED_BY              LAST_UPDATED_BY  
                        ,P_IN_OIC_INSTANCE_ID                               OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.PLNUMBER                            = tmp.PLNUMBER
                    AND NVL(tbl.CUSTOMER_PO_NUMBER,'NA')        = nvl(tmp.CUSTOMER_PO_NUMBER,'NA')   )
                WHEN NOT MATCHED THEN
                    INSERT (
                             CIE_INCORTA_SHIP_DETAIL_ID
                            ,SHIPPED_DATE   		    
                            ,SHIPPING_WAREHOUSE		
                            ,ORDER_TYPE               
                            ,PLNUMBER                 
                            ,SALES_ORDER_NUMBER       
                            ,SHIPTO_CUSTOMER_NAME     
                            ,ADDRESS1                 
                            --,ADDRESS2                 
                            --,ADDRESS3                 
                            ,CITY                     
                            ,STATE                    
                            ,COUNTRYCODE              
                            ,SHIPMENT_CARRIER         
                            ,TRACKING_NUMBER          
                            ,EXPECTED_DELIVERY_DATE   
                            ,COUNTRY_NAME             
                            ,DELIVERY_STATUS          
                            ,LATEST_MILESTONE_STATUS  
                            ,CUSTOMER_PO_NUMBER       
                            ,DELIVERED_DATE           
                            ,OIC_INSTANCE_ID
                            ,CREATION_DATE
                            ,CREATED_BY
                            ,LAST_UPDATE_DATE
                            ,LAST_UPDATED_BY
                    )
                    VALUES (
                         CHM_INCORTA_SHIP_DETAIL_SEQ.NEXTVAL
                        ,to_date(substr(tmp.SHIPPED_DATE,1,10),'YYYY-MM-DD')
                        ,tmp.SHIPPING_WAREHOUSE		
                        ,tmp.ORDER_TYPE             
                        ,tmp.PLNUMBER               
                        ,tmp.SALES_ORDER_NUMBER     
                        ,tmp.SHIPTO_CUSTOMER_NAME   
                        ,tmp.ADDRESS              
                        ,tmp.CITY                   
                        ,tmp.STATE                  
                        ,tmp.COUNTRYCODE            
                        ,tmp.SHIPMENT_CARRIER       
                        ,tmp.TRACKING_NUMBER        
                        ,to_date(substr(tmp.EXPECTED_DELIVERY_DATE,1,10),'YYYY-MM-DD') 
                        ,tmp.COUNTRY_NAME           
                        ,tmp.DELIVERY_STATUS        
                        ,tmp.LATEST_MILESTONE_STATUS
                        ,tmp.CUSTOMER_PO_NUMBER     
                        ,to_date(substr(tmp.DELIVERED_DATE,1,10),'YYYY-MM-DD')         
                        ,tmp.OIC_INSTANCE_ID
                        ,tmp.CREATION_DATE
                        ,tmp.CREATED_BY
                        ,tmp.LAST_UPDATE_DATE
                        ,tmp.LAST_UPDATED_BY
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         SHIPPED_DATE   		        = to_date(substr(tmp.SHIPPED_DATE,1,10),'YYYY-MM-DD')
                        ,SHIPPING_WAREHOUSE		        = tmp.SHIPPING_WAREHOUSE		   
                        ,ORDER_TYPE                     = tmp.ORDER_TYPE                
                        ,SALES_ORDER_NUMBER             = tmp.SALES_ORDER_NUMBER        
                        ,SHIPTO_CUSTOMER_NAME           = tmp.SHIPTO_CUSTOMER_NAME      
                        ,ADDRESS1                       = tmp.ADDRESS    
                        ,CITY                           = tmp.CITY                      
                        ,STATE                          = tmp.STATE                     
                        ,COUNTRYCODE                    = tmp.COUNTRYCODE               
                        ,SHIPMENT_CARRIER               = tmp.SHIPMENT_CARRIER          
                        ,TRACKING_NUMBER                = tmp.TRACKING_NUMBER           
                        ,EXPECTED_DELIVERY_DATE         = to_date(substr(tmp.EXPECTED_DELIVERY_DATE,1,10),'YYYY-MM-DD')     
                        ,COUNTRY_NAME                   = tmp.COUNTRY_NAME              
                        ,DELIVERY_STATUS                = tmp.DELIVERY_STATUS           
                        ,LATEST_MILESTONE_STATUS        = tmp.LATEST_MILESTONE_STATUS   
                        ,DELIVERED_DATE                 = to_date(substr(tmp.DELIVERED_DATE,1,10),'YYYY-MM-DD')            
                        ,OIC_INSTANCE_ID			    = tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATED_BY			    = tmp.LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE			    = tmp.LAST_UPDATE_DATE
                    WHERE	1=1
                    AND PLNUMBER                        = tmp.PLNUMBER
                    AND nvl(CUSTOMER_PO_NUMBER,'NA')    = nvl(tmp.CUSTOMER_PO_NUMBER,'NA');

                L_MERGE_COUNT:= L_MERGE_COUNT+1;
                COMMIT;

            END;

        END LOOP;

        IF P_IN_NEXT_FETCH_POS > P_IN_TOTAL_ROWS 
        THEN
            P_OUT_HAS_MORE :='N';
        ELSE
            P_OUT_HAS_MORE :='Y';
        END IF;    

        P_OUT_RECORDS_FETCHED   := L_COUNT;
        P_OUT_RECORDS_MERGED    := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE     := substr(L_ERROR_MESSAGE,1,4000);

        UPDATE CHM_INTEGRATION_RUNS
        SET  LAST_COMPLETED_STAGE       = 'Shipment Data Sync'
            ,LOG                        = LOG||' Total Records Synced: '||L_COUNT||chr(10)
            ,TOTAL_FETCHED_RECORDS      = nvl(TOTAL_FETCHED_RECORDS,0) + L_COUNT
            ,TOTAL_SUCCESS_RECORDS      = nvl(TOTAL_SUCCESS_RECORDS,0) + L_COUNT
            ,LAST_UPDATE_DATE           = SYSDATE
        WHERE   CHM_INTEGRATION_RUN_ID  = P_IN_OIC_INSTANCE_ID;
        COMMIT;

        BEGIN
            SELECT  nvl(TOTAL_FETCHED_RECORDS,0) INTO L_COUNT
            FROM    CHM_INTEGRATION_RUNS
            WHERE   CHM_INTEGRATION_RUN_ID  = P_IN_OIC_INSTANCE_ID;

            IF L_COUNT >= P_IN_TOTAL_ROWS
            THEN
                UPDATE CHM_INTEGRATION_RUNS
                SET  PHASE                      = 'Completed'
                    ,STATUS                     = 'Success'
                    ,LOG                        = LOG||' Integration Completed'
                    ,COMPLETION_DATE            = SYSDATE
                    ,LAST_UPDATE_DATE           = SYSDATE
                WHERE   CHM_INTEGRATION_RUN_ID  = P_IN_OIC_INSTANCE_ID;
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN 
                dbms_output.put_line('Exception: '||SQLERRM);
        END;    
    END MERGE_DATA;

END CHM_INCORTA_SHIPMENT_PKG;
/
