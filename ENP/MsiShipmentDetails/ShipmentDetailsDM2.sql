select	wdd.source_header_number SO_NO	,
IODV.ORGANIZATION_name    	shipping_org_name,	
WDD.SUBINVENTORY shipping_location,
(select attribute2 from inv_serial_numbers where serial_number=a.serial_number 
		 and inventory_item_id=wdd.inventory_item_id and rownum=1) pallet_number,
	  dha.customer_po_number PO_NO	,
	 hp.party_name   	customer_name	,
	 (hl.address1 ||' '||
	 hl.address2 	||' '||
	 hl.address3	||' '||
	 hl.address4	||' '||
	hl.city 	||' '||
	hl.POSTAL_CODE	||' '||
	 hl.country 	) SHIPPING_ADDRESS,
	 WDA.DELIVERY_ID    	PL_NO	,
	 wdd.delivery_detail_id,
	a.serial_number SERIAL_NUMBER ,
	 TO_CHAR (cast(dfla.actual_ship_date as timestamp) AT TIME ZONE 'PST','DD-MON-YYYY',
	   'nls_date_language=American') act_SHIP_DATE	,
	   (select item_number from egp_system_items where 
	 inventory_item_id=wdd.inventory_item_id  AND ROWNUM=1 )  	ENPHASE_PRODUCT_NAME	,
		 (select eii.Attribute_Char2
from EGO_ITEM_EFF_B eii , inv_organization_definitions_v org , egp_system_Items esi 
where context_Code = 'Additional Attributes (Master Controlled)'
and eii.organization_id= org.organization_id
and eii.Inventory_Item_Id = esi.Inventory_Item_Id
and eii.Organization_id = esi.Organization_Id
and org.Organization_code = 'MAS'
and esi.inventory_item_id = wdd.inventory_item_id and rownum=1) ||' '||dha.change_version_number    	TAN_NUMBER	,
	 	 dla.line_number line_no ,(select attribute1 from inv_serial_numbers where serial_number=a.serial_number 
		 and inventory_item_id=wdd.inventory_item_id and rownum=1)  box_number  		
	 FROM 
	WSH_NEW_DELIVERIES WND,
		   WSH_DELIVERY_DETAILS WDD,
		   WSH_DELIVERY_ASSIGNMENTS WDA,
		   inv_organization_definitions_v iodv,
		    inv_unit_transactions a, 
			inv_material_txns b,
		   doo_headers_all dha,
		   doo_lines_all dla,
		   doo_fulfill_lines_all dfla,
		   hz_locations hl,
		   hz_locations hlb,
		   hz_parties hp,
		   hz_parties hpb,
		   hz_party_sites          ship_hps,
		   doo_order_addresses doas
	WHERE     WDA.DELIVERY_ID = WND.DELIVERY_ID  
	and WDD.SOURCE_HEADER_NUMBER =dha.ORDER_NUMBER
	and dha.header_id=dla.header_id 
	and dha.header_id=dfla.header_id 
	and dla.line_id=dfla.line_id   
	and a.transaction_id=b.transaction_id 
	and b.picking_line_id=wdd.delivery_detail_id  
	and doas.party_id = hp.party_id  
	and ship_hps.location_id=hl.location_id 
	and dha.header_id=doas.header_id 
	and doas.ADDRESS_USE_TYPE='SHIP_TO' 
and doas.party_site_id=ship_hps.party_site_id
	and  wdd.source_shipment_id=dfla.FULFILL_line_ID 
	and dha.org_id=dla.org_id
		   AND WDA.DELIVERY_DETAIL_ID = WDD.DELIVERY_DETAIL_ID
		   AND WDD.organization_id = iodv.organization_id 
		   and wdd.BILL_TO_LOCATION_ID=hlb.location_id 
		   and wdd.ship_to_party_id=hp.party_id
		   and wdd.bill_to_party_id=hpb.party_id 
			and wnd.delivery_id=:P_DELIVERY_ID 
		         and wdd.released_status='C' order by line_number