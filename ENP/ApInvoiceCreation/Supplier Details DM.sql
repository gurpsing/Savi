/*************************************************************************************************
* Report Name           : Supplier Details Report                                                *
* Purpose               : Report to extract Supplier Details from installer number               *
*                                                                                                *
**************************************************************************************************
* Date          Author                 Version          Description                              *
* -----------   ---------------------  -------          -----------------------------------------*
* 16-Apr-2025   Gurpreet Singh         1.0              Initial Version                          *
*************************************************************************************************/
SELECT
    psv.segment1 Supplier_Number,
    psv.vendor_name Supplier_Name,
    psm.vendor_site_code Supplier_site,
    psv.attribute1 Installer_Number
FROM
    poz_suppliers_v          psv,
    poz_supplier_sites_all_m psm
WHERE
        1 = 1
    AND psv.vendor_id = psm.vendor_id
    AND psv.attribute1 = :installer_number
    AND rownum=1
    
   