/*************************************************************************************************
* Report Name           : Self Billing Report                                                    *
* Purpose               : Report to extract Invoice Details                                      *
*                                                                                                *
**************************************************************************************************
* Date          Author                 Version          Description                              *
* -----------   ---------------------  -------          -----------------------------------------*
* 12-May-2025   Gurpreet Singh         1.0              Initial Version                          *
*************************************************************************************************/
SELECT  DISTINCT
     aia.invoice_id                                 AS INVOICE_ID
    ,aia.invoice_num                                AS INVOICE_NUMBER
    ,1                                              AS KEY
    ,to_char(trunc(aia.invoice_date),'mm/dd/yyyy')  AS INVOICE_DATE
    ,(  SELECT 
         TO_CHAR(TRUNC(aps.due_date),'mm/dd/yyyy')
        FROM ap_payment_schedules_all aps
        WHERE aps.invoice_id = aia.invoice_id
        AND ROWNUM=1
    )                                               AS DUE_DATE
    ,aia.description                                AS DESCRIPTION
    ,aia.INVOICE_CURRENCY_CODE                      AS CUR
    ,TO_CHAR(aia.invoice_amount, 'FM9999999990.00') AS AMOUNT
	,aia.PAYMENT_METHOD_CODE                        AS METHOD
    ,psv.party_id                                   AS PARTY_ID
    ,psv.vendor_name                                AS SUPPLIER_NAME
    ,psv.segment1                                   AS SUPPLIER_NUMBER
    ,psp.income_tax_id                              AS INCOME_TAX_ID
    ,pssm.vendor_site_code                          AS SUPPLIER_SITE
    ,hl.address1                                    AS SUPPLIER_ADDRESS1
    ,hl.address2                                    AS SUPPLIER_ADDRESS2
    ,hl.city                                        AS SUPPLIER_CITY
    ,ftv.territory_short_name                       AS COUNTRY
    ,NVL(psc.email_address,'Not Present')           AS SUPPLIER_EMAIL
    ,NVL(psc.phone_number, 'Not Present')           AS SUPPLIER_PHONE_NUMBER
    ,'ap@enphaseenergy.com'                         AS BILL_EMAIL
    ,'ap@enphaseenergy.com'                         AS SHIP_EMAIL
    ,ieba.bank_account_number                       AS BANK_ACCOUNT_NUM
    ,ieba.bank_account_name                         AS BANK_ACCOUNT_NAME
    ,NVL(ieba.bank_branch_name,'Not Present')       AS BRANCH_NAME
    ,NVL(ieba.bank_number, 'Not Present')           AS BRANCH_NUMBER
    ,NVL(ieba.bank_name,'Not Present')              AS BANK_NAME
    ,hle.address1                                   AS BILL_Addr1
    ,hle.address2                                   AS Bill_Addr2
	,hle.city                                       AS Bill_Addr3
	,hle.Postal_Code                                AS Bill_Addr4
	,ftv.territory_short_name                       AS Bill_Country
    ,hle.address1                                   AS Ship_Addr1
    ,hle.address2                                   AS Ship_Addr2
	,hle.city                                       AS Ship_Addr3
	,hle.Postal_Code                                AS Ship_Addr4
	,ftv.territory_short_name                       AS Ship_Country
	,ibm.remit_advice_email                         AS REMITTANCE_EMAIL 
    ,(  SELECT 
          TO_CHAR((NVL(zl.TAX_RATE,0)),'FM990.00')
        FROM zx_lines_det_factors jtdfl
            ,zx_lines zl ,ap_invoices_all inv
        WHERE 1=1
        AND jtdfl.TRX_LINE_ID   = zl.TRX_LINE_ID
        AND inv.invoice_id      = zl.trx_id
        AND inv.invoice_id      = jtdfl.trx_id
        AND inv.invoice_id      = aia.invoice_id
        AND inv.CANCELLED_DATE  IS NULL
        AND ROWNUM=1
    )                                               AS TAX_RATE 
    ,(  SELECT SUM(NVL(zl.UNROUNDED_TAX_AMT,0)) 
        FROM zx_lines_det_factors jtdfl
            ,zx_lines zl ,ap_invoices_all inv
        WHERE 1=1
        AND jtdfl.TRX_LINE_ID   = zl.TRX_LINE_ID
        AND inv.invoice_id      = zl.trx_id
        AND inv.invoice_id      = jtdfl.trx_id
        AND inv.invoice_id      = aia.invoice_id
        AND inv.CANCELLED_DATE  IS NULL
    )                                               AS TOTAL_TAX
FROM
     AP_INVOICES_ALL                aia
    ,POZ_SUPPLIERS_V                psv
    ,POZ_SUPPLIER_SITES_ALL_M       pssm
    ,POZ_SUPPLIERS_PII              psp 
    ,HZ_LOCATIONS                   hl
    ,IBY_EXT_BANK_ACCOUNTS_V        ieba
    ,(
        SELECT *
        FROM (
            SELECT psc.*,
                   ROW_NUMBER() OVER (PARTITION BY sup_party_id ORDER BY last_update_date DESC) AS rn
            FROM poz_all_supplier_contacts_v psc
        )
        WHERE rn = 1
    ) psc
    ,HR_OPERATING_UNITS             hou
    ,XLE_ENTITY_PROFILES            xep
    ,XLE_REGISTRATIONS              xr
    ,HZ_LOCATIONS                   hle
    ,FND_TERRITORIES_VL             ftv
    ,iby_external_payees_all        ibm
WHERE 1 = 1
AND aia.vendor_id           = psv.vendor_id
AND psv.vendor_id           = psv.vendor_id
AND pssm.vendor_id          = psv.vendor_id
AND hl.location_id          = pssm.location_id
--AND psv.vendor_name         = ieba.bank_account_name (+)
AND psv.party_id            = ieba.primary_acct_owner_party_id (+)
AND psv.vendor_id           = psp.vendor_id
AND psc.sup_party_id (+)    = psv.party_id
AND aia.org_id              = hou.organization_id
AND xep.legal_entity_id     = hou.default_legal_context_id 
AND xep.legal_entity_id     = xr.source_id
AND xr.location_id          = hle.location_id
AND xr.source_table         = 'XLE_ENTITY_PROFILES'
AND hle.country             = ftv.territory_code 
AND psv.party_id            = ibm.payee_party_id (+)
AND 'EMAIL'                 = ibm.remit_advice_delivery_method (+)
AND SYSDATE BETWEEN NVL (xr.effective_from, SYSDATE - 1) AND NVL (xr.effective_to, SYSDATE + 1)
AND aia.invoice_num         = :INVOICE_NUMBER
