CREATE OR REPLACE PACKAGE BODY CHM_ITEM_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_ITEM_PKG                                                                                                                          *
    * Purpose                        : Package Body for CHM Item Integration                                                                                                 *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 03-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 03-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_ITEM			            IN      TBL_ITEM
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2     ---- V1.1
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
        FOR i IN P_IN_ITEM.FIRST .. P_IN_ITEM.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_ITEMS tbl
                USING (
                    SELECT 
                         P_IN_ITEM(i).SOURCE_ITEM_ID                    SOURCE_ITEM_ID
                        ,P_IN_ITEM(i).ORG_ID                            ORG_ID
                        ,P_IN_ITEM(i).LANGUAGE                          LANGUAGE
                        ,P_IN_ITEM(i).ITEM_NUMBER                       ITEM_NUMBER
                        ,P_IN_ITEM(i).DESCRIPTION                       DESCRIPTION
                        ,P_IN_ITEM(i).LONG_DESCRIPTION                  LONG_DESCRIPTION
                        ,P_IN_ITEM(i).ITEM_TYPE                         ITEM_TYPE
                        ,P_IN_ITEM(i).APPROVAL_STATUS                   APPROVAL_STATUS
                        ,P_IN_ITEM(i).TEMPLATE_NAME                     TEMPLATE_NAME
                        ,P_IN_ITEM(i).CATEGORY_SET_ID                   CATEGORY_SET_ID               
                        ,P_IN_ITEM(i).CATALOG_CODE                      CATALOG_CODE                  
                        ,P_IN_ITEM(i).PURCHASING_ITEM_FLAG              PURCHASING_ITEM_FLAG
                        ,P_IN_ITEM(i).SHIPPABLE_ITEM_FLAG               SHIPPABLE_ITEM_FLAG
                        ,P_IN_ITEM(i).CUSTOMER_ORDER_FLAG               CUSTOMER_ORDER_FLAG
                        ,P_IN_ITEM(i).INTERNAL_ORDER_FLAG               INTERNAL_ORDER_FLAG
                        ,P_IN_ITEM(i).INVENTORY_ITEM_FLAG               INVENTORY_ITEM_FLAG
                        ,P_IN_ITEM(i).INVENTORY_ASSET_FLAG              INVENTORY_ASSET_FLAG
                        ,P_IN_ITEM(i).PURCHASING_ENABLED_FLAG           PURCHASING_ENABLED_FLAG
                        ,P_IN_ITEM(i).CUSTOMER_ORDER_ENABLED_FLAG       CUSTOMER_ORDER_ENABLED_FLAG
                        ,P_IN_ITEM(i).INTERNAL_ORDER_ENABLED_FLAG       INTERNAL_ORDER_ENABLED_FLAG
                        ,P_IN_ITEM(i).SO_TRANSACTIONS_FLAG              SO_TRANSACTIONS_FLAG
                        ,P_IN_ITEM(i).MTL_TRANSACTIONS_ENABLED_FLAG     MTL_TRANSACTIONS_ENABLED_FLAG
                        ,P_IN_ITEM(i).STOCK_ENABLED_FLAG                STOCK_ENABLED_FLAG
                        ,P_IN_ITEM(i).RETURNABLE_FLAG                   RETURNABLE_FLAG
                        ,P_IN_ITEM(i).TAXABLE_FLAG                      TAXABLE_FLAG
                        ,P_IN_ITEM(i).MRP_CALCULATE_ATP_FLAG            MRP_CALCULATE_ATP_FLAG
                        ,P_IN_ITEM(i).ATP_COMPONENTS_FLAG               ATP_COMPONENTS_FLAG
                        ,P_IN_ITEM(i).ATP_FLAG                          ATP_FLAG
                        ,P_IN_ITEM(i).SERVICEABLE_PRODUCT_FLAG          SERVICEABLE_PRODUCT_FLAG
                        ,P_IN_ITEM(i).MATERIAL_BILLABLE_FLAG            MATERIAL_BILLABLE_FLAG
                        ,P_IN_ITEM(i).INVOICEABLE_ITEM_FLAG             INVOICEABLE_ITEM_FLAG
                        ,P_IN_ITEM(i).INVOICE_ENABLED_FLAG              INVOICE_ENABLED_FLAG
                        ,P_IN_ITEM(i).COSTING_ENABLED_FLAG              COSTING_ENABLED_FLAG
                        ,P_IN_ITEM(i).ELECTRONIC_FLAG                   ELECTRONIC_FLAG
                        ,P_IN_ITEM(i).COMMS_NL_TRACKABLE_FLAG           COMMS_NL_TRACKABLE_FLAG
                        ,P_IN_ITEM(i).ORDERABLE_ON_WEB_FLAG             ORDERABLE_ON_WEB_FLAG
                        ,P_IN_ITEM(i).BACK_ORDERABLE_FLAG               BACK_ORDERABLE_FLAG
                        ,P_IN_ITEM(i).INDIVISIBLE_FLAG                  INDIVISIBLE_FLAG
                        ,P_IN_ITEM(i).FINANCING_ALLOWED_FLAG            FINANCING_ALLOWED_FLAG
                        ,P_IN_ITEM(i).SERV_BILLING_ENABLED_FLAG         SERV_BILLING_ENABLED_FLAG
                        ,P_IN_ITEM(i).PLANNED_INV_POINT_FLAG            PLANNED_INV_POINT_FLAG
                        ,P_IN_ITEM(i).SO_AUTHORIZATION_FLAG             SO_AUTHORIZATION_FLAG
                        ,P_IN_ITEM(i).CONSIGNED_FLAG                    CONSIGNED_FLAG
                        ,P_IN_ITEM(i).ASSET_TRACKED_FLAG                ASSET_TRACKED_FLAG
                        ,P_IN_ITEM(i).ALLOW_SUSPEND_FLAG                ALLOW_SUSPEND_FLAG
                        ,P_IN_ITEM(i).ALLOW_TERMINATE_FLAG              ALLOW_TERMINATE_FLAG
                        ,P_IN_ITEM(i).INSPECTION_REQUIRED_FLAG          INSPECTION_REQUIRED_FLAG
                        ,P_IN_ITEM(i).ENGINEERED_ITEM_FLAG              ENGINEERED_ITEM_FLAG
                        ,P_IN_ITEM(i).REVISION_QTY_CONTROL_CODE         REVISION_QTY_CONTROL_CODE
                        ,P_IN_ITEM(i).ITEM_CATALOG_GROUP_ID             ITEM_CATALOG_GROUP_ID
                        ,P_IN_ITEM(i).DEFAULT_SHIPPING_ORG              DEFAULT_SHIPPING_ORG
                        ,P_IN_ITEM(i).QTY_RCV_EXCEPTION_CODE            QTY_RCV_EXCEPTION_CODE
                        ,P_IN_ITEM(i).MARKET_PRICE                      MARKET_PRICE
                        ,P_IN_ITEM(i).HAZARD_CLASS_ID                   HAZARD_CLASS_ID
                        ,P_IN_ITEM(i).QTY_RCV_TOLERANCE                 QTY_RCV_TOLERANCE
                        ,P_IN_ITEM(i).LIST_PRICE_PER_UNIT               LIST_PRICE_PER_UNIT
                        ,P_IN_ITEM(i).UN_NUMBER_ID                      UN_NUMBER_ID
                        ,P_IN_ITEM(i).PRICE_TOLERANCE_PERCENT           PRICE_TOLERANCE_PERCENT
                        ,P_IN_ITEM(i).ROUNDING_FACTOR                   ROUNDING_FACTOR
                        ,P_IN_ITEM(i).UNIT_OF_ISSUE                     UNIT_OF_ISSUE
                        ,P_IN_ITEM(i).LOT_CONTROL_CODE                  LOT_CONTROL_CODE
                        ,P_IN_ITEM(i).SHELF_LIFE_CODE                   SHELF_LIFE_CODE
                        ,P_IN_ITEM(i).SHELF_LIFE_DAYS                   SHELF_LIFE_DAYS
                        ,P_IN_ITEM(i).SERIAL_NUMBER_CONTROL_CODE        SERIAL_NUMBER_CONTROL_CODE
                        ,P_IN_ITEM(i).UNIT_WEIGHT                       UNIT_WEIGHT
                        ,P_IN_ITEM(i).WEIGHT_UOM_CODE                   WEIGHT_UOM_CODE
                        ,P_IN_ITEM(i).VOLUME_UOM_CODE                   VOLUME_UOM_CODE
                        ,P_IN_ITEM(i).UNIT_VOLUME                       UNIT_VOLUME
                        ,P_IN_ITEM(i).ORDER_COST                        ORDER_COST
                        ,P_IN_ITEM(i).DIMENSION_UOM_CODE                DIMENSION_UOM_CODE
                        ,P_IN_ITEM(i).UNIT_LENGTH                       UNIT_LENGTH
                        ,P_IN_ITEM(i).UNIT_WIDTH                        UNIT_WIDTH
                        ,P_IN_ITEM(i).UNIT_HEIGHT                       UNIT_HEIGHT
                        ,P_IN_ITEM(i).ACCOUNTING_RULE_ID	            ACCOUNTING_RULE_ID	    
                        ,P_IN_ITEM(i).BASE_ITEM_ID	                    BASE_ITEM_ID	            
                        ,P_IN_ITEM(i).BOM_ITEM_TYPE	                    BOM_ITEM_TYPE	            
                        ,P_IN_ITEM(i).INVENTORY_ORGANIZATION_ID	        INVENTORY_ORGANIZATION_ID	
                        ,P_IN_ITEM(i).INVOICING_RULE_ID	                INVOICING_RULE_ID	        
                        ,P_IN_ITEM(i).MASTER_ORG_ID	                    MASTER_ORG_ID	            
                        ,P_IN_ITEM(i).ORGANIZATION_ID	                ORGANIZATION_ID	        
                        ,P_IN_ITEM(i).PICK_COMPONENTS_FLAG	            PICK_COMPONENTS_FLAG	    
                        ,P_IN_ITEM(i).PRIMARY_UOM_CODE	                PRIMARY_UOM_CODE	        
                        ,P_IN_ITEM(i).SECONDARY_UOM_CODE	            SECONDARY_UOM_CODE	    
                        ,P_IN_ITEM(i).SOURCE_TYPE	                    SOURCE_TYPE	            
                        ,P_IN_ITEM(i).START_AUTO_SERIAL_NUMBER	        START_AUTO_SERIAL_NUMBER	
                        ,P_IN_ITEM(i).SUMMARY_FLAG	                    SUMMARY_FLAG	            
                        ,P_IN_ITEM(i).ATTRIBUTE_CATEGORY                ATTRIBUTE_CATEGORY
                        ,P_IN_ITEM(i).ATTRIBUTE1                        ATTRIBUTE1
                        ,P_IN_ITEM(i).ATTRIBUTE2                        ATTRIBUTE2
                        ,P_IN_ITEM(i).ATTRIBUTE3                        ATTRIBUTE3
                        ,P_IN_ITEM(i).ATTRIBUTE4                        ATTRIBUTE4
                        ,P_IN_ITEM(i).ATTRIBUTE5                        ATTRIBUTE5
                        ,P_IN_ITEM(i).ATTRIBUTE6                        ATTRIBUTE6
                        ,P_IN_ITEM(i).ATTRIBUTE7                        ATTRIBUTE7
                        ,P_IN_ITEM(i).ATTRIBUTE8                        ATTRIBUTE8
                        ,P_IN_ITEM(i).ATTRIBUTE9                        ATTRIBUTE9
                        ,P_IN_ITEM(i).ATTRIBUTE10                       ATTRIBUTE10
                        ,P_IN_ITEM(i).ATTRIBUTE11                       ATTRIBUTE11
                        ,P_IN_ITEM(i).ATTRIBUTE12                       ATTRIBUTE12
                        ,P_IN_ITEM(i).ATTRIBUTE13                       ATTRIBUTE13
                        ,P_IN_ITEM(i).ATTRIBUTE14                       ATTRIBUTE14
                        ,P_IN_ITEM(i).ATTRIBUTE15                       ATTRIBUTE15
                        ,P_IN_ITEM(i).ENABLED_FLAG                      ENABLED_FLAG        
                        ,P_IN_ITEM(i).START_DATE_ACTIVE                 START_DATE_ACTIVE  
                        ,P_IN_ITEM(i).END_DATE_ACTIVE                   END_DATE_ACTIVE    
                        ,P_IN_ITEM(i).LAST_UPDATE_LOGIN                 LAST_UPDATE_LOGIN   
                        ,P_IN_ITEM(i).CREATED_BY                        CREATED_BY          
                        ,P_IN_ITEM(i).CREATION_DATE                     CREATION_DATE       
                        ,P_IN_ITEM(i).LAST_UPDATED_BY                   LAST_UPDATED_BY     
                        ,P_IN_ITEM(i).LAST_UPDATE_DATE                  LAST_UPDATE_DATE    
                        ,P_IN_OIC_INSTANCE_ID                           OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.SOURCE_ITEM_ID      = tmp.SOURCE_ITEM_ID  
                    AND tbl.ORG_ID              = tmp.ORG_ID
                )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SOURCE_ITEM_ID
                        ,ORG_ID
                        ,LANGUAGE
                        ,ITEM_NUMBER
                        ,DESCRIPTION
                        ,LONG_DESCRIPTION
                        ,ITEM_TYPE
                        ,APPROVAL_STATUS
                        ,TEMPLATE_NAME
                        ,CATEGORY_SET_ID               
                        ,CATALOG_CODE                  
                        ,PURCHASING_ITEM_FLAG
                        ,SHIPPABLE_ITEM_FLAG
                        ,CUSTOMER_ORDER_FLAG
                        ,INTERNAL_ORDER_FLAG
                        ,INVENTORY_ITEM_FLAG
                        ,INVENTORY_ASSET_FLAG
                        ,PURCHASING_ENABLED_FLAG
                        ,CUSTOMER_ORDER_ENABLED_FLAG
                        ,INTERNAL_ORDER_ENABLED_FLAG
                        ,SO_TRANSACTIONS_FLAG
                        ,MTL_TRANSACTIONS_ENABLED_FLAG
                        ,STOCK_ENABLED_FLAG
                        ,RETURNABLE_FLAG
                        ,TAXABLE_FLAG
                        ,MRP_CALCULATE_ATP_FLAG
                        ,ATP_COMPONENTS_FLAG
                        ,ATP_FLAG
                        ,SERVICEABLE_PRODUCT_FLAG
                        ,MATERIAL_BILLABLE_FLAG
                        ,INVOICEABLE_ITEM_FLAG
                        ,INVOICE_ENABLED_FLAG
                        ,COSTING_ENABLED_FLAG
                        ,ELECTRONIC_FLAG
                        ,COMMS_NL_TRACKABLE_FLAG
                        ,ORDERABLE_ON_WEB_FLAG
                        ,BACK_ORDERABLE_FLAG
                        ,INDIVISIBLE_FLAG
                        ,FINANCING_ALLOWED_FLAG
                        ,SERV_BILLING_ENABLED_FLAG
                        ,PLANNED_INV_POINT_FLAG
                        ,SO_AUTHORIZATION_FLAG
                        ,CONSIGNED_FLAG
                        ,ASSET_TRACKED_FLAG
                        ,ALLOW_SUSPEND_FLAG
                        ,ALLOW_TERMINATE_FLAG
                        ,INSPECTION_REQUIRED_FLAG
                        ,ENGINEERED_ITEM_FLAG
                        ,REVISION_QTY_CONTROL_CODE
                        ,ITEM_CATALOG_GROUP_ID
                        ,DEFAULT_SHIPPING_ORG
                        ,QTY_RCV_EXCEPTION_CODE
                        ,MARKET_PRICE
                        ,HAZARD_CLASS_ID
                        ,QTY_RCV_TOLERANCE
                        ,LIST_PRICE_PER_UNIT
                        ,UN_NUMBER_ID
                        ,PRICE_TOLERANCE_PERCENT
                        ,ROUNDING_FACTOR
                        ,UNIT_OF_ISSUE
                        ,LOT_CONTROL_CODE
                        ,SHELF_LIFE_CODE
                        ,SHELF_LIFE_DAYS
                        ,SERIAL_NUMBER_CONTROL_CODE
                        ,UNIT_WEIGHT
                        ,WEIGHT_UOM_CODE
                        ,VOLUME_UOM_CODE
                        ,UNIT_VOLUME
                        ,ORDER_COST
                        ,DIMENSION_UOM_CODE
                        ,UNIT_LENGTH
                        ,UNIT_WIDTH
                        ,UNIT_HEIGHT
                        ,ACCOUNTING_RULE_ID	       
                        ,BASE_ITEM_ID	           
                        ,BOM_ITEM_TYPE	           
                        ,INVENTORY_ORGANIZATION_ID
                        ,INVOICING_RULE_ID	       
                        ,MASTER_ORG_ID	           
                        ,ORGANIZATION_ID	       
                        ,PICK_COMPONENTS_FLAG	   
                        ,PRIMARY_UOM_CODE	       
                        ,SECONDARY_UOM_CODE	       
                        ,SOURCE_TYPE	           
                        ,START_AUTO_SERIAL_NUMBER	
                        ,SUMMARY_FLAG
                        ,ATTRIBUTE_CATEGORY
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
                        ,ENABLED_FLAG        
                        ,START_DATE_ACTIVE  
                        ,END_DATE_ACTIVE
                        ,LAST_UPDATE_LOGIN
                        ,CREATED_BY       
                        ,CREATION_DATE    
                        ,LAST_UPDATED_BY  
                        ,LAST_UPDATE_DATE 
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.SOURCE_ITEM_ID 
                        ,tmp.ORG_ID 
                        ,tmp.LANGUAGE 
                        ,tmp.ITEM_NUMBER 
                        ,tmp.DESCRIPTION 
                        ,tmp.LONG_DESCRIPTION 
                        ,tmp.ITEM_TYPE 
                        ,tmp.APPROVAL_STATUS 
                        ,tmp.TEMPLATE_NAME 
                        ,tmp.CATEGORY_SET_ID                
                        ,tmp.CATALOG_CODE                   
                        ,tmp.PURCHASING_ITEM_FLAG 
                        ,tmp.SHIPPABLE_ITEM_FLAG 
                        ,tmp.CUSTOMER_ORDER_FLAG 
                        ,tmp.INTERNAL_ORDER_FLAG 
                        ,tmp.INVENTORY_ITEM_FLAG 
                        ,tmp.INVENTORY_ASSET_FLAG 
                        ,tmp.PURCHASING_ENABLED_FLAG 
                        ,tmp.CUSTOMER_ORDER_ENABLED_FLAG 
                        ,tmp.INTERNAL_ORDER_ENABLED_FLAG 
                        ,tmp.SO_TRANSACTIONS_FLAG 
                        ,tmp.MTL_TRANSACTIONS_ENABLED_FLAG 
                        ,tmp.STOCK_ENABLED_FLAG 
                        ,tmp.RETURNABLE_FLAG 
                        ,tmp.TAXABLE_FLAG 
                        ,tmp.MRP_CALCULATE_ATP_FLAG 
                        ,tmp.ATP_COMPONENTS_FLAG 
                        ,tmp.ATP_FLAG 
                        ,tmp.SERVICEABLE_PRODUCT_FLAG 
                        ,tmp.MATERIAL_BILLABLE_FLAG 
                        ,tmp.INVOICEABLE_ITEM_FLAG 
                        ,tmp.INVOICE_ENABLED_FLAG 
                        ,tmp.COSTING_ENABLED_FLAG 
                        ,tmp.ELECTRONIC_FLAG 
                        ,tmp.COMMS_NL_TRACKABLE_FLAG 
                        ,tmp.ORDERABLE_ON_WEB_FLAG 
                        ,tmp.BACK_ORDERABLE_FLAG 
                        ,tmp.INDIVISIBLE_FLAG 
                        ,tmp.FINANCING_ALLOWED_FLAG 
                        ,tmp.SERV_BILLING_ENABLED_FLAG 
                        ,tmp.PLANNED_INV_POINT_FLAG 
                        ,tmp.SO_AUTHORIZATION_FLAG 
                        ,tmp.CONSIGNED_FLAG 
                        ,tmp.ASSET_TRACKED_FLAG 
                        ,tmp.ALLOW_SUSPEND_FLAG 
                        ,tmp.ALLOW_TERMINATE_FLAG 
                        ,tmp.INSPECTION_REQUIRED_FLAG 
                        ,tmp.ENGINEERED_ITEM_FLAG 
                        ,tmp.REVISION_QTY_CONTROL_CODE 
                        ,tmp.ITEM_CATALOG_GROUP_ID 
                        ,tmp.DEFAULT_SHIPPING_ORG 
                        ,tmp.QTY_RCV_EXCEPTION_CODE 
                        ,tmp.MARKET_PRICE 
                        ,tmp.HAZARD_CLASS_ID 
                        ,tmp.QTY_RCV_TOLERANCE 
                        ,tmp.LIST_PRICE_PER_UNIT 
                        ,tmp.UN_NUMBER_ID 
                        ,tmp.PRICE_TOLERANCE_PERCENT 
                        ,tmp.ROUNDING_FACTOR 
                        ,tmp.UNIT_OF_ISSUE 
                        ,tmp.LOT_CONTROL_CODE 
                        ,tmp.SHELF_LIFE_CODE 
                        ,tmp.SHELF_LIFE_DAYS 
                        ,tmp.SERIAL_NUMBER_CONTROL_CODE 
                        ,tmp.UNIT_WEIGHT 
                        ,tmp.WEIGHT_UOM_CODE 
                        ,tmp.VOLUME_UOM_CODE 
                        ,tmp.UNIT_VOLUME 
                        ,tmp.ORDER_COST 
                        ,tmp.DIMENSION_UOM_CODE 
                        ,tmp.UNIT_LENGTH 
                        ,tmp.UNIT_WIDTH 
                        ,tmp.UNIT_HEIGHT
                        ,tmp.ACCOUNTING_RULE_ID	              
                        ,tmp.BASE_ITEM_ID	                  
                        ,tmp.BOM_ITEM_TYPE	                  
                        ,tmp.INVENTORY_ORGANIZATION_ID	      
                        ,tmp.INVOICING_RULE_ID	              
                        ,tmp.MASTER_ORG_ID	                  
                        ,tmp.ORGANIZATION_ID	              
                        ,tmp.PICK_COMPONENTS_FLAG	          
                        ,tmp.PRIMARY_UOM_CODE	              
                        ,tmp.SECONDARY_UOM_CODE	              
                        ,tmp.SOURCE_TYPE	                  
                        ,tmp.START_AUTO_SERIAL_NUMBER	      
                        ,tmp.SUMMARY_FLAG
                        ,tmp.ATTRIBUTE_CATEGORY 
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
                        ,tmp.ENABLED_FLAG         
                        ,tmp.START_DATE_ACTIVE   
                        ,tmp.END_DATE_ACTIVE
                        ,tmp.LAST_UPDATE_LOGIN
                        ,tmp.CREATED_BY       
                        ,tmp.CREATION_DATE    
                        ,tmp.LAST_UPDATED_BY  
                        ,tmp.LAST_UPDATE_DATE
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         LANGUAGE                           = tmp.LANGUAGE      
                        ,ITEM_NUMBER                        = tmp.ITEM_NUMBER                      
                        ,DESCRIPTION                        = tmp.DESCRIPTION                      
                        ,LONG_DESCRIPTION                   = tmp.LONG_DESCRIPTION                 
                        ,ITEM_TYPE                          = tmp.ITEM_TYPE                        
                        ,APPROVAL_STATUS                    = tmp.APPROVAL_STATUS                  
                        ,TEMPLATE_NAME                      = tmp.TEMPLATE_NAME                    
                        ,CATEGORY_SET_ID                    = tmp.CATEGORY_SET_ID                  
                        ,CATALOG_CODE                       = tmp.CATALOG_CODE                     
                        ,PURCHASING_ITEM_FLAG               = tmp.PURCHASING_ITEM_FLAG             
                        ,SHIPPABLE_ITEM_FLAG                = tmp.SHIPPABLE_ITEM_FLAG              
                        ,CUSTOMER_ORDER_FLAG                = tmp.CUSTOMER_ORDER_FLAG              
                        ,INTERNAL_ORDER_FLAG                = tmp.INTERNAL_ORDER_FLAG              
                        ,INVENTORY_ITEM_FLAG                = tmp.INVENTORY_ITEM_FLAG              
                        ,INVENTORY_ASSET_FLAG               = tmp.INVENTORY_ASSET_FLAG             
                        ,PURCHASING_ENABLED_FLAG            = tmp.PURCHASING_ENABLED_FLAG          
                        ,CUSTOMER_ORDER_ENABLED_FLAG        = tmp.CUSTOMER_ORDER_ENABLED_FLAG      
                        ,INTERNAL_ORDER_ENABLED_FLAG        = tmp.INTERNAL_ORDER_ENABLED_FLAG      
                        ,SO_TRANSACTIONS_FLAG               = tmp.SO_TRANSACTIONS_FLAG             
                        ,MTL_TRANSACTIONS_ENABLED_FLAG      = tmp.MTL_TRANSACTIONS_ENABLED_FLAG    
                        ,STOCK_ENABLED_FLAG                 = tmp.STOCK_ENABLED_FLAG               
                        ,RETURNABLE_FLAG                    = tmp.RETURNABLE_FLAG                  
                        ,TAXABLE_FLAG                       = tmp.TAXABLE_FLAG                     
                        ,MRP_CALCULATE_ATP_FLAG             = tmp.MRP_CALCULATE_ATP_FLAG           
                        ,ATP_COMPONENTS_FLAG                = tmp.ATP_COMPONENTS_FLAG              
                        ,ATP_FLAG                           = tmp.ATP_FLAG                         
                        ,SERVICEABLE_PRODUCT_FLAG           = tmp.SERVICEABLE_PRODUCT_FLAG         
                        ,MATERIAL_BILLABLE_FLAG             = tmp.MATERIAL_BILLABLE_FLAG           
                        ,INVOICEABLE_ITEM_FLAG              = tmp.INVOICEABLE_ITEM_FLAG            
                        ,INVOICE_ENABLED_FLAG               = tmp.INVOICE_ENABLED_FLAG             
                        ,COSTING_ENABLED_FLAG               = tmp.COSTING_ENABLED_FLAG             
                        ,ELECTRONIC_FLAG                    = tmp.ELECTRONIC_FLAG                  
                        ,COMMS_NL_TRACKABLE_FLAG            = tmp.COMMS_NL_TRACKABLE_FLAG          
                        ,ORDERABLE_ON_WEB_FLAG              = tmp.ORDERABLE_ON_WEB_FLAG            
                        ,BACK_ORDERABLE_FLAG                = tmp.BACK_ORDERABLE_FLAG              
                        ,INDIVISIBLE_FLAG                   = tmp.INDIVISIBLE_FLAG                 
                        ,FINANCING_ALLOWED_FLAG             = tmp.FINANCING_ALLOWED_FLAG           
                        ,SERV_BILLING_ENABLED_FLAG          = tmp.SERV_BILLING_ENABLED_FLAG        
                        ,PLANNED_INV_POINT_FLAG             = tmp.PLANNED_INV_POINT_FLAG           
                        ,SO_AUTHORIZATION_FLAG              = tmp.SO_AUTHORIZATION_FLAG            
                        ,CONSIGNED_FLAG                     = tmp.CONSIGNED_FLAG                   
                        ,ASSET_TRACKED_FLAG                 = tmp.ASSET_TRACKED_FLAG               
                        ,ALLOW_SUSPEND_FLAG                 = tmp.ALLOW_SUSPEND_FLAG               
                        ,ALLOW_TERMINATE_FLAG               = tmp.ALLOW_TERMINATE_FLAG             
                        ,INSPECTION_REQUIRED_FLAG           = tmp.INSPECTION_REQUIRED_FLAG         
                        ,ENGINEERED_ITEM_FLAG               = tmp.ENGINEERED_ITEM_FLAG             
                        ,REVISION_QTY_CONTROL_CODE          = tmp.REVISION_QTY_CONTROL_CODE        
                        ,ITEM_CATALOG_GROUP_ID              = tmp.ITEM_CATALOG_GROUP_ID            
                        ,DEFAULT_SHIPPING_ORG               = tmp.DEFAULT_SHIPPING_ORG             
                        ,QTY_RCV_EXCEPTION_CODE             = tmp.QTY_RCV_EXCEPTION_CODE           
                        ,MARKET_PRICE                       = tmp.MARKET_PRICE                     
                        ,HAZARD_CLASS_ID                    = tmp.HAZARD_CLASS_ID                  
                        ,QTY_RCV_TOLERANCE                  = tmp.QTY_RCV_TOLERANCE                
                        ,LIST_PRICE_PER_UNIT                = tmp.LIST_PRICE_PER_UNIT              
                        ,UN_NUMBER_ID                       = tmp.UN_NUMBER_ID                     
                        ,PRICE_TOLERANCE_PERCENT            = tmp.PRICE_TOLERANCE_PERCENT          
                        ,ROUNDING_FACTOR                    = tmp.ROUNDING_FACTOR                  
                        ,UNIT_OF_ISSUE                      = tmp.UNIT_OF_ISSUE                    
                        ,LOT_CONTROL_CODE                   = tmp.LOT_CONTROL_CODE                 
                        ,SHELF_LIFE_CODE                    = tmp.SHELF_LIFE_CODE                  
                        ,SHELF_LIFE_DAYS                    = tmp.SHELF_LIFE_DAYS                  
                        ,SERIAL_NUMBER_CONTROL_CODE         = tmp.SERIAL_NUMBER_CONTROL_CODE       
                        ,UNIT_WEIGHT                        = tmp.UNIT_WEIGHT                      
                        ,WEIGHT_UOM_CODE                    = tmp.WEIGHT_UOM_CODE                  
                        ,VOLUME_UOM_CODE                    = tmp.VOLUME_UOM_CODE                  
                        ,UNIT_VOLUME                        = tmp.UNIT_VOLUME                      
                        ,ORDER_COST                         = tmp.ORDER_COST                       
                        ,DIMENSION_UOM_CODE                 = tmp.DIMENSION_UOM_CODE               
                        ,UNIT_LENGTH                        = tmp.UNIT_LENGTH                      
                        ,UNIT_WIDTH                         = tmp.UNIT_WIDTH                       
                        ,UNIT_HEIGHT                        = tmp.UNIT_HEIGHT                      
                        ,ACCOUNTING_RULE_ID	                = tmp.ACCOUNTING_RULE_ID	                           
                        ,BASE_ITEM_ID	                    = tmp.BASE_ITEM_ID	                               
                        ,BOM_ITEM_TYPE	                    = tmp.BOM_ITEM_TYPE	                               
                        ,INVENTORY_ORGANIZATION_ID	        = tmp.INVENTORY_ORGANIZATION_ID                     
                        ,INVOICING_RULE_ID	                = tmp.INVOICING_RULE_ID	                           
                        ,MASTER_ORG_ID	                    = tmp.MASTER_ORG_ID	                               
                        ,ORGANIZATION_ID	                = tmp.ORGANIZATION_ID	                           
                        ,PICK_COMPONENTS_FLAG	            = tmp.PICK_COMPONENTS_FLAG	                       
                        ,PRIMARY_UOM_CODE	                = tmp.PRIMARY_UOM_CODE	                           
                        ,SECONDARY_UOM_CODE	                = tmp.SECONDARY_UOM_CODE	                           
                        ,SOURCE_TYPE	                    = tmp.SOURCE_TYPE	                               
                        ,START_AUTO_SERIAL_NUMBER	        = tmp.START_AUTO_SERIAL_NUMBER                     
                        ,SUMMARY_FLAG	                    = tmp.SUMMARY_FLAG	                               
                        ,ATTRIBUTE_CATEGORY                 = tmp.ATTRIBUTE_CATEGORY               
                        ,ATTRIBUTE1                         = tmp.ATTRIBUTE1                       
                        ,ATTRIBUTE2                         = tmp.ATTRIBUTE2                       
                        ,ATTRIBUTE3                         = tmp.ATTRIBUTE3                       
                        ,ATTRIBUTE4                         = tmp.ATTRIBUTE4                       
                        ,ATTRIBUTE5                         = tmp.ATTRIBUTE5                       
                        ,ATTRIBUTE6                         = tmp.ATTRIBUTE6                       
                        ,ATTRIBUTE7                         = tmp.ATTRIBUTE7                       
                        ,ATTRIBUTE8                         = tmp.ATTRIBUTE8                       
                        ,ATTRIBUTE9                         = tmp.ATTRIBUTE9                       
                        ,ATTRIBUTE10                        = tmp.ATTRIBUTE10                      
                        ,ATTRIBUTE11                        = tmp.ATTRIBUTE11                      
                        ,ATTRIBUTE12                        = tmp.ATTRIBUTE12                      
                        ,ATTRIBUTE13                        = tmp.ATTRIBUTE13                      
                        ,ATTRIBUTE14                        = tmp.ATTRIBUTE14                      
                        ,ATTRIBUTE15                        = tmp.ATTRIBUTE15                      
                        ,ENABLED_FLAG                       = tmp.ENABLED_FLAG                     
                        ,START_DATE_ACTIVE                  = tmp.START_DATE_ACTIVE                
                        ,END_DATE_ACTIVE                    = tmp.END_DATE_ACTIVE                  
                        ,LAST_UPDATE_LOGIN			        = tmp.LAST_UPDATE_LOGIN
                        ,CREATED_BY			                = tmp.CREATED_BY
                        ,CREATION_DATE			            = tmp.CREATION_DATE
                        ,LAST_UPDATED_BY			        = tmp.LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE			        = tmp.LAST_UPDATE_DATE
                    WHERE	1=1
                    AND SOURCE_ITEM_ID                      = tmp.SOURCE_ITEM_ID
                    AND ORG_ID                              = tmp.ORG_ID;
                
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
    
END CHM_ITEM_PKG;
/





