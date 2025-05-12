--------------------------------------------------------
--  DDL for Package CHM_MSI_CLAIM_PROCESS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHM_MSI_CLAIM_PROCESS_PKG" AS
/*************************************************************************************************************************************************************************
    * Type                      : PL/SQL Package                                                                                                                        
    * Package Name        		: CHM_MSI_CLAIM_PROCESS_PKG                                                                                                                         
    * Purpose                   : Package for Processing MSI Rebate Claims                                                                                                
    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            	: 10-FEB-2025  
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------

    *************************************************************************************************************************************************************************/

 FUNCTION clear_batch_line_log (
    p_line_id IN NUMBER
  ) RETURN NUMBER;

  FUNCTION clear_batch_line_reject_reasons (
    p_line_id IN NUMBER
  ) RETURN NUMBER;  

  PROCEDURE insert_batch_logs (
    p_run_id IN NUMBER, p_file_id IN NUMBER, p_batch_id IN NUMBER, p_line_id NUMBER, p_log_type VARCHAR2, p_log_code VARCHAR2, p_log_msg VARCHAR2, p_source_app_id IN NUMBER
  );

  PROCEDURE insert_claim_batch_exception (
    p_run_id NUMBER, p_batch_id NUMBER, p_line_id NUMBER, p_error_type VARCHAR2, p_error_code VARCHAR2, p_error_msg VARCHAR2, p_source_app_id NUMBER
  );

  PROCEDURE ap_invoice_process_request (
		p_request_id NUMBER
	);  

PROCEDURE send_ap_invoice_email (
	p_batch_id    IN NUMBER DEFAULT NULL,
	p_report_request_id IN NUMBER DEFAULT NULL
);

PROCEDURE submit_ap_invoice_process(
	p_batch_id chm_msi_claim_batch.batch_id%TYPE,
	p_msg	OUT VARCHAR2
  );

  PROCEDURE insert_claim_reject_reasons (
    p_run_id IN NUMBER, p_file_id IN NUMBER, p_batch_id IN NUMBER,
	p_claim_line_id IN chm_msi_claim_reject_reasons.claim_line_id%TYPE, 
	p_reason_type IN VARCHAR2,
	p_reason_code IN chm_msi_claim_reject_reasons.reason_code%TYPE, 
	p_comments IN VARCHAR2,
	p_source_app_id IN NUMBER
  );

  PROCEDURE cancel_batch (p_batch_id NUMBER,p_reason_code IN VARCHAR2 DEFAULT NULL, p_comments IN VARCHAR2 DEFAULT NULL);

  PROCEDURE cancel_batch_line (p_batch_id NUMBER,p_batch_line_id NUMBER, 
	p_reason_code IN VARCHAR2 DEFAULT NULL, p_comments IN VARCHAR2 DEFAULT NULL);

  PROCEDURE reject_batch_line (p_batch_id NUMBER,p_batch_line_id NUMBER);

  PROCEDURE create_claim_batch(p_report_request_id IN NUMBER, p_run_id IN NUMBER);


  FUNCTION reset_rebate_line_status(p_claim_batch_id IN NUMBER, p_claim_line_id IN NUMBER)
  RETURN NUMBER;

  FUNCTION reset_rebate_lines_status(p_claim_batch_id IN NUMBER)
  RETURN NUMBER;

  FUNCTION is_auto_approve(p_claim_type VARCHAR2) RETURN VARCHAR2;

  PROCEDURE ap_invoice_process (p_batch_id chm_msi_claim_batch.batch_id%TYPE);

  PROCEDURE auto_ap_invoice_process (p_request_id NUMBER);


  PROCEDURE insert_report_requests
  (
		p_user_id           IN        NUMBER,
		p_to_email      IN      VARCHAR2,
		p_ref_name       IN      VARCHAR2,
		p_installer_id      IN      VARCHAR2,
		p_file_type      IN      VARCHAR2,
		p_from_date      IN     VARCHAR2,
		p_to_date      IN     VARCHAR2,
		p_batch_type	IN		VARCHAR2,
		p_report_type     IN		VARCHAR2,
		p_rebate_type 	  IN		VARCHAR2,	
		p_country		  IN		VARCHAR2
  );


END CHM_MSI_CLAIM_PROCESS_PKG;

/
