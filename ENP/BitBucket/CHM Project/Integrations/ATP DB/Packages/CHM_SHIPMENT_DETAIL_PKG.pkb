create or replace PACKAGE BODY CHM_SHIPMENT_DETAIL_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_SHIPMENT_DETAIL_PKG                                                                                                               *
    * Purpose                        : Package Body for CHM Shipment Detail sync from fusion                                                                                 *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 31-Jan-2024                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 31-Jan-2024   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    --Procedure to merge shipment data received from fusion   
    PROCEDURE MERGE_DATA (
        P_IN_CHM_SHIPMENT_DETAIL IN TBL_CHM_SHIPMENT_DETAIL,
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2,               ------- V1.1
        P_OUT_RECORDS_FETCHED   OUT NUMBER,
        P_OUT_RECORDS_MERGED    OUT NUMBER,
        P_OUT_ERROR_MESSAGE     OUT VARCHAR2
    ) AS
        L_COUNT         NUMBER := 0;
        L_MERGE_COUNT   NUMBER := 0;
        L_ERROR_MESSAGE VARCHAR2(30000);
    BEGIN
        FOR I IN P_IN_CHM_SHIPMENT_DETAIL.FIRST..P_IN_CHM_SHIPMENT_DETAIL.LAST LOOP
            L_COUNT := L_COUNT + 1;
            BEGIN
                MERGE INTO CHM_SHIP_DETAILS_TBL TBL
                USING (
                    SELECT
                         P_IN_CHM_SHIPMENT_DETAIL(I).FULFILL_LINE_ID	                         FULFILL_LINE_ID	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).HEADER_ID             	                     HEADER_ID                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).LINE_ID               	                     LINE_ID                        
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).DELIVERY_ID           	                     DELIVERY_ID                    
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).DELIVERY_DETAIL_ID    	                     DELIVERY_DETAIL_ID             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).DELIVERY_ASSIGNMENT_ID	                     DELIVERY_ASSIGNMENT_ID         
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ORGANIZATION_NAME	                         ORGANIZATION_NAME	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIPMENT_NO	                             SHIPMENT_NO	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).STATUS_NAME	                             STATUS_NAME	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).WAYBILL	                                 WAYBILL	                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).FOB_CODE	                                 FOB_CODE	                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CONFIRMED_BY	                             CONFIRMED_BY	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).NET_WEIGHT	                                 NET_WEIGHT	                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).UOM	                                     UOM	                         
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIP_CONFIRM_ACK	                         SHIP_CONFIRM_ACK	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIP_METHOD	                             SHIP_METHOD	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIP_METHOD_CODE	                         SHIP_METHOD_CODE	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SERVICE_LEVEL	                             SERVICE_LEVEL	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIPPING_STATUS	                         SHIPPING_STATUS	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SOURCE_HEADER_NUMBER	                     SOURCE_HEADER_NUMBER	         
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).WSH_DESC	                                 WSH_DESC	                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ITEM_DESCRIPTION	                         ITEM_DESCRIPTION	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).WSH_SHIPQTY	                             WSH_SHIPQTY	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SALESPERSON	                             SALESPERSON	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).REQUESTED_QUANTITY	                         REQUESTED_QUANTITY	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).PRIMARY_UOM_CODE	                         PRIMARY_UOM_CODE	             
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SKU	                                     SKU	                         
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).FREIGHT_AMT	                             FREIGHT_AMT	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ORIG_FREIGHT	                             ORIG_FREIGHT	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).FREIGHT_ADDER	                             FREIGHT_ADDER	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).FREIGHT_COST_TYPE_MEANING	                 FREIGHT_COST_TYPE_MEANING	     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CUST_REQ_OTD_REASON	                     CUST_REQ_OTD_REASON	         
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ESTIMATED_TIME_OF_ARRIVAL	                 ESTIMATED_TIME_OF_ARRIVAL	     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ORDER_NUMBER	                             ORDER_NUMBER	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).LINE_NUMBER	                             LINE_NUMBER	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).LINE_STATUS	                             LINE_STATUS	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ORDER_TYPE	                                 ORDER_TYPE	                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CUST_PO_NUMBER	                             CUST_PO_NUMBER	                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SCHEDULED_SHIP_DATE	                     SCHEDULED_SHIP_DATE	         
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ACTUAL_SHIPMENT_DATE                        ACTUAL_SHIPMENT_DATE            
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).WEEK                                        WEEK                            
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIP_DATE                                   SHIP_DATE                       
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ACTUAL_SHIP_DATE                            ACTUAL_SHIP_DATE                
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ORDER_DATE                                  ORDER_DATE                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).UNIT_SELLING_PRICE                          UNIT_SELLING_PRICE              
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).EXTENDED_AMOUNT                             EXTENDED_AMOUNT                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CURRENCY_CODE                               CURRENCY_CODE                   
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIPPING_INSTRUCTIONS                       SHIPPING_INSTRUCTIONS           
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SUBINVENTORY                                SUBINVENTORY                    
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).WAREHOUSE                                   WAREHOUSE                       
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).REQUEST_DATE                                REQUEST_DATE                    
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).PROMISE_DATE                                PROMISE_DATE                    
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CUST_REQUEST_DATE                           CUST_REQUEST_DATE               
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SITE_USE_CODE                               SITE_USE_CODE                   
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIPTO_LOCATION                             SHIPTO_LOCATION                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).SHIP_TO_CUSTOMER_NAME                       SHIP_TO_CUSTOMER_NAME           
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ADDRESS1                                    ADDRESS1                        
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ADDRESS2                                    ADDRESS2                        
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ADDRESS3                                    ADDRESS3                        
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CITY                                        CITY                            
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).STATE                                       STATE                           
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ZIP_CODE                                    ZIP_CODE                        
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).COUNTRY                                     COUNTRY                         
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).PARTY_ID                                    PARTY_ID                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).PARTY_NUMBER                                PARTY_NUMBER                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CUST_ACCOUNT_ID                             CUST_ACCOUNT_ID                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CUSTOMER_NUMBER                             CUSTOMER_NUMBER                 
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CUSTOMER_NAME                               CUSTOMER_NAME                   
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ITEM_COST                                   ITEM_COST                       
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).PRODUCT_TYPE                                PRODUCT_TYPE                    
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).PRODUCT_FAMILY                              PRODUCT_FAMILY                  
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).DESTINATION_SUBINVENTORY_CODE               DESTINATION_SUBINVENTORY_CODE   
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).DESTINATION_ORG_NAME                        DESTINATION_ORG_NAME            
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).DESTINATION_LOC_NAME                        DESTINATION_LOC_NAME            
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).BOOKED_DATE                                 BOOKED_DATE                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).BOOKED_BY                                   BOOKED_BY                       
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).IS_BOOKED_BY_CREATOR                        IS_BOOKED_BY_CREATOR            
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE1                                  ATTRIBUTE1                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE2                                  ATTRIBUTE2                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE3                                  ATTRIBUTE3                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE4                                  ATTRIBUTE4                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE5                                  ATTRIBUTE5                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE6                                  ATTRIBUTE6                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE7                                  ATTRIBUTE7                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE8                                  ATTRIBUTE8                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE9                                  ATTRIBUTE9                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).ATTRIBUTE10                                 ATTRIBUTE10                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).OIC_INSTANCE_ID                             OIC_INSTANCE_ID                     
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).CREATED_BY                                  CREATED_BY                      
                        ,P_IN_CHM_SHIPMENT_DETAIL(I).LAST_UPDATED_BY                             LAST_UPDATED_BY                     
                    FROM
                        DUAL
                ) TMP ON ( 
                        TBL.HEADER_ID               = TMP.HEADER_ID 
                    AND TBL.LINE_ID                 = TMP.LINE_ID 
                    AND TBL.DELIVERY_ID             = TMP.DELIVERY_ID 
                    AND TBL.DELIVERY_DETAIL_ID      = TMP.DELIVERY_DETAIL_ID 
                    AND TBL.DELIVERY_ASSIGNMENT_ID  = TMP.DELIVERY_ASSIGNMENT_ID 
                    AND TBL.FULFILL_LINE_ID         = TMP.FULFILL_LINE_ID
                
                )
                WHEN NOT MATCHED THEN
                INSERT (
                     FULFILL_LINE_ID
                    ,HEADER_ID             
                    ,LINE_ID               
                    ,DELIVERY_ID           
                    ,DELIVERY_DETAIL_ID    
                    ,DELIVERY_ASSIGNMENT_ID
                    ,ORGANIZATION_NAME	             
                    ,SHIPMENT_NO	                 
                    ,STATUS_NAME	                 
                    ,WAYBILL	                     
                    ,FOB_CODE	                     
                    ,CONFIRMED_BY	                 
                    ,NET_WEIGHT	                     
                    ,UOM	                         
                    ,SHIP_CONFIRM_ACK	             
                    ,SHIP_METHOD	                 
                    ,SHIP_METHOD_CODE	             
                    ,SERVICE_LEVEL	                 
                    ,SHIPPING_STATUS	             
                    ,SOURCE_HEADER_NUMBER	         
                    ,WSH_DESC	                     
                    ,ITEM_DESCRIPTION	             
                    ,WSH_SHIPQTY	                 
                    ,SALESPERSON	                 
                    ,REQUESTED_QUANTITY	             
                    ,PRIMARY_UOM_CODE	             
                    ,SKU	                         
                    ,FREIGHT_AMT	                 
                    ,ORIG_FREIGHT	                 
                    ,FREIGHT_ADDER	                 
                    ,FREIGHT_COST_TYPE_MEANING	     
                    ,CUST_REQ_OTD_REASON	         
                    ,ESTIMATED_TIME_OF_ARRIVAL	     
                    ,ORDER_NUMBER	                 
                    ,LINE_NUMBER	                 
                    ,LINE_STATUS	                 
                    ,ORDER_TYPE	                     
                    ,CUST_PO_NUMBER	                 
                    ,SCHEDULED_SHIP_DATE	         
                    ,ACTUAL_SHIPMENT_DATE            
                    ,WEEK                            
                    ,SHIP_DATE                       
                    ,ACTUAL_SHIP_DATE                
                    ,ORDER_DATE                      
                    ,UNIT_SELLING_PRICE              
                    ,EXTENDED_AMOUNT                 
                    ,CURRENCY_CODE                   
                    ,SHIPPING_INSTRUCTIONS           
                    ,SUBINVENTORY                    
                    ,WAREHOUSE                       
                    ,REQUEST_DATE                    
                    ,PROMISE_DATE                    
                    ,CUST_REQUEST_DATE               
                    ,SITE_USE_CODE                   
                    ,SHIPTO_LOCATION                 
                    ,SHIP_TO_CUSTOMER_NAME           
                    ,ADDRESS1                        
                    ,ADDRESS2                        
                    ,ADDRESS3                        
                    ,CITY                            
                    ,STATE                           
                    ,ZIP_CODE                        
                    ,COUNTRY   
                    ,PARTY_ID       
                    ,PARTY_NUMBER   
                    ,CUST_ACCOUNT_ID
                    ,CUSTOMER_NUMBER                 
                    ,CUSTOMER_NAME                   
                    ,ITEM_COST                       
                    ,PRODUCT_TYPE                    
                    ,PRODUCT_FAMILY                  
                    ,DESTINATION_SUBINVENTORY_CODE   
                    ,DESTINATION_ORG_NAME            
                    ,DESTINATION_LOC_NAME            
                    ,BOOKED_DATE                     
                    ,BOOKED_BY                       
                    ,IS_BOOKED_BY_CREATOR            
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
                    ,OIC_INSTANCE_ID
                    ,CREATED_BY
                    ,LAST_UPDATED_BY
                )
                VALUES
                    ( 
                         tmp.FULFILL_LINE_ID	             
                        ,tmp.HEADER_ID             	             
                        ,tmp.LINE_ID               	             
                        ,tmp.DELIVERY_ID           	             
                        ,tmp.DELIVERY_DETAIL_ID    	             
                        ,tmp.DELIVERY_ASSIGNMENT_ID	             
                        ,tmp.ORGANIZATION_NAME	             
                        ,tmp.SHIPMENT_NO	                 
                        ,tmp.STATUS_NAME	                 
                        ,tmp.WAYBILL	                     
                        ,tmp.FOB_CODE	                     
                        ,tmp.CONFIRMED_BY	                 
                        ,tmp.NET_WEIGHT	                     
                        ,tmp.UOM	                         
                        ,tmp.SHIP_CONFIRM_ACK	             
                        ,tmp.SHIP_METHOD	                 
                        ,tmp.SHIP_METHOD_CODE	             
                        ,tmp.SERVICE_LEVEL	                 
                        ,tmp.SHIPPING_STATUS	             
                        ,tmp.SOURCE_HEADER_NUMBER	         
                        ,tmp.WSH_DESC	                     
                        ,tmp.ITEM_DESCRIPTION	             
                        ,tmp.WSH_SHIPQTY	                 
                        ,tmp.SALESPERSON	                 
                        ,tmp.REQUESTED_QUANTITY	             
                        ,tmp.PRIMARY_UOM_CODE	             
                        ,tmp.SKU	                         
                        ,tmp.FREIGHT_AMT	                 
                        ,tmp.ORIG_FREIGHT	                 
                        ,tmp.FREIGHT_ADDER	                 
                        ,tmp.FREIGHT_COST_TYPE_MEANING	     
                        ,tmp.CUST_REQ_OTD_REASON	         
                        ,tmp.ESTIMATED_TIME_OF_ARRIVAL	     
                        ,tmp.ORDER_NUMBER	                 
                        ,tmp.LINE_NUMBER	                 
                        ,tmp.LINE_STATUS	                 
                        ,tmp.ORDER_TYPE	                     
                        ,tmp.CUST_PO_NUMBER	                 
                        ,tmp.SCHEDULED_SHIP_DATE	         
                        ,tmp.ACTUAL_SHIPMENT_DATE            
                        ,tmp.WEEK                            
                        ,tmp.SHIP_DATE                       
                        ,tmp.ACTUAL_SHIP_DATE                
                        ,tmp.ORDER_DATE                      
                        ,tmp.UNIT_SELLING_PRICE              
                        ,tmp.EXTENDED_AMOUNT                 
                        ,tmp.CURRENCY_CODE                   
                        ,tmp.SHIPPING_INSTRUCTIONS           
                        ,tmp.SUBINVENTORY                    
                        ,tmp.WAREHOUSE                       
                        ,tmp.REQUEST_DATE                    
                        ,tmp.PROMISE_DATE                    
                        ,tmp.CUST_REQUEST_DATE               
                        ,tmp.SITE_USE_CODE                   
                        ,tmp.SHIPTO_LOCATION                 
                        ,tmp.SHIP_TO_CUSTOMER_NAME           
                        ,tmp.ADDRESS1                        
                        ,tmp.ADDRESS2                        
                        ,tmp.ADDRESS3                        
                        ,tmp.CITY                            
                        ,tmp.STATE                           
                        ,tmp.ZIP_CODE                        
                        ,tmp.COUNTRY                         
                        ,tmp.PARTY_ID                        
                        ,tmp.PARTY_NUMBER                    
                        ,tmp.CUST_ACCOUNT_ID                 
                        ,tmp.CUSTOMER_NUMBER                 
                        ,tmp.CUSTOMER_NAME                   
                        ,tmp.ITEM_COST                       
                        ,tmp.PRODUCT_TYPE                    
                        ,tmp.PRODUCT_FAMILY                  
                        ,tmp.DESTINATION_SUBINVENTORY_CODE   
                        ,tmp.DESTINATION_ORG_NAME            
                        ,tmp.DESTINATION_LOC_NAME            
                        ,tmp.BOOKED_DATE                     
                        ,tmp.BOOKED_BY                       
                        ,tmp.IS_BOOKED_BY_CREATOR            
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
                        ,tmp.OIC_INSTANCE_ID
                        ,tmp.CREATED_BY   
                        ,tmp.LAST_UPDATED_BY    

                )
                WHEN MATCHED THEN UPDATE
                SET 
                     ORGANIZATION_NAME	             =tmp.ORGANIZATION_NAME	             
                    ,SHIPMENT_NO	                 =tmp.SHIPMENT_NO	                 
                    ,STATUS_NAME	                 =tmp.STATUS_NAME	                 
                    ,WAYBILL	                     =tmp.WAYBILL	                     
                    ,FOB_CODE	                     =tmp.FOB_CODE	                     
                    ,CONFIRMED_BY	                 =tmp.CONFIRMED_BY	                 
                    ,NET_WEIGHT	                     =tmp.NET_WEIGHT	                     
                    ,UOM	                         =tmp.UOM	                         
                    ,SHIP_CONFIRM_ACK	             =tmp.SHIP_CONFIRM_ACK	             
                    ,SHIP_METHOD	                 =tmp.SHIP_METHOD	                 
                    ,SHIP_METHOD_CODE	             =tmp.SHIP_METHOD_CODE	             
                    ,SERVICE_LEVEL	                 =tmp.SERVICE_LEVEL	                 
                    ,SHIPPING_STATUS	             =tmp.SHIPPING_STATUS	             
                    ,SOURCE_HEADER_NUMBER	         =tmp.SOURCE_HEADER_NUMBER	         
                    ,WSH_DESC	                     =tmp.WSH_DESC	                     
                    ,ITEM_DESCRIPTION	             =tmp.ITEM_DESCRIPTION	             
                    ,WSH_SHIPQTY	                 =tmp.WSH_SHIPQTY	                 
                    ,SALESPERSON	                 =tmp.SALESPERSON	                 
                    ,REQUESTED_QUANTITY	             =tmp.REQUESTED_QUANTITY	             
                    ,PRIMARY_UOM_CODE	             =tmp.PRIMARY_UOM_CODE	             
                    ,SKU	                         =tmp.SKU	                         
                    ,FREIGHT_AMT	                 =tmp.FREIGHT_AMT	                 
                    ,ORIG_FREIGHT	                 =tmp.ORIG_FREIGHT	                 
                    ,FREIGHT_ADDER	                 =tmp.FREIGHT_ADDER	                 
                    ,FREIGHT_COST_TYPE_MEANING	     =tmp.FREIGHT_COST_TYPE_MEANING	     
                    ,CUST_REQ_OTD_REASON	         =tmp.CUST_REQ_OTD_REASON	         
                    ,ESTIMATED_TIME_OF_ARRIVAL	     =tmp.ESTIMATED_TIME_OF_ARRIVAL	     
                    ,ORDER_NUMBER	                 =tmp.ORDER_NUMBER	                 
                    ,LINE_NUMBER	                 =tmp.LINE_NUMBER	                 
                    ,LINE_STATUS	                 =tmp.LINE_STATUS	                 
                    ,ORDER_TYPE	                     =tmp.ORDER_TYPE	                     
                    ,CUST_PO_NUMBER	                 =tmp.CUST_PO_NUMBER	                 
                    ,SCHEDULED_SHIP_DATE	         =tmp.SCHEDULED_SHIP_DATE	         
                    ,ACTUAL_SHIPMENT_DATE            =tmp.ACTUAL_SHIPMENT_DATE            
                    ,WEEK                            =tmp.WEEK                            
                    ,SHIP_DATE                       =tmp.SHIP_DATE                       
                    ,ACTUAL_SHIP_DATE                =tmp.ACTUAL_SHIP_DATE                
                    ,ORDER_DATE                      =tmp.ORDER_DATE                      
                    ,UNIT_SELLING_PRICE              =tmp.UNIT_SELLING_PRICE              
                    ,EXTENDED_AMOUNT                 =tmp.EXTENDED_AMOUNT                 
                    ,CURRENCY_CODE                   =tmp.CURRENCY_CODE                   
                    ,SHIPPING_INSTRUCTIONS           =tmp.SHIPPING_INSTRUCTIONS           
                    ,SUBINVENTORY                    =tmp.SUBINVENTORY                    
                    ,WAREHOUSE                       =tmp.WAREHOUSE                       
                    ,REQUEST_DATE                    =tmp.REQUEST_DATE                    
                    ,PROMISE_DATE                    =tmp.PROMISE_DATE                    
                    ,CUST_REQUEST_DATE               =tmp.CUST_REQUEST_DATE               
                    ,SITE_USE_CODE                   =tmp.SITE_USE_CODE                   
                    ,SHIPTO_LOCATION                 =tmp.SHIPTO_LOCATION                 
                    ,SHIP_TO_CUSTOMER_NAME           =tmp.SHIP_TO_CUSTOMER_NAME           
                    ,ADDRESS1                        =tmp.ADDRESS1                        
                    ,ADDRESS2                        =tmp.ADDRESS2                        
                    ,ADDRESS3                        =tmp.ADDRESS3                        
                    ,CITY                            =tmp.CITY                            
                    ,STATE                           =tmp.STATE                           
                    ,ZIP_CODE                        =tmp.ZIP_CODE                        
                    ,COUNTRY                         =tmp.COUNTRY                         
                    ,PARTY_ID                        =tmp.PARTY_ID                        
                    ,PARTY_NUMBER                    =tmp.PARTY_NUMBER                    
                    ,CUST_ACCOUNT_ID                 =tmp.CUST_ACCOUNT_ID                 
                    ,CUSTOMER_NUMBER                 =tmp.CUSTOMER_NUMBER                 
                    ,CUSTOMER_NAME                   =tmp.CUSTOMER_NAME                   
                    ,ITEM_COST                       =tmp.ITEM_COST                       
                    ,PRODUCT_TYPE                    =tmp.PRODUCT_TYPE                    
                    ,PRODUCT_FAMILY                  =tmp.PRODUCT_FAMILY                  
                    ,DESTINATION_SUBINVENTORY_CODE   =tmp.DESTINATION_SUBINVENTORY_CODE   
                    ,DESTINATION_ORG_NAME            =tmp.DESTINATION_ORG_NAME            
                    ,DESTINATION_LOC_NAME            =tmp.DESTINATION_LOC_NAME            
                    ,BOOKED_DATE                     =tmp.BOOKED_DATE                     
                    ,BOOKED_BY                       =tmp.BOOKED_BY                       
                    ,IS_BOOKED_BY_CREATOR            =tmp.IS_BOOKED_BY_CREATOR            
                    ,ATTRIBUTE1                      =tmp.ATTRIBUTE1                      
                    ,ATTRIBUTE2                      =tmp.ATTRIBUTE2                      
                    ,ATTRIBUTE3                      =tmp.ATTRIBUTE3                      
                    ,ATTRIBUTE4                      =tmp.ATTRIBUTE4                      
                    ,ATTRIBUTE5                      =tmp.ATTRIBUTE5                      
                    ,ATTRIBUTE6                      =tmp.ATTRIBUTE6                      
                    ,ATTRIBUTE7                      =tmp.ATTRIBUTE7                      
                    ,ATTRIBUTE8                      =tmp.ATTRIBUTE8                      
                    ,ATTRIBUTE9                      =tmp.ATTRIBUTE9                      
                    ,ATTRIBUTE10                     =tmp.ATTRIBUTE10
                    ,OIC_INSTANCE_ID                 =tmp.OIC_INSTANCE_ID
                    ,LAST_UPDATE_DATE                =sysdate
                    ,LAST_UPDATED_BY                 =tmp.LAST_UPDATED_BY
                WHERE 1 = 1
                AND HEADER_ID               = TMP.HEADER_ID 
                AND LINE_ID                 = TMP.LINE_ID 
                AND DELIVERY_ID             = TMP.DELIVERY_ID 
                AND DELIVERY_DETAIL_ID      = TMP.DELIVERY_DETAIL_ID 
                AND DELIVERY_ASSIGNMENT_ID  = TMP.DELIVERY_ASSIGNMENT_ID 
                AND FULFILL_LINE_ID         = TMP.FULFILL_LINE_ID;


                L_MERGE_COUNT := L_MERGE_COUNT + 1;

                COMMIT;

            EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||'['||P_IN_CHM_SHIPMENT_DETAIL(I).HEADER_ID||'-'||P_IN_CHM_SHIPMENT_DETAIL(I).LINE_ID||'-'||P_IN_CHM_SHIPMENT_DETAIL(I).DELIVERY_ID||'-'||P_IN_CHM_SHIPMENT_DETAIL(I).DELIVERY_DETAIL_ID||'-'||P_IN_CHM_SHIPMENT_DETAIL(I).DELIVERY_ASSIGNMENT_ID||'-'||P_IN_CHM_SHIPMENT_DETAIL(I).FULFILL_LINE_ID||'] - '||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;


        END LOOP;

        P_OUT_RECORDS_FETCHED := L_COUNT;
        P_OUT_RECORDS_MERGED := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE := SUBSTR(L_ERROR_MESSAGE, 1, 4000);

        UPDATE CHM_INTEGRATION_RUNS
        SET      TOTAL_FETCHED_RECORDS      = nvl(TOTAL_FETCHED_RECORDS,0)+L_COUNT
                ,TOTAL_SUCCESS_RECORDS      = nvl(TOTAL_SUCCESS_RECORDS,0)+L_MERGE_COUNT
                ,TOTAL_ERROR_RECORDS        = nvl(TOTAL_ERROR_RECORDS,0) + (L_COUNT - L_MERGE_COUNT)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END MERGE_DATA;

END CHM_SHIPMENT_DETAIL_PKG;
/
