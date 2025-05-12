/**********************************************************************************************************
* Report Name           : MsiShipmentDetailsReport                                                        *
* Purpose               : Report to extract MSI Shipment Details                                          *
*                                                                                                         *
***********************************************************************************************************
* Date          Author                 Version          Description                                       *
* -----------   ---------------------  -------          --------------------------------------------------*
* 27-Feb-2025   Gurpreet Singh         1.0              Initial Version                                   *
* 05-May-2025   Gurpreet Singh         1.1              Addition of inv_serial_numbers in UAT Testing     *
**********************************************************************************************************/
SELECT /*+ parallel(dha) parallel(dla) parallel(dfla) parallel(wda) parallel(wdd) parallel(wnd) */ 
     dha.org_id                                             sales_order_org_id
    ,wnd.organization_id                                    shipping_org_id
    ,dha.header_id                                          header_id
    ,dla.line_id                                            line_id
    ,dfla.fulfill_line_id                                   fulfill_line_id
    ,wda.delivery_id                                        delivery_id
    ,wdd.delivery_detail_id                                 delivery_detail_id 
    ,wda.delivery_assignment_id                             delivery_assignment_id 
    ,(  SELECT hou.name 
        FROM hr_operating_units hou
        WHERE hou.organization_id = dha.org_id
        AND ROWNUM=1 )                                      sales_order_org_name
    ,(  SELECT org.organization_name 
        FROM inv_organization_definitions_v org
        WHERE org.organization_id = wnd.organization_id
        AND ROWNUM=1 )                                      shipping_org_name
    ,(  SELECT organization_code 
        FROM inv_org_parameters org
        WHERE org.organization_id = dfla.fulfill_org_id
        AND ROWNUM=1 )                                      warehouse    
    ,dfla.subinventory                                      subinventory
    ,dha.order_number                                       order_number
    ,wnd.delivery_name                                      shipment_no
    ,dha.order_type_code                                    sales_order_type
    ,dla.display_line_number                                line_number
    ,dla.line_type_code                                     sales_order_line_type
    ,wdd.inventory_item_id                                  inventory_item_id
    ,(  SELECT item_number FROM egp_system_items 
        WHERE inventory_item_id=wdd.inventory_item_id  
        AND ROWNUM=1 )                                      enphase_product_name
    ,iut.serial_number                                      serial_number
    ,TO_CHAR (cast(dfla.actual_ship_date as timestamp) 
        AT TIME ZONE 'PST',
        'YYYY-MM-DD','nls_date_language=American')         actual_ship_date
    ,hp.party_name                                          customer_name
    ,(  SELECT hca.cust_account_id 
        FROM hz_cust_accounts hca,doo_order_addresses doa 
        where doa.ADDRESS_USE_TYPE = 'BILL_TO'   
        AND doa.HEADER_ID =dha.HEADER_ID    
        AND doa.cust_acct_id = hca.cust_account_id
        AND ROWNUM=1 )                                      cust_account_id
    ,(  SELECT hca.account_number 
        FROM hz_cust_accounts hca,doo_order_addresses doa 
        WHERE doa.ADDRESS_USE_TYPE = 'BILL_TO'   
        AND doa.HEADER_ID =dha.HEADER_ID    
        AND doa.cust_acct_id = hca.cust_account_id
        AND ROWNUM=1 )                                      cust_account_number
    ,(  hl.address1     ||' '||
        hl.address2     ||' '||
        hl.address3     ||' '||
        hl.address4     ||' '||
        hl.city         ||' '||
        hl.POSTAL_CODE  ||' '||
        hl.country
      )                                                     shipping_address
    ,wdd.subinventory                                       shipping_location
    ,hl.country                                             country
    ,TO_CHAR(TRUNC(dfla.last_update_date),
        'YYYY-MM-DD','nls_date_language=American')          sync_for_date 
FROM 
     doo_headers_all dha
    ,doo_lines_all dla
    ,doo_fulfill_lines_all dfla
    ,wsh_delivery_details wdd
    ,wsh_delivery_assignments wda
    ,wsh_new_deliveries wnd
    ,doo_order_addresses doas
    ,hz_parties hp
    ,hz_party_sites ship_hps
    ,hz_locations hl
    ,inv_unit_transactions iut 
    ,inv_material_txns imt
    ,inv_serial_numbers isn
WHERE 1=1
AND dha.header_id               = dla.header_id 
AND dla.header_id               = dfla.header_id
AND dla.line_id                 = dfla.line_id
AND wdd.released_status         = 'C'
AND wdd.source_shipment_id      = dfla.fulfill_line_id
and wdd.delivery_detail_id      = wda.delivery_detail_id
AND wda.delivery_id             = wnd.delivery_id
AND dha.header_id               = doas.header_id 
AND doas.ADDRESS_USE_TYPE       = 'SHIP_TO' 
AND doas.party_site_id          = ship_hps.party_site_id
AND doas.party_id               = hp.party_id  
AND ship_hps.location_id        = hl.location_id 
AND dha.sold_to_party_id        = hp.party_id(+)
AND wdd.delivery_detail_id      = imt.picking_line_id  
AND imt.transaction_id          = iut.transaction_id
AND hl.country                  <> 'US'
AND iut.serial_number           = isn.serial_number
AND iut.serial_number           = '482429022022'
AND iut.transaction_date        = (
    select 
      max(isn.initialization_date) 
    from 
      inv_serial_numbers isn 
    where 
      isn.serial_number = iut.serial_number
)
AND( 
    (   :P_ORDER_NUMBER = 'NA' AND 
        (   TRUNC(dfla.last_update_date) 
            BETWEEN 
                TRUNC(NVL(:P_FROM_SHIP_DATE,dfla.last_update_date)) 
            AND
                NVL(
                    DECODE(	:P_TO_SHIP_DATE,
                            'NA',NULL,
                    TRUNC(		to_date(:P_TO_SHIP_DATE,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN')
                    ))
                    ,TRUNC(dfla.last_update_date)
                )
        )
    )
    OR dha.order_number = :P_ORDER_NUMBER
)