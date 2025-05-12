--------------------------------------------------------
--  DDL for Package Body CHM_MSI_CLAIM_PROCESS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHM_MSI_CLAIM_PROCESS_PKG" AS
/*************************************************************************************************************************************************************************
    * Type                      : PL/SQL Package                                                                                                                        
    * Package Name        		: CHM_MSI_CLAIM_PROCESS_PKG                                                                                                                         
    * Purpose                   : Package for Processing MSI Rebate Claims                                                                                                
    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            	: 10-FEB-2025  
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------
      04-APR-2025             Ronnie Moses                            Selectiva                       1.0             Fixing the logic for the AP Invoice request (Request should verify for pending invoice status).
	  04-APR-2025             Raj V		                          	  Selectiva                       1.1             Procedure send_ap_invoice_email Added logic to get Requestor Email in send_ap_invoice_email procedure
	  04-APR-2025             Raj V		                          	  Selectiva                       1.1             Procedure create_claim_batch Changed the status update to g_status_batch_created instead of SUBMITTED_FOR_PAYMENT
    *************************************************************************************************************************************************************************/
  g_instance_name			VARCHAR2(2000):= chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'SERVER_NAME' );
	g_mail_from        VARCHAR2(100) := NVL(chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_MSI_CLAIM_EMAILS', p_lookup_code => 'MSI_EMAIL_FROM' ),'donotreply@enphaseenergy.com');  
	g_application_id   NUMBER := NVL(chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'APPLICATION_ID' ),101);  
  g_auto_approval_auto_submit BOOLEAN := FALSE;
  g_report_type	VARCHAR2(4000);
  g_report_request_id NUMBER;
  g_run_id	NUMBER;
  g_status_new VARCHAR2(50) := 'NEW';
  g_status_processed VARCHAR2(50) := 'PROCESSED';
  g_status_in_process VARCHAR2(50) := 'IN_PROCESS';
  g_status_exception VARCHAR2(50) := 'EXCEPTION';
  g_status_completed  VARCHAR2(50) := 'COMPLETED';
  g_status_valid VARCHAR2(50) := 'VALID';
  g_status_valid_with_exception VARCHAR2(50) := 'VALID_WITH_EXCEPTION';
  g_status_accepted VARCHAR2(50) := 'ACCEPTED';
  g_status_needs_revalidation VARCHAR2(50) := 'NEEDS_REVALIDATION';
  g_status_pending_approval VARCHAR2(50) := 'PENDING_APPROVAL';
  g_status_pending_ap_invoice VARCHAR2(50) := 'PENDING_AP_INVOICE_CREATION';
  g_status_approved VARCHAR2(50) := 'APPROVED';
  g_status_rejected VARCHAR2(50) := 'REJECTED';
  g_status_cancelled VARCHAR2(50) := 'CANCELLED';
  g_status_closed VARCHAR2(50) := 'CLOSED';
  g_status_batch_created	VARCHAR2(50):='INCENTIVE_BATCH_CREATED';
  g_file_type VARCHAR2(50) := 'CLAIMS';
  g_msg_log VARCHAR2(50) := 'MESSAGE';
  g_debug_log VARCHAR2(50) := 'DEBUG_MESSAGE';
  g_error_log VARCHAR2(50) := 'ERROR';
  g_warning_log VARCHAR2(50) := 'WARNING';
  g_success_log VARCHAR2(50) := 'SUCCESS';
  g_reject_reason_lookup_type VARCHAR2(50) := 'CHM_MSI_CLAIM_REJECT_REASONS_LOV';
  g_cancel_reason_lookup_type VARCHAR2(50) := 'CHM_MSI_CLAIM_CANCEL_REASON';
  g_spa_mapping_type VARCHAR2(50) := 'SPA';
  g_sku_mapping_type VARCHAR2(50) := 'SKU';
  g_installer_mapping_type VARCHAR2(50) := 'INSTALLER';
  g_dist_record_type VARCHAR2(50) := 'DISTRIBUTOR';
  g_reason_type VARCHAR2(50) := 'SYSTEM';
  g_user_reason_type VARCHAR2(50) := 'USER';
  g_cancel_reason_type VARCHAR2(50) := 'USER_CANCEL';
  g_no_data_found NUMBER := -1;
  g_more_than_one_found NUMBER := -2;
  g_all_lines_claimed NUMBER := -3;
  g_user_num_id							NUMBER:=CHM_MSI_SCHEDULE_REQUEST_PKG.get_user_id(CHM_UTIL_PKG.GETUSERNAME());
  g_conversion_type VARCHAR2(50) := 'User';
  g_claim_source VARCHAR2(50) := 'ENE_MANUAL_UPLOAD';
  g_transaction_type VARCHAR2(50) := 'CM';
  g_claim_line_type VARCHAR2(50) := 'LINE';

  g_status_generated 					VARCHAR2(50) := 'GENERATED';
  g_status_failed 						VARCHAR2(50) := 'FAILED';
  g_status_submitted 					VARCHAR2(50) := 'SUBMITTED';

  g_msi_rebate_ap_invoice_email_to VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_MSI_CLAIM_EMAILS','MSI_REBATE_AP_INVOICE_EMAIL_TO');
  g_msi_rebate_ap_invoice_email_cc VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_MSI_CLAIM_EMAILS','MSI_REBATE_AP_INVOICE_EMAIL_CC'); 
  g_msi_rebate_ap_invoice_email_bcc VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_MSI_CLAIM_EMAILS','MSI_REBATE_AP_INVOICE_EMAIL_BCC');

  g_unit_amount_tolerance NUMBER := 1;
  g_days_tolerance NUMBER := 1;
  g_qty_tolerance NUMBER := 1;
  g_source_app_id NUMBER := chm_util_pkg.getsourceapp('CHM');
  g_file_id NUMBER;
  g_batch_id NUMBER;
  g_user_id	VARCHAR2(1000):=CHM_UTIL_PKG.GETUSERNAME();
  g_ip_address VARCHAR2(1000):=CHM_UTIL_PKG.GETIPADDRESS();
  g_enterprise_id	NUMBER:=CHM_CONST_PKG.GETENTERPRISEID();
  g_start_date    DATE:=NVL(CHM_POS_CLAIM_CREATION_PKG.get_start_date,TO_DATE('01-JAN-2023','DD-MON-RRRR')); --cutoff date
  g_user_name VARCHAR2(4000);

  g_all_lines_cancel_reason_code	VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_ALL_LINES_CANCEL_REASON_CODE');
  g_all_lines_cancel_comment  		VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_ALL_LINES_CANCEL_REASON_COMMENTS');


  g_ap_invoice_source		VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','INVOICE_SOURCE'),'MSI');
  g_ap_invoice_description	VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','INVOICE_DESCRIPTION'),'Marketing Services Incentive (MSI)');
  g_ap_invoice_type			VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','INVOICE_TYPE'),'STANDARD');
  g_ap_calculate_tax		VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','CALCULATE_TAX'),'Y');
  g_ap_add_tax				VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','ADD_TAX'),'Y');
  g_ap_line_type			VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','LINE_TYPE'),'ITEM');
  g_ap_product_type			VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','PRODUCT_TYPE'),'SERVICES');
  g_ap_line_group_number	VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','LINE_GROUP_NUMBER'),'1');
  g_ap_attribute_category	VARCHAR2(4000):=NVL(CHM_UTIL_PKG.get_lookup_value('CHM_MSI_AP_INVOICE_SETUP','ATTRIBUTE_CATEGORY'),'ENE_MSI_AP_LINES_DFF');


  FUNCTION is_auto_approve(p_claim_type VARCHAR2) RETURN VARCHAR2
  AS 
  l_auto_approve	VARCHAR2(4000):='N';

  CURSOR c_approve IS 
  SELECT description
  FROM	 chm_lookup_values_v1
  WHERE  lookup_type='CHM_MSI_CLAIM_TYPE'
  AND    lookup_code=p_claim_type;

  BEGIN

	FOR vc IN c_approve LOOP
		l_auto_approve:=vc.description;
	END LOOP;

	RETURN l_auto_approve;
  EXCEPTION
	WHEN OTHERS THEN 
		RETURN l_auto_approve;
  END is_auto_approve;



  --Added by Raj 3/6/25
  FUNCTION get_user_name(p_user_id IN NUMBER)
  RETURN VARCHAR2
  AS
  l_user_name   VARCHAR2(4000);
  BEGIN
    SELECT  MAX(user_name)
    INTO    l_user_name
    FROM    chm_user_management
    WHERE   user_id=p_user_id;

    RETURN l_user_name;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN TO_CHAR(p_user_id);
  END get_user_name;

  FUNCTION clear_batch_line_log (
    p_line_id IN NUMBER
  ) RETURN NUMBER AS
  BEGIN
    insert_batch_logs(g_run_id, g_file_id, g_batch_id, p_line_id, g_debug_log, 'CLEAR_BATCH_LINE_LOG', ' p_line_id = ' || p_line_id, g_source_app_id);

    DELETE FROM chm_msi_claim_logs
    WHERE
        line_id = p_line_id AND nvl(current_flag, 'N') = 'Y';

    RETURN SQL%rowcount;
  EXCEPTION
    WHEN OTHERS THEN
      chm_msi_debug_api.log_exp(p_line_id, 'Error occurred in CHM_MSI_CLAIM_PROCESS_PKG.clear_batch_line_log ', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace);

      RETURN 0;
  END clear_batch_line_log;

  FUNCTION clear_batch_line_reject_reasons (
    p_line_id IN NUMBER
  ) RETURN NUMBER AS
  BEGIN
    insert_batch_logs(g_run_id, g_file_id, g_batch_id, p_line_id, g_debug_log, 'CLEAR_BATCH_LINE_REJECT_REASONS', ' p_line_id = ' || p_line_id, g_source_app_id);

    DELETE FROM chm_msi_claim_reject_reasons
    WHERE
        claim_line_id = p_line_id AND reason_type = 'SYSTEM'; --06-nov-2023 changes													   

    RETURN SQL%rowcount;
  EXCEPTION
    WHEN OTHERS THEN
      chm_msi_debug_api.log_exp(p_line_id, 'Error occurred in CHM_MSI_CLAIM_PROCESS_PKG.clear_batch_line_reject_reasons ', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace);

      RETURN 0;
  END clear_batch_line_reject_reasons;

  PROCEDURE insert_batch_logs (
    p_run_id IN NUMBER, p_file_id IN NUMBER, p_batch_id IN NUMBER, p_line_id NUMBER, p_log_type VARCHAR2, p_log_code VARCHAR2, p_log_msg VARCHAR2, p_source_app_id IN NUMBER
  ) AS
    PRAGMA autonomous_transaction;
  BEGIN
    INSERT INTO chm_msi_claim_logs (
      batch_log_id, run_id, file_id, line_id, batch_id, log_type, log_code, log_msg, current_flag, source_app_id
    ) VALUES (
      chm_claim_logs_seq.NEXTVAL, p_run_id, p_file_id, p_line_id, p_batch_id, p_log_type, p_log_code, p_log_msg, 'Y', p_source_app_id
    );

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      chm_msi_debug_api.log_exp(p_run_id, 'chm_process_claim_pkg.insert_batch_logs', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace);

  END insert_batch_logs;

  PROCEDURE insert_claim_batch_exception (
    p_run_id NUMBER, p_batch_id NUMBER, p_line_id NUMBER, p_error_type VARCHAR2, p_error_code VARCHAR2, p_error_msg VARCHAR2, p_source_app_id NUMBER
  ) AS
  BEGIN
    INSERT INTO chm_msi_claim_batch_exceptions (
      batch_id, line_id, run_id, current_flag, error_type, error_code, error_message, start_date, source_app_id
    ) VALUES (
      p_batch_id, p_line_id, p_run_id, 'Y', p_error_type, p_error_code, p_error_msg, systimestamp, p_source_app_id
    );

  EXCEPTION
    WHEN OTHERS THEN
      chm_msi_debug_api.log_exp(p_line_id, 'Error occurred in CHM_MSI_CLAIM_PROCESS_PKG.insert_claim_batch_exception ', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace);
  END insert_claim_batch_exception;  

 PROCEDURE insert_claim_reject_reasons (
    p_run_id IN NUMBER, p_file_id IN NUMBER, p_batch_id IN NUMBER,
	p_claim_line_id IN chm_msi_claim_reject_reasons.claim_line_id%TYPE, 
	p_reason_type IN VARCHAR2,
	p_reason_code IN chm_msi_claim_reject_reasons.reason_code%TYPE, 
	p_comments IN VARCHAR2,
	p_source_app_id IN NUMBER
  ) AS
    l_reason_description chm_claim_reject_reasons.reason_description%TYPE;
	l_msg			VARCHAR2(4000);
  BEGIN 

    insert_batch_logs(p_run_id, p_file_id, p_batch_id, NULL, g_debug_log, 'INSERT_CLAIM_REJECT_REASONS', 'p_claim_line_id = ' || p_claim_line_id || 'p_reason_code = ' || p_reason_code, p_source_app_id);

    IF p_reason_type='CANCEL' THEN 
		l_reason_description := chm_util_pkg.get_lookup_value(g_cancel_reason_lookup_type, p_reason_code);
	ELSE 
		l_reason_description := chm_util_pkg.get_lookup_value(g_reject_reason_lookup_type, p_reason_code);

	END IF; 

    INSERT INTO chm_msi_claim_reject_reasons (batch_id,
      claim_line_id, reason_code, reason_description, reason_type, reason_comment,source_app_id
    ) VALUES (
      p_batch_id,p_claim_line_id, p_reason_code, l_reason_description, p_reason_type, p_comments,
	  p_source_app_id
    );

  EXCEPTION
    WHEN OTHERS THEN
      insert_batch_logs(p_run_id, p_file_id, p_batch_id, p_claim_line_id, g_error_log, 'CLAIM_REJECT_REASONS', 'Error occurred  in CHM_MSI_CLAIM_PROCESS_PKG.insert_claim_reject_reasons: ' || dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_source_app_id);

      chm_msi_debug_api.log_exp(p_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.insert_claim_reject_reasons', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace);
	  RAISE; 
  END insert_claim_reject_reasons;



  FUNCTION reset_rebate_line_status(p_claim_batch_id IN NUMBER, p_claim_line_id IN NUMBER)
  RETURN NUMBER
  AS
  l_msg			VARCHAR2(4000);
  BEGIN 

	l_msg := 'Resetting Rebate Lines having Claim Line ID = '||p_claim_line_id;
	insert_batch_logs(-1, -1, p_claim_batch_id, p_claim_line_id, g_msg_log, 'RESET_REBATE_LINE_STATUS', l_msg, g_source_app_id);

	UPDATE 	chm_enlighten_device_rebates
	   SET  rebate_status = 'ELIGIBLE_FOR_PAYMENT'
			,claim_line_id=NULL
			,claim_batch_id=NULL
	 WHERE 	claim_line_id=p_claim_line_id;

	RETURN SQL%ROWCOUNT;
  END reset_rebate_line_status;

  FUNCTION reset_rebate_lines_status(p_claim_batch_id IN NUMBER)
  RETURN NUMBER AS
  l_msg			VARCHAR2(4000);
  BEGIN 

	l_msg := 'Resetting All Rebate Lines having Claim Batch ID = '||p_claim_batch_id;
	insert_batch_logs(-1, -1, p_claim_batch_id, NULL, g_msg_log, 'RESET_REBATE_LINES_STATUS', l_msg, g_source_app_id);

	UPDATE 	chm_enlighten_device_rebates
	   SET  rebate_status = 'ELIGIBLE_FOR_PAYMENT'
			,claim_line_id=NULL
			,claim_batch_id=NULL
	 WHERE 	claim_batch_id=p_claim_batch_id;

	RETURN SQL%ROWCOUNT;
  END reset_rebate_lines_status;  

  PROCEDURE cancel_batch (p_batch_id NUMBER, p_reason_code IN VARCHAR2 DEFAULT NULL, p_comments IN VARCHAR2 DEFAULT NULL)
  AS 
  l_no_of_rows	NUMBER:=0;
  l_msg			VARCHAR2(4000);
  BEGIN 

	l_msg := 'Cancelling Batch ID '||p_batch_id||' Reason = '||p_reason_code;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	UPDATE chm_msi_claim_batch
	SET 	batch_status=g_status_cancelled
	WHERE	batch_id=p_batch_id;

	l_no_of_rows:=SQL%ROWCOUNT;

	l_msg := 'No of Batch Records updated with CANCEL = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	UPDATE chm_msi_claim_batch_lines
	SET 	line_status=g_status_cancelled
	WHERE	batch_id=p_batch_id;

	l_no_of_rows:=SQL%ROWCOUNT;

	l_msg := 'No of Line Records updated with CANCEL = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	--release rebate lines
	l_no_of_rows:=reset_rebate_lines_status(p_batch_id);

	l_msg := 'No of Rebate Records Released = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	insert_claim_reject_reasons (
		p_run_id => -1, p_file_id => -1, p_batch_id => p_batch_id,
		p_claim_line_id => NULL, 
		p_reason_type => 'CANCEL',
		p_reason_code => p_reason_code, 
		p_comments => p_comments,
		p_source_app_id => g_source_app_id
	  );

	l_msg := 'Inserted Cancel Reason Code and Comments';
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);



  END cancel_batch;

  PROCEDURE cancel_batch_line (p_batch_id NUMBER,p_batch_line_id NUMBER, 
  p_reason_code IN VARCHAR2 DEFAULT NULL, p_comments IN VARCHAR2 DEFAULT NULL)
  AS 
  l_no_of_rows	NUMBER:=0;
  l_msg			VARCHAR2(4000);
  BEGIN 

	l_msg := 'Cancelling Batch Line ID '||p_batch_line_id||' Reason = '||p_reason_code;
	insert_batch_logs(-1, -1, p_batch_id, p_batch_line_id, g_msg_log, 'CANCEL_BATCH_LINE', l_msg, g_source_app_id);

	UPDATE chm_msi_claim_batch_lines
	SET 	line_status=g_status_cancelled
	WHERE	batch_id=p_batch_id
	AND 	line_id=p_batch_line_id;

	l_no_of_rows:=SQL%ROWCOUNT;

	l_msg := 'No of Line Records updated with CANCEL = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, p_batch_line_id, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	--release rebate line
	l_no_of_rows:=reset_rebate_line_status(p_batch_id,p_batch_line_id);

	l_msg := 'No of Rebate Records Released = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, p_batch_line_id, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	insert_claim_reject_reasons (
		p_run_id => -1, p_file_id => -1, p_batch_id => p_batch_id,
		p_claim_line_id => p_batch_line_id, 
		p_reason_type => 'CANCEL',
		p_reason_code => p_reason_code, 
		p_comments => p_comments,
		p_source_app_id => g_source_app_id
	  );	

	l_msg := 'Inserted Cancel Reason Code and Comments';
	insert_batch_logs(-1, -1, p_batch_id, p_batch_line_id, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	  SELECT 	count(*)
	  INTO 		l_no_of_rows
	  FROM 		chm_msi_claim_batch_lines
	  WHERE 	line_status!=g_status_cancelled;

	l_msg := 'No of Lines left without Cancel Status = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, p_batch_line_id, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);


	  IF l_no_of_rows=0 THEN 
		l_msg := 'All lines are in Cancel Status. So Cancelling the batch';
		insert_batch_logs(-1, -1, p_batch_id, p_batch_line_id, g_msg_log, 'CANCEL_BATCH', l_msg, g_source_app_id);
		cancel_batch(p_batch_id,g_all_lines_cancel_reason_code,g_all_lines_cancel_comment);
	  END IF;	

  END cancel_batch_line;


  PROCEDURE reject_batch_line (p_batch_id NUMBER,p_batch_line_id NUMBER)
  AS 
  l_no_of_rows	NUMBER:=0;
  BEGIN 

	UPDATE chm_msi_claim_batch_lines
	SET 	line_status=g_status_rejected
	WHERE	batch_id=p_batch_id
	AND 	line_id=p_batch_line_id;

	--release rebate line
	l_no_of_rows:=reset_rebate_line_status(p_batch_id,p_batch_line_id);
  END reject_batch_line;  


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
  )
AS 
l_request_id	NUMBER;
 BEGIN
	  INSERT INTO CHM_MSI_REPORT_REQUESTS (
					status,
					user_id,
					report_filters,
					report_type
				) VALUES (
					g_status_submitted,           
					p_user_id,
					'{
						FILE_REFERENCE_NAME: "'|| p_ref_name ||'",
						INSTALLER: "'|| p_installer_id || '",
						COUNTRY: "'|| p_country || '",						
						TO_EMAIL: "'|| p_to_email ||'",
						REPORT_FORMAT: "'|| p_file_type ||'",
						FROM_DATE: "'|| p_from_date ||'",
						TO_DATE: "'|| p_to_date || '",
						REBATE_TYPE: "'|| p_rebate_type || '",
						BATCH_TYPE: "'||  p_batch_type || '"}',
					p_report_type
					)
					RETURNING report_request_id INTO L_request_id;

    EXCEPTION
        WHEN OTHERS THEN

                chm_msi_debug_api.log_exp(p_transaction_id => p_ref_name, 
                                            p_module =>'CHM_MSI_CLAIM_PROCESS_PKG.insert_report_requests', 
                                            p_sqlcode => sqlcode, 
                                            p_sqlerrm => dbms_utility.format_error_stack
                                                                 || ', '
                                                                 || dbms_utility.format_error_backtrace,
                                            p_report_type => g_report_type                     
                                      );  


    END insert_report_requests;

PROCEDURE create_claim_batch(p_report_request_id IN NUMBER, p_run_id IN NUMBER)
AS

   CURSOR rebate_batch_lines_cursor (
        p_installer_id IN VARCHAR2,
        p_country      IN VARCHAR2,
        p_rebate_type  IN VARCHAR2,
        p_from_date    IN DATE,
        p_to_date      IN DATE,
        p_batch_type   IN VARCHAR2
    ) IS
    SELECT
		cedr.chm_device_rebate_id,
        cedr.chm_enlighten_site_id,
		cedr.chm_enlighten_device_id,
        cedr.spa_number,
        cedr.spa_line_id,
        cedr.device_item_number,
        cedr.rebate_item_number,
        cedr.rebate_type,
        cedr.rebate_tier,
        cedr.spa_original_amount,
        cedr.claim_date,
        cedr.rebate_currency,
        cedr.rebate_amount,
        cedr.rebate_source,
        cedr.rebate_status,
        cedr.claim_batch_id,
        cedr.claim_line_id,
        cedr.rebate_payee_type,
        cedr.rebate_payee_id,
        cesm.site_id id,
        cesm.name,
        cesm.type,
        cesm.owner_id,
        cesm.installer_id,
        cesm.maintainer_id,
        cesm.site_first_interval_end_date first_interval_end_date,
		cesm.device_first_interval_end_date,
		cesm.stage_3_status_date,
        cesm.pcu_channel_count,
        cesm.envoy_count,
        cesm.acb_count,
        cesm.nsr_count,
        cesm.encharge_count,
        cesm.enpower_count,
        cesm.pcu_types,
        cesm.status_code,
        cesm.ac_voltage,
        cesm.site_created_date created_date,
        cesm.measured_acv,
        cesm.is_lease,
        cesm.partner_id,
        cesm.system_host_id,
        cesm.enlighten_site_url,
        cesm.stage,
        cesm.system_start_date,
        cesm.zero_touch,
        cesm.allow_api_access,
        cesm.location_access,
        cesm.rate_schedule,
        cesm.description,
        cesm.operational,
        cesm.interconnect_date,
        cesm.internet_connection_type,
        cesm.pcu_attachment_type,
        cesm.connection_type,
        cesm.sfdc_drip_campaign_flag,
        cesm.iqevc_count,
        cesm.consumption_ct,
        cesm.hems,
        cesm.address_id,
        cesm.address_1,
        cesm.address_2,
        cesm.address_city,
        cesm.address_state,
        cesm.address_zip,
        cesm.address_country,
        cesm.serial_num serial_number,
        cesm.hw_part_num hw_part_number,
        cesm.device_created_date,
        cesm.disti_oracle_account_number,
        cesm.disti_oracle_account_id,
        cesm.oracle_order_type,
		cesm.product_family,
		cesm.product_type

    FROM
        chm_enlighten_device_rebates cedr,
        chm_enlighten_site_device_attributes_v1 cesm
       -- chm_enlighten_site_master    cesm,
        --chm_enlighten_device_details cedd
    WHERE
            cedr.chm_enlighten_site_id = cesm.chm_enlighten_site_id
        AND cedr.chm_enlighten_device_id = cesm.chm_enlighten_device_id
        AND cedr.claim_date BETWEEN trunc(p_from_date) and trunc(p_to_date) --TO_DATE(TO_CHAR(p_from_date, 'DD-MON-YYYY'),'DD-MON-YYYY') AND  TO_DATE(TO_CHAR(p_to_date, 'DD-MON-YYYY'), 'DD-MON-YYYY')
        --AND cesm.address_country = nvl(p_country, cesm.address_country)
			--and cedr.REBATE_PAYEE_ID = nvl(p_installer_id, cedr.REBATE_PAYEE_ID)
        AND cedr.rebate_type = nvl(p_rebate_type, cedr.rebate_type)
        AND cedr.rebate_source = 'SYSTEM'
        AND cedr.rebate_status = 'ELIGIBLE_FOR_PAYMENT'
        AND (p_country IS NULL 
			OR instr(':'
                       || p_country
                       || ':',
                       ':'
                       || cesm.address_country
                       || ':') > 0 ) 
		AND ( p_installer_id IS NULL
              OR instr(':'
                       || p_installer_id
                       || ':',
                       ':'
                       || to_char(cedr.rebate_payee_id)
                       || ':') > 0 );

 CURSOR c_distinct_payee (
        p_installer_id IN VARCHAR2,
        p_country      IN VARCHAR2,
        p_rebate_type  IN VARCHAR2,
        p_from_date    IN DATE,
        p_to_date      IN DATE,
        p_batch_type   IN VARCHAR2
    ) IS
    SELECT  cedr.rebate_payee_type,
			cedr.rebate_payee_id,
			count(*) no_of_lines
    FROM
        chm_enlighten_device_rebates cedr,
        chm_enlighten_site_device_attributes_v1 cesm
        --chm_enlighten_device_rebates cedr,
        --chm_enlighten_site_master    cesm,
        --chm_enlighten_device_details cedd
    WHERE
            cedr.chm_enlighten_site_id = cesm.chm_enlighten_site_id
        AND cedr.chm_enlighten_device_id = cesm.chm_enlighten_device_id            
        AND cedr.claim_date BETWEEN trunc(p_from_date) and trunc(p_to_date)
        --AND cesm.address_country = nvl(p_country, cesm.address_country)
			--and cedr.REBATE_PAYEE_ID = nvl(p_installer_id, cedr.REBATE_PAYEE_ID)
        AND cedr.rebate_type = nvl(p_rebate_type, cedr.rebate_type)
        AND cedr.rebate_source = 'SYSTEM'
        AND cedr.rebate_status = 'ELIGIBLE_FOR_PAYMENT'
		AND (p_country IS NULL 
			OR instr(':'
                       || p_country
                       || ':',
                       ':'
                       || cesm.address_country
                       || ':') > 0 )	
        AND ( p_installer_id IS NULL
              OR instr(':'
                       || p_installer_id
                       || ':',
                       ':'
                       || to_char(cedr.rebate_payee_id)
                       || ':') > 0 )
	GROUP BY cedr.rebate_payee_type,cedr.rebate_payee_id;




    l_msg                           VARCHAR2(4000);
    l_batch_id                      NUMBER;
    l_batch_line_id                 NUMBER;
    l_file_reference_name           VARCHAR2(4000);
    l_to_email                      VARCHAR2(4000);
    l_report_format                 VARCHAR2(20);
    l_from_date                     TIMESTAMP WITH TIME ZONE;
    l_to_date                       TIMESTAMP WITH TIME ZONE;
    l_installer_id                  VARCHAR2(4000);
    l_batch_type                    VARCHAR2(4000);
    l_report_request_id             NUMBER := p_report_request_id;
    l_batch_reference_name          VARCHAR2(4000);
    l_rebate_type                   VARCHAR2(4000);
    l_country                       VARCHAR2(4000);
    l_rebate_batch_cursor_count     NUMBER := 0; --added by Ronnie
    l_rows_inserted                 NUMBER := 0; --added by Ronnie
	l_batch_inserted                NUMBER := 0;
    m_claim_date                    DATE; ---TEMP
    l_file_id                       NUMBER;
	l_file_rows_inserted			NUMBER;
	l_batch_rows_inserted			NUMBER;
	l_auto_approve					VARCHAR2(4000);

BEGIN

    l_msg := 'START CREATE_CLAIM_BATCH';
	CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', 'Start Claim Process', 'MSI_CLAIM_BATCH_CREATION');	
	g_run_id:=p_run_id;


	g_report_type:='MSI_CLAIM_BATCH_CREATION';
    chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
    , p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);


	 --Added by Raj
	  --This is to collect all the parameters from the user submitted request from UI
	  -- The reqeust is stored in chm_msi_report_requests along with the parameters in JSON format
	  --we will read the JSON format and get the parameters into variables

    BEGIN
        SELECT
            jt.file_reference_name || jt.report_format,
            jt.file_reference_name,
            jt.installer,
            jt.country,
            jt.rebate_type,
            jt.to_email,
            jt.report_format,
            to_timestamp_tz(jt.from_date, chm_const_pkg.getdateformattzr),
            to_timestamp_tz(jt.to_date, chm_const_pkg.getdateformattzr),
            jt.batch_type
        INTO
            l_file_reference_name,
            l_batch_reference_name,
            l_installer_id,
            l_country,
            l_rebate_type,
            l_to_email,
            l_report_format,
            l_from_date,
            l_to_date,
            l_batch_type
        FROM
                JSON_TABLE ( (
                    SELECT
                        REPORT_FILTERS
                    FROM
                        chm_msi_report_requests
                    WHERE
                        report_request_id = p_report_request_id
                ), '$[*]'
                    COLUMNS (
                        file_reference_name VARCHAR2 ( 4000 ) PATH '$.FILE_REFERENCE_NAME',
                        installer VARCHAR2 ( 4000 ) PATH '$.INSTALLER',
                        country VARCHAR2 ( 4000 ) PATH '$.COUNTRY',
                        rebate_type VARCHAR2 ( 4000 ) PATH '$.REBATE_TYPE',
                        to_email VARCHAR2 ( 4000 ) PATH '$.TO_EMAIL',
                        report_format VARCHAR2 ( 4000 ) PATH '$.REPORT_FORMAT',
                        from_date VARCHAR2 ( 4000 ) PATH '$.FROM_DATE',
                        to_date VARCHAR2 ( 4000 ) PATH '$.TO_DATE',
                        batch_type VARCHAR2 ( 4000 ) PATH '$.BATCH_TYPE'
                    )
                )
            jt;
--debug_rk('parameters query from date ' || l_from_date ||'to date '|| l_to_date);
--debug_rk('lines creation begins rebate_batch_lines_cursor ' || l_installer_id ||', '|| l_country ||', '|| l_rebate_type ||', '|| l_from_date ||', '|| l_to_date ||', '|| l_batch_type);
    EXCEPTION
       WHEN no_data_found THEN
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH', 
							p_msg =>'NO DATA FOUND FOR THE REQUEST ID' , p_report_type=> g_report_type);
        WHEN OTHERS THEN 
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH', 
							p_msg =>SQLERRM , p_report_type=> g_report_type);
    END;

	l_msg:='l_file_reference_name = '||l_file_reference_name||'l_batch_reference_name = '||l_batch_reference_name||' l_installer_id = '||l_installer_id||' l_country = '||l_country||' l_rebate_type = '||l_rebate_type||' l_to_email = '||l_to_email||' l_report_format = '||l_report_format||' l_from_date = '||l_from_date||' l_to_date = '||l_to_date||' l_batch_type = '||l_batch_type;
	chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);	


      -- If there is no such Request ID then we will exit the procedure
      --Added by Raj
    IF l_from_date IS NULL THEN 
        ---ADD LOG MESSAGES AS EXITING
		 chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id , p_module =>  'CREATE_CLAIM_BATCH', 
							p_msg =>'FROM DATE IS NULL FOR THE REQUEST ID' , p_report_type=> g_report_type);


		BEGIN
			l_msg:='Update Request Status to Failed';
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);	
			chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_failed);
		EXCEPTION
			WHEN OTHERS THEN
				UPDATE chm_msi_report_requests
				SET
					status = g_status_failed
				WHERE
					report_request_id = l_report_request_id;

				chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', 'update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);

				COMMIT;
				RETURN;
		END;							

        RETURN;
    END IF;
--debug_rk('end if line 420 ');
    --Added by Raj
    --We will update the request status as IN_PROCESS so its reflected on UI that its being processed
    BEGIN
		l_msg:='Update Request Status to In Process';
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);	

        chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_in_process);
    EXCEPTION
        WHEN OTHERS THEN
            UPDATE chm_msi_report_requests
            SET
                status = g_status_failed
            WHERE
                report_request_id = l_report_request_id;
--debug_rk('failed status update ' || g_status_failed );
            chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', 'update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);

            COMMIT;
            RETURN;
    END;


    IF l_batch_type = 'ALL_INSTALLERS' THEN
--debug_rk('ALL INSTALLERS IF ENTERED ');
--debug_rk('lines creation begins rebate_batch_lines_cursor ' || l_installer_id ||', '|| l_country ||', '|| l_rebate_type ||', '|| l_from_date ||', '|| l_to_date ||', '|| l_batch_type);
		--PLEASE ADD LOGIC TO CHECK IF THERE ARE ANY VALID CHILD RCORDS.
		--IF YES THEN ONLY WE WILL CREATE A BATCH ELSE WE WILL NOT CREATE BATCH AND 
		--UPDATE THE REQUEST AS COMPLETED
		l_rebate_batch_cursor_count:=0;
		FOR rbc IN rebate_batch_lines_cursor(l_installer_id,		--added by Ronnie
										l_country, 
										l_rebate_type, 
										l_from_date, 
										l_to_date,
                                      l_batch_type) 
        LOOP
            l_rebate_batch_cursor_count := l_rebate_batch_cursor_count + 1;
            EXIT WHEN l_rebate_batch_cursor_count = 1;
        END LOOP;
--debug_rk('l_rebate_batch_cursor_count ' || l_rebate_batch_cursor_count);
		l_msg:='l_rebate_batch_cursor_count = '||l_rebate_batch_cursor_count;

		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

        IF l_rebate_batch_cursor_count = 0 THEN
			BEGIN
				l_msg:='No Eligible Records Found. Exiting the process ';
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
				chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_failed);
			EXCEPTION
				WHEN OTHERS THEN
					UPDATE chm_msi_report_requests
					SET
						status = g_status_failed
					WHERE
						report_request_id = l_report_request_id;

					chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', 'update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);

					COMMIT;
					RETURN;
			END;					

			RETURN;

		ELSE --Create Batch and Lines

      --added by Raj 3/6/25

					INSERT INTO chm_msi_claim_files (
						file_name,
						file_path,
						file_content,
						sheet_name,
						file_status,
						claim_type,
						source_app_id,
						enterprise_id,
						batch_reference
					) values
					(
						l_batch_reference_name,
						'Request ID : '||l_report_request_id||'-'||'User Submitted Request',
						'User Submitted Request',
						'User Submitted Request',
						g_status_in_process,
						'MSI_REBATE',
						chm_util_pkg.getsourceapp('CHM'),
						1,
						l_batch_reference_name
                    )
					RETURN file_id INTO l_file_id;

		l_file_rows_inserted:=SQL%ROWCOUNT;
        l_msg :='File ID Created. File ID = '||l_file_id||'. No of rows inserted = '||l_file_rows_inserted;
        chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
        chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

			SELECT chm_msi_claim_batch_seq.NEXTVAL 
			INTO l_batch_id FROM dual;
--debug_rk('batch creation begins l_batch_id ' || l_batch_id);
			l_msg := 'Batch ID = '||l_batch_id;
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			


            INSERT INTO chm_msi_claim_batch (
                batch_id,
                file_id,
                payee_id,
                batch_status,
                batch_start_date,
                batch_end_date,
                batch_source,
                claim_type,
                batch_reference,
				report_request_id
            ) VALUES (
                l_batch_id,
                l_file_id,
                - 1,
                g_status_new,
                TRUNC(l_from_date),
                TRUNC(l_to_date),
                'SYSTEM',
                'MSI_REBATE',
                l_batch_reference_name, ----Added by Raj 
				l_report_request_id
            );
--debug_rk('batch created ');

			l_batch_rows_inserted:=SQL%ROWCOUNT;
			l_msg := 'No of Batches Inserted = '||l_batch_rows_inserted;
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);


			l_rows_inserted:=0;
--debug_rk('534 before for cursor ');
			FOR r IN rebate_batch_lines_cursor(l_installer_id, l_country, l_rebate_type, l_from_date, l_to_date,
                                        l_batch_type) 
			LOOP
--debug_rk('entered loop ');
--debug_rk('entered loop ' || to_char(l_from_date, 'dd-mon-yy') || ' , ' || trunc(l_to_date));
m_claim_date := r.claim_date;
--debug_rk('claim_date format 1 ' || m_claim_date);
--debug_rk('claim_date format 2 ' || to_timestamp(m_claim_date, CHM_CONST_PKG.getdateformattzr));
--debug_rk('chm_device_rebate_id ' || r.chm_device_rebate_id);
                INSERT INTO chm_msi_claim_batch_lines (
                    batch_id,
					chm_device_rebate_id,
                    line_status,
                    approval_status,
                    duplicate_line_id,
                    claim_date,
                    claim_type,
                    spa_number,
                    device_item_number,
                    serial_number,
                    hw_part_number,
                    device_created_date,
                    chm_enlighten_device_id,
                   -- chm_msi_device_activation_id,
                    qty_sold,
                    uom,
                    rebate_item_number,
                    rebate_type,
                    rebate_tier,
                    unit_claim_amount,
                    extended_claim_amount,
                    user_unit_claim_amount,
                    user_extended_claim_amount,
                    currency,
                    chm_enlighten_site_id,
                    site_id,
					device_first_interval_end_date,
                    site_first_interval_end_date,
					stage_3_status_date,
                    site_stage,
                    site_type,
                    site_name,
                    site_address_id,
                    site_address1,
                    site_address2,
                    site_city,
                    site_state,
                    site_zip,
                    site_country,
                    payee_id,
                    payee_type,
                    installer_id,
                    oracle_order_type,
                    oracle_disti_id,
                    oracle_disti_account_number,
					product_type,
					product_family					
                ) VALUES (
                    l_batch_id,
					r.chm_device_rebate_id,
                    g_status_new,
                    NULL,
                    NULL,
					r.claim_date,
                    --to_timestamp(r.claim_date, 'DD-MON-RR'), --added by Ronnie
                    'MSI_REBATE',
                    r.spa_number,
                    r.device_item_number,
                    r.serial_number,
                    r.hw_part_number,
					r.device_created_date,
                    --TO_TIMESTAMP_TZ(r.device_created_date, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'),
                    r.chm_enlighten_device_id,          
                    1,
                    NULL,
                    r.rebate_item_number,
                    r.rebate_type,
                    r.rebate_tier,
                    r.rebate_amount,
                    r.rebate_amount,
                    NULL,
                    NULL,
                    r.rebate_currency,
                    r.chm_enlighten_site_id,
                    r.id,
					r.device_first_interval_end_date,
					r.first_interval_end_date,
					--TO_TIMESTAMP_TZ(r.device_first_interval_end_date, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'), --added by Ronnie
                    --TO_TIMESTAMP_TZ(r.first_interval_end_date, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'), --added by Ronnie
					r.stage_3_status_date,
                    r.stage,
                    r.type,
                    r.name,
                    r.address_id,
                    r.address_1,
                    r.address_2,
                    r.address_city,
                    r.address_state,
                    r.address_zip,
                    r.address_country,
                    r.rebate_payee_id,
                    r.rebate_payee_type,
                    r.installer_id,
                    r.oracle_order_type,
                    r.disti_oracle_account_number,
                    r.disti_oracle_account_id,
					r.product_type,
					r.product_family					
                ) RETURNING line_id INTO l_batch_line_id;

--debug_rk('609: No. of rows inserted in lines table  ' || SQL%rowcount);
				--l_msg := 'No of Batch Lines Inserted = ' || SQL%rowcount;
				--chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				--chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

                l_rows_inserted := l_rows_inserted + 1; --INCREMENT ROWS INSERTED

                UPDATE chm_enlighten_device_rebates
                SET
                    claim_batch_id = l_batch_id,
                    claim_line_id = l_batch_line_id,
                    rebate_status = g_status_batch_created  ----Added by Raj
                WHERE
                        chm_device_rebate_id = r.chm_device_rebate_id; --Added by Ronnie -- CHECK This condition is incorrect. You have to update using the primary key of the table
----debug_rk('623: No of Rebate Records Updated  ' || SQL%rowcount);
				--l_msg := 'No of Rebate Records Updated = ' || SQL%rowcount;
				--chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				--chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

            END LOOP;
--debug_rk('629: Total No of Claim Lines Inserted  ' || l_rows_inserted || l_batch_id);
			l_msg := 'Total No of Claim Lines Inserted = ' ||l_rows_inserted||' for Batch ID = '||l_batch_id;
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
			insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);



			UPDATE 	chm_msi_claim_files
			SET 	file_status = g_status_processed
			WHERE 	file_id = l_file_id;

			l_msg := 'Updated File status to Processed '||' for File ID = '||l_file_id;
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
			insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);

/* 			--check for Auto Approval 
			l_auto_approve:=is_auto_approve('MSI_REBATE');

			l_msg := 'Checking for Auto Approve. Auto Approve = '||l_auto_approve;

			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
			insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);

			chm_msi_claim_approval_pkg.submit_auto_approval_request(l_batch_id,'AUTO_APPROVE_BATCH_'||l_batch_id,'Auto Approve MSI Claim Batch '||l_batch_id);

			l_msg := 'Auto Approve Completed';

			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
			insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);
 */

			BEGIN
				l_msg:='Update Request Status to Completed';
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);	

				chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_generated);
				insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE chm_msi_report_requests
					SET
						status = g_status_failed
					WHERE
						report_request_id = l_report_request_id;

					chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', 'update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);

					COMMIT;
					RETURN;
			END;

		END IF; -- l_rebate_batch_cursor_count = 0
	END IF; ---l_batch_type = 'ALL_INSTALLERS'

----------------------------------------------------------------------------------------
--CREATE ONE BATCH PER INSTALLER PAYEE
----------------------------------------------------------------------------------------

	IF l_batch_type = 'EACH_INSTALLER' THEN
--debug_rk('EACH_INSTALLER IF ');
		l_rebate_batch_cursor_count:=0;
		FOR rbc IN rebate_batch_lines_cursor(l_installer_id,		--added by Ronnie
										l_country, 
										l_rebate_type, 
										l_from_date, 
										l_to_date,
                                      l_batch_type) 
        LOOP
            l_rebate_batch_cursor_count := l_rebate_batch_cursor_count + 1;
            EXIT WHEN l_rebate_batch_cursor_count = 1;
        END LOOP;
--debug_rk('REBATE_BATCH CURSOR COUNT ' || l_rebate_batch_cursor_count);
		l_msg:='l_rebate_batch_cursor_count = '||l_rebate_batch_cursor_count;

		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

        IF l_rebate_batch_cursor_count = 0 THEN
			l_msg:='No Eligible Records Found. Exiting the process ';
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
--debug_rk('l_rebate_batch_cursor_count = 0: No Eligible Records Found. Exiting the process  ');
			BEGIN
				l_msg:='Update Request Status to Error';
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);	
				chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_failed);
                --debug_rk('UPDATING STATUS TO FAILED ');
			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET		status = g_status_failed
					WHERE	report_request_id = l_report_request_id;
--debug_rk('WHEN OTHERS ' || g_status_failed || ', ' || SQLERRM);
					chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', 'update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);

					COMMIT;
					RETURN;
			END;					
			RETURN;

		ELSE --Create Batch and Lines
			l_batch_inserted:=0;
			FOR vc IN c_distinct_payee(l_installer_id,		--added by Ronnie
										l_country, 
										l_rebate_type, 
										l_from_date, 
										l_to_date,
                                      l_batch_type)
			LOOP
--debug_rk('ENTERED LOOP FOR C_DISTINCT_PAYEE ');

				INSERT INTO chm_msi_claim_files (
						file_name,
						file_path,
						file_content,
						sheet_name,
						file_status,
						claim_type,
						source_app_id,
						enterprise_id,
						batch_reference
					) values
					(
						l_batch_reference_name,
						'Request ID : '||l_report_request_id||'-'||'User Submitted Request',
						'User Submitted Request',
						'User Submitted Request',
						g_status_in_process,
						'MSI_REBATE',
						chm_util_pkg.getsourceapp('CHM'),
						1,
						l_batch_reference_name
                    )
					RETURN file_id INTO l_file_id;

		l_file_rows_inserted:=SQL%ROWCOUNT;

        l_msg :='File ID Created. File ID = '||l_file_id||'. No of Rows Inserted = '||l_file_rows_inserted;
        chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
        chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

--debug_rk('902 C_DISTINCT_PAYEE BATCH ID' || l_batch_id || ', rebate_payee_id'|| vc.rebate_payee_id);

				SELECT chm_msi_claim_batch_seq.NEXTVAL 
				INTO l_batch_id FROM dual;
--debug_rk('C_DISTINCT_PAYEE BATCH ID' || l_batch_id || ', rebate_payee_id'|| vc.rebate_payee_id);
				l_msg := 'Batch ID = '||l_batch_id||' Rebate Payee ID = '||vc.rebate_payee_id||' No of Records = '||vc.no_of_lines;
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

				INSERT INTO chm_msi_claim_batch (
					batch_id,
					file_id,
					payee_id,
					batch_status,
					batch_start_date,
					batch_end_date,
					batch_source,
					claim_type,
					batch_reference,
					report_request_id
				) VALUES (
					l_batch_id,
					l_file_id,
					vc.rebate_payee_id,
					g_status_new,
					trunc(l_from_date),
					trunc(l_to_date),
					'SYSTEM',
					'MSI_REBATE',
					l_batch_reference_name, ----Added by Raj 
					l_report_request_id
				);

				l_batch_rows_inserted:=SQL%ROWCOUNT;

--debug_rk('INSERT INTO chm_msi_claim_batch NO. ' || l_batch_rows_inserted);
				l_msg := 'No of Batches Inserted = '||l_batch_rows_inserted;
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);

				l_batch_inserted:=l_batch_inserted+1;

				l_rows_inserted:=0;

				--Get only the records of the Payee ID for which batch header is created

				FOR r IN rebate_batch_lines_cursor(vc.rebate_payee_id, 
											l_country, l_rebate_type, 
											l_from_date, l_to_date,
											l_batch_type) 
				LOOP
--debug_rk('LINES CURSOR ENTERED ' || SQL%ROWCOUNT);
--debug_rk('C_DISTINCT_PAYEE BATCH ID' || l_batch_id || ', vc.rebate_payee_id '|| vc.rebate_payee_id || 'r.revate_payee_id ' || r.rebate_payee_id);

				INSERT INTO chm_msi_claim_batch_lines (
                    batch_id,
					chm_device_rebate_id,
                    line_status,
                    approval_status,
                    duplicate_line_id,
                    claim_date,
                    claim_type,
                    spa_number,
                    device_item_number,
                    serial_number,
                    hw_part_number,
                    device_created_date,
                    chm_enlighten_device_id,
                   -- chm_msi_device_activation_id,
                    qty_sold,
                    uom,
                    rebate_item_number,
                    rebate_type,
                    rebate_tier,
                    unit_claim_amount,
                    extended_claim_amount,
                    user_unit_claim_amount,
                    user_extended_claim_amount,
                    currency,
                    chm_enlighten_site_id,
                    site_id,
					device_first_interval_end_date,
                    site_first_interval_end_date,
					stage_3_status_date,
                    site_stage,
                    site_type,
                    site_name,
                    site_address_id,
                    site_address1,
                    site_address2,
                    site_city,
                    site_state,
                    site_zip,
                    site_country,
                    payee_id,
                    payee_type,
                    installer_id,
                    oracle_order_type,
                    oracle_disti_id,
                    oracle_disti_account_number,
					product_type,
					product_family					
                ) VALUES (
                    l_batch_id,
					r.chm_device_rebate_id,
                    g_status_new,
                    NULL,
                    NULL,
					r.claim_date,
                    --to_timestamp(r.claim_date, 'DD-MON-RR'), --added by Ronnie
                    'MSI_REBATE',
                    r.spa_number,
                    r.device_item_number,
                    r.serial_number,
                    r.hw_part_number,
					r.device_created_date,
                    --TO_TIMESTAMP_TZ(r.device_created_date, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'),
                    r.chm_enlighten_device_id,          
                    1,
                    NULL,
                    r.rebate_item_number,
                    r.rebate_type,
                    r.rebate_tier,
                    r.rebate_amount,
                    r.rebate_amount,
                    NULL,
                    NULL,
                    r.rebate_currency,
                    r.chm_enlighten_site_id,
                    r.id,
					r.device_first_interval_end_date,
					r.first_interval_end_date,
					--TO_TIMESTAMP_TZ(r.device_first_interval_end_date, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'), --added by Ronnie
                    --TO_TIMESTAMP_TZ(r.first_interval_end_date, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZH:TZM'), --added by Ronnie
					r.stage_3_status_date,
                    r.stage,
                    r.type,
                    r.name,
                    r.address_id,
                    r.address_1,
                    r.address_2,
                    r.address_city,
                    r.address_state,
                    r.address_zip,
                    r.address_country,
                    r.rebate_payee_id,
                    r.rebate_payee_type,
                    r.installer_id,
                    r.oracle_order_type,
                    r.disti_oracle_account_number,
                    r.disti_oracle_account_id,
					r.product_type,
					r.product_family					
                ) RETURNING line_id INTO l_batch_line_id;


--debug_rk('LINES CURSOR ENTERED AFTER INSERT ' || SQL%ROWCOUNT);
--debug_rk('1028 C_DISTINCT_PAYEE BATCH ID' || l_batch_id || ', vc.rebate_payee_id '|| vc.rebate_payee_id || 'r.revate_payee_id ' || r.rebate_payee_id);
					--l_msg := 'No of Batch Lines Inserted = ' || SQL%rowcount;
					--chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
					--chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

					l_rows_inserted := l_rows_inserted + 1; --INCREMENT ROWS INSERTED

					UPDATE chm_enlighten_device_rebates
					SET
						claim_batch_id = l_batch_id,
						claim_line_id = l_batch_line_id,
						rebate_status = g_status_batch_created  ----Added by Raj
					WHERE
							chm_device_rebate_id = r.chm_device_rebate_id; --Added by Ronnie -- CHECK This condition is incorrect. You have to update using the primary key of the table

--debug_rk('AFTER UPDATING chm_enlighten_device_rebates ' || l_batch_line_id || r.rebate_payee_id);
					--l_msg := 'No of Rebate Records Updated = ' || SQL%rowcount;
					--chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
					--chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

				END LOOP;
--debug_rk('Total No of Claim Lines Inserted = ' || l_rows_inserted || ', BATCH_ID = ' || l_batch_id);
				l_msg := 'Total No of Claim Lines Inserted = ' ||l_rows_inserted||' for Batch ID = '||l_batch_id;
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
				insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);

				  UPDATE 	chm_msi_claim_files
				  SET 	file_status = g_status_processed,
						last_updated_date=SYSTIMESTAMP
				  WHERE file_id = l_file_id;

				l_msg := 'Total No of Claim Lines Inserted = ' ||l_rows_inserted||' for Batch ID = '||l_batch_id;
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
				insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);

					IF l_rows_inserted = 0 THEN
						UPDATE 	chm_msi_claim_batch 
						SET		batch_status='CANCELLED'
						WHERE 	batch_id=l_batch_id;

						l_msg := 'Updating Batch status to Cancelled as 0 lines inserted for Batch ID = '||l_batch_id;
						chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
						chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			
						insert_batch_logs(g_run_id, l_file_id, l_batch_id, NULL, g_msg_log, 'CREATE_CLAIM_BATCH', l_msg, g_source_app_id);

					END IF;


			END LOOP;
--debug_rk('Total No of Claim Batches Inserted = ' || l_batch_inserted);
			l_msg := 'Total No of Claim Batches Inserted = ' ||l_batch_inserted;
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);			

			BEGIN
				l_msg:='Update Request Status to Generated';
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
				chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);	
				chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_generated);
			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET		status = g_status_failed
					WHERE	report_request_id = l_report_request_id;
--debug_rk('WHEN OTHERS ' || g_status_failed || ', ' || SQLERRM);
					chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', 'update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);

					COMMIT;
					RETURN;
			END;			

		END IF; -- l_rebate_batch_cursor_count = 0
	END IF; ---l_batch_type = 'EACH_INSTALLER'	
--debug_rk('END CREATE_CLAIM_BATCH EACH_INSTALLER');
    l_msg := 'END CREATE_CLAIM_BATCH';
	chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.CREATE_CLAIM_BATCH', l_msg, g_report_type);
	chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);

EXCEPTION
    WHEN OTHERS THEN
		ROLLBACK;

		l_msg := SQLERRM;
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CREATE_CLAIM_BATCH',p_msg =>l_msg , p_report_type=> g_report_type);	
--debug_rk('978 EXCEPTION ' || SQLERRM);
		UPDATE chm_msi_report_requests
        SET    status = g_status_failed
        WHERE  report_request_id = l_report_request_id;

		COMMIT;	
END create_claim_batch;

PROCEDURE submit_ap_invoice_process(
	p_batch_id chm_msi_claim_batch.batch_id%TYPE,
	p_msg	OUT VARCHAR2
  ) AS

	l_request_id 	NUMBER;
	l_record_count	NUMBER;
  l_no_of_rows    NUMBER;

	v_run_id		NUMBER;
	v_in_process_run_count_excep	NUMBER;

	l_report_type	VARCHAR2(4000):='MSI_AUTO_AP_INVOICE';
	l_module		VARCHAR2(4000):='CHM_MSI_CLAIM_PROCESS_PKG.SUBMIT_AP_INVOICE_PROCESS';

	l_claim_type  VARCHAR2(100):='MSI_REBATE';
	l_auto_approve VARCHAR2(100):='N';
	v_msg	      VARCHAR2(4000);
BEGIN

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>p_batch_id,p_module=> l_module, p_msg=>'START Process.',p_report_type => l_report_type);
	v_msg := 'Inserting Request for AP Invoice Creation';
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SUBMIT_AP_INVOICE_PROCESS', v_msg, g_source_app_id);

	INSERT INTO chm_msi_report_requests (status, user_id, 
		report_filters, report_type)
		VALUES (
			g_status_submitted,           
			g_user_num_id, 
			'{	FILE_REFERENCE_NAME: "' || '[User Submitted] - [CLAIM BATCH ID : '||p_batch_id||'] '||l_report_type||' - '||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')|| '",
				REPORT_TYPE: "' || l_report_type || '",
				TO_EMAIL: "' || lower(g_user_id) || '",				
				BATCH_ID: "' || p_batch_id || '"}', 
			l_report_type
		)	RETURNING report_request_id INTO l_request_id;

	v_msg:='Submitted Report Request ID = '||l_request_id;
	p_msg:=v_msg;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SUBMIT_AP_INVOICE_PROCESS', v_msg, g_source_app_id);
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>p_batch_id,p_module=> l_module, p_msg=>'Report Request ID = '||l_request_id,p_report_type => l_report_type);

	UPDATE  chm_msi_claim_batch
	SET 	batch_status=g_status_pending_ap_invoice
			,ap_invoice_request_id=l_request_id
	WHERE	batch_id=p_batch_id
	AND 	batch_status=g_status_approved;

	l_no_of_rows:=SQL%ROWCOUNT;

	v_msg := 'No of Batch Records updated with Status Pending AP Invoice = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SUBMIT_AP_INVOICE_PROCESS', v_msg, g_source_app_id);

	UPDATE  chm_msi_claim_batch_lines
	SET 	line_status=g_status_pending_ap_invoice
			,ap_invoice_request_id=l_request_id
	WHERE	batch_id=p_batch_id
	AND 	line_status=g_status_approved;

	l_no_of_rows:=SQL%ROWCOUNT;

	v_msg := 'No of Batch Line Records updated with Status Pending AP Invoice = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SUBMIT_AP_INVOICE_PROCESS', v_msg, g_source_app_id);

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
		chm_msi_debug_api.log_exp(p_batch_id, 'Error occurred in CHM_MSI_CLAIM_PROCESS_PKG.SUBMIT_AP_INVOICE_PROCESS ', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace);
		insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SUBMIT_AP_INVOICE_PROCESS', 'Error occurred in Submit AP Invoice Process '||SQLCODE||'-'||SQLERRM, g_source_app_id);
		RAISE;
END submit_ap_invoice_process;	

PROCEDURE ap_invoice_process (
    p_batch_id chm_msi_claim_batch.batch_id%TYPE
  ) AS
    l_rec_cnt NUMBER;
	l_msg		VARCHAR2(4000);
	l_ap_invoice_number	VARCHAR2(4000);
	l_ap_invoice_id		NUMBER;
	l_reference_id		NUMBER;
	l_no_of_rows      NUMBER;
	l_accounting_date DATE:=TRUNC(SYSDATE);

CURSOR 	c_inv_group IS 
SELECT 	accounting_date,payee_number,spa_number, count(*) no_of_lines
FROM 	chm_msi_claim_ap_invoices
WHERE 	oracle_ap_interface_status=g_status_new
AND 	claim_batch_id=p_batch_id
GROUP BY accounting_date,payee_number,spa_number;

  BEGIN
	l_msg:='START ap_invoice_process';
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

	/*UPDATE  chm_msi_claim_batch
	SET 	batch_status=g_status_pending_ap_invoice
			,ap_invoice_request_id=-1
	WHERE	batch_id=p_batch_id
	AND 	batch_status=g_status_approved;

	l_no_of_rows:=SQL%ROWCOUNT;

	l_msg := 'No of Batch Records updated with Pending AP Invoice = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

	UPDATE  chm_msi_claim_batch_lines
	SET 	ap_invoice_request_id=-1
	WHERE	batch_id=p_batch_id
	AND 	line_status=g_status_approved;

	l_no_of_rows:=SQL%ROWCOUNT;

	l_msg := 'No of Line Records updated with AP Invoice Request ID = '||l_no_of_rows;
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     


	COMMIT;
	*/

	INSERT 
    INTO chm_msi_claim_ap_invoices
       (
		--invoice_line_number
		/*,invoice_source
		,invoice_description
		,invoice_type
		,calculate_tax
		,add_tax
		,line_type
		,product_type
		,line_group_number*/
        claim_batch_id
       , transaction_date
       , accounting_date
	   ,payee_number
	   ,payee_name
	   ,payee_enlighten_id
	   ,installer_number
	   ,installer_name
	   ,installer_enlighten_id	   
	   ,spa_number
	   ,spa_start_date
	   ,spa_expiration_date
	   ,rebate_type
	   ,rebate_tier
	   ,rebate_item_number
	   ,device_item_number
       ,transaction_line_description
	   ,site_id
	   ,site_name
       ,currency_code
       ,quantity
       ,total_amount
	   ,oracle_ap_interface_status
	   ,country
	   ,report_request_id
	   )
    SELECT
			--rownum,
			p_batch_id,                                                                                                        -- CLAIM_BATCH_ID
			cbl.claim_date,
			l_accounting_date,
			cbl.payee_sfdc_customer_key,
			cbl.payee_sfdc_account_name,
			cbl.payee_enlighten_installer_id,
			cbl.installer_sfdc_customer_key,
			cbl.installer_sfdc_account_name,
			cbl.installer_enlighten_installer_id,
			cbl.spa_number,
			TRUNC(cmsh.spa_start_date),
			TRUNC(cmsh.spa_expiration_date),
			cbl.rebate_type,
			cbl.rebate_tier,
			--DECODE(cbl.rebate_tier,NULL,NULL,'Level-'||cbl.rebate_tier),
			cbl.rebate_item_number,
			cbl.device_item_number,
			g_ap_invoice_description,
			--'Marketing Services Incentive (MSI)',
			cbl.site_id,
			cbl.site_name,
			cbl.currency,
			SUM(qty_sold),
			SUM(NVL(cbl.extended_claim_amount,user_extended_claim_amount)),
			g_status_new,
			NVL(csam.country,'XX'),
			g_report_request_id
			--(select country from chm_sfdc_account_master where customer_key=payee_sfdc_customer_key AND ROWNUM=1)
        FROM      chm_msi_claim_batch_lines_av  cbl
              , chm_msi_claim_batch        cb
			  ,chm_msi_spa_header cmsh
			  ,chm_sfdc_account_master csam
      WHERE     cb.batch_id = cbl.batch_id 
	  AND 		cbl.spa_number = cmsh.spa_number(+)
	  AND 		cbl.payee_sfdc_customer_key = csam.customer_key(+)
      AND       cbl.batch_id = p_batch_id 
	  AND       cb.batch_status = g_status_pending_ap_invoice
      AND       cbl.line_status= g_status_pending_ap_invoice
	  AND 		NOT EXISTS (
				SELECT 1 FROM chm_msi_claim_ap_invoices b 
				where b.claim_batch_id=p_batch_id
				)
	GROUP BY   	cbl.claim_date,
				cbl.payee_sfdc_customer_key,
				cbl.payee_sfdc_account_name,
				cbl.payee_enlighten_installer_id,
				cbl.installer_sfdc_customer_key,
				cbl.installer_sfdc_account_name,
				cbl.installer_enlighten_installer_id,
				cbl.spa_number,
				TRUNC(cmsh.spa_start_date),
				TRUNC(cmsh.spa_expiration_date),
				cbl.rebate_type,
				cbl.rebate_tier,
				cbl.rebate_item_number,
				cbl.device_item_number,
				cbl.site_id,
				cbl.site_name,
				cbl.currency,
				NVL(csam.country,'XX')
				;

    l_rec_cnt := SQL%rowcount;
	l_msg:=l_rec_cnt || ' records have been inserted successfully';

    chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
	insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
    CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

	IF l_rec_cnt = 0 THEN

		l_msg:='Reverting Batch Status to Approved';

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
		insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

		UPDATE  chm_msi_claim_batch
		SET 	batch_status=g_status_approved
		WHERE	batch_id=p_batch_id
		AND 	batch_status=g_status_pending_ap_invoice;

		l_no_of_rows:=SQL%ROWCOUNT;

		l_msg := 'No of Batch Records updated back to Approved = '||l_no_of_rows;
		insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

		UPDATE  chm_msi_claim_batch_lines
		SET 	line_status=g_status_approved
		WHERE	batch_id=p_batch_id
		AND 	line_status=g_status_pending_ap_invoice;

		l_no_of_rows:=SQL%ROWCOUNT;

		l_msg := 'No of Batch Line Records updated back to Approved = '||l_no_of_rows;
		insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

		COMMIT;		

	ELSIF l_rec_cnt > 0 THEN

		FOR vc_group IN c_inv_group LOOP 

			l_msg:='Payee Number = '||vc_group.payee_number||' Accounting Date = '||vc_group.accounting_date||' SPA Number = '||vc_group.spa_number||' No of Lines = '||vc_group.no_of_lines;
			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
    		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

			SELECT 	CHM_MSI_AP_INVOICE_NUMBER_SEQ.NEXTVAL 
			INTO 	l_ap_invoice_id
			FROM 	dual;

			l_ap_invoice_number:='CHM_MSI_'||p_batch_id||'_'||l_ap_invoice_id;

			l_msg:='l_ap_invoice_number = '||l_ap_invoice_number;
			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
    		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     	
			insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);


			UPDATE 	chm_msi_claim_ap_invoices
			SET    	oracle_ap_invoice_number=l_ap_invoice_number
					,oracle_ap_invoice_id=l_ap_invoice_id
		    WHERE 	payee_number=vc_group.payee_number
			AND 	accounting_date=vc_group.accounting_date
			AND 	spa_number=vc_group.spa_number
			AND 	oracle_ap_interface_status=g_status_new
			AND 	claim_batch_id=p_batch_id;

			l_msg:='No of Lines Updated with Inv Number = '||SQL%ROWCOUNT||'. No of Rows to Update = '||vc_group.no_of_lines;
			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     	
			insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);

			UPDATE 	chm_msi_claim_ap_invoices
			SET 	invoice_line_number=rownum
			WHERE 	oracle_ap_invoice_id=l_ap_invoice_id;

			l_rec_cnt := SQL%ROWCOUNT;
			l_msg:='Updating Invoice Line Number. No of lines updated = '||l_rec_cnt;

			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  
			insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);


			UPDATE chm_msi_claim_batch_lines ccbl
			SET    oracle_ap_invoice_id = l_ap_invoice_id
				   ,oracle_ap_invoice_number=l_ap_invoice_number	
			WHERE
				ccbl.line_status  = g_status_pending_ap_invoice
			AND ccbl.payee_id = (select MAX(chm_account_id) from chm_sfdc_account_master csam where 
								csam.customer_key=vc_group.payee_number)
			AND ccbl.spa_number=vc_group.spa_number
			AND ccbl.batch_id=p_batch_id;

			l_rec_cnt := SQL%ROWCOUNT;
			l_msg:='Updating Invoice ID and Inv Number on Batch Lines. No of lines updated = '||l_rec_cnt;

			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  	
			insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);

		END LOOP;

		--INSERT AP INVOICE HEADER

		INSERT INTO CHM_MSI_CLAIM_AP_INVOICE_HEADER
		(	oracle_ap_invoice_id ,
			oracle_ap_invoice_number,
			invoice_amount ,
			invoice_currency ,
			invoice_date ,
			installer_number ,
			installer_sfdc_account_id,
			country,
			no_of_invoice_lines,
			oracle_ap_interface_status)
		SELECT 
			ap.oracle_ap_invoice_id,
			ap.oracle_ap_invoice_number,
			sum(ap.total_amount) invoice_amount, 
			ap.currency_code invoice_currency,
			ap.accounting_date invoice_date,
			ap.installer_number, 
			csam.sfdc_account_id,
			ap.country, 
			count(*) no_of_invoice_lines,
			g_status_new
		FROM 
			chm_msi_claim_ap_invoices ap ,
			chm_sfdc_account_master csam
		WHERE 
			ap.installer_number=csam.customer_key
		AND ap.claim_batch_id=p_batch_id
		AND ap.oracle_ap_interface_status=g_status_new
		GROUP BY 	ap.oracle_ap_invoice_id,
					ap.oracle_ap_invoice_number,
					ap.currency_code ,
					ap.accounting_date ,
					ap.installer_number,
					csam.sfdc_account_id,
					ap.country;

		l_rec_cnt := SQL%ROWCOUNT;
		l_msg:='Inserting Invoice Headers. No of records inserted = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  	
		insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);



		UPDATE 	chm_msi_claim_batch_lines ccbl
		SET		line_status = g_status_closed
		WHERE  	ccbl.line_status  = g_status_pending_ap_invoice -- 26-FEB-2023
		  AND 	ccbl.batch_id = p_batch_id;

		l_rec_cnt := SQL%rowcount;
		l_msg:='Updating Line Status to Closed. No of lines updated = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
		insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  

		UPDATE 	chm_msi_claim_batch ccb
		SET		batch_status = g_status_closed
		WHERE	ccb.batch_id = p_batch_id;

		l_rec_cnt := SQL%rowcount;
		l_msg:='Updating Batch Status to Closed. No of lines updated = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
		insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     
		COMMIT;

		UPDATE chm_enlighten_device_rebates cedr
		SET    (oracle_ap_invoice_id,oracle_ap_invoice_number,rebate_status)=
				(select ccbl.oracle_ap_invoice_id,ccbl.oracle_ap_invoice_number,'SUBMITTED_FOR_INVOICE' 
				from chm_msi_claim_batch_lines ccbl
				WHERE ccbl.line_id=cedr.claim_line_id)
		WHERE  	cedr.claim_batch_id = p_batch_id;

		l_rec_cnt := SQL%ROWCOUNT;
		l_msg:='Updating Invoice ID and Inv Number on Rebate Lines. No of lines updated = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  	

		BEGIN 
			l_msg:='Sending Email';
			chm_msi_claim_process_pkg.insert_batch_logs(g_run_id, -1, p_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', l_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

			send_ap_invoice_email(p_batch_id, NULL);
		EXCEPTION 
			WHEN OTHERS THEN 
				CHM_MSI_CLAIM_PROCESS_PKG.insert_batch_logs(g_run_id, -1, p_batch_id, NULL, 'EXCEPTION',
													   'AP_INVOICE_PROCESS', dbms_utility.format_error_stack
																				  || ', '
																				  || dbms_utility.format_error_backtrace, g_source_app_id
																				  );

				chm_msi_debug_api.log_exp(p_batch_id, 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS'
				, sqlcode, dbms_utility.format_error_stack
																								   || ', '
																								   || dbms_utility.format_error_backtrace

							);

		END;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      chm_msi_debug_api.log_exp(p_batch_id, 'Error occurred in CHM_MSI_CLAIM_PROCESS_PKG.ap_invoice_process ', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace);
	  insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS', 'Error occurred in AP Invoice Process '||SQLCODE||'-'||SQLERRM, g_source_app_id);
	  CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     
      RAISE;
  END ap_invoice_process;

PROCEDURE send_ap_invoice_email (
	p_batch_id    IN NUMBER DEFAULT NULL,
	p_report_request_id IN NUMBER DEFAULT NULL
) AS

	v_req_ref_no             VARCHAR2(4000);
	v_submitter              VARCHAR2(200);
	v_placeholders           CLOB;
	v_approval_history_table CLOB;
	v_pr_approver            VARCHAR2(4000);
	v_bk_approver            VARCHAR2(4000);
	v_approval_url           VARCHAR2(4000);
	v_mail_url               VARCHAR2(2000);
	v_application_id         NUMBER;
	v_appr_page_no           NUMBER;
	v_appr_page_item         VARCHAR2(100);
	l_mail_id                NUMBER;
	l_mail_to                VARCHAR2(4000);
	l_mail_cc                VARCHAR2(4000);
	l_mail_bcc               VARCHAR2(4000);
	l_subject                VARCHAR2(2000);
	l_body_text              CLOB;
	l_html_body              CLOB;
	l_cc_email               VARCHAR2(4000) DEFAULT '';
	l_bcc_email              VARCHAR2(4000) DEFAULT '';
	v_batch_id				 NUMBER;
	v_msg					 VARCHAR2(4000);
	l_placeholders			 VARCHAR2(4000);
	v_query_context APEX_EXEC.T_CONTEXT;
	l_sql					VARCHAR2(4000);
	l_export 							apex_data_export.t_export;
	l_requestor_email		VARCHAR2(4000);
	l_requestor_id			NUMBER;

BEGIN
		l_mail_to :=
		CASE
		WHEN UPPER(g_user_id) = 'SYSTEM' THEN NULL
		 WHEN instr(lower(g_user_id), '@enphaseenergy.com') > 0 THEN
		   g_user_id
		 ELSE g_user_id||'@enphaseenergy.com'
		END;


		IF p_report_request_id IS NOT NULL THEN

			v_msg:='Get Requestor Email for Request Id '||p_report_request_id;
			chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SEND_AP_INVOICE_EMAIL', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => v_msg, p_source_app_id => g_source_app_id);

			BEGIN
				SELECT 	user_id
				INTO 	l_requestor_id
				FROM 	chm_msi_report_requests
				WHERE 	report_request_id=p_report_request_id;

				l_requestor_email:=CHM_MSI_UTIL_PKG.get_user_email(l_requestor_id);
			EXCEPTION
				WHEN OTHERS THEN
					v_msg:='Error getting Requestor Email '||SQLERRM;
					chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SEND_AP_INVOICE_EMAIL', v_msg, g_source_app_id);		
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => v_msg, p_source_app_id => g_source_app_id);
					l_requestor_email:=NULL;
			END;
			v_msg:=' Requestor Email for Request Id '||l_requestor_email;
			chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SEND_AP_INVOICE_EMAIL', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => v_msg, p_source_app_id => g_source_app_id);

		END IF;

		IF l_mail_to IS NULL THEN 
			l_mail_to := g_msi_rebate_ap_invoice_email_to;
		ELSE
			l_mail_to := l_mail_to||','||g_msi_rebate_ap_invoice_email_to;
		END IF;

		IF l_requestor_email IS NOT NULL THEN 
			l_mail_to := l_mail_to||','||l_requestor_email;
		END IF;

		l_mail_cc := g_msi_rebate_ap_invoice_email_cc;
		l_mail_bcc := g_msi_rebate_ap_invoice_email_bcc;

		IF p_batch_id IS NOT NULL THEN

			v_msg:='Send AP Invoice Created Email to  =  '||l_mail_to;
			chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SEND_AP_INVOICE_EMAIL', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => v_msg, p_source_app_id => g_source_app_id);


			l_placeholders:='{' ||' "BATCH_ID":'||apex_json.stringify(p_batch_id)||', "INSTANCE":'||apex_json.stringify(g_instance_name)||' }';

			chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SEND_AP_INVOICE_EMAIL', l_placeholders, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => l_placeholders, p_source_app_id => g_source_app_id);

			l_sql:='SELECT oracle_ap_invoice_id "#oracle_ap_invoice_id#", oracle_ap_invoice_number "#oracle_ap_invoice_number#",
				currency_code "#currency_code#",spa_number "#spa_number#", payee_name "#payee_name#" ,payee_number "#payee_number#",
				SUM(total_amount) "#amount#", count(*)  "#no_of_invoice_lines#"
				FROM chm_msi_claim_ap_invoices
				WHERE claim_batch_id='||p_batch_id||
				' GROUP BY oracle_ap_invoice_id, oracle_ap_invoice_number,
				currency_code,spa_number, payee_name , payee_number';

				  -- Create the email using the APEX email template
			  l_mail_id := APEX_MAIL.send(
				p_to => l_mail_to,
				p_cc=> l_mail_cc,
				p_bcc => l_mail_bcc,
				p_from => g_mail_from,
				p_placeholders => l_placeholders,
				p_application_id=>g_application_id,
				p_template_static_id => 'CHM_MSI_AP_INVOICE_NOTIFICATION'
			  );		

				chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, p_batch_id, NULL, g_msg_log, 'SEND_AP_INVOICE_EMAIL', 'l_mail_id = '||l_mail_id, g_source_app_id);		
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => 'l_mail_id = '||l_mail_id, p_source_app_id => g_source_app_id);

			v_query_context := APEX_EXEC.OPEN_QUERY_CONTEXT(
			p_sql_query => l_sql,
			p_location => apex_exec.c_location_local_db
			);

			l_export := apex_data_export.export(p_context => v_query_context, p_format => apex_data_export.c_format_xlsx);
			apex_mail.add_attachment(p_mail_id => l_mail_id, p_attachment => l_export.content_blob, p_filename => 'MSI_AP_Invoices_for_Batch_ID_'||p_batch_id||'.xlsx', p_mime_type => l_export.mime_type);

			apex_exec.close(v_query_context);

			apex_mail.push_queue;
		ELSIF p_report_request_id IS NOT NULL THEN

			v_msg:='Send AP Invoice Created Email to  =  '||l_mail_to;
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => v_msg, p_source_app_id => g_source_app_id);

			l_placeholders:='{' ||' "REQUEST_ID":'||apex_json.stringify(p_report_request_id)||', "INSTANCE":'||apex_json.stringify(g_instance_name)||' }';

			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => l_placeholders, p_source_app_id => g_source_app_id);

			l_sql:='SELECT oracle_ap_invoice_id "#oracle_ap_invoice_id#", oracle_ap_invoice_number "#oracle_ap_invoice_number#",
				currency_code "#currency_code#",spa_number "#spa_number#", payee_name "#payee_name#" ,payee_number "#payee_number#",
				SUM(total_amount) "#amount#", count(*)  "#no_of_invoice_lines#"
				FROM chm_msi_claim_ap_invoices
				WHERE report_request_id='||p_report_request_id||
				' GROUP BY oracle_ap_invoice_id, oracle_ap_invoice_number,
				currency_code,spa_number, payee_name , payee_number';

				  -- Create the email using the APEX email template
			l_mail_id := APEX_MAIL.send(
				p_to => l_mail_to,
				p_cc=> l_mail_cc,
				p_bcc => l_mail_bcc,
				p_from => g_mail_from,
				p_placeholders => l_placeholders,
				p_application_id=>g_application_id,
				p_template_static_id => 'CHM_MSI_AP_INVOICE_REQUEST_NOTIFICATION'
			  );		

				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_AP_INVOICE_EMAIL', p_log_msg => 'l_mail_id = '||l_mail_id, p_source_app_id => g_source_app_id);

			v_query_context := APEX_EXEC.OPEN_QUERY_CONTEXT(
			p_sql_query => l_sql,
			p_location => apex_exec.c_location_local_db
			);

			l_export := apex_data_export.export(p_context => v_query_context, p_format => apex_data_export.c_format_xlsx);
			apex_mail.add_attachment(p_mail_id => l_mail_id, p_attachment => l_export.content_blob, p_filename => 'MSI_AP_Invoices_for_Request_ID_'||p_report_request_id||'.xlsx', p_mime_type => l_export.mime_type);

			apex_exec.close(v_query_context);

			apex_mail.push_queue;		

		END IF;


EXCEPTION
	WHEN OTHERS THEN
		chm_msi_debug_api.log_exp(-1, 'chm_msi_claim_approval_pkg.send_ap_invoice_email', sqlcode, dbms_utility.format_error_stack
																									 || ', '
																									 || dbms_utility.format_error_backtrace
																									 );
END send_ap_invoice_email;


	PROCEDURE auto_ap_invoice_process (
		p_request_id NUMBER
		) AS

	v_run_id             NUMBER;
	v_file_id            NUMBER;
	v_claim_type         VARCHAR2(4000);
	v_approvers_count    NUMBER:=0;
	v_request_id         NUMBER;
	v_min_approval_level NUMBER;
	v_primary_approver   VARCHAR2(4000);
	v_backup_approver    VARCHAR2(4000);
	v_req_ref_no         VARCHAR2(4000);
	v_msg				 VARCHAR2(4000);
	v_in_process_run_count_excep	NUMBER;	
	l_to_email			VARCHAR2(4000);	
	l_file_reference_name	VARCHAR2(4000);	

	l_batch_id 		VARCHAR2(4000);
	l_batch_type 	VARCHAR2(4000);
	l_batch_status 	VARCHAR2(4000);
	l_report_type	VARCHAR2(4000):='AUTO_APPROVE_MSI_BATCH';
	l_module		VARCHAR2(4000):='CHM_MSI_CLAIM_APPROVAL_PKG.AUTO_AP_INVOICE_PROCESS';
	l_report_request_id	NUMBER:=p_request_id;	
	l_submitter_comments	VARCHAR2(4000):='Auto Approving Batch '||SYSTIMESTAMP;
	l_req_ref VARCHAR2(4000):='Auto Approve Request ID '||p_request_id;


    BEGIN  
  		g_run_id:=-1;
		g_report_request_id:=p_request_id;
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process. Request ID  = '||p_request_id,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg => 'START Processing Request ID = ' || p_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg => 'Update Request Status to In Process', p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'AUTO_AP_INVOICE_PROCESS', p_msg => 'Update Request Status to In Process', p_report_type => g_report_type);

		CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_in_process);

		COMMIT;

		SELECT
				jt.file_reference_name || '_Request_ID_' || l_report_request_id || '_' || g_user_id, 
				jt.to_email,jt.batch_id
		INTO
				l_file_reference_name, 
				l_to_email, l_batch_id
		FROM
			JSON_TABLE ( (
			  SELECT
				report_filters
			  FROM
				chm_msi_report_requests
			  WHERE
				report_request_id = l_report_request_id
			), '$[*]'
			  COLUMNS (
				file_reference_name VARCHAR2 ( 4000 ) PATH '$.FILE_REFERENCE_NAME', 
				to_email VARCHAR2 ( 4000 ) PATH '$.TO_EMAIL', 
				batch_id VARCHAR2 ( 4000 ) PATH '$.BATCH_ID' 
			  )
			)
		  jt;	

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id ||' Batch Type = '||l_batch_type ,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'AUTO_AP_INVOICE_PROCESS', p_log_msg => 'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id||' Batch Type = '||l_batch_type, p_source_app_id => g_source_app_id);     

		BEGIN 
			SELECT 	batch_status 
			INTO 	l_batch_status
			FROM 	chm_msi_claim_batch
			WHERE 	batch_id=l_batch_id;
		EXCEPTION 
			WHEN OTHERS THEN 
				l_batch_status:=NULL;
				v_msg:='Error Getting Batch Status = '||SQLERRM;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'AUTO_AP_INVOICE_PROCESS', v_msg, g_source_app_id);			
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'AUTO_AP_INVOICE_PROCESS', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     

		END;

		v_msg:='Batch ID '||l_batch_id||' Status = '||l_batch_status;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'AUTO_AP_INVOICE_PROCESS', v_msg, g_source_app_id);			
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'AUTO_AP_INVOICE_PROCESS', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     

		IF NVL(l_batch_status,'X')=g_status_pending_ap_invoice THEN --ronnie 04-APR-2025
			v_msg:='Calling AP Invoice Process';
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'AUTO_AP_INVOICE_PROCESS', v_msg, g_source_app_id);			
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'AUTO_AP_INVOICE_PROCESS', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     

			ap_invoice_process(l_batch_id);

			CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_generated);
		ELSE 
			v_msg:='Batch '||l_batch_id||' is not in Pending AP Invoice creation status. Exiting'; --ronnie 04-APR-2025
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, l_batch_id, NULL, g_msg_log, 'AUTO_AP_INVOICE_PROCESS', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'AUTO_AP_INVOICE_PROCESS', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     
			CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_failed);			
		END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            CHM_MSI_CLAIM_PROCESS_PKG.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, 'EXCEPTION',
                                                   'AUTO_AP_INVOICE_PROCESS', dbms_utility.format_error_stack
                                                                              || ', '
                                                                              || dbms_utility.format_error_backtrace, g_source_app_id
                                                                              );

            chm_msi_debug_api.log_exp(l_batch_id, 'CHM_MSI_CLAIM_PROCESS_PKG.auto_ap_invoice_process
            ', sqlcode, dbms_utility.format_error_stack
                                                                                               || ', '
                                                                                               || dbms_utility.format_error_backtrace
                                                                                               );

			CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_failed);			
	END	auto_ap_invoice_process;


	--new procedure for end of period 

PROCEDURE ap_invoice_process_request (
		p_request_id NUMBER
	) AS

v_run_id             NUMBER;
v_file_id            NUMBER;
v_claim_type         VARCHAR2(4000);
v_approvers_count    NUMBER:=0;
v_request_id         NUMBER;
v_min_approval_level NUMBER;
v_primary_approver   VARCHAR2(4000);
v_backup_approver    VARCHAR2(4000);
v_req_ref_no         VARCHAR2(4000);
v_msg				 VARCHAR2(4000);
v_in_process_run_count_excep	NUMBER;	
l_to_email			VARCHAR2(4000);	
l_file_reference_name	VARCHAR2(4000);	
l_installer_id		NUMBER;
l_country		VARCHAR2(4000);
l_rebate_type	VARCHAR2(4000);

l_from_date                     TIMESTAMP WITH TIME ZONE;
l_to_date                       TIMESTAMP WITH TIME ZONE;
l_no_of_rows   NUMBER; 
l_batch_id 		VARCHAR2(4000);
l_batch_type 	VARCHAR2(4000);
l_batch_status 	VARCHAR2(4000);
l_report_type	VARCHAR2(4000):='AUTO_APPROVE_MSI_BATCH';
l_module		VARCHAR2(4000):='CHM_MSI_CLAIM_APPROVAL_PKG.AP_INVOICE_PROCESS_REQUEST';
l_report_request_id	NUMBER:=p_request_id;	
p_report_request_id	NUMBER:=p_request_id;	
l_submitter_comments	VARCHAR2(4000):='Auto Approving Batch '||SYSTIMESTAMP;
l_req_ref 			VARCHAR2(4000):='Auto Approve Request ID '||p_request_id;
l_msg				VARCHAR2(4000);	
l_rec_cnt   NUMBER;
l_ap_invoice_id NUMBER;
l_ap_invoice_number VARCHAR2(4000);
l_accounting_date	DATE;

CURSOR c_batch(p_installer_id IN VARCHAR2,
	p_country      IN VARCHAR2,
	p_rebate_type  IN VARCHAR2,
	p_from_date    IN DATE,
	p_to_date      IN DATE)
IS
SELECT DISTINCT ccbh.batch_id , ccbl.line_id
FROM 
	chm_msi_claim_batch_lines ccbl,
	chm_msi_claim_batch ccbh
WHERE 1=1
AND ccbl.batch_id=ccbh.batch_id 
AND ccbh.batch_status = g_status_approved
AND ccbh.claim_type='MSI_REBATE'
AND ccbl.claim_date BETWEEN trunc(p_from_date) and trunc(p_to_date)
AND ccbl.rebate_type = nvl(p_rebate_type, ccbl.rebate_type)
AND ccbl.line_status = g_status_approved
AND (p_country IS NULL 
			OR instr(':'
				   || p_country
				   || ':',
				   ':'
				   || ccbl.site_country
				   || ':') > 0 
	)	
AND ( p_installer_id IS NULL
			OR instr(':'
				   || p_installer_id
				   || ':',
				   ':'
				   || to_char(ccbl.payee_id)
				   || ':') > 0 
	);

CURSOR 	c_inv_group IS 
SELECT 	report_request_id,accounting_date,payee_number,spa_number, count(*) no_of_lines
FROM 	chm_msi_claim_ap_invoices
WHERE 	oracle_ap_interface_status=g_status_new
AND 	report_request_id=p_request_id
GROUP BY report_request_id,accounting_date,payee_number,spa_number;

BEGIN  
	g_run_id:=-1;
	g_report_request_id:=p_request_id;
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process. Request ID  = '||p_request_id,p_report_type => l_report_type);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg => 'START Processing Request ID = ' || p_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.AP_INVOICE_PROCESS_REQUEST', p_log_msg => 'Update Request Status to In Process', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'AP_INVOICE_PROCESS_REQUEST', p_msg => 'Update Request Status to In Process', p_report_type => g_report_type);

	CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_in_process);

	COMMIT;

	BEGIN
		SELECT
			jt.file_reference_name,
			jt.installer,
			jt.country,
			jt.rebate_type,
			jt.to_email,
			to_timestamp_tz(jt.from_date, chm_const_pkg.getdateformattzr),
			to_timestamp_tz(jt.to_date, chm_const_pkg.getdateformattzr),
			jt.batch_type
		INTO
			l_file_reference_name,
			l_installer_id,
			l_country,
			l_rebate_type,
			l_to_email,
			l_from_date,
			l_to_date,
			l_batch_type
		FROM
				JSON_TABLE ( (
					SELECT
						REPORT_FILTERS
					FROM
						chm_msi_report_requests
					WHERE
						report_request_id = p_report_request_id
				), '$[*]'
					COLUMNS (
						file_reference_name VARCHAR2 ( 4000 ) PATH '$.FILE_REFERENCE_NAME',
						installer VARCHAR2 ( 4000 ) PATH '$.INSTALLER',
						country VARCHAR2 ( 4000 ) PATH '$.COUNTRY',
						rebate_type VARCHAR2 ( 4000 ) PATH '$.REBATE_TYPE',
						to_email VARCHAR2 ( 4000 ) PATH '$.TO_EMAIL',
						from_date VARCHAR2 ( 4000 ) PATH '$.FROM_DATE',
						to_date VARCHAR2 ( 4000 ) PATH '$.TO_DATE',
						batch_type VARCHAR2 ( 4000 ) PATH '$.BATCH_TYPE'
					)
				)
			jt;
	EXCEPTION
	   WHEN no_data_found THEN
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'AP_INVOICE_PROCESS_REQUEST', 
							p_msg =>'NO DATA FOUND FOR THE REQUEST ID' , p_report_type=> g_report_type);
		WHEN OTHERS THEN 
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'AP_INVOICE_PROCESS_REQUEST', 
							p_msg =>SQLERRM , p_report_type=> g_report_type);
	END;

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id ||' Batch Type = '||l_batch_type ,p_report_type => l_report_type);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg => 'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id||' Batch Type = '||l_batch_type, p_source_app_id => g_source_app_id);     


    IF l_from_date IS NULL THEN 
        ---ADD LOG MESSAGES AS EXITING
		 chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id , p_module =>  'AP_INVOICE_PROCESS_REQUEST', 
							p_msg =>'FROM DATE IS NULL FOR THE REQUEST ID' , p_report_type=> g_report_type);


		BEGIN
			l_msg:='Update Request Status to Failed';
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log	, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'AP_INVOICE_PROCESS_REQUEST',p_msg =>l_msg , p_report_type=> g_report_type);	
			chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_failed);
		EXCEPTION
			WHEN OTHERS THEN
				UPDATE chm_msi_report_requests
				SET
					status = g_status_failed
				WHERE
					report_request_id = l_report_request_id;

				chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', 'update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);

				COMMIT;
				RETURN;
		END;							

        RETURN;
    END IF;

	--Process data 
	FOR vc in c_batch(l_installer_id,l_country,l_rebate_type,l_from_date,l_to_date)
	LOOP

		l_msg:='Updating Batch ID = '||vc.batch_id||' Status to Pending AP Invoice Creation';

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
		insert_batch_logs(-1, -1, vc.batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS_REQUEST', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

		UPDATE  chm_msi_claim_batch
		SET 	batch_status=g_status_pending_ap_invoice
				,ap_invoice_request_id=l_report_request_id
		WHERE	batch_id=vc.batch_id
		AND 	batch_status=g_status_approved;

		l_no_of_rows:=SQL%ROWCOUNT;

		l_msg := 'No of Batch Records updated with Pending AP Invoice = '||l_no_of_rows;
		insert_batch_logs(-1, -1, vc.batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS_REQUEST', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

		UPDATE  chm_msi_claim_batch_lines
		SET 	line_status=g_status_pending_ap_invoice
				,ap_invoice_request_id=l_report_request_id
		WHERE	batch_id=vc.batch_id
		AND 	line_status=g_status_approved;

		l_no_of_rows:=SQL%ROWCOUNT;

		l_msg := 'No of Batch Records updated with Pending AP Invoice = '||l_no_of_rows;
		insert_batch_logs(-1, -1, vc.batch_id, NULL, g_msg_log, 'AP_INVOICE_PROCESS_REQUEST', l_msg, g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

		COMMIT;
	END LOOP;


	l_accounting_date:=TRUNC(SYSDATE);


	INSERT 
    INTO chm_msi_claim_ap_invoices
       (
		--invoice_line_number
		/*,invoice_source
		,invoice_description
		,invoice_type
		,calculate_tax
		,add_tax
		,line_type
		,product_type
		,line_group_number*/
        claim_batch_id
       , transaction_date
       , accounting_date
	   ,payee_number
	   ,payee_name
	   ,payee_enlighten_id
	   ,installer_number
	   ,installer_name
	   ,installer_enlighten_id	   
	   ,spa_number
	   ,spa_start_date
	   ,spa_expiration_date
	   ,rebate_type
	   ,rebate_tier
	   ,rebate_item_number
	   ,device_item_number
       , transaction_line_description
	   ,site_id
	   ,site_name
       , currency_code
       , quantity
       , total_amount
	   ,oracle_ap_interface_status
	   ,country
	   ,report_request_id
	   ,reference_name
	   )
    SELECT
			--rownum,
			cb.batch_id,                                                                                                        -- CLAIM_BATCH_ID
			cbl.claim_date,
			l_accounting_date,
			cbl.payee_sfdc_customer_key,
			cbl.payee_sfdc_account_name,
			cbl.payee_enlighten_installer_id,
			cbl.installer_sfdc_customer_key,
			cbl.installer_sfdc_account_name,
			cbl.installer_enlighten_installer_id,
			cbl.spa_number,
			TRUNC(cmsh.spa_start_date),
			TRUNC(cmsh.spa_expiration_date),
			cbl.rebate_type,
			cbl.rebate_tier,
			cbl.rebate_item_number,
			cbl.device_item_number,
			'Marketing Services Incentive (MSI)',
			cbl.site_id,
			cbl.site_name,
			cbl.currency,
			SUM(qty_sold),
			SUM(NVL(cbl.extended_claim_amount,user_extended_claim_amount)),
			g_status_new,
			NVL(csam.country,'XX'),
			g_report_request_id,
			l_file_reference_name
        FROM      chm_msi_claim_batch_lines_av  cbl
              , chm_msi_claim_batch        cb
			  ,chm_msi_spa_header cmsh
			  ,chm_sfdc_account_master csam
      WHERE     cb.batch_id = cbl.batch_id 
		AND 	cbl.spa_number = cmsh.spa_number(+)
		AND 	cbl.payee_sfdc_customer_key = csam.customer_key(+)
		--AND     cbl.batch_id = p_batch_id 
		AND     cb.batch_status = g_status_pending_ap_invoice
		AND     cbl.line_status= g_status_approved
		AND 	cb.claim_type='MSI_REBATE'	
		AND 	cbl.claim_date BETWEEN trunc(l_from_date) and trunc(l_to_date)
		AND 	cbl.rebate_type = nvl(l_rebate_type, cbl.rebate_type)
		AND 	cbl.line_status = g_status_approved
		AND		(l_country IS NULL 
					OR instr(':'
					   || l_country
					   || ':',
					   ':'
					   || cbl.site_country
					   || ':') > 0 
				)	
		AND 	( l_installer_id IS NULL
					OR instr(':'
						   || l_installer_id
						   || ':',
						   ':'
						   || to_char(cbl.payee_id)
						   || ':') > 0 
				)	  
	GROUP BY   	cb.batch_id,
				cbl.claim_date,
				cbl.payee_sfdc_customer_key,
				cbl.payee_sfdc_account_name,
				cbl.payee_enlighten_installer_id,
				cbl.installer_sfdc_customer_key,
				cbl.installer_sfdc_account_name,
				cbl.installer_enlighten_installer_id,
				cbl.spa_number,
				TRUNC(cmsh.spa_start_date),
				TRUNC(cmsh.spa_expiration_date),
				cbl.rebate_type,
				cbl.rebate_tier,
				cbl.rebate_item_number,
				cbl.device_item_number,
				cbl.site_id,
				cbl.site_name,
				cbl.currency,
				NVL(csam.country,'XX')
				;

    l_rec_cnt := SQL%rowcount;
	l_msg:=l_rec_cnt || ' records have been inserted successfully';

    chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
    chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

	IF l_rec_cnt > 0 THEN

		FOR vc_group IN c_inv_group LOOP 

			l_msg:='Payee Number = '||vc_group.payee_number||' Accounting Date = '||vc_group.accounting_date||' SPA Number = '||vc_group.spa_number||' No of Lines = '||vc_group.no_of_lines;
			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
    		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

			SELECT 	CHM_MSI_AP_INVOICE_NUMBER_SEQ.NEXTVAL 
			INTO 	l_ap_invoice_id
			FROM 	dual;

			l_ap_invoice_number:='CHM_MSI_'||l_ap_invoice_id;

			l_msg:='l_ap_invoice_number = '||l_ap_invoice_number;
			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
    		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     	

			UPDATE 	chm_msi_claim_ap_invoices
			SET    	oracle_ap_invoice_number=l_ap_invoice_number
					,oracle_ap_invoice_id=l_ap_invoice_id
		    WHERE 	payee_number=vc_group.payee_number
			AND 	accounting_date=vc_group.accounting_date
			AND 	spa_number=vc_group.spa_number
			AND 	oracle_ap_interface_status=g_status_new
			AND 	report_request_id=vc_group.report_request_id;

			l_msg:='No of Lines Updated with Inv Number = '||SQL%ROWCOUNT||'. No of Rows to Update = '||vc_group.no_of_lines;
			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     	


			UPDATE 	chm_msi_claim_ap_invoices
			SET 	invoice_line_number=rownum
			WHERE 	oracle_ap_invoice_id=l_ap_invoice_id;

			l_rec_cnt := SQL%ROWCOUNT;
			l_msg:='Updating Invoice Line Number. No of lines updated = '||l_rec_cnt;

			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  

			UPDATE chm_msi_claim_batch_lines ccbl
			SET    oracle_ap_invoice_id = l_ap_invoice_id
				   ,oracle_ap_invoice_number=l_ap_invoice_number	
			WHERE
				ccbl.line_status  = g_status_approved -- 26-FEB-2023
			AND ccbl.payee_id = (select MAX(chm_account_id) from chm_sfdc_account_master csam where 
								csam.customer_key=vc_group.payee_number)
			AND ccbl.spa_number=vc_group.spa_number
			AND 	ccbl.batch_id IN (SELECT claim_batch_id
								FROM 	chm_msi_claim_ap_invoices cmap
								WHERE   cmap.report_request_id=g_report_request_id
								);

			l_rec_cnt := SQL%ROWCOUNT;
			l_msg:='Updating Invoice ID and Inv Number on Lines. No of lines updated = '||l_rec_cnt;

			chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  	

		END LOOP;

		UPDATE 	chm_msi_claim_batch_lines ccbl
		SET		line_status = g_status_closed
		WHERE	ccbl.line_status  = g_status_approved -- 26-FEB-2023
		AND 	ccbl.batch_id IN (SELECT claim_batch_id
								FROM 	chm_msi_claim_ap_invoices cmap
								WHERE   cmap.report_request_id=g_report_request_id
								);

		l_rec_cnt := SQL%ROWCOUNT;
		l_msg:='Updating Line Status to Closed. No of lines updated = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  


		UPDATE chm_enlighten_device_rebates cedr
		SET    (oracle_ap_invoice_id,oracle_ap_invoice_number,rebate_status)=
				(select ccbl.oracle_ap_invoice_id,ccbl.oracle_ap_invoice_number,'SUBMITTED_FOR_INVOICE' 
				from chm_msi_claim_batch_lines ccbl
				WHERE ccbl.line_id=cedr.claim_line_id)
		WHERE  
			cedr.claim_batch_id IN (SELECT cmap.claim_batch_id
							FROM 	chm_msi_claim_ap_invoices cmap
							WHERE   cmap.report_request_id=g_report_request_id
							);

		l_rec_cnt := SQL%ROWCOUNT;
		l_msg:='Updating Invoice ID and Inv Number on Rebate Lines. No of lines updated = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS', l_msg);
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     				  	


		UPDATE chm_msi_claim_batch ccb
		SET		batch_status = g_status_closed
		WHERE	ccb.batch_id IN (SELECT claim_batch_id
								FROM 	chm_msi_claim_ap_invoices cmap
								WHERE   cmap.report_request_id=g_report_request_id
								);

		l_rec_cnt := SQL%ROWCOUNT;
		l_msg:='Updating Batch Status to Closed. No of Batches updated = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     
		COMMIT;

		l_msg:='Batch Submitted for AP Invoice Creation as part of Report Request ID = '||g_report_request_id||'. No of Invoices created for this batch = ';

		INSERT INTO chm_msi_claim_logs (
		  batch_log_id, run_id,  file_id, 
		  batch_id, log_type, log_code, 
		  log_msg, current_flag, source_app_id
		) 
		SELECT 	chm_claim_logs_seq.NEXTVAL, g_run_id, -1,
				c.batch_id,g_msg_log,l_module,
				l_msg||c.no_of_invoices,'Y',g_source_app_id
		FROM (	SELECT 	claim_batch_id batch_id, count(*) no_of_invoices
				FROM 	chm_msi_claim_ap_invoices cmap
				WHERE   cmap.report_request_id=g_report_request_id
				GROUP BY claim_batch_id) c;

		l_rec_cnt := SQL%ROWCOUNT;
		l_msg:='Inserted Batch Log Messages. No of messages inserted = '||l_rec_cnt;

		chm_msi_debug_api.log_msg('', 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST', l_msg);
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     
		COMMIT;		

		BEGIN 
			l_msg:='Sending Email';
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

			send_ap_invoice_email(p_batch_id=>NULL, p_report_request_id=>g_report_request_id);
		EXCEPTION 
			WHEN OTHERS THEN 
				l_msg:='Error occured during Send Email.'||SQLERRM||'-'||SQLCODE;
				chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_error_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

				chm_msi_debug_api.log_exp(NULL, 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST'
				, sqlcode, dbms_utility.format_error_stack
																								   || ', '
																								   || dbms_utility.format_error_backtrace

							);
		END;

		CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_generated);
	ELSE

		CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_failed);

    END IF;	

EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		l_msg:='Error occured.'||SQLERRM||'-'||SQLCODE;
		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_error_log, p_log_code => 'AP_INVOICE_PROCESS_REQUEST', p_log_msg =>l_msg, p_source_app_id => g_source_app_id);     

		CHM_MSI_CLAIM_PROCESS_PKG.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, 'EXCEPTION',
											   'AP_INVOICE_PROCESS_REQUEST', dbms_utility.format_error_stack
																		  || ', '
																		  || dbms_utility.format_error_backtrace, g_source_app_id
																		  );

		chm_msi_debug_api.log_exp(l_batch_id, 'CHM_MSI_CLAIM_PROCESS_PKG.AP_INVOICE_PROCESS_REQUEST
		', sqlcode, dbms_utility.format_error_stack
																						   || ', '
																						   || dbms_utility.format_error_backtrace
																						   );

		CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_failed);			
END	ap_invoice_process_request;

END CHM_MSI_CLAIM_PROCESS_PKG;

/
