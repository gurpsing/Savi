Select Invoice_Num from AP_INVOICES_ALL aia
 where Source='MSI'
AND not exists (
    SELECT 1 FROM ap_invoice_distributions_all aida
    WHERE aida.invoice_id = aia.invoice_id AND nvl(aida.match_status_flag,'N') <> 'A'
) 
AND aia.wfapproval_status = 'WFAPPROVED'
order by last_update_date desc

