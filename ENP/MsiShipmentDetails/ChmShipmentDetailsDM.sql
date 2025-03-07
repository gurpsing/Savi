--++==========================================================================================================+
   -- |Development - Maintenance History:                                                                        |
   --++==========================================================================================================+
   -- |                                                                                                          |
   -- |Version   Date         Author                Remarks                                                      |
   -- |-------   ----------   ---------------       -------------------------------------------                  |
   -- |1.0       01-May-2022  Infosys                Initial Version                                             |
   -- |1.1       09-Aug-2023  Prem Raj               ITSD-190692: Need to added created_by,           |
   --                                                creation_date, booked_by, booked_date, is_booked_by_creator |
   -- |1.2       09-Jan-2024   Praveen Kumar         PES RMA Changes - Add a field ETA to report 
   -- |1.3       25-Jan-2024   Gurpreet Singh        Changes for CHM Project
   -- |1.4       25-Nov-2024   Dhivagar              ITSD-290471-Single row subquery returns more rows
   -- ===========================================================================================================+
   --       																									 |
   -- +==========================================================================================================+
   -- Path: Custom/Order Management/Shipment DM --                                                               |
   -- ===========================================================================================================+
   


with shipment_det as
(
select /*+ parallel(dfla) parallel(wda) parallel(wdd) parallel(wnd) */ org.organization_name,--wnd.delivery_id, hdr.header_id, dfla.fulfill_line_id,
    --wnd.organization_id org_id, wnd.delivery_id,wnd.ACTUAL_SHIP_DATE wnd_shpdt,
	org.organization_code,
	wnd.delivery_name Shipment_No,
	wnd.STATUS_CODE status_name,
	wnd.waybill,
	wnd.fob_code,
	wnd.confirmed_by,
	wnd.net_weight, 
	dfla.ordered_uom uom,
	(case when wnd.ATTRIBUTE6 is null then 'N'
		when wnd.ATTRIBUTE6 = 'I' then 'Y' 
		else
		wnd.ATTRIBUTE6
		end
	)  Ship_Confirm_ACK, 
	dfla.actual_Ship_Date Actual_Shipment_Date,
	dfla.SHIP_CLASS_OF_SERVICE,
	dfla.SHIP_MODE_OF_TRANSPORT,
	TO_CHAR(dfla.CARRIER_ID) carrier_id,
	wnd.ship_method_code,
	wnd.service_level,
	'Shipped' Shipping_Status,
	wdd.source_header_number,
	--wdd.item_description wsh_desc,
	REPLACE(REPLACE(wdd.item_description,chr(10),' '), chr(13), ' ') wsh_desc,
	REPLACE(REPLACE(wdd.item_description,chr(10),' '), chr(13), ' ') item_description,
	wdd.shipped_quantity wsh_shipqty,  
    wdd.delivery_detail_id	,
	nvl(dfla.SALESPERSON_ID, hdr.SALESPERSON_ID) SALESPERSON_ID,
	wdd.sales_order_number,wdd.organization_id wdd_org_id, wdd.inventory_item_id,
	nvl(wdd.converted_quantity,wdd.src_requested_quantity ) requested_quantity,
	hdr.order_number,
	lin.display_line_number LINE_NUMBER,
	dfla.status_code Line_Status,
	hdr.ORDER_TYPE_CODE   Order_Type,
	hdr.CUSTOMER_PO_NUMBER CUST_PO_NUMBER,
	hdr.SOURCE_DOCUMENT_TYPE_CODE,
	hdr.SOURCE_ORDER_ID,
	dfla.schedule_ship_date  Scheduled_Ship_Date,
	TO_CHAR(TO_DATE((TO_CHAR(cast(dfla.actual_ship_date as timestamp) AT TIME ZONE 'PST','MM/DD/YYYY HH:MI:SS AM')),'MM/DD/YYYY HH:MI:SS AM'), 'IW') Week,
	TO_DATE((TO_CHAR(cast(wnd.initial_pickup_date as timestamp) AT TIME ZONE 'PST','MM/DD/YYYY HH:MI:SS AM')),'MM/DD/YYYY HH:MI:SS AM') Ship_Date,
	TO_DATE((TO_CHAR(cast(dfla.actual_ship_date as timestamp) AT TIME ZONE 'PST','MM/DD/YYYY HH:MI:SS AM')),'MM/DD/YYYY HH:MI:SS AM') actual_Ship_Date,
	hdr.ordered_date  Order_Date,	
	dfla.unit_selling_price, -- V2
	dfla.extended_amount,
	hdr.transactional_currency_code Currency_Code,
	REPLACE(REPLACE(dfla.SHIPPING_INSTRUCTIONS, CHR(13), ' '), CHR(10), ' ')  SHIPPING_INSTRUCTIONS, 
	dfla.subinventory,	
	dfla.REQUEST_SHIP_DATE  Request_Date,		 
	dfla.PROMISE_SHIP_DATE  Promise_Date,
	dfla.REQUEST_SHIP_DATE  Cust_Request_Date,	
	hdr.sold_to_party_id,
	dfla.ship_to_party_site_id,
	dfla.fulfill_org_id,
	dfla.destination_org_id,
	(select organization_code from inv_org_parameters where organization_id=dfla.destination_org_id) dest_org,
	dfla.destination_location_id dest_loc_id,
	(SELECT attribute_char1 
     FROM doo_fulfill_lines_eff_b 
	 WHERE context_code='Legacy System Line Attributes' and fulfill_line_id=dfla.fulfill_line_id
    ) Cust_Req_OTD_Reason,
	(SELECT ATTRIBUTE_TIMESTAMP1
     FROM doo_fulfill_lines_eff_b
    WHERE context_code = 'Line Attributes'
    AND fulfill_line_id = dfla.fulfill_line_id
	AND rownum=1
	) Estimated_time_of_Arrival,--Changes for 1.3
	HP.PARTY_ID     party_id,                                                                           --added for v1.3
	HP.PARTY_NUMBER party_number,                                                                       --added for v1.3
	(select hca.cust_account_id from hz_cust_accounts hca, doo_order_addresses doa where doa.ADDRESS_USE_TYPE(+) = 'BILL_TO'   
     and doa.HEADER_ID(+) =hdr.HEADER_ID    
     and doa.cust_acct_id = hca.cust_account_id(+) ) cust_account_id,                                    --added for v1.4
	(select hca.account_number from hz_cust_accounts hca, doo_order_addresses doa where doa.ADDRESS_USE_TYPE(+) = 'BILL_TO'   
     and doa.HEADER_ID(+) =hdr.HEADER_ID    
     and doa.cust_acct_id = hca.cust_account_id(+)) customer_number,                                     --added for v1.4
    HP.PARTY_NAME customer_name,
    hdr.creation_date,                                                                   -- ITSD-190692
	hdr.created_by,                                                                      -- ITSD-190692
	hdr.submitted_date,                                                                  -- ITSD-190692
	hdr.submitted_by,                                                                    -- ITSD-190692
	DECODE(hdr.created_by, hdr.submitted_by , 'Yes' ,'No' ) is_booked_by_creator       -- ITSD-190692
	/*(select rcta.trx_number 
	   from ra_customer_trx_all  rcta, 
	        ra_customer_trx_lines_all rctla 
	  where rcta.customer_trx_id = rctla.customer_trx_id 
        AND rctla.interface_line_attribute6 =  to_char(dfla.fulfill_line_id)
		AND rownum=1) trx_number      */                                                   -- ITSD-190692
        ,hdr.header_id                  --added for v1.3
        ,lin.line_id                    --added for v1.3
        ,wnd.delivery_id                --added for v1.3
        ,wda.delivery_assignment_id     --added for v1.3
        ,dfla.fulfill_line_id           --added for v1.3
 from 
	wsh_new_deliveries wnd,
	wsh_delivery_assignments wda,
	wsh_delivery_details wdd, 
	doo_fulfill_lines_all dfla,
	INV_ORGANIZATION_DEFINITIONS_V   org,
	doo_lines_all lin,
    doo_headers_all hdr,
	hz_parties hp
where 1=1
AND wdd.source_shipment_id   = dfla.fulfill_line_id
--and wnd.ACTUAL_SHIP_DATE  >= NVL(:P_From_Ship_Date,wnd.ACTUAL_SHIP_DATE)-1    --commented for v1.3
and (
    (	
		TRUNC(wnd.ACTUAL_SHIP_DATE)  
		BETWEEN 
			TRUNC(NVL(:P_From_Ship_Date,wnd.ACTUAL_SHIP_DATE)-1) 
		AND 
			NVL(
					DECODE(	:P_To_Ship_Date,
							'NA',NULL,
			TRUNC(				to_date(:P_To_Ship_Date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN')+1
					))
					,TRUNC(wnd.ACTUAL_SHIP_DATE+1)
			)
	)
    OR
    (   (
			TRUNC(dfla.last_update_date) 
			BETWEEN 
				TRUNC(NVL(:P_From_Ship_Date,dfla.last_update_date)-1) 
			AND
				NVL(
					DECODE(	:P_To_Ship_Date,
							'NA',NULL,
					TRUNC(		to_date(:P_To_Ship_Date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN')+1
					))
					,TRUNC(dfla.last_update_date+1)
				)
		)
        AND
        (   SELECT ATTRIBUTE_TIMESTAMP1
            FROM doo_fulfill_lines_eff_b
            WHERE context_code = 'Line Attributes'
            AND fulfill_line_id = dfla.fulfill_line_id
            AND rownum=1
        ) IS NOT NULL
    )
) --added for v1.3
and wnd.delivery_id = wda.delivery_id
and wda.delivery_detail_id = wdd.delivery_detail_id
and wdd.released_status = 'C'
and wnd.organization_id = org.organization_id
--and org.organization_name in NVL(:p_org_name,org.organization_name) --commented for v1.3
and lin.line_id = dfla.line_id
and hdr.header_id = dfla.header_id
and lin.header_id = hdr.header_id
and hdr.order_number = wdd.sales_order_number
and hdr.sold_to_party_id = hp.party_id(+)
---testing--and wnd.delivery_name='3137536' --jj
),
---------------------------------------------------
ship_to
as
(SELECT hpb.party_name, 
hpsb.party_site_number location_id,
			--hl.location_id,
			hl.address1,  
			hl.address2, 
			hl.address3, 
			hl.address4, 
			hl.city, 
			hl.state,
			hl.postal_code,
			hl.PROVINCE,
			hl.country , 
			hpsu.party_site_id,
			hpsu.site_use_type
		FROM   hz_party_site_uses hpsu, 
			hz_parties hpb, 
			hz_party_sites hpsb, 
		--	hz_cust_accounts hcab,                             --added for v1.4
			hz_locations hl 
		WHERE  1 = 1 
			AND hpsu.site_use_type = 'SHIP_TO' 
			AND hpb.party_id = hpsb.party_id 
			AND hpsu.party_site_id = hpsb.party_site_id 
		--	AND hcab.party_id = hpb.party_id                   --added for v1.4
			AND hpsb.location_id = hl.location_id
) 
---------------------------------------------------
select sd.organization_name,
sd.Shipment_No,
sd.status_name,
sd.waybill,
sd.fob_code,
sd.confirmed_by,
sd.net_weight,
sd.uom,
sd.Ship_Confirm_ACK,
(SELECT  
            (PartyPEO.party_name
            ||
            ' '
            ||
            ModeOfTransportPEO.MEANING
            ||
            ' '
            ||
            ServiceLevelPEO.MEANING) Ship_Method        
            
        FROM   
                msc_xref_mapping mxm_LOS       ,
                msc_xref_mapping mxm_MOT       ,
                msc_xref_mapping mxm_CAR       ,
                RCS_LOOKUPS ModeOfTransportPEO ,
                RCS_LOOKUPS ServiceLevelPEO    ,
                HZ_PARTIES PartyPEO                        
                
        WHERE 1 = 1 
        AND   sd.SHIP_CLASS_OF_SERVICE = mxm_LOS.target_value
        AND   mxm_LOS.entity_name    = 'WSH_SERVICE_LEVELS'
        AND   ServiceLevelPEO.LOOKUP_CODE = MXM_LOS.SOURCE_VALUE
        AND   ServiceLevelPEO.LOOKUP_TYPE = 'WSH_SERVICE_LEVELS'
        AND   sd.SHIP_MODE_OF_TRANSPORT = mxm_MOT.target_value
        AND   mxm_MOT.entity_name     = 'WSH_MODE_OF_TRANSPORT'
        AND   ModeOfTransportPEO.LOOKUP_CODE     = MXM_MOT.SOURCE_VALUE
        AND   ModeOfTransportPEO.LOOKUP_TYPE = 'WSH_MODE_OF_TRANSPORT'
        AND   TO_CHAR(sd.CARRIER_ID) = mxm_CAR.target_value
        AND   mxm_CAR.entity_name  = 'CARRIERS'
        AND   PartyPEO.party_id = mxm_CAR.source_value
        AND   ROWNUM=1 
) ship_method,
  sd.ship_method_code,
  sd.service_level,
  sd.Shipping_Status,
  sd.source_header_number,
  sd.wsh_desc,
  sd.item_description,
  sd.wsh_shipqty,
  (select name from ra_salesreps where party_id = sd.SALESPERSON_ID ) salesperson,
  sd.requested_quantity,
  msi.PRIMARY_UOM_CODE,		 
  msi.item_number SKU,
  --cst.unit_amount  Freight_Amt, 
  (select cst.unit_amount from wsh_freight_costs cst where cst.delivery_detail_id = sd.delivery_detail_id) Freight_Amt,
  NULL Orig_Freight,
  NULL Freight_Adder,
  --fct.FREIGHT_COST_NAME freight_cost_type_meaning,
  (select fct.FREIGHT_COST_NAME from wsh_freight_costs cst, wsh_freight_cost_types fct 
    where cst.FREIGHT_COST_TYPE_ID = fct.FREIGHT_COST_TYPE_ID 
	  and cst.delivery_detail_id = sd.delivery_detail_id) freight_cost_type_meaning,
  sd.Cust_Req_OTD_Reason,
  sd.Estimated_time_of_Arrival, --Added as per Rev 1.2
  sd.order_number,
  sd.LINE_NUMBER,
  sd.Line_Status,
  sd.Order_Type,
  sd.CUST_PO_NUMBER,
  sd.Scheduled_Ship_Date,
  sd.Actual_Shipment_Date,
  sd.Week,
  sd.Ship_Date,
  sd.actual_Ship_Date,
  sd.Order_Date,
  sd.unit_selling_price,
  sd.extended_amount,
  sd.Currency_Code,
  sd.SHIPPING_INSTRUCTIONS,
  sd.subinventory,
  (SELECT organization_code FROM inv_org_parameters WHERE organization_id = sd.fulfill_org_id) warehouse,
  sd.Request_Date,
  sd.Promise_Date,
  sd.Cust_Request_Date,
  ship_to.SITE_USE_TYPE SITE_USE_CODE,
  ship_to.location_id SHIPTO_LOCATION,
  case when ship_to.party_name is not null  
		then ship_to.party_name
       when sd.dest_org = 'SR1'
		then (select ADDRESS_LINE_1  
	         FROM hr_locations where  location_Id =  sd.dest_loc_id)
       else (CASE WHEN sd.ORDER_TYPE LIKE '%Internal%'
				THEN(
					SELECT  hl.LOCATION_NAME
					FROM hr_all_organization_units haou, hr_locations hl
					WHERE haou.location_id = hl.location_Id
					and haou.organization_Id = sd.destination_org_id
					and rownum=1
					)
			END) 
  end  Ship_To_Customer_Name,
  case when ship_to.ADDRESS1 is not null  
            then REPLACE(REPLACE(ship_to.ADDRESS1, CHR(13), ' '), CHR(10), ' ')
       when sd.dest_org = 'SR1'
            then (select ADDRESS_LINE_2  
	         FROM hr_locations where  location_Id =  sd.dest_loc_id)
       else (
            SELECT  hl.address_line_1
            FROM hr_all_organization_units haou, hr_locations hl
            WHERE haou.location_id = hl.location_Id
            and haou.organization_Id = sd.destination_org_id
            and rownum=1
            ) 
  end	Address1,
  case when ship_to.ADDRESS2 is not null  
            then ship_to.ADDRESS2
       when sd.dest_org = 'SR1'
            then 
            (select ADDRESS_LINE_3  FROM 
            hr_locations
            where  location_Id =  sd.dest_loc_id)
       else (
            SELECT  hl.address_line_2
            FROM 
            hr_all_organization_units haou, hr_locations hl
            WHERE 
            haou.location_id = hl.location_Id
            and haou.organization_Id = sd.destination_org_id
            and rownum=1
            ) 
  end Address2,
  case when ship_to.ADDRESS3 is not null  
            then ship_to.ADDRESS3
            when sd.dest_org = 'SR1'
            then 
            (select ADDRESS_LINE_4  FROM 
            hr_locations
            where  location_Id =  sd.dest_loc_id)
            
        else (
            SELECT  hl.address_line_3
            FROM 
            hr_all_organization_units haou, hr_locations hl
            WHERE 
            haou.location_id = hl.location_Id
            and haou.organization_Id = sd.destination_org_id
            and rownum=1
            ) 
  end			   Address3,
  case when ship_to.CITY is not null  
            then ship_to.CITY
       when sd.dest_org = 'SR1'
            then 
            (select TOWN_OR_CITY  FROM 
            hr_locations
            where  location_Id =  sd.dest_loc_id)
       else (
            SELECT  TOWN_OR_CITY
            FROM 
            hr_all_organization_units haou, hr_locations hl
            WHERE 
            haou.location_id = hl.location_Id
            and haou.organization_Id = sd.destination_org_id
            and rownum=1
            ) 
  end			   City,
  case when ship_to.STATE is not null  
            then ship_to.STATE 
            
       when sd.dest_org = 'SR1'
            then 
            (select REGION_2  FROM 
            hr_locations
            where  location_Id =  sd.dest_loc_id)
            
            
       else (
            SELECT  REGION_2
            FROM 
            hr_all_organization_units haou, hr_locations hl
            WHERE 
            haou.location_id = hl.location_Id
            and haou.organization_Id = sd.destination_org_id
            ) 
  end			   State,
  case when ship_to.POSTAL_CODE is not null  
            then ship_to.POSTAL_CODE
       when sd.dest_org = 'SR1'
            then 
            (select POSTAL_CODE  FROM 
            hr_locations
            where  location_Id =  sd.dest_loc_id)
       else (
            SELECT  POSTAL_CODE
            FROM 
            hr_all_organization_units haou, hr_locations hl
            WHERE 
            haou.location_id = hl.location_Id
            and haou.organization_Id = sd.destination_org_id
            and rownum=1
            ) 
  end Zip_Code,
            
  case when ship_to.COUNTRY is not null  
            then ship_to.COUNTRY
       when sd.dest_org = 'SR1'
            then 
            (select COUNTRY  FROM 
            hr_locations
            where  location_Id =  sd.dest_loc_id)
       else (
            SELECT  COUNTRY
            FROM 
            hr_all_organization_units haou, hr_locations hl
            WHERE 
            haou.location_id = hl.location_Id
            and haou.organization_Id = sd.destination_org_id
            and rownum=1
            ) 
  end Country,
  sd.party_id,          --added for v1.3
  sd.party_number,      --added for v1.3
  sd.cust_account_id,   --added for v1.3
  sd.customer_number,
  sd.customer_name,
  --item cost --
  NVL((select round(ccv.unit_cost,2)
            from 
				cst_vu_onhand_valuations            ccv,
                cst_val_unit_details             cvud,
                cst_val_unit_combinations        cvuc,
                CST_VAL_STRUCTURES_B             cval
                where 
                sd.organization_code = cvuc.inv_org_code
                and sd.subinventory = cvuc.subinventory_code --added for inventory valuation method change
                AND cvud.val_unit_combination_id = cvuc.val_unit_combination_id
                AND cvud.val_unit_id = ccv.val_unit_id
                AND cvud.cost_book_id = ccv.cost_book_id
                AND  cvud.VAL_STRUCTURE_ID = cval.VAL_STRUCTURE_ID 
                AND sd.inventory_item_id = ccv.inventory_item_id
                AND cval.VAL_STRUCTURE_TYPE_CODE = 'ASSET'
                AND cvuc.enabled_flag = 'Y'
                AND TRUNC(SYSDATE) BETWEEN TRUNC((NVL(cvuc.start_date_Active,sysdate))) AND TRUNC((NVL(cvuc.end_date_Active,sysdate)))
                --AND SYSDATE < ccv.eff_to_date
				and sysdate between ccv.start_date and ccv.end_date
                --AND SYSDATE >= ccv.snapshot_date
                AND ROWNUM = 1
                ),
                (select round(ccv.unit_cost,2)
				from 
				cst_vu_onhand_valuations         ccv,
                cst_val_unit_details             cvud,
                cst_val_unit_combinations        cvuc
                where 
                sd.organization_code = cvuc.inv_org_code
                and sd.subinventory = cvuc.subinventory_code --added for inventory valuation method change
                AND cvud.val_unit_combination_id = cvuc.val_unit_combination_id
                AND cvud.val_unit_id = ccv.val_unit_id
                AND cvud.cost_book_id = ccv.cost_book_id
                AND sd.inventory_item_id = ccv.inventory_item_id               
                AND cvuc.enabled_flag = 'Y'
                AND TRUNC(SYSDATE) BETWEEN TRUNC((NVL(cvuc.start_date_Active,sysdate))) AND TRUNC((NVL(cvuc.end_date_Active,sysdate)))
                --AND SYSDATE < ccv.eff_to_date
                and sysdate between ccv.start_date and ccv.end_date
				--AND SYSDATE >= ccv.snapshot_date
                and rownum=1)
	) item_cost,
  --item_cost --
  (SELECT SUBSTR(ec.category_name,1,INSTR(ec.category_name,'.') -1)
        --eia.category_id,eia.inventory_item_id,eia.organization_id
        FROM  egp_item_cat_assignments eia,
              egp_category_sets_vl ecs, 
			  egp_categories_vl ec
        WHERE  1=1
		and ec.category_id = eia.category_id
        AND eia.category_set_id = ecs.category_set_id
        AND ecs.category_set_name = 'Inventory'
		and eia.inventory_item_id = msi.inventory_item_id
        and rownum=1
   ) Product_type ,
  (SELECT SUBSTR(category_name,INSTR(category_name,'.')+1)
        --eia.category_id,eia.inventory_item_id,eia.organization_id
        FROM  egp_item_cat_assignments eia,
              egp_category_sets_vl ecs, 
			  egp_categories_vl ec
        WHERE  1=1
		and ec.category_id = eia.category_id
        AND eia.category_set_id = ecs.category_set_id
        AND ecs.category_set_name = 'Inventory'
		and eia.inventory_item_id = msi.inventory_item_id
        and rownum=1
   ) Product_family ,  
   
  case when sd.SOURCE_DOCUMENT_TYPE_CODE='TO'
        then (SELECT a.destination_subinventory_code 
				FROM INV_TRANSFER_ORDER_LINES a
				WHERE a.header_id = sd.SOURCE_ORDER_ID
				and rownum=1) 
  end destination_subinventory_code , 
        
   case when sd.SOURCE_DOCUMENT_TYPE_CODE='TO'
        then
			(SELECT inv.organization_name 
			FROM INV_TRANSFER_ORDER_LINES a,
			inv_organization_definitions_v inv
			WHERE a.header_id = sd.SOURCE_ORDER_ID
			AND  inv.organization_id = a.destination_organization_id
			and rownum=1) 
  end destination_org_name ,
  
  case when sd.SOURCE_DOCUMENT_TYPE_CODE='TO'
        then     
        (SELECT hl.LOCATION_NAME
        FROM INV_TRANSFER_ORDER_LINES a,
        hr_locations hl
        WHERE a.header_id = sd.SOURCE_ORDER_ID
        AND hl.location_id = a.destination_location_id
        and rownum=1) 
 end destination_loc_name  ,
	sd.creation_date,                  -- ITSD-190692
	sd.created_by,                     -- ITSD-190692
	sd.submitted_date booked_date,     -- ITSD-190692
	sd.submitted_by booked_by ,        -- ITSD-190692
	sd.is_booked_by_creator           -- ITSD-190692
	--sd.trx_number                      -- ITSD-190692
    ,sd.header_id                   --added for v1.3
    ,sd.line_id                     --added for v1.3
    ,sd.delivery_id                 --added for v1.3
    ,sd.delivery_detail_id          --added for v1.3
    ,sd.delivery_assignment_id      --added for v1.3
    ,sd.fulfill_line_id             --added for v1.3
from shipment_det sd, 
	 ship_to , 
	 EGP_SYSTEM_ITEMS_B  msi
where 1=1
and sd.inventory_item_id = msi.inventory_item_id  
and sd.fulfill_org_id = msi.organization_id 
and sd.ship_to_party_site_id = ship_to.party_site_id(+)
--and sd.customer_name = 'ZES SOLAR ENERJI TEDARIK VE TICARET A.Ş.'
--and sd.party_number='273380'
--and (sd.actual_Ship_Date >= NVL(:P_From_Ship_Date,sd.actual_Ship_Date) AND  trunc(sd.actual_Ship_Date) <=  NVL(:P_To_Ship_Date,SYSDATE))  --commented for v1.3
--ORDER BY SOURCE_HEADER_NUMBER ASC  --commented for v1.3