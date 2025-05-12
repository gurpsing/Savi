SELECT aia.invoice_id, 
       aia.invoice_num, 
       ibm.remit_advice_email AS ToEmail
       --, psv.vendor_name,
       --, aia.invoice_date
FROM ap_invoices_all aia,
     poz_suppliers ps,
     poz_suppliers_v psv,
     iby_external_payees_all ibm
WHERE 1 = 1
  AND aia.vendor_id = ps.vendor_id
  AND ps.vendor_id = psv.vendor_id
  AND psv.party_id = ibm.payee_party_id
  AND ibm.remit_advice_delivery_method = 'EMAIL'
  AND aia.source = 'MSI'
  AND (
      (:INVOICE_NUMBER IS NOT NULL AND :INVOICE_NUMBER != 'NA' AND aia.invoice_num = :INVOICE_NUMBER)
      OR
      (
        (:INVOICE_NUMBER IS NULL OR :INVOICE_NUMBER = 'NA')
        AND (:SUPPLIER_NAME IS NOT NULL AND :SUPPLIER_NAME != 'NA')
        AND psv.vendor_name = :SUPPLIER_NAME
        AND trunc(aia.invoice_date) >= trunc(to_date(:From_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN'))
        AND trunc(aia.invoice_date) <= trunc(to_date(:To_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN'))
      )
      OR
      (
        (:INVOICE_NUMBER IS NULL OR :INVOICE_NUMBER = 'NA')
        AND (:SUPPLIER_NAME IS NULL OR :SUPPLIER_NAME = 'NA')
        AND trunc(aia.invoice_date) >= trunc(to_date(:From_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN'))
        AND trunc(aia.invoice_date) <= trunc(to_date(:To_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN'))
      )
  )



SELECT aia.invoice_id, 
       aia.invoice_num, 
       ibm.remit_advice_email AS ToEmail
       , psv.vendor_name
       , aia.invoice_date
FROM ap_invoices_all aia,
     poz_suppliers ps,
     poz_suppliers_v psv,
     iby_external_payees_all ibm
WHERE 1 = 1
  AND aia.vendor_id = ps.vendor_id
  AND ps.vendor_id = psv.vendor_id
  AND psv.party_id = ibm.payee_party_id
  AND ibm.remit_advice_delivery_method = 'EMAIL'
  AND aia.source = 'MSI'
  and aia.invoice_num ='CHM_MSI_881_9000026'
  
  
  INVOICE_ID (1678070)
INVOICE_NUM (CHM_MSI_881_9000026)
TOEMAIL (JOELLENT@CLEANSOLAR.COM,AP@enphaseenergy.com)
VENDOR_NAME (CLEAN SOLAR, INC.)
INVOICE_DATE (2025-04-16T00:00:00.000+00:00)

  
  AND (
      (:INVOICE_NUMBER IS NOT NULL AND :INVOICE_NUMBER != 'NA' AND aia.invoice_num = :INVOICE_NUMBER) false
      OR
      (
        (:INVOICE_NUMBER IS NULL OR :INVOICE_NUMBER = 'NA')
        AND (:SUPPLIER_NAME IS NOT NULL AND :SUPPLIER_NAME != 'NA') false
        AND psv.vendor_name = :SUPPLIER_NAME
        AND aia.invoice_date >= to_date(:From_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN')
        AND aia.invoice_date <= to_date(:To_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN') 
      )
      OR
      (
        (:INVOICE_NUMBER IS NULL OR :INVOICE_NUMBER = 'NA')
        AND (:SUPPLIER_NAME IS NULL OR :SUPPLIER_NAME = 'NA')
        AND aia.invoice_date >= to_date(:From_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN')
        AND aia.invoice_date <= to_date(:To_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN') 
      )
  )
  
  
  
  
SELECT aia.invoice_id, 
       aia.invoice_num, 
       ibm.remit_advice_email AS ToEmail
       , psv.vendor_name
       , aia.invoice_date
       , trunc(to_date(:From_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN')) from_date
       , trunc(to_date(:To_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN')) To_date
FROM ap_invoices_all aia,
     poz_suppliers ps,
     poz_suppliers_v psv,
     iby_external_payees_all ibm
WHERE 1 = 1
  AND aia.vendor_id = ps.vendor_id
  AND ps.vendor_id = psv.vendor_id
  AND psv.party_id = ibm.payee_party_id
  AND ibm.remit_advice_delivery_method = 'EMAIL'
  AND aia.source = 'MSI'
and aia.invoice_num ='CHM_MSI_881_9000026'
AND trunc(aia.invoice_date) >= trunc(to_date(:From_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN'))
AND trunc(aia.invoice_date) <= trunc(to_date(:To_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=AMERICAN'))

  