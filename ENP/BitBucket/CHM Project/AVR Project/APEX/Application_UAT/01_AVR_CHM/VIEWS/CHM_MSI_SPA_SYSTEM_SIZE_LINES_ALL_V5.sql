--------------------------------------------------------
--  DDL for View CHM_MSI_SPA_SYSTEM_SIZE_LINES_ALL_V5
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CHM_MSI_SPA_SYSTEM_SIZE_LINES_ALL_V5" ("ITEM_SOURCE", "PRIORITY", "SPA_LINE_TYPE", "CHM_SPA_LINE_ID", "SPA_NUMBER", "SPA_START_DATE", "SPA_EXPIRATION_DATE", "LINE_ITEM_NUMBER", "ITEM_NUMBER", "REBATE_ITEM_NUMBER", "MIN_QTY", "SPA_CURRENCY", "REBATE_CURRENCY", "REBATE_AMOUNT", "REBATE_TIER", "REBATE_TIER_MIN_QTY", "REBATE_TIER_MAX_QTY", "SPA_BACK_DATED", "SPA_CREATED_DATE", "SPA_LAST_UPDATE_DATE", "SPA_FINAL_APPROVAL_DATE_TIME", "SPA_STATUS", "SPA_TYPE", "SFDC_SPA_ID", "CHM_SPA_ID", "GEOGRAPHY", "OPPORTUNITY_OWNER", "INSTALLER_ACCOUNT_NAME", "INSTALLER_CUSTOMER_KEY", "PRIMARY_PARTNER", "SPA_NAME", "STAGE", "OPPORTUNITY_NAME", "DEAL_LOGISTICS", "OPPORTUNITY_OWNER_ID", "SPA_OPPORTUNITY_ID", "ACCOUNT_ID", "NEW_RENEWAL", "SPA_CONTACT", "SPA_TIERS", "TIER1_MIN", "TIER2_MIN", "TIER3_MIN", "TIER4_MIN", "TIER5_MIN", "TIER1_MAX", "TIER2_MAX", "TIER3_MAX", "TIER4_MAX", "TIER5_MAX") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
  'MAIN_SKU' item_source,
   0 priority,
    'SYSTEM_SIZE' spa_line_type,
    --csl.chm_msi_spa_sys_size_detail_id chm_spa_line_id,
	csl.chm_msi_spa_sys_size_id chm_spa_line_id,
    csh.spa_number SPA_NUMBER,  
	csh.spa_start_date,
	csh.spa_expiration_date,	
    -1 LINE_ITEM_NUMBER 
	,csl.product AS ITEM_NUMBER
    ,csl.product AS REBATE_ITEM_NUMBER   
	,csl.MIN_QTY MIN_QTY,
    csh.spa_total_price_currency SPA_CURRENCY,
	csh.spa_Total_Price_Currency REBATE_CURRENCY,
	--csl.tier_incentive REBATE_AMOUNT,
	csl.REBATE_AMOUNT,
    TIER_NAME REBATE_TIER,
    MIN_QTY REBATE_TIER_MIN_QTY,
    MAX_QTY REBATE_TIER_MAX_QTY,
	csh.spa_back_dated,
	csh.spa_created_date,
	csh.spa_last_update_date,
	csh.spa_final_approval_date_time,
	csh.status spa_status,
	csh.spa_type,
	csh.id sfdc_spa_id,
	csh.chm_spa_id,
	csh.geography,
	csh.opportunity_owner,
	csh.installer_account_name,
	csh.installer_customer_key,
	csh.primary_partner,
	csh.spa_name,
	csh.stage,
	csh.opportunity_name,
	csh.deal_logistics,
	csh.opportunity_owner_id,
	csh.spa_opportunity_id,
	csh.account_id,
	csh.new_renewal,
	csh.spa_contact,
	csh.spa_tiers,
	csh.tier1_min,
	csh.tier2_min,
	csh.tier3_min,
	csh.tier4_min,
	csh.tier5_min,
	csh.tier1_max,
	csh.tier2_max,
	csh.tier3_max,
	csh.tier4_max,
	csh.tier5_max	
	FROM 
	CHM_MSI_SYS_SIZE_INCENTIVE_V1 CSL,
	--CHM_MSI_SYS_SIZE_INCENTIVE_CHM CSL,
	--chm_msi_spa_system_size_incentive_detail  CSL,
	 	chm_msi_spa_header CSH
	WHERE 
	--csl.spa=csh.spa_number
	 csl.spa=csh.id
	--AND UPPER(NVL(csh.is_deleted,'FALSE'))='FALSE'
	AND UPPER(NVL(csl.is_deleted,'FALSE'))='FALSE'
	--AND UPPER(NVL(csl.status,'xx'))='APPROVED'	 
  UNION ALL
SELECT 
  -- when spa alternate sku with price is provided in lookup
	  'SPA_SPECIFIC_REFERENCE_SKU' item_source,
    1 priority,
    'SYSTEM_SIZE' spa_line_type,
    --csl.CHM_MSI_SPA_SYS_SIZE_DETAIL_ID CHM_SPA_LINE_ID,
	csl.chm_msi_spa_sys_size_id chm_spa_line_id,
    csh.spa_number SPA_NUMBER,  
	csh.spa_start_date,
	csh.spa_expiration_date,	
    -1 LINE_ITEM_NUMBER,    
    caa.enphase_code AS ITEM_NUMBER
    ,csl.product AS REBATE_ITEM_NUMBER
		,csl.MIN_QTY MIN_QTY,
		--csl.sales_price_currency SALES_PRICE_CURRENCY,
    csh.spa_total_price_currency SPA_CURRENCY,
		csh.Spa_Total_Price_Currency REBATE_CURRENCY,
		--csl.tier_incentive REBATE_AMOUNT,
		csl.REBATE_AMOUNT,
    TIER_NAME REBATE_TIER,
    MIN_QTY REBATE_TIER_MIN_QTY,
    MAX_QTY REBATE_TIER_MAX_QTY,
	csh.spa_back_dated,
	csh.spa_created_date,
	csh.spa_last_update_date,
	csh.spa_final_approval_date_time,
	csh.status spa_status,
	csh.spa_type,
	csh.id sfdc_ap_id,
	csh.chm_spa_id,
	csh.geography,
	csh.opportunity_owner,
	csh.installer_account_name,
	csh.installer_customer_key,
	csh.primary_partner,
	csh.spa_name,
	csh.stage,
	csh.opportunity_name,
	csh.deal_logistics,
	csh.opportunity_owner_id,
	csh.spa_opportunity_id,
	csh.account_id,
	csh.new_renewal,
	csh.spa_contact,
	csh.spa_tiers,
	csh.tier1_min,
	csh.tier2_min,
	csh.tier3_min,
	csh.tier4_min,
	csh.tier5_min,
	csh.tier1_max,
	csh.tier2_max,
	csh.tier3_max,
	csh.tier4_max,
	csh.tier5_max
	FROM 
		CHM_CLAIMS_ALTERNATE_ATTRIBUTES caa,
   -- CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL  CSL,
   --CHM_MSI_SYS_SIZE_INCENTIVE_CHM CSL,
   CHM_MSI_SYS_SIZE_INCENTIVE_V1 CSL,
    CHM_MSI_SPA_HEADER CSH
	WHERE  1=1
  AND caa.spa_code=csh.spa_number
 --AND  csl.chm_spa_id=csh.chm_spa_id
 --AND  csl.spa=csh.spa_number
 AND csl.spa=csh.id
	--AND UPPER(NVL(csh.is_deleted,'FALSE'))='FALSE'
	AND UPPER(NVL(csl.is_deleted,'FALSE'))='FALSE'
	--AND UPPER(NVL(csl.status,'xx'))='APPROVED' 
  AND caa.type = 'SKU'
	AND NVL(caa.enabled,'N')='Y'
	AND caa.reference_sku=csl.product
	AND (caa.spa_code,caa.enphase_code) NOT IN
                    (SELECT csh1.spa_number, csl1.product 
                    FROM CHM_MSI_SYS_SIZE_INCENTIVE_CHM CSL1,
												CHM_MSI_SPA_HEADER CSH1
												WHERE  1=1
                         --AND  csl.chm_spa_id=csh.chm_spa_id
                          --AND  csl1.spa=csh1.spa_number
						  AND csl1.spa=csh1.id
												)
	AND (caa.spa_code,caa.reference_sku) IN (SELECT csh1.spa_number, csl1.product 
                        FROM CHM_MSI_SYS_SIZE_INCENTIVE_CHM  csl1,
												CHM_MSI_SPA_HEADER CSH1
												WHERE 1=1
                         --AND  csl.chm_spa_id=csh.chm_spa_id
                          --AND  csl1.spa=csh1.spa_number
						  AND csl1.spa=csh1.id
												)                        
  AND NVL(caa.UNIT_REBATE_AMT,0) = 0 -- we need to get  Unit Rebate Amount from reference SKU
   AND caa.spa_code IS NOT NULL 
   AND caa.reference_sku IS NOT NULL
UNION ALL
SELECT DISTINCT
   -- when spa alternate sku is referenced to another sku without price we need to use reference SKU on the SPA to get the price
	  'GLOBAL_REFERENCE_SKU' item_source,
    2 priority,
    'SYSTEM_SIZE' spa_line_type,
    --csl.CHM_MSI_SPA_SYS_SIZE_DETAIL_ID CHM_SPA_LINE_ID,
	csl.chm_msi_spa_sys_size_id chm_spa_line_id,
    csh.spa_number SPA_NUMBER,
	csh.spa_start_date,
	csh.spa_expiration_date,	
		-1 LINE_ITEM_NUMBER 
		,caa.enphase_code AS ITEM_NUMBER
    ,csl.product AS REBATE_ITEM_NUMBER
		,csl.MIN_QTY MIN_QTY,
		--csl.sales_price_currency SALES_PRICE_CURRENCY,
    csh.spa_total_price_currency SPA_CURRENCY,
		csh.Spa_Total_Price_Currency REBATE_CURRENCY,
		--csl.tier_incentive REBATE_AMOUNT,
		csl.REBATE_AMOUNT,
    TIER_NAME REBATE_TIER,
    MIN_QTY REBATE_TIER_MIN_QTY,
    MAX_QTY REBATE_TIER_MAX_QTY,
	csh.spa_back_dated,
	csh.spa_created_date,
	csh.spa_last_update_date,
	csh.spa_final_approval_date_time,
	csh.status spa_status,
	csh.spa_type,
	csh.id sfdc_ap_id,
	csh.chm_spa_id,
	csh.geography,
	csh.opportunity_owner,
	csh.installer_account_name,
	csh.installer_customer_key,
	csh.primary_partner,
	csh.spa_name,
	csh.stage,
	csh.opportunity_name,
	csh.deal_logistics,
	csh.opportunity_owner_id,
	csh.spa_opportunity_id,
	csh.account_id,
	csh.new_renewal,
	csh.spa_contact,
	csh.spa_tiers,
	csh.tier1_min,
	csh.tier2_min,
	csh.tier3_min,
	csh.tier4_min,
	csh.tier5_min,
	csh.tier1_max,
	csh.tier2_max,
	csh.tier3_max,
	csh.tier4_max,
	csh.tier5_max
	FROM 
		chm_claims_alternate_attributes caa,
    --CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVE_DETAIL  CSL,
	--CHM_MSI_SYS_SIZE_INCENTIVE_CHM CSL,
	CHM_MSI_SYS_SIZE_INCENTIVE_V1 CSL,
    chm_msi_spa_header CSH
	WHERE  
 1=1
 --AND  csl.chm_spa_id=csh.chm_spa_id
 --AND  csl.spa=csh.spa_number
 AND  csl.spa=csh.id
 AND  csl.product=caa.reference_sku
 --AND UPPER(NVL(csh.is_deleted,'FALSE'))='FALSE'
 AND UPPER(NVL(csl.is_deleted,'FALSE'))='FALSE'
 --AND UPPER(NVL(csl.status,'xx'))='APPROVED' 
 AND  caa.type = 'SKU'
 AND  NVL(caa.enabled,'N')='Y'
 AND  NVL(caa.unit_rebate_amt,0) = 0 -- we need to get  Unit Rebate Amount from reference SKU
 AND  caa.reference_sku IS NOT NULL
 -- we are not picking spa specific reference SKUs here
 AND (csh.spa_number,caa.enphase_code) NOT IN 
     (SELECT  NVL(CAA1.SPA_CODE,'X'), NVL(CAA1.ENPHASE_CODE,'X') 
      FROM CHM.CHM_CLAIMS_ALTERNATE_ATTRIBUTES caa1 WHERE TYPE='SKU'
      AND   NVL(caa1.enabled,'N')='Y'
     )    
 -- we are not picking SKUs that are already on the SPA
 AND (csh.spa_number,caa.enphase_code) 
 NOT IN (SELECT csh1.spa_number,  csl1.product 
				FROM  CHM_MSI_SYS_SIZE_INCENTIVE_CHM  CSL1,
				  		CHM_MSI_SPA_HEADER CSH1
					WHERE
          -- csl1.chm_spa_id=csh1.chm_spa_id
          csl1.spa=csh1.spa_number
					)
;
