create or replace PACKAGE BODY CHM_MSI_SHIPMENT_DETAIL_PKG
/*******************************************************************************************************
* Type                           : PL/SQL Package Body                                                 *
* Package Name                   : CHM_MSI_SHIPMENT_DETAIL_PKG                                         *
* Purpose                        : Package Body for MSI CHM Shipment Detail sync from fusion           *
* Created By                     : Gurpreet Singh                                                      *
* Created Date                   : 05-Mar-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 05-Mar-2025   Gurpreet Singh                 1.0              Intial Version                         * 
* 05-May-2025   Gurpreet Singh                 1.1              Changing Key Columns in UAT Testing    * 
*******************************************************************************************************/    
AS
    --Procedure to merge shipment data received from fusion   
    PROCEDURE MERGE_DATA (
         P_IN_CHM_MSI_SHIPMENT_DETAIL IN TBL_CHM_MSI_SHIPMENT_DETAIL
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_MSI_SHIPMENT_DETAIL.FIRST..P_IN_CHM_MSI_SHIPMENT_DETAIL.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_MSI_SHIP_DETAILS_TBL TBL
                USING (
                    SELECT
                         P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SALES_ORDER_ORG_ID                 SALES_ORDER_ORG_ID         
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SHIPPING_ORG_ID                    SHIPPING_ORG_ID            
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).HEADER_ID             	            HEADER_ID             	    
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).LINE_ID               	            LINE_ID               	    
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).FULFILL_LINE_ID	                FULFILL_LINE_ID	        
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).DELIVERY_ID    	                DELIVERY_ID    	        
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).DELIVERY_DETAIL_ID    	            DELIVERY_DETAIL_ID    	    
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).DELIVERY_ASSIGNMENT_ID    	        DELIVERY_ASSIGNMENT_ID    	
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SALES_ORDER_ORG_NAME               SALES_ORDER_ORG_NAME       
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SHIPPING_ORG_NAME                  SHIPPING_ORG_NAME          
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).WAREHOUSE           	            WAREHOUSE           	    
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SUBINVENTORY           	        SUBINVENTORY           	
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ORDER_NUMBER           	        ORDER_NUMBER           	
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SHIPMENT_NO                        SHIPMENT_NO                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SALES_ORDER_TYPE                   SALES_ORDER_TYPE           
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).LINE_NUMBER                        LINE_NUMBER                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SALES_ORDER_LINE_TYPE              SALES_ORDER_LINE_TYPE      
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).INVENTORY_ITEM_ID                  INVENTORY_ITEM_ID          
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ENPHASE_PRODUCT_NAME               ENPHASE_PRODUCT_NAME       
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SERIAL_NUMBER                      SERIAL_NUMBER              
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ACTUAL_SHIP_DATE                   ACTUAL_SHIP_DATE           
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).CUSTOMER_NAME                      CUSTOMER_NAME              
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).CUST_ACCOUNT_ID                    CUST_ACCOUNT_ID            
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).CUST_ACCOUNT_NUMBER                CUST_ACCOUNT_NUMBER        
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SHIPPING_ADDRESS                   SHIPPING_ADDRESS           
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SHIPPING_LOCATION                  SHIPPING_LOCATION          
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).COUNTRY                            COUNTRY                    
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SYNC_FOR_DATE                      SYNC_FOR_DATE                    
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE1                         ATTRIBUTE1                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE2                         ATTRIBUTE2                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE3                         ATTRIBUTE3                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE4                         ATTRIBUTE4                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE5                         ATTRIBUTE5                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE6                         ATTRIBUTE6                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE7                         ATTRIBUTE7                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE8                         ATTRIBUTE8                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE9                         ATTRIBUTE9                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE10                        ATTRIBUTE10                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE11                        ATTRIBUTE11                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE12                        ATTRIBUTE12                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE13                        ATTRIBUTE13                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE14                        ATTRIBUTE14                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).ATTRIBUTE15                        ATTRIBUTE15                
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).OIC_INSTANCE_ID                    OIC_INSTANCE_ID            
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).CREATED_BY                         CREATED_BY                 
                        ,P_IN_CHM_MSI_SHIPMENT_DETAIL(I).LAST_UPDATED_BY                    LAST_UPDATED_BY            
                    FROM
                        DUAL
                ) TMP ON ( 
                        TBL.SERIAL_NUMBER           = TMP.SERIAL_NUMBER
                    /*    TBL.HEADER_ID               = TMP.HEADER_ID 
                    AND TBL.LINE_ID                 = TMP.LINE_ID 
                    AND TBL.FULFILL_LINE_ID         = TMP.FULFILL_LINE_ID
                    AND TBL.DELIVERY_ID             = TMP.DELIVERY_ID 
                    AND TBL.DELIVERY_DETAIL_ID      = TMP.DELIVERY_DETAIL_ID 
                    AND TBL.DELIVERY_ASSIGNMENT_ID  = TMP.DELIVERY_ASSIGNMENT_ID 
                    */  --commented for 1.1
                )
                WHEN NOT MATCHED THEN
                INSERT (
                     SALES_ORDER_ORG_ID       
                    ,SHIPPING_ORG_ID          
                    ,HEADER_ID             	 
                    ,LINE_ID               	 
                    ,FULFILL_LINE_ID	        
                    ,DELIVERY_ID    	        
                    ,DELIVERY_DETAIL_ID    	 
                    ,DELIVERY_ASSIGNMENT_ID   
                    ,SALES_ORDER_ORG_NAME     
                    ,SHIPPING_ORG_NAME        
                    ,WAREHOUSE           	 
                    ,SUBINVENTORY           	
                    ,ORDER_NUMBER           	
                    ,SHIPMENT_NO              
                    ,SALES_ORDER_TYPE         
                    ,LINE_NUMBER              
                    ,SALES_ORDER_LINE_TYPE    
                    ,INVENTORY_ITEM_ID        
                    ,ENPHASE_PRODUCT_NAME     
                    ,SERIAL_NUMBER            
                    ,ACTUAL_SHIP_DATE         
                    ,CUSTOMER_NAME            
                    ,CUST_ACCOUNT_ID          
                    ,CUST_ACCOUNT_NUMBER      
                    ,SHIPPING_ADDRESS         
                    ,SHIPPING_LOCATION        
                    ,COUNTRY
                    ,SYNC_FOR_DATE
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
                    ,OIC_INSTANCE_ID          
                    ,CREATED_BY               
                    ,LAST_UPDATED_BY   
                    ,CREATION_DATE
                    ,LAST_UPDATED_DATE
                )
                VALUES
                ( 
                     tmp.SALES_ORDER_ORG_ID       
                    ,tmp.SHIPPING_ORG_ID          
                    ,tmp.HEADER_ID             	 
                    ,tmp.LINE_ID               	 
                    ,tmp.FULFILL_LINE_ID	        
                    ,tmp.DELIVERY_ID    	        
                    ,tmp.DELIVERY_DETAIL_ID    	 
                    ,tmp.DELIVERY_ASSIGNMENT_ID   
                    ,tmp.SALES_ORDER_ORG_NAME     
                    ,tmp.SHIPPING_ORG_NAME        
                    ,tmp.WAREHOUSE           	 
                    ,tmp.SUBINVENTORY           	
                    ,tmp.ORDER_NUMBER           	
                    ,tmp.SHIPMENT_NO              
                    ,tmp.SALES_ORDER_TYPE         
                    ,tmp.LINE_NUMBER              
                    ,tmp.SALES_ORDER_LINE_TYPE    
                    ,tmp.INVENTORY_ITEM_ID        
                    ,tmp.ENPHASE_PRODUCT_NAME     
                    ,tmp.SERIAL_NUMBER            
                    ,tmp.ACTUAL_SHIP_DATE         
                    ,tmp.CUSTOMER_NAME            
                    ,tmp.CUST_ACCOUNT_ID          
                    ,tmp.CUST_ACCOUNT_NUMBER      
                    ,tmp.SHIPPING_ADDRESS         
                    ,tmp.SHIPPING_LOCATION        
                    ,tmp.COUNTRY                  
                    ,tmp.SYNC_FOR_DATE                  
                    ,tmp.ATTRIBUTE1               
                    ,tmp.ATTRIBUTE2               
                    ,tmp.ATTRIBUTE3               
                    ,tmp.ATTRIBUTE4               
                    ,tmp.ATTRIBUTE5               
                    ,tmp.ATTRIBUTE6               
                    ,tmp.ATTRIBUTE7               
                    ,tmp.ATTRIBUTE8               
                    ,tmp.ATTRIBUTE9               
                    ,tmp.ATTRIBUTE10              
                    ,tmp.ATTRIBUTE11              
                    ,tmp.ATTRIBUTE12              
                    ,tmp.ATTRIBUTE13              
                    ,tmp.ATTRIBUTE14              
                    ,tmp.ATTRIBUTE15              
                    ,tmp.OIC_INSTANCE_ID          
                    ,tmp.CREATED_BY               
                    ,tmp.LAST_UPDATED_BY              
                    ,SYSDATE
                    ,SYSDATE
                )
                WHEN MATCHED THEN UPDATE
                SET 
                     SALES_ORDER_ORG_ID             = tmp.SALES_ORDER_ORG_ID       
                    ,SHIPPING_ORG_ID                = tmp.SHIPPING_ORG_ID          
                    ,SALES_ORDER_ORG_NAME           = tmp.SALES_ORDER_ORG_NAME     
                    ,SHIPPING_ORG_NAME              = tmp.SHIPPING_ORG_NAME        
                    ,WAREHOUSE           	        = tmp.WAREHOUSE           	 
                    ,SUBINVENTORY           	    = tmp.SUBINVENTORY           	
                    ,ORDER_NUMBER           	    = tmp.ORDER_NUMBER           	
                    ,SHIPMENT_NO                    = tmp.SHIPMENT_NO              
                    ,SALES_ORDER_TYPE               = tmp.SALES_ORDER_TYPE         
                    ,LINE_NUMBER                    = tmp.LINE_NUMBER              
                    ,SALES_ORDER_LINE_TYPE          = tmp.SALES_ORDER_LINE_TYPE    
                    ,INVENTORY_ITEM_ID              = tmp.INVENTORY_ITEM_ID        
                    ,ENPHASE_PRODUCT_NAME           = tmp.ENPHASE_PRODUCT_NAME     
                    ,ACTUAL_SHIP_DATE               = tmp.ACTUAL_SHIP_DATE         
                    ,CUSTOMER_NAME                  = tmp.CUSTOMER_NAME            
                    ,CUST_ACCOUNT_ID                = tmp.CUST_ACCOUNT_ID          
                    ,CUST_ACCOUNT_NUMBER            = tmp.CUST_ACCOUNT_NUMBER      
                    ,SHIPPING_ADDRESS               = tmp.SHIPPING_ADDRESS         
                    ,SHIPPING_LOCATION              = tmp.SHIPPING_LOCATION        
                    ,COUNTRY                        = tmp.COUNTRY                  
                    ,SYNC_FOR_DATE                  = tmp.SYNC_FOR_DATE                  
                    ,ATTRIBUTE1                     = tmp.ATTRIBUTE1               
                    ,ATTRIBUTE2                     = tmp.ATTRIBUTE2               
                    ,ATTRIBUTE3                     = tmp.ATTRIBUTE3               
                    ,ATTRIBUTE4                     = tmp.ATTRIBUTE4               
                    ,ATTRIBUTE5                     = tmp.ATTRIBUTE5               
                    ,ATTRIBUTE6                     = tmp.ATTRIBUTE6               
                    ,ATTRIBUTE7                     = tmp.ATTRIBUTE7               
                    ,ATTRIBUTE8                     = tmp.ATTRIBUTE8               
                    ,ATTRIBUTE9                     = tmp.ATTRIBUTE9               
                    ,ATTRIBUTE10                    = tmp.ATTRIBUTE10              
                    ,ATTRIBUTE11                    = tmp.ATTRIBUTE11              
                    ,ATTRIBUTE12                    = tmp.ATTRIBUTE12              
                    ,ATTRIBUTE13                    = tmp.ATTRIBUTE13              
                    ,ATTRIBUTE14                    = tmp.ATTRIBUTE14              
                    ,ATTRIBUTE15                    = tmp.ATTRIBUTE15              
                    ,OIC_INSTANCE_ID                = tmp.OIC_INSTANCE_ID          
                    ,CREATED_BY                     = tmp.CREATED_BY               
                    ,LAST_UPDATED_BY                = tmp.LAST_UPDATED_BY          
                    ,LAST_UPDATED_DATE              = SYSDATE
                    ,HEADER_ID                      = TMP.HEADER_ID 
                    ,LINE_ID                        = TMP.LINE_ID 
                    ,DELIVERY_ID                    = TMP.DELIVERY_ID 
                    ,FULFILL_LINE_ID                = TMP.FULFILL_LINE_ID
                    ,DELIVERY_DETAIL_ID             = TMP.DELIVERY_DETAIL_ID 
                    ,DELIVERY_ASSIGNMENT_ID         = TMP.DELIVERY_ASSIGNMENT_ID 
                WHERE 1 = 1
                AND TBL.HEADER_ID               = TMP.HEADER_ID 
                AND TBL.LINE_ID                 = TMP.LINE_ID 
                AND TBL.DELIVERY_ID             = TMP.DELIVERY_ID 
                AND TBL.FULFILL_LINE_ID         = TMP.FULFILL_LINE_ID
                AND TBL.DELIVERY_DETAIL_ID      = TMP.DELIVERY_DETAIL_ID 
                AND TBL.DELIVERY_ASSIGNMENT_ID  = TMP.DELIVERY_ASSIGNMENT_ID 
                AND TBL.SERIAL_NUMBER           = TMP.SERIAL_NUMBER
                ;


                L_MERGE_COUNT := L_MERGE_COUNT + 1;
                COMMIT;
                
            EXCEPTION
                WHEN OTHERS THEN 
                    L_ERROR_MESSAGE := substr(SQLERRM,1,30000);
                    UPDATE CHM_INTEGRATION_RUNS
                    SET      LOG    = LOG   ||CHR(10)||'Merge Error [' 
                                    ||P_IN_CHM_MSI_SHIPMENT_DETAIL(I).HEADER_ID                 ||'-'     
                                    ||P_IN_CHM_MSI_SHIPMENT_DETAIL(I).LINE_ID                   ||'-'
                                    ||P_IN_CHM_MSI_SHIPMENT_DETAIL(I).FULFILL_LINE_ID	        ||'-'
                                    ||P_IN_CHM_MSI_SHIPMENT_DETAIL(I).DELIVERY_ID    	        ||'-'
                                    ||P_IN_CHM_MSI_SHIPMENT_DETAIL(I).DELIVERY_DETAIL_ID        ||'-'
                                    ||P_IN_CHM_MSI_SHIPMENT_DETAIL(I).DELIVERY_ASSIGNMENT_ID    ||'-'
                                    ||P_IN_CHM_MSI_SHIPMENT_DETAIL(I).SERIAL_NUMBER             ||'] '
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
                ,LAST_UPDATE_DATE           = SYSDATE
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_DATA;

    
    --Procedure to get dates
    PROCEDURE GET_DATES(
         P_IN_FROM_DATE              IN     VARCHAR2 DEFAULT NULL
        ,P_IN_TO_DATE                IN     VARCHAR2 DEFAULT NULL
        ,P_IN_ORDER_NUMBER           IN     VARCHAR2 DEFAULT NULL
        ,P_OUT_DATA                  OUT    SYS_REFCURSOR             
    )
    AS
    BEGIN
    
        OPEN P_OUT_DATA FOR
        SELECT 
            to_char(dt.date_value,'DD-MON-YYYY') date_value
            --,lkp.lookup_code country
        FROM (
            SELECT (TO_DATE(P_IN_FROM_DATE, 'DD-MON-YYYY')-1) + LEVEL - 1 AS date_value
            FROM DUAL
            CONNECT BY LEVEL <= 
            CASE 
                WHEN P_IN_ORDER_NUMBER <> 'NA' THEN 1 
                ELSE (TO_DATE(P_IN_TO_DATE, 'DD-MON-YYYY')+1) - (TO_DATE(P_IN_FROM_DATE, 'DD-MON-YYYY') -1) + 1 
            END
        ) dt
        /*,(   SELECT lookup_code FROM chm_lookup_values 
            WHERE chm_lookup_type_id IN ( 
                SELECT chm_lookup_type_id FROM chm_lookup_types 
                WHERE lookup_type           = 'CHM_MSI_SHIPMENT_SYNC_COUNTRY_RESTRICTION' 
                AND source_application_id   = -1  
                AND NVL(enabled_flag,'N')   = 'Y'
                )                             
            AND NVL(enabled_flag,'N')       = 'Y'
            AND P_IN_ORDER_NUMBER = 'NA'
            UNION 
            SELECT 'N/A' FROM DUAL
            WHERE P_IN_ORDER_NUMBER <> 'NA'
        ) lkp*/
        ORDER BY dt.date_value; 
    
    END GET_DATES;
    
    

END CHM_MSI_SHIPMENT_DETAIL_PKG;
/
