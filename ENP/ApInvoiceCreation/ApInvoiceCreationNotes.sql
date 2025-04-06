select * from poz_suppliers_v where vendor_id='300000147854070';

VENDOR_NAME (CLEAN SOLAR, INC.)
VENDOR_ID (300000147854070)
SEGMENT1 (1076)
PARTY_ID (300000147854067)
VENDOR_TYPE_LOOKUP_CODE (INSTALLER)
ATTRIBUTE1 (0002021)    --CHM_MSI_CLAIM_AP_INVOICES.INSTALLER_NUMBER



select 
     pv.vendor_id
    ,pv.vendor_name
    ,pv.segment1
    ,pvs.vendor_site_id
    ,pvs.vendor_site_code
FROM
     poz_suppliers_v pv
    ,poz_supplier_sites_all_m pvs
WHERE 1=1
AND pv.vendor_id               =   pvs.vendor_id
AND pv.vendor_type_lookup_code = 'INSTALLER'
AND (select count(1) from poz_supplier_sites_all_m pvs1
    where pvs1.vendor_id = pv.vendor_id
) >1