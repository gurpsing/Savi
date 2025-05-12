create or replace PACKAGE CHM_SHIPMENT_DETAIL_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_SHIPMENT_DETAIL_PKG                                                                                                               *
    * Purpose                        : Package Specification for CHM Shipment Detail sync from fusion                                                                        *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 31-Jan-2024                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 31-Jan-2024   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/
AS
    TYPE REC_CHM_SHIPMENT_DETAIL IS RECORD (
             FULFILL_LINE_ID	             NUMBER
            ,HEADER_ID             	             NUMBER
            ,LINE_ID               	             NUMBER
            ,DELIVERY_ID           	             NUMBER
            ,DELIVERY_DETAIL_ID    	             NUMBER
            ,DELIVERY_ASSIGNMENT_ID	             NUMBER
            ,ORGANIZATION_NAME	             VARCHAR2(4000 BYTE)
            ,SHIPMENT_NO	                 VARCHAR2(4000 BYTE)
            ,STATUS_NAME	                 VARCHAR2(4000 BYTE)
            ,WAYBILL	                     VARCHAR2(4000 BYTE)
            ,FOB_CODE	                     VARCHAR2(4000 BYTE)
            ,CONFIRMED_BY	                 VARCHAR2(4000 BYTE)
            ,NET_WEIGHT	                     NUMBER
            ,UOM	                         VARCHAR2(4000 BYTE)
            ,SHIP_CONFIRM_ACK	             VARCHAR2(4000 BYTE)
            ,SHIP_METHOD	                 VARCHAR2(4000 BYTE)
            ,SHIP_METHOD_CODE	             VARCHAR2(4000 BYTE)
            ,SERVICE_LEVEL	                 VARCHAR2(4000 BYTE)
            ,SHIPPING_STATUS	             VARCHAR2(4000 BYTE)
            ,SOURCE_HEADER_NUMBER	         VARCHAR2(4000 BYTE)
            ,WSH_DESC	                     VARCHAR2(4000 BYTE)
            ,ITEM_DESCRIPTION	             VARCHAR2(4000 BYTE)
            ,WSH_SHIPQTY	                 NUMBER
            ,SALESPERSON	                 VARCHAR2(4000 BYTE)
            ,REQUESTED_QUANTITY	             NUMBER
            ,PRIMARY_UOM_CODE	             VARCHAR2(4000 BYTE)
            ,SKU	                         VARCHAR2(4000 BYTE)
            ,FREIGHT_AMT	                 NUMBER
            ,ORIG_FREIGHT	                 VARCHAR2(4000 BYTE)
            ,FREIGHT_ADDER	                 VARCHAR2(4000 BYTE)
            ,FREIGHT_COST_TYPE_MEANING	     VARCHAR2(4000 BYTE)
            ,CUST_REQ_OTD_REASON	         VARCHAR2(4000 BYTE)
            ,ESTIMATED_TIME_OF_ARRIVAL	     VARCHAR2(4000 BYTE)
            ,ORDER_NUMBER	                 VARCHAR2(4000 BYTE)
            ,LINE_NUMBER	                 VARCHAR2(4000 BYTE)
            ,LINE_STATUS	                 VARCHAR2(4000 BYTE)
            ,ORDER_TYPE	                     VARCHAR2(4000 BYTE)
            ,CUST_PO_NUMBER	                 VARCHAR2(4000 BYTE)
            ,SCHEDULED_SHIP_DATE	         VARCHAR2(4000 BYTE)
            ,ACTUAL_SHIPMENT_DATE            VARCHAR2(4000 BYTE)
            ,WEEK                            VARCHAR2(4000 BYTE)
            ,SHIP_DATE                       VARCHAR2(4000 BYTE)
            ,ACTUAL_SHIP_DATE                VARCHAR2(4000 BYTE)
            ,ORDER_DATE                      VARCHAR2(4000 BYTE)
            ,UNIT_SELLING_PRICE              NUMBER
            ,EXTENDED_AMOUNT                 NUMBER
            ,CURRENCY_CODE                   VARCHAR2(4000 BYTE)
            ,SHIPPING_INSTRUCTIONS           VARCHAR2(4000 BYTE)
            ,SUBINVENTORY                    VARCHAR2(4000 BYTE)
            ,WAREHOUSE                       VARCHAR2(4000 BYTE)
            ,REQUEST_DATE                    VARCHAR2(4000 BYTE)
            ,PROMISE_DATE                    VARCHAR2(4000 BYTE)
            ,CUST_REQUEST_DATE               VARCHAR2(4000 BYTE)
            ,SITE_USE_CODE                   VARCHAR2(4000 BYTE)
            ,SHIPTO_LOCATION                 VARCHAR2(4000 BYTE)
            ,SHIP_TO_CUSTOMER_NAME           VARCHAR2(4000 BYTE)
            ,ADDRESS1                        VARCHAR2(4000 BYTE)
            ,ADDRESS2                        VARCHAR2(4000 BYTE)
            ,ADDRESS3                        VARCHAR2(4000 BYTE)
            ,CITY                            VARCHAR2(4000 BYTE)
            ,STATE                           VARCHAR2(4000 BYTE)
            ,ZIP_CODE                        VARCHAR2(4000 BYTE)
            ,COUNTRY                         VARCHAR2(4000 BYTE)
            ,PARTY_ID                        NUMBER
            ,PARTY_NUMBER                    VARCHAR2(4000 BYTE)
            ,CUST_ACCOUNT_ID                 NUMBER
            ,CUSTOMER_NUMBER                 VARCHAR2(4000 BYTE)
            ,CUSTOMER_NAME                   VARCHAR2(4000 BYTE)
            ,ITEM_COST                       NUMBER
            ,PRODUCT_TYPE                    VARCHAR2(4000 BYTE)
            ,PRODUCT_FAMILY                  VARCHAR2(4000 BYTE)
            ,DESTINATION_SUBINVENTORY_CODE   VARCHAR2(4000 BYTE)
            ,DESTINATION_ORG_NAME            VARCHAR2(4000 BYTE)
            ,DESTINATION_LOC_NAME            VARCHAR2(4000 BYTE)
            ,BOOKED_DATE                     VARCHAR2(4000 BYTE)
            ,BOOKED_BY                       VARCHAR2(4000 BYTE)
            ,IS_BOOKED_BY_CREATOR            VARCHAR2(4000 BYTE)
            ,ATTRIBUTE1                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE2                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE3                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE4                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE5                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE6                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE7                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE8                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE9                      VARCHAR2(4000 BYTE) 
            ,ATTRIBUTE10                     VARCHAR2(4000 BYTE)
            ,OIC_INSTANCE_ID                 VARCHAR2(4000 BYTE)   ------ V1.1
            ,CREATED_BY                      VARCHAR2(4000 BYTE)
            ,LAST_UPDATED_BY                 VARCHAR2(4000 BYTE)
    );

    TYPE TBL_CHM_SHIPMENT_DETAIL IS TABLE OF REC_CHM_SHIPMENT_DETAIL;

    --Procedure to merge shipment data received from fusion   
    PROCEDURE MERGE_DATA (
        P_IN_CHM_SHIPMENT_DETAIL IN TBL_CHM_SHIPMENT_DETAIL,
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2,             ------- V1.1
        P_OUT_RECORDS_FETCHED   OUT NUMBER,
        P_OUT_RECORDS_MERGED    OUT NUMBER,
        P_OUT_ERROR_MESSAGE     OUT VARCHAR2
    );

END CHM_SHIPMENT_DETAIL_PKG;
/