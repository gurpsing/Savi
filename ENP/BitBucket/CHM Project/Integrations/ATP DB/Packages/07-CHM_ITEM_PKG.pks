CREATE OR REPLACE PACKAGE CHM_ITEM_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_ITEM_PKG                                                                                                                          *
    * Purpose                        : Package Specification for CHM Item Integration                                                                                        *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 03-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 03-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_ITEM IS RECORD (
         SOURCE_ITEM_ID	                    NUMBER       
        ,ORG_ID	                            NUMBER              
        ,LANGUAGE	                        VARCHAR2(4000)
        ,ITEM_NUMBER	                    VARCHAR2(4000)
        ,DESCRIPTION	                    VARCHAR2(4000)
        ,LONG_DESCRIPTION	                VARCHAR2(4000)
        ,ITEM_TYPE	                        VARCHAR2(4000)
        ,APPROVAL_STATUS	                VARCHAR2(4000)
        ,TEMPLATE_NAME	                    VARCHAR2(4000)
        ,CATEGORY_SET_ID                    NUMBER
        ,CATALOG_CODE                       VARCHAR2(4000)
        ,PURCHASING_ITEM_FLAG	            CHAR(1)
        ,SHIPPABLE_ITEM_FLAG	            CHAR(1)
        ,CUSTOMER_ORDER_FLAG	            CHAR(1)
        ,INTERNAL_ORDER_FLAG	            CHAR(1)
        ,INVENTORY_ITEM_FLAG	            CHAR(1)
        ,INVENTORY_ASSET_FLAG	            CHAR(1)
        ,PURCHASING_ENABLED_FLAG	        CHAR(1)
        ,CUSTOMER_ORDER_ENABLED_FLAG	    CHAR(1)
        ,INTERNAL_ORDER_ENABLED_FLAG	    CHAR(1)
        ,SO_TRANSACTIONS_FLAG	            CHAR(1)
        ,MTL_TRANSACTIONS_ENABLED_FLAG	    CHAR(1)
        ,STOCK_ENABLED_FLAG	                CHAR(1)
        ,RETURNABLE_FLAG	                CHAR(1)
        ,TAXABLE_FLAG	                    CHAR(1)
        ,MRP_CALCULATE_ATP_FLAG	            CHAR(1)
        ,ATP_COMPONENTS_FLAG	            CHAR(1)
        ,ATP_FLAG	                        CHAR(1)
        ,SERVICEABLE_PRODUCT_FLAG	        CHAR(1)
        ,MATERIAL_BILLABLE_FLAG	            CHAR(1)
        ,INVOICEABLE_ITEM_FLAG	            CHAR(1)
        ,INVOICE_ENABLED_FLAG	            CHAR(1)
        ,COSTING_ENABLED_FLAG	            CHAR(1)
        ,ELECTRONIC_FLAG	                CHAR(1)
        ,COMMS_NL_TRACKABLE_FLAG	        CHAR(1)
        ,ORDERABLE_ON_WEB_FLAG	            CHAR(1)
        ,BACK_ORDERABLE_FLAG	            CHAR(1)
        ,INDIVISIBLE_FLAG	                CHAR(1)
        ,FINANCING_ALLOWED_FLAG	            CHAR(1)
        ,SERV_BILLING_ENABLED_FLAG	        CHAR(1)
        ,PLANNED_INV_POINT_FLAG	            CHAR(1)
        ,SO_AUTHORIZATION_FLAG	            CHAR(1)
        ,CONSIGNED_FLAG	                    CHAR(1)
        ,ASSET_TRACKED_FLAG	                CHAR(1)
        ,ALLOW_SUSPEND_FLAG	                CHAR(1)
        ,ALLOW_TERMINATE_FLAG	            CHAR(1)
        ,INSPECTION_REQUIRED_FLAG	        CHAR(1)
        ,ENGINEERED_ITEM_FLAG	            CHAR(1)
        ,REVISION_QTY_CONTROL_CODE	        NUMBER
        ,ITEM_CATALOG_GROUP_ID	            NUMBER
        ,DEFAULT_SHIPPING_ORG	            NUMBER
        ,QTY_RCV_EXCEPTION_CODE	            VARCHAR2(4000)
        ,MARKET_PRICE	                    NUMBER
        ,HAZARD_CLASS_ID	                NUMBER
        ,QTY_RCV_TOLERANCE	                NUMBER
        ,LIST_PRICE_PER_UNIT	            NUMBER
        ,UN_NUMBER_ID	                    NUMBER
        ,PRICE_TOLERANCE_PERCENT	        NUMBER
        ,ROUNDING_FACTOR	                NUMBER
        ,UNIT_OF_ISSUE	                    VARCHAR2(4000)
        ,LOT_CONTROL_CODE	                NUMBER
        ,SHELF_LIFE_CODE	                NUMBER
        ,SHELF_LIFE_DAYS	                NUMBER
        ,SERIAL_NUMBER_CONTROL_CODE	        NUMBER
        ,UNIT_WEIGHT	                    NUMBER
        ,WEIGHT_UOM_CODE	                VARCHAR2(4000)
        ,VOLUME_UOM_CODE	                VARCHAR2(4000)
        ,UNIT_VOLUME	                    NUMBER
        ,ORDER_COST	                        NUMBER
        ,DIMENSION_UOM_CODE	                VARCHAR2(4000)
        ,UNIT_LENGTH	                    NUMBER
        ,UNIT_WIDTH	                        NUMBER
        ,UNIT_HEIGHT	                    NUMBER
        ,ACCOUNTING_RULE_ID	                NUMBER
        ,BASE_ITEM_ID	                    NUMBER
        ,BOM_ITEM_TYPE	                    NUMBER
        ,INVENTORY_ORGANIZATION_ID	        NUMBER
        ,INVOICING_RULE_ID	                NUMBER
        ,MASTER_ORG_ID	                    NUMBER
        ,ORGANIZATION_ID	                NUMBER
        ,PICK_COMPONENTS_FLAG	            VARCHAR2(4000)
        ,PRIMARY_UOM_CODE	                VARCHAR2(4000)
        ,SECONDARY_UOM_CODE	                VARCHAR2(4000)
        ,SOURCE_TYPE	                    NUMBER
        ,START_AUTO_SERIAL_NUMBER	        VARCHAR2(4000)
        ,SUMMARY_FLAG	                    VARCHAR2(4000)
        ,ATTRIBUTE_CATEGORY	                VARCHAR2(4000)
        ,ATTRIBUTE1	                        VARCHAR2(4000)
        ,ATTRIBUTE2	                        VARCHAR2(4000)
        ,ATTRIBUTE3	                        VARCHAR2(4000)
        ,ATTRIBUTE4	                        VARCHAR2(4000)
        ,ATTRIBUTE5	                        VARCHAR2(4000)
        ,ATTRIBUTE6	                        VARCHAR2(4000)
        ,ATTRIBUTE7	                        VARCHAR2(4000)
        ,ATTRIBUTE8	                        VARCHAR2(4000)
        ,ATTRIBUTE9	                        VARCHAR2(4000)
        ,ATTRIBUTE10	                    VARCHAR2(4000)
        ,ATTRIBUTE11	                    VARCHAR2(4000)
        ,ATTRIBUTE12	                    VARCHAR2(4000)
        ,ATTRIBUTE13	                    VARCHAR2(4000)
        ,ATTRIBUTE14	                    VARCHAR2(4000)
        ,ATTRIBUTE15	                    VARCHAR2(4000)
        ,ENABLED_FLAG        		        CHAR(1)             
        ,START_DATE_ACTIVE  		        DATE                
        ,END_DATE_ACTIVE    		        DATE
        ,LAST_UPDATE_LOGIN	                VARCHAR2(4000)
        ,CREATED_BY         		        VARCHAR2(4000)      
        ,CREATION_DATE      		        DATE                
        ,LAST_UPDATED_BY    		        VARCHAR2(4000)      
        ,LAST_UPDATE_DATE   		        DATE  
    );
    
    TYPE TBL_ITEM IS TABLE OF REC_ITEM;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_ITEM			            IN      TBL_ITEM
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2    ----- V1.1
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_ITEM_PKG;
/
