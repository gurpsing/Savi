/*************************************************************************************************
* Report Name           : Self Billing Report                                                *
* Purpose               : Report to extract Invoice Details 
*                                                                                                *
**************************************************************************************************
* Date          Author                 Version          Description                              *
* -----------   ---------------------  -------          -----------------------------------------*
* 28-Apr-2025   Raja Ratnakar           1.0              Initial Version                          *
*************************************************************************************************/
SELECT DISTINCT
    aia.invoice_num                 invoice_number,
    1  as Key,
    to_char(trunc(aia.invoice_date),'mm/dd/yy') invoice_date,
    to_char(trunc(aia.terms_date),'mm/dd/yy')   due_date,
    aia.description,
    aia.invoice_amount              Amount,
	aia.PAYMENT_METHOD_CODE         Method,
    psv.vendor_name                 supplier_name,
    pssm.vendor_site_code           supplier_site,
    ps.segment1                     supplier_number,
    hl.address1                     supplier_address1,
    hl.address2                     supplier_address2,
    hl.city                         supplier_city,
    ftv.territory_short_name        country,
    NVL(psc.email_address,'Not Present') supplier_email,
    NVL(psc.phone_number, 'Not Present') supplier_phone_number,
    aia.invoice_id,
    ps.party_id,
    ieba.bank_account_number  bank_account_num,
    ieba.bank_account_name,
    NVL(ieba.bank_branch_name,'Not Present') branch_name,
    NVL(ieba.bank_number, 'Not Present') branch_number,
    NVL(ieba.bank_name,'Not Present') bank_name,
    psp.income_tax_id,
    hl1.address1 BILL_Addr1,
    hl1.address2 Bill_Addr2,
	hl1.city Bill_Addr3,
	hl1.Postal_Code Bill_Addr4,
	ftv.territory_short_name Bill_Country,
    hl1.address1 Ship_Addr1,
    hl1.address2 Ship_Addr2,
	hl1.city     Ship_Addr3,
	hl1.Postal_Code Ship_Addr4,
	ftv.territory_short_name Ship_Country,
	ibm.remit_advice_email  Remittance_Email, 
    'ap@enphaseenergy.com' BILL_Email,
    'ap@enphaseenergy.com' SHIP_Email

FROM
    ap_invoices_all          aia,
    poz_suppliers            ps,
    poz_suppliers_v          psv,
    poz_supplier_sites_all_m pssm,
    hz_locations             hl,
    IBY_EXT_BANK_ACCOUNTS_V    ieba,
    poz_suppliers_pii        psp,
	xle_entity_profiles      xep,
	hz_locations             hl1,
	xle_registrations        xr,
    xle_jurisdictions_vl     xjv,
    fnd_territories_vl       ftv,
	ce_index_banks           cea,
	--ce_index_bank_branches   ceab,
	iby_external_payees_all  ibm,
    (
        SELECT *
        FROM (
            SELECT psc.*,
                   ROW_NUMBER() OVER (PARTITION BY sup_party_id ORDER BY last_update_date DESC) AS rn
            FROM poz_all_supplier_contacts_v psc
        )
        WHERE rn = 1
    ) psc
WHERE
    1 = 1
    AND aia.vendor_id = ps.vendor_id
    AND ps.vendor_id = psv.vendor_id
    AND pssm.vendor_id = ps.vendor_id
    AND hl.location_id = pssm.location_id
    AND ieba.bank_account_name = psv.vendor_name
    AND ps.vendor_id = psp.vendor_id
    AND psc.sup_party_id = psv.party_id
	AND hl.country = xep.ATTRIBUTE_CATEGORY
	AND xep.name = hl1.ADDRESS1
	AND xr.source_table = 'XLE_ENTITY_PROFILES'
    AND xr.source_id = xep.legal_entity_id
    AND xjv.jurisdiction_id = xr.jurisdiction_id
    AND hl1.location_id = xr.location_id
    AND ftv.territory_code = hl1.country
	--AND ieba.bank_id = cea.bank_party_id
	AND psv.party_id = ibm.payee_party_id
	AND ibm.remit_advice_delivery_method = 'EMAIL'
	--AND cea.bank_id = ceab.bank_party_id
    AND SYSDATE BETWEEN NVL (xr.effective_from, SYSDATE - 1)
                     AND NVL (xr.effective_to, SYSDATE + 1)
    AND aia.invoice_num = :INVOICE_NUMBER