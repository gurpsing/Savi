--++=====================================================================+
   -- |Development - Maintenance History:                                   |
   --++=====================================================================+
   -- |                                                                     |
   -- |Version   Date         Author                Remarks                 |
   -- |-------   ----------   ---------------       ----------------------- |
   -- |1.0      25-Apr-2022  Infosys                Initial Version         |
   -- |1.1      01-Aug-2024  Gowtham                ITSD-268680 - To fetch the correct Ship Method| 
   -- ======================================================================+

   -- +==================================================================== +
   -- | Report data for  OIC Integration              |
   -- ======================================================================+
   -- +=============================================================================== +
   -- Path: Custom/Integrations/Order Management/Data Models/SHIPMENT_DETAILS_REPORT_DM -- 
   -- ================================================================================+   
SELECT
    *
FROM
    (
        SELECT
            wnd.waybill                                      tracking_number,
			--Changes Hemanth 0n 02-SEP---
			--'' attribute_value,
            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    wdd.source_header_number
                ELSE
                    ''
            END                                              attribute_value,
			--Changes Hemanth 0n 02-SEP---			  
            (
                SELECT
                    attribute_char7
                FROM
                    doo_headers_eff_b
                WHERE
                        header_id = dha.header_id
                    AND context_code = 'Header Attributes'
                    AND ROWNUM = 1
            )                                                rma_ref_id,
            iodv.organization_code                           trading_partner,
            dha.status_code                                  order_status,
	 
	 
		
			--Changes Hemanth 0n 02-SEP---
			--wdd.source_header_number ORDER_NUMBER	,
            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    ''
                ELSE
                    wdd.source_header_number
            END                                              order_number,
			  --Changes Hemanth 0n 02-SEP---

            dha.customer_po_number                           po_number,
            hp.party_name                                    ship_to_cust,
	
			--Changes Hemanth 0n 02-SEP---
			--hp.party_number   	ACCOUNT_NUMBER	,

            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    (
                        SELECT
                            attribute_char6
                        FROM
                            doo_headers_eff_b
                        WHERE
                                dha.header_id = doo_headers_eff_b.header_id
                            AND context_code = 'Header Attributes'
                    )
                ELSE
                    hp.party_number
            END                                              account_number,
            --Changes Hemanth 0n 02-SEP---

            hl.address1                                      ship_to_address,
            hl.address2                                      ship_to_address2,
            hl.address3                                      ship_to_address3,
            hl.address4                                      ship_to_address4,
            hl.city                                          ship_to_city,
            hl.postal_code                                   ship_to_postal_code,
            hl.country                                       ship_to_country_code,
            wda.delivery_id                                  delivery_number,
            to_char(CAST(dfla.actual_ship_date AS TIMESTAMP) AT TIME ZONE 'PST',
                    'DD-MON-YYYY',
                    'nls_date_language=American')            ship_date,
            wdd.currency_code                                curr,
            dha.shipping_instructions                        attribute4,
	
			/*nvl(wnd.attribute7,(select 
		    WCV.CARRIER_NAME
                 || '-'
                 || WND.MODE_OF_TRANSPORT
                 || '-'
                 || WND.SERVICE_LEVEL from WSH_CARRIERS_V wcv where 
				  WCV.CARRIER_ID = WND.CARRIER_ID)) */  
           --Changes Hemanth 0n 02-SEP---

				 /* wnd.FOB_CODE  	FOB	,
	      (select rt.name
           from hz_customer_profiles_f hcpf,
                ra_terms rt
          where hcpf.site_use_id is null
            and hcpf.effective_start_date <= sysdate
            and nvl(hcpf.effective_end_date,sysdate+1) >= sysdate
            and rt.term_id = hcpf.standard_terms
            and rt.start_date_active <= sysdate
            and nvl(rt.end_date_active,sysdate+1) >= sysdate
            and hcpf.cust_account_id = dfla.bill_to_customer_id )    	TERMS	,*/

            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    NULL
                ELSE
                    wnd.fob_code
            END                                              fob,
            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    NULL
                ELSE
                    (
                        SELECT
                            rt.name
                        FROM
                            hz_customer_profiles_f hcpf,
                            ra_terms               rt
                        WHERE
                            hcpf.site_use_id IS NULL
                            AND hcpf.effective_start_date <= sysdate
                            AND nvl(hcpf.effective_end_date, sysdate + 1) >= sysdate
                            AND rt.term_id = hcpf.standard_terms
                            AND rt.start_date_active <= sysdate
                            AND nvl(rt.end_date_active, sysdate + 1) >= sysdate
                            AND hcpf.cust_account_id = dfla.bill_to_customer_id
                    )
            END                                              terms,
			
			--Changes Hemanth 0n 02-SEP---


            to_char(CAST(dfla.promise_ship_date AS TIMESTAMP) AT TIME ZONE 'PST',
                    'DD-MON-YYYY',
                    'nls_date_language=American')            line_promised_date,
            nvl(wdd.picked_quantity, wdd.requested_quantity) line_shipped_qty,
            dla.ordered_qty,
            (
                SELECT
                    unit_of_measure
                FROM
                    inv_units_of_measure_tl pp,
                    inv_units_of_measure_b  qq
                WHERE
                        pp.unit_of_measure_id = qq.unit_of_measure_id
                    AND pp.language = 'US'
                    AND qq.uom_code = wdd.requested_quantity_uom
            )                                                line_uom_code,
            (
                SELECT
                    item_number
                FROM
                    egp_system_items
                WHERE
                        inventory_item_id = wdd.inventory_item_id
                    AND ROWNUM = 1
            )                                                line_part_number,
            wdd.item_description                             line_description,
	        --(nvl(WDD.picked_quantity,wdd.requested_quantity)*wdd.unit_price)    	
            to_char((
                SELECT
                    SUM(a.prorated_amount) freight_cost
                FROM
                    wsh_prorated_freight_costs a
                WHERE
                    delivery_id = :p_delivery_id
            ),
                    'fm9999999.90')                          line_amount,
            dla.line_number,
            dfla.unit_selling_price,
            (
                SELECT
                    hp.email_address
                FROM
                    hz_relationships hr,
                    hz_parties       hp
                WHERE
                        1 = 1
                    AND hr.subject_id = hp.party_id
                    AND directional_flag = 'F'
                    AND hr.relationship_id = nvl(dfla.ship_to_contact_id, wdd.sold_to_contact_id)
                    AND ROWNUM = 1
            )                                                cust_email,
            (
                SELECT
                    hp.primary_phone_number
                FROM
                    hz_relationships hr,
                    hz_parties       hp
                WHERE
                        1 = 1
                    AND hr.subject_id = hp.party_id
                    AND directional_flag = 'F'
                    AND hr.relationship_id = nvl(dfla.ship_to_contact_id, wdd.sold_to_contact_id)
                    AND ROWNUM = 1
            )                                                cust_phone,
            (
                SELECT
                    hp.party_name
                FROM
                    hz_relationships hr,
                    hz_parties       hp
                WHERE
                        1 = 1
                    AND hr.subject_id = hp.party_id
                    AND directional_flag = 'F'
                    AND hr.relationship_id = nvl(dfla.ship_to_contact_id, wdd.sold_to_contact_id)
                    AND ROWNUM = 1
            )                                                cust_value,
            (
                SELECT
                    wcv.carrier_name
                    || '-'
                    || (
                        SELECT
                            meaning
                        FROM
                            fnd_lookup_values_vl
                        WHERE
                                lookup_type = 'WSH_MODE_OF_TRANSPORT'
                           -- AND lookup_code = a.mode_of_transport -- Commented as per Version 1.1
						      AND lookup_code = wnd.mode_of_transport -- Added as per Version 1.1
                    )
                    || '-'
                    || (
                        SELECT
                            meaning
                        FROM
                            fnd_lookup_values_vl
                        WHERE
                                lookup_type = 'WSH_SERVICE_LEVELS'
                          --  AND lookup_code = a.service_level -- Commented as per Version 1.1
						      AND lookup_code = wnd.service_level -- Added as per Version 1.1
                    )
                FROM
                    wsh_carriers_v           wcv
					/* Commented as per version 1.1 Starts 
                    wsh_new_deliveries       a,
                    wsh_delivery_details     b,
                    wsh_delivery_assignments c
                WHERE
                        wcv.carrier_id = a.carrier_id
                    AND a.delivery_id = c.delivery_id
                    AND c.delivery_detail_id = b.delivery_detail_id
                    AND b.source_header_number = dha.order_number
                    AND b.released_status = 'C' Commented as per version 1.1 Ends */
					WHERE
					wcv.carrier_id=wnd.carrier_id -- Added as per version 1.1				
                    AND ROWNUM = 1
					
            )                                                ship_method
        FROM
            wsh_new_deliveries             wnd,
            wsh_delivery_details           wdd,
            wsh_delivery_assignments       wda,
            inv_organization_definitions_v iodv,
            doo_headers_all                dha,
            doo_lines_all                  dla,
            doo_fulfill_lines_all          dfla,
            hz_locations                   hl,
            hz_locations                   hlb,
            hz_parties                     hp,
            hz_parties                     hpb,
            hz_party_sites                 ship_hps,
            doo_order_addresses            doas
        WHERE
                wda.delivery_id = wnd.delivery_id
            AND wdd.source_header_number = dha.order_number
            AND dha.header_id = dla.header_id
            AND dha.header_id = dfla.header_id
            AND dla.line_id = dfla.line_id
            AND doas.party_id = hp.party_id
            AND ship_hps.location_id = hl.location_id
            AND dha.header_id = doas.header_id
            AND doas.address_use_type = 'SHIP_TO'
            AND doas.party_site_id = ship_hps.party_site_id
            AND wdd.source_shipment_id = dfla.fulfill_line_id
            AND dha.org_id = dla.org_id
            AND wda.delivery_detail_id = wdd.delivery_detail_id
            AND wdd.organization_id = iodv.organization_id 
		   --and wdd.SHIP_TO_LOCATION_ID=hl.location_id 
            AND wdd.bill_to_location_id = hlb.location_id
            AND wdd.ship_to_party_id = hp.party_id
            AND wdd.bill_to_party_id = hpb.party_id
            AND wnd.delivery_id = :p_delivery_id
			-- AND wdd.source_code='OE'
            AND wdd.released_status = 'C'
        UNION ALL
        SELECT
            wnd.waybill                                      tracking_number,
		
			--Changes Hemanth 0n 02-SEP---
			--'' attribute_value,
            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    wdd.source_header_number
                ELSE
                    ''
            END                                              attribute_value,
			--Changes Hemanth 0n 02-SEP---	

            (
                SELECT
                    attribute_char7
                FROM
                    doo_headers_eff_b
                WHERE
                        header_id = dha.header_id
                    AND context_code = 'Header Attributes'
                    AND ROWNUM = 1
            )                                                rma_ref_id,
            iodv.organization_code                           trading_partner,
            dha.status_code                                  order_status,
			--Changes Hemanth 0n 02-SEP---
			--wdd.source_header_number ORDER_NUMBER	,
            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    ''
                ELSE
                    wdd.source_header_number
            END                                              order_number,
			 --Changes Hemanth 0n 02-SEP---
            dha.customer_po_number                           po_number,
            hp.party_name                                    ship_to_cust, 
			--Changes Hemanth 0n 02-SEP---
			--hp.party_number   	ACCOUNT_NUMBER	,

            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    (
                        SELECT
                            attribute_char6
                        FROM
                            doo_headers_eff_b
                        WHERE
                                dha.header_id = doo_headers_eff_b.header_id
                            AND context_code = 'Header Attributes'
                    )
                ELSE
                    hp.party_number
            END                                              account_number,
            --Changes Hemanth 0n 02-SEP---
            hl.address_line_1                                ship_to_address,
            hl.address_line_2                                ship_to_address2,
            hl.address_line_3                                ship_to_address3,
            hl.address_line_4                                ship_to_address4,
            hl.town_or_city                                  ship_to_city,
            hl.postal_code                                   ship_to_postal_code,
            hl.country                                       ship_to_country_code,
            wda.delivery_id                                  delivery_number,
            to_char(CAST(dfla.actual_ship_date AS TIMESTAMP) AT TIME ZONE 'PST',
                    'DD-MON-YYYY',
                    'nls_date_language=American')            ship_date,
            wdd.currency_code                                curr,
            dha.shipping_instructions                        attribute4,
	 
	       /*nvl(wnd.attribute7,(select 
                  WCV.CARRIER_NAME
                 || '-'
                 || WND.MODE_OF_TRANSPORT
                 || '-'
                 || WND.SERVICE_LEVEL from WSH_CARRIERS_V wcv where 
				  WCV.CARRIER_ID = WND.CARRIER_ID)) */   
			
          --Changes Hemanth 0n 02-SEP---
			
				/*  wnd.FOB_CODE  	FOB	,
	      (select rt.name
           from hz_customer_profiles_f hcpf,
                ra_terms rt
          where hcpf.site_use_id is null
            and hcpf.effective_start_date <= sysdate
            and nvl(hcpf.effective_end_date,sysdate+1) >= sysdate
            and rt.term_id = hcpf.standard_terms
            and rt.start_date_active <= sysdate
            and nvl(rt.end_date_active,sysdate+1) >= sysdate
            and hcpf.cust_account_id = dfla.bill_to_customer_id )    	TERMS	,*/

            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    NULL
                ELSE
                    wnd.fob_code
            END                                              fob,
            CASE
                WHEN dha.order_type_code LIKE '%RMA%' THEN
                    NULL
                ELSE
                    (
                        SELECT
                            rt.name
                        FROM
                            hz_customer_profiles_f hcpf,
                            ra_terms               rt
                        WHERE
                            hcpf.site_use_id IS NULL
                            AND hcpf.effective_start_date <= sysdate
                            AND nvl(hcpf.effective_end_date, sysdate + 1) >= sysdate
                            AND rt.term_id = hcpf.standard_terms
                            AND rt.start_date_active <= sysdate
                            AND nvl(rt.end_date_active, sysdate + 1) >= sysdate
                            AND hcpf.cust_account_id = dfla.bill_to_customer_id
                    )
            END                                              terms,
			
			--Changes Hemanth 0n 02-SEP---

            to_char(CAST(dfla.promise_ship_date AS TIMESTAMP) AT TIME ZONE 'PST',
                    'DD-MON-YYYY',
                    'nls_date_language=American')            line_promised_date,
            nvl(wdd.picked_quantity, wdd.requested_quantity) line_shipped_qty,
            dla.ordered_qty,
            (
                SELECT
                    unit_of_measure
                FROM
                    inv_units_of_measure_tl pp,
                    inv_units_of_measure_b  qq
                WHERE
                        pp.unit_of_measure_id = qq.unit_of_measure_id
                    AND pp.language = 'US'
                    AND qq.uom_code = wdd.requested_quantity_uom
            )                                                line_uom_code,
            (
                SELECT
                    item_number
                FROM
                    egp_system_items
                WHERE
                        inventory_item_id = wdd.inventory_item_id
                    AND ROWNUM = 1
            )                                                line_part_number,
            wdd.item_description                             line_description,
	        --(nvl(WDD.picked_quantity,wdd.requested_quantity)*wdd.unit_price)    	
            to_char((
                SELECT
                    SUM(a.prorated_amount) freight_cost
                FROM
                    wsh_prorated_freight_costs a
                WHERE
                    delivery_id = :p_delivery_id
            ),
                    'fm9999999.90')                          line_amount,
            dla.line_number,
            dfla.unit_selling_price,
            (
                SELECT
                    attribute2
                FROM
                    inv_secondary_inventories
                WHERE
                        secondary_inventory_name = (
                            SELECT DISTINCT
                                destination_subinventory_code
                            FROM
                                inv_transfer_order_lines   itol,
                                inv_transfer_order_headers itoh
                            WHERE
                                    itoh.header_id = itol.header_id
                                AND itoh.header_number = dha.order_number
                                AND ROWNUM = 1
                        )
                    AND organization_id = dfla.destination_org_id
            )                                                cust_email,
            (
                SELECT
                    hp.primary_phone_number
                FROM
                    hz_relationships hr,
                    hz_parties       hp
                WHERE
                        1 = 1
                    AND hr.subject_id = hp.party_id
                    AND directional_flag = 'F'
                    AND hr.relationship_id = nvl(dfla.ship_to_contact_id, wdd.sold_to_contact_id)
                    AND ROWNUM = 1
            )                                                cust_phone,
            (
                SELECT
                    hp.party_name
                FROM
                    hz_relationships hr,
                    hz_parties       hp
                WHERE
                        1 = 1
                    AND hr.subject_id = hp.party_id
                    AND directional_flag = 'F'
                    AND hr.relationship_id = nvl(dfla.ship_to_contact_id, wdd.sold_to_contact_id)
                    AND ROWNUM = 1
            )                                                cust_value,
            (
                SELECT
                    wcv.carrier_name
                    || '-'
                    || (
                        SELECT
                            meaning
                        FROM
                            fnd_lookup_values_vl
                        WHERE
                                lookup_type = 'WSH_MODE_OF_TRANSPORT'
                           -- AND lookup_code = a.mode_of_transport -- Commented as per Version 1.1
						      AND lookup_code = wnd.mode_of_transport -- Added as per Version 1.1
                    )
                    || '-'
                    || (
                        SELECT
                            meaning
                        FROM
                            fnd_lookup_values_vl
                        WHERE
                                lookup_type = 'WSH_SERVICE_LEVELS'
                          --  AND lookup_code = a.service_level -- Commented as per Version 1.1
						      AND lookup_code = wnd.service_level -- Added as per Version 1.1
                    )
                FROM
                    wsh_carriers_v           wcv
					/* Commented as per version 1.1 Starts 
                    wsh_new_deliveries       a,
                    wsh_delivery_details     b,
                    wsh_delivery_assignments c
                WHERE
                        wcv.carrier_id = a.carrier_id
                    AND a.delivery_id = c.delivery_id
                    AND c.delivery_detail_id = b.delivery_detail_id
                    AND b.source_header_number = dha.order_number
                    AND b.released_status = 'C' Commented as per version 1.1 Ends */
					WHERE
					wcv.carrier_id=wnd.carrier_id -- Added as per version 1.1				
                    AND ROWNUM = 1
					
            )                                                ship_method
        FROM
            wsh_new_deliveries             wnd,
            wsh_delivery_details           wdd,
            wsh_delivery_assignments       wda,
            inv_organization_definitions_v iodv,
            doo_headers_all                dha,
            doo_lines_all                  dla,
            doo_fulfill_lines_all          dfla,
            hr_locations                   hl,
            hz_parties                     hp
        WHERE
                wda.delivery_id = wnd.delivery_id
            AND wdd.source_header_number = dha.order_number
            AND dha.header_id = dla.header_id
            AND dha.header_id = dfla.header_id
            AND dla.line_id = dfla.line_id
            AND wdd.sold_to_party_id = hp.party_id
            AND wdd.ship_to_location_id = hl.location_id
            AND wdd.source_shipment_id = dfla.fulfill_line_id
            AND dha.org_id = dla.org_id
            AND wda.delivery_detail_id = wdd.delivery_detail_id
            AND wdd.organization_id = iodv.organization_id 
		   --and wdd.SHIP_TO_LOCATION_ID=hl.location_id 
            AND wdd.ship_to_party_id = hp.party_id
            AND wnd.delivery_id = :p_delivery_id
			-- AND wdd.source_code='OE'
            AND wdd.released_status = 'C'
    )
ORDER BY
    line_number
    
    
    
    