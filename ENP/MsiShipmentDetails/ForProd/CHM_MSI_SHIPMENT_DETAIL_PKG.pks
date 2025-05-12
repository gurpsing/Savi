create or replace PACKAGE CHM_MSI_SHIPMENT_DETAIL_PKG    
/*******************************************************************************************************
* Type                           : PL/SQL Package Specification                                        *
* Package Name                   : CHM_MSI_SHIPMENT_DETAIL_PKG                                         *
* Purpose                        : Package Specification for MSI CHM Shipment Detail sync from fusion  *
* Created By                     : Gurpreet Singh                                                      *
* Created Date                   : 05-Mar-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 05-Mar-2025   Gurpreet Singh                 1.0              Intial Version                         * 
*******************************************************************************************************/
AS
    TYPE REC_CHM_MSI_SHIPMENT_DETAIL IS RECORD (
             SALES_ORDER_ORG_ID             NUMBER
            ,SHIPPING_ORG_ID                NUMBER
            ,HEADER_ID             	        NUMBER
            ,LINE_ID               	        NUMBER
            ,FULFILL_LINE_ID	            NUMBER
            ,DELIVERY_ID    	            NUMBER
            ,DELIVERY_DETAIL_ID    	        NUMBER
            ,DELIVERY_ASSIGNMENT_ID    	    NUMBER
            ,SALES_ORDER_ORG_NAME           VARCHAR2(4000)
            ,SHIPPING_ORG_NAME           	VARCHAR2(4000)
            ,WAREHOUSE           	        VARCHAR2(4000)
            ,SUBINVENTORY           	    VARCHAR2(4000)
            ,ORDER_NUMBER           	    VARCHAR2(4000)
            ,SHIPMENT_NO                    VARCHAR2(4000)
            ,SALES_ORDER_TYPE               VARCHAR2(4000)
            ,LINE_NUMBER                    VARCHAR2(4000)
            ,SALES_ORDER_LINE_TYPE          VARCHAR2(4000)
            ,INVENTORY_ITEM_ID              VARCHAR2(4000)
            ,ENPHASE_PRODUCT_NAME           VARCHAR2(4000)
            ,SERIAL_NUMBER                  VARCHAR2(4000)
            ,ACTUAL_SHIP_DATE               TIMESTAMP(6) WITH TIME ZONE
            ,CUSTOMER_NAME                  VARCHAR2(4000)
            ,CUST_ACCOUNT_ID                NUMBER
            ,CUST_ACCOUNT_NUMBER            VARCHAR2(4000)
            ,SHIPPING_ADDRESS               VARCHAR2(4000)
            ,SHIPPING_LOCATION              VARCHAR2(4000)
            ,COUNTRY                        VARCHAR2(4000)
            ,SYNC_FOR_DATE                  DATE
            ,ATTRIBUTE1                     VARCHAR2(4000) 
            ,ATTRIBUTE2                     VARCHAR2(4000) 
            ,ATTRIBUTE3                     VARCHAR2(4000) 
            ,ATTRIBUTE4                     VARCHAR2(4000) 
            ,ATTRIBUTE5                     VARCHAR2(4000) 
            ,ATTRIBUTE6                     VARCHAR2(4000) 
            ,ATTRIBUTE7                     VARCHAR2(4000) 
            ,ATTRIBUTE8                     VARCHAR2(4000) 
            ,ATTRIBUTE9                     VARCHAR2(4000) 
            ,ATTRIBUTE10                    VARCHAR2(4000)
            ,ATTRIBUTE11                    VARCHAR2(4000)
            ,ATTRIBUTE12                    VARCHAR2(4000)
            ,ATTRIBUTE13                    VARCHAR2(4000)
            ,ATTRIBUTE14                    VARCHAR2(4000)
            ,ATTRIBUTE15                    VARCHAR2(4000)
            ,OIC_INSTANCE_ID                VARCHAR2(4000)
            ,CREATED_BY                     VARCHAR2(4000)
            ,LAST_UPDATED_BY                VARCHAR2(4000)
    );

    TYPE TBL_CHM_MSI_SHIPMENT_DETAIL IS TABLE OF REC_CHM_MSI_SHIPMENT_DETAIL;

    --Procedure to merge shipment data received from fusion   
    PROCEDURE MERGE_DATA (
         P_IN_CHM_MSI_SHIPMENT_DETAIL IN TBL_CHM_MSI_SHIPMENT_DETAIL
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    );
    
    --Procedure to get dates
    PROCEDURE GET_DATES(
         P_IN_FROM_DATE              IN     VARCHAR2 DEFAULT NULL
        ,P_IN_TO_DATE                IN     VARCHAR2 DEFAULT NULL
        ,P_IN_ORDER_NUMBER           IN     VARCHAR2 DEFAULT NULL
        ,P_OUT_DATA                  OUT    SYS_REFCURSOR             
    );
    
    --Procedure to remove duplicate serial records   
    PROCEDURE REMOVE_DUPLICATE_SERIALS (
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    );
    
    
    
END CHM_MSI_SHIPMENT_DETAIL_PKG;
/