/*************************************************************************************************
* Report Name           : Invoice Rejection Report                                               *
* Purpose               : Report to extract Invoice Rejection Details                            *
*                                                                                                *
**************************************************************************************************
* Date          Author                 Version          Description                              *
* -----------   ---------------------  -------          -----------------------------------------*
* 16-Apr-2025   Gurpreet Singh         1.0              Initial Version                          *
*************************************************************************************************/
SELECT
     aii.load_request_id
    ,aii.invoice_id
    ,aii.invoice_num
    ,LISTAGG( distinct air.reject_lookup_code, ', ') WITHIN GROUP (ORDER BY air.reject_lookup_code) reject_lookup_code
    ,(SELECT count(*) FROM ap_invoices_interface WHERE LOAD_REQUEST_ID = :load_request_id and NVL(STATUS,'NA') <>'PROCESSED') failed_count
    ,aii.status
FROM
     ap_interface_rejections air
	,ap_invoices_interface aii
WHERE 1=1
AND aii.load_request_id = air.load_request_id (+)
AND aii.load_request_id = :load_request_id
group by aii.load_request_id
    ,aii.invoice_id
    ,aii.invoice_num
    ,aii.status