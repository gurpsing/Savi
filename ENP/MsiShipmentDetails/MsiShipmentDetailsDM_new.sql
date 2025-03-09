/*************************************************************************************************
* Report Name           : MsiShipmentDetailsReport                                               *
* Purpose               : Report to extract MSI Shipment Details                                 *
*                                                                                                *
**************************************************************************************************
* Date          Author                 Version          Description                              *
* -----------   ---------------------  -------          -----------------------------------------*
* 27-Feb-2025   Gurpreet Singh         1.0              Initial Version                          *
*************************************************************************************************/   
SELECT /*+ parallel(dfla) parallel(wda) parallel(wdd) parallel(wnd) */ 
    
    (   SELECT org.organization_name 
        FROM inv_organization_definitions_v org
        WHERE org.organization_id = wnd.organization_id 
        AND ROWNUM=1 )                                      shipping_org_name
    ,wda.delivery_id    	                                pl_no
    ,wdd.delivery_detail_id                                 delivery_detail_id 
    ,dha.order_number                                       so_no
    ,dha.order_type_code                                    sales_order_type
    ,dla.line_type_code                                     sales_order_line_type
    ,wdd.inventory_item_id                                  inventory_item_id
    ,(  select item_number from egp_system_items 
        where inventory_item_id=wdd.inventory_item_id  
        AND ROWNUM=1 )                                      enphase_product_name
    ,iut.serial_number                                      serial_number
    ,TO_CHAR (cast(dfla.actual_ship_date as timestamp) 
        AT TIME ZONE 'PST',
        'DD-MON-YYYY','nls_date_language=American')         actual_ship_date
    ,hp.party_name                                          customer_name
    ,(  select hca.cust_account_id 
        from hz_cust_accounts hca,doo_order_addresses doa 
        where doa.ADDRESS_USE_TYPE(+) = 'BILL_TO'   
        and doa.HEADER_ID(+) =dha.HEADER_ID    
        and doa.cust_acct_id = hca.cust_account_id(+)
        AND ROWNUM=1 )                                      cust_account_id
	,(  select hca.account_number 
        from hz_cust_accounts hca,doo_order_addresses doa 
        where doa.ADDRESS_USE_TYPE(+) = 'BILL_TO'   
        and doa.HEADER_ID(+) =dha.HEADER_ID    
        and doa.cust_acct_id = hca.cust_account_id(+)
        AND ROWNUM=1 )                                      customer_number
    ,(  hl.address1     ||' '||
        hl.address2     ||' '||
        hl.address3	    ||' '||
        hl.address4	    ||' '||
        hl.city 	    ||' '||
        hl.POSTAL_CODE	||' '||
        hl.country
      )                                                     shipping_address
    ,wdd.subinventory                                       shipping_location
    ,hl.country                                             country
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
AND dha.order_number            = :P_ORDER_NUMBER
--AND dha.order_number        = wdd.sales_order_number
AND dha.sold_to_party_id        = hp.party_id(+)
AND wdd.delivery_detail_id  = imt.picking_line_id  
AND imt.transaction_id      = iut.transaction_id