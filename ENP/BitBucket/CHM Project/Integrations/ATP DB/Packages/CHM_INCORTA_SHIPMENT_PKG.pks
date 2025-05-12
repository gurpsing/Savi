create or replace PACKAGE CHM_INCORTA_SHIPMENT_PKG
    
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

    TYPE REC_SHIPMENT IS RECORD (
         SHIPPED_DATE   			   VARCHAR2(4000)
        ,SHIPPING_WAREHOUSE			   VARCHAR2(4000) 	
        ,ORDER_TYPE                    VARCHAR2(4000)
        ,PLNUMBER                      VARCHAR2(4000)
        ,SALES_ORDER_NUMBER            VARCHAR2(4000)
        ,SHIPTO_CUSTOMER_NAME          VARCHAR2(4000)
        ,ADDRESS                       VARCHAR2(4000)
        ,CITY                          VARCHAR2(4000)
        ,STATE                         VARCHAR2(4000)
        ,COUNTRYCODE                   VARCHAR2(4000)
        ,SHIPMENT_CARRIER              VARCHAR2(4000)
        ,TRACKING_NUMBER               VARCHAR2(4000)
        ,EXPECTED_DELIVERY_DATE        VARCHAR2(4000)
        ,COUNTRY_NAME                  VARCHAR2(4000)
        ,DELIVERY_STATUS               VARCHAR2(4000)
        ,LATEST_MILESTONE_STATUS       VARCHAR2(4000)
        ,CUSTOMER_PO_NUMBER            VARCHAR2(4000)
        ,DELIVERED_DATE                VARCHAR2(4000)
        ,CREATION_DATE                 DATE 
        ,CREATED_BY                    VARCHAR2(4000) 
        ,LAST_UPDATE_DATE              DATE
        ,LAST_UPDATED_BY               VARCHAR2(4000)
    );

    TYPE TBL_SHIPMENT_DATA IS TABLE OF REC_SHIPMENT;

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
    );

END CHM_INCORTA_SHIPMENT_PKG;
/

