--------------------------------------------------------
--  DDL for Package Body CHM_MSI_SCHEDULE_REQUEST_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHM_MSI_SCHEDULE_REQUEST_PKG" AS
/*************************************************************************************************************************************************************************
    * Type                      : PL/SQL Package                                                                                                                        
    * Package Name        		: CHM_MSI_SCHEDULE_REQUEST_PKG                                                                                                                         
    * Purpose                   : Package for launching MSI Rebate Batch Jobs                                                                                                
    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            	: 10-FEB-2025  
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------

    *************************************************************************************************************************************************************************/

  g_sku_mapping_type 					VARCHAR2(50) := 'SKU';
  g_spa_mapping_type 					VARCHAR2(50) := 'SPA';
  g_approved_status 					VARCHAR2(50) := 'APPROVED';
  g_status_approved						VARCHAR2(50) := 'APPROVED';
  g_status_processed 					VARCHAR2(50) := 'PROCESSED';
  g_installer_account_record_type 		VARCHAR2(50) := 'INSTALLER';
  g_file_type 							VARCHAR2(50) := 'MSI_REBATE';
  g_msg_log 							VARCHAR2(50) := 'MESSAGE';
  g_status_new 							VARCHAR2(50) := 'NEW';
  g_pending_approval_status 			VARCHAR2(50) := 'PENDING_APPROVAL';
  g_status_pending_ap_invoice 			VARCHAR2(50) := 'PENDING_AP_INVOICE_CREATION';
  g_status_in_process 					VARCHAR2(50) := 'IN_PROCESS';
  g_error_log 							VARCHAR2(50) := 'ERROR';
  g_warning_log 						VARCHAR2(50) := 'WARNING';
  g_success_log 						VARCHAR2(50) := 'SUCCESS';
  g_processed_status 					VARCHAR2(50) := 'PROCESSED';
  g_status_generated 					VARCHAR2(50) := 'GENERATED';
  g_status_failed 						VARCHAR2(50) := 'FAILED';
  g_status_submitted 					VARCHAR2(50) := 'SUBMITTED';
  g_csv_format 							VARCHAR2(50) := '.csv';
  g_xlsx_format 						VARCHAR2(50) := '.xlsx';
  g_FROM_mail 							VARCHAR2(250) := 'doNOTreply@enphaseenergy.com';
  g_application_id 						NUMBER := 101;
  l_request_cnt 						NUMBER;
  g_report_type 						VARCHAR2(100) := 'MSI_REBATE';
  g_run_id 								NUMBER:=-1;
  g_report_request_id 					NUMBER;
  g_source_app_id 						NUMBER:=chm_util_pkg.getsourceapp('CHM');
  g_user_id								VARCHAR2(4000):=CHM_UTIL_PKG.GETUSERNAME();
  g_user_num_id							NUMBER:=get_user_id(CHM_UTIL_PKG.GETUSERNAME());
  g_enterprise_id						NUMBER:=CHM_CONST_PKG.GETENTERPRISEID();
  g_ip_address							VARCHAR2(4000):=CHM_UTIL_PKG.GETIPADDRESS();
  g_user_agent							VARCHAR2(4000):=CHM_UTIL_PKG.GETIPADDRESS();
  l_row_count_sql 						NUMBER;
  g_status_completed          				VARCHAR2(50) := 'COMPLETED';
  g_activation_batch_size						NUMBER:=TO_NUMBER(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_ATTRIBUTE_BATCH_SIZE'));
  g_rebate_calculation_batch_size				NUMBER:=TO_NUMBER(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_REBATE_CALCULATION_BATCH_SIZE'));
  g_system_size_batch_size						NUMBER:=TO_NUMBER(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_SYSTEM_SIZE_BATCH_SIZE'));  
  g_activation_report_email						VARCHAR2(4000):= CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_ATTRIBUTE_EMAIL');
  g_device_attribute_derivation_cutoff_date 	DATE:= NVL(TO_DATE(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_ATTRIBUTE_CUTOFF_DATE'),'DD-MON-RRRR'),TO_DATE('01-JAN-2025','DD-MON-RRRR'));
  g_device_attribute_derivation_cutoff_days 	NUMBER:= NVL(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_ELIGIBILITY_DAYS'),90);
  g_spa_eligibility_derivation_cutoff_days 		NUMBER:= NVL(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_SPA_ELIGIBILITY_DAYS'),90);  
  g_system_attachment_prereq_product_type		VARCHAR2(4000):= CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_SYSTEM_ATTACHMENT_PRE_REQUISITE_PRODUCT_TYPE');
  g_system_size_product_type					VARCHAR2(4000):= CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_SYSTEM_SIZE_PRODUCT_TYPE');
  --g_rebate_eligibility					VARCHAR2(50) := 'REBATE_ELIGIBILITY';
  --g_rebate_calculation					VARCHAR2(50) := 'REBATE_CALCULATION';

	g_tier_1	VARCHAR2(100):='Tier 1';
	g_tier_2	VARCHAR2(100):='Tier 2';
	g_tier_3	VARCHAR2(100):='Tier 3';
	g_tier_4	VARCHAR2(100):='Tier 4';
	g_tier_5	VARCHAR2(100):='Tier 5';

FUNCTION get_user_id(p_user_name IN VARCHAR2) RETURN NUMBER
AS
l_user_id	NUMBER;

CURSOR c_user IS 
SELECT * FROM CHM_USER_MANAGEMENT_V
WHERE UPPER(USER_NAME) = UPPER(p_user_name)
FETCH FIRST ROW ONLY;

BEGIN 

	IF p_user_name='SYSTEM' THEN
		l_user_id:=0;
	ELSE 
		FOR vc_user IN c_user LOOP
			l_user_id:=vc_user.user_id;
		END LOOP;
	END IF;
	
	RETURN NVL(l_user_id,0);

EXCEPTION
	WHEN OTHERS THEN 
		RETURN NVL(l_user_id,0);
END get_user_id;


FUNCTION get_request_type(p_request_id IN NUMBER) RETURN VARCHAR2
AS

CURSOR c_type IS 
SELECT 	report_type
FROM 	chm_msi_report_requests 
WHERE 	report_request_id=p_request_id;

l_report_type	VARCHAR2(1000);

BEGIN 
	CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.', 'get_request_type p_request_id = ' ||p_request_id, 'GET_REQUEST_TYPE');

	OPEN 	c_type;
	FETCH 	c_type INTO l_report_type;
	CLOSE 	c_type;

	CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.', 'get_request_type l_report_type = ' ||l_report_type, 'GET_REQUEST_TYPE');
	
	RETURN l_report_type;
END get_request_type;


PROCEDURE insert_report_logs (
	p_run_id IN NUMBER, p_report_request_id IN NUMBER DEFAULT NULL, 
	p_log_type IN VARCHAR2, p_log_code IN VARCHAR2, 
	p_log_msg IN VARCHAR2, p_source_app_id IN NUMBER
	) AS

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
	INSERT INTO chm_msi_claim_logs (
	  batch_log_id, run_id, report_request_id, log_type, log_code, log_msg, source_app_id
	) VALUES (
	  chm_claim_logs_seq.NEXTVAL, p_run_id, p_report_request_id, p_log_type, p_log_code, p_log_msg, p_source_app_id
	);
	
	COMMIT;
	
END insert_report_logs;

PROCEDURE update_request_status (p_report_request_id IN NUMBER, p_status VARCHAR2) AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG', 'update_request_status ' || 'p_report_request_id = ' || p_report_request_id || 'p_status = ' || p_status, g_report_type);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log, p_log_code => 'UPDATE_REQUEST_STATUS', p_log_msg => 'START update_request_status ' || 'p_report_request_id = ' || p_report_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);	

	UPDATE chm_msi_report_requests
	SET
	  status = p_status, 
	  attribute2 = g_run_id,
	  last_updated_date=SYSDATE
	WHERE
	  report_request_id = p_report_request_id;

	CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.', 'update_request_status ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log, p_log_code => 'UPDATE_REQUEST_STATUS', p_log_msg => 'End update_request_status ' || 'p_report_request_id = ' || p_report_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);		

	COMMIT;
EXCEPTION
	WHEN OTHERS THEN
		CHM_MSI_DEBUG_API.log_exp(p_report_request_id, 'Error occurred in CHM_MSI_SCHEDULE_REQUEST_PKG - update_request_status', sqlcode, dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, g_report_type);
END update_request_status;

--Release the batch records so the record can be picked up again
PROCEDURE release_batch_records(p_batch_id NUMBER)
AS 
l_record_count	NUMBER;

BEGIN 
	l_record_count:=0;
	
	/*

	UPDATE 	chm_enlighten_device_details cedd
	SET 	attribute2=NULL
			,attribute3=p_batch_id -- last batch id
			,attribute4=TO_NUMBER(NVL(attribute4,0))+1 -- No of times processed
	WHERE 	attribute2=p_batch_id;
	*/
	
	UPDATE 	chm_enlighten_device_attributes ceda
	SET 	batch_id=NULL
			,last_batch_id=p_batch_id -- last batch id
			,batch_process_count=NVL(batch_process_count,0)+1 -- No of times processed
	WHERE 	batch_id=p_batch_id;
	
	l_record_count:=SQL%ROWCOUNT;
	COMMIT;

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'RELEASE_BATCH_RECORDS', p_log_msg => 'l_record_count = ' || l_record_count||' No of Device Attribute Records Updated with Batch ID NULL  = '||l_record_count, p_source_app_id => g_source_app_id);     
EXCEPTION
	WHEN OTHERS THEN 
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.RELEASE_BATCH_RECORDS', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'RELEASE_BATCH_RECORDS', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);
END release_batch_records;

--Release the batch records so the record can be picked up again
PROCEDURE release_system_size_batch_records(p_batch_id NUMBER)
AS 
l_msg VARCHAR2(4000);
BEGIN 

	l_msg:='START release_system_size_batch_records For p_batch_id = '||p_batch_id;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'RELEASE_SYSTEM_SIZE_BATCH_RECORDS', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											

	UPDATE 	chm_enlighten_device_attributes
	SET		system_size_tier_calc_process_count= NVL(system_size_tier_calc_process_count,0)+1
			,system_size_tier_calc_last_batch_id=p_batch_id
			,system_size_tier_calc_batch_id=NULL
	WHERE 	system_size_tier_calc_batch_id=p_batch_id;

	l_msg:='End No of Rows Updated for '||p_batch_id||' = '||SQL%ROWCOUNT;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'RELEASE_SYSTEM_SIZE_BATCH_RECORDS', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											

END release_system_size_batch_records;	


--SPA Payee
FUNCTION get_spa_payee(p_spa_number IN VARCHAR2) RETURN NUMBER
AS

l_spa_payee_id	NUMBER;

CURSOR c_payee IS 
SELECT 	chm_account_id
FROM 	chm_msi_spa_payee_v5
WHERE 	spa_number=p_spa_number;

BEGIN 

	OPEN c_payee;
	FETCH c_payee INTO l_spa_payee_id;
	CLOSE c_Payee;

	RETURN l_spa_payee_id;

EXCEPTION
	WHEN OTHERS THEN 
		l_spa_payee_id:=NULL;
		RETURN l_spa_payee_id;
END get_spa_payee;

PROCEDURE update_batch_process_count(p_chm_enlighten_device_id IN NUMBER)
AS
l_msg	VARCHAR2(4000);
l_report_request_id NUMBER:=g_report_request_id;
BEGIN 

	l_msg:='START update_batch_process_count For Device Attribute ID = '||p_chm_enlighten_device_id;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											

	UPDATE chm_enlighten_device_attributes
	SET	system_size_tier_calc_process_count= NVL(system_size_tier_calc_process_count,0)+1
	WHERE chm_enlighten_device_id=p_chm_enlighten_device_id;

	l_msg:='END No of Rows Update for '||p_chm_enlighten_device_id||' = '||SQL%ROWCOUNT;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											

END update_batch_process_count;


--FUNCTION is_tier_calculated(g_tier_1,vc3.chm_enlighten_device_id,l_tier1_calc_amount);

FUNCTION is_tier_calculated(p_tier IN VARCHAR2,
							p_chm_enlighten_device_id IN NUMBER, 
							p_tier_calc_amount OUT NUMBER,
							p_chm_device_rebate_id OUT NUMBER
)
RETURN VARCHAR2 
AS

l_tier_calc			VARCHAR2(1):='N';

CURSOR c_rebate IS 
SELECT 	* 
FROM 	chm_enlighten_device_rebates
WHERE 	chm_enlighten_device_id=p_chm_enlighten_device_id
AND 	rebate_type='SYSTEM_SIZE'
AND 	rebate_source='SYSTEM'
AND 	rebate_tier=p_tier;

rebate_rec 	c_rebate%ROWTYPE;

BEGIN 

	OPEN 	c_rebate;
	FETCH 	c_rebate INTO rebate_rec;
	CLOSE 	c_rebate;

	IF rebate_rec.chm_enlighten_device_id IS NOT NULL THEN
		p_tier_calc_amount:=rebate_rec.rebate_amount;
		p_chm_device_rebate_id:=rebate_rec.chm_device_rebate_id;
		l_tier_calc:='Y';
	END IF;

	RETURN l_tier_calc;

EXCEPTION
	WHEN OTHERS THEN 
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.IS_TIER_CALCULATED', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'IS_TIER_CALCULATED', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);
		l_tier_calc:='N';
		RETURN l_tier_calc;

END is_tier_calculated;	

--FUNCTION is_tier_calculated(g_tier_1,vc3.chm_enlighten_device_id,l_tier1_calc_amount);

FUNCTION is_tier_calculated(p_tier IN VARCHAR2,
							p_chm_enlighten_device_id IN NUMBER
)
RETURN VARCHAR2 
AS

l_tier_calc			VARCHAR2(1):='N';

CURSOR c_rebate IS 
SELECT 	* 
FROM 	chm_enlighten_device_rebates
WHERE 	chm_enlighten_device_id=p_chm_enlighten_device_id
AND 	rebate_type='SYSTEM_SIZE'
AND 	rebate_source='SYSTEM'
AND 	rebate_tier=p_tier;

rebate_rec 	c_rebate%ROWTYPE;

BEGIN 

	OPEN 	c_rebate;
	FETCH 	c_rebate INTO rebate_rec;
	CLOSE 	c_rebate;

	IF rebate_rec.chm_enlighten_device_id IS NOT NULL THEN
		l_tier_calc:='Y';
	END IF;
	
	RETURN l_tier_calc;

EXCEPTION
	WHEN OTHERS THEN 
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.IS_TIER_CALCULATED', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'IS_TIER_CALCULATED', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);
		l_tier_calc:='N';
		RETURN l_tier_calc;

END is_tier_calculated;	


PROCEDURE insert_msi_auto_ap_invoice_requests (
     p_to_email IN VARCHAR2 DEFAULT NULL, 
	 p_ref_name IN VARCHAR2 DEFAULT NULL
	 ) AS

	l_request_id 	NUMBER;
	l_record_count	NUMBER;

	v_run_id		NUMBER;
	v_in_process_run_count_excep	NUMBER;
	
	l_report_type	VARCHAR2(4000):='MSI_AUTO_AP_INVOICE';
	l_module		VARCHAR2(4000):='CHM_MSI_SCHEDULE_REQUEST_PKG.INSERT_MSI_AUTO_AP_INVOICE_REQUESTS';

	l_claim_type  VARCHAR2(100):='MSI_REBATE';
	l_auto_approve VARCHAR2(100):='N';
	v_msg			VARCHAR2(4000);
	
	CURSOR c_batch (p_claim_type IN VARCHAR2) IS 
	SELECT 	batch_id FROM chm_msi_claim_batch
	WHERE 	claim_type=p_claim_type
	AND 	batch_status  = g_approved_status
	ORDER BY 1;

BEGIN
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process.',p_report_type => l_report_type);
	g_report_type:='INSERT_MSI_AUTO_AP_INVOICE_REQUESTS';
	v_run_id := chm_automation_runs_pkg.start_automation_run(g_report_type);	
	
	/* --check for Auto Approval 
	l_auto_approve:=chm_msi_claim_process_pkg.is_auto_approve('MSI_REBATE');
	 */
	 
	FOR vc in c_batch(l_claim_type) LOOP 
	
		INSERT INTO chm_msi_report_requests (status, user_id, 
			report_filters, report_type)
			VALUES (
				g_status_submitted,           
				g_user_num_id, 
				'{	FILE_REFERENCE_NAME: "' || '[CLAIM BATCH ID : '||vc.batch_id||'] '||NVL(p_ref_name,l_report_type)||' - '||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')|| '",
					REPORT_TYPE: "' || l_report_type || '",
					TO_EMAIL: "' || NVL(p_to_email,g_activation_report_email) || '",
					BATCH_ID: "' || vc.batch_id || '"}', 
				l_report_type
			)	RETURNING report_request_id INTO l_request_id;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Report Request ID = '||l_request_id,p_report_type => l_report_type);
					-- Commit after each batch update

		UPDATE  chm_msi_claim_batch
		SET 	batch_status=g_status_pending_ap_invoice
				,ap_invoice_request_id=l_request_id
		WHERE	batch_id=vc.batch_id
		AND 	batch_status=g_status_approved;
		
		l_record_count:=SQL%ROWCOUNT;

		v_msg := 'No of Batch Records updated with Pending AP Invoice = '||l_record_count;
		chm_claim_process_pkg.insert_batch_logs(-1, -1, vc.batch_id, NULL, g_msg_log, 'INSERT_MSI_AUTO_AP_INVOICE_REQUESTS', v_msg, g_source_app_id);

		UPDATE  chm_msi_claim_batch_lines
		SET 	line_status=g_status_pending_ap_invoice
				,ap_invoice_request_id=l_request_id
		WHERE	batch_id=vc.batch_id
		AND 	line_status=g_status_approved;
		
		l_record_count:=SQL%ROWCOUNT;

		v_msg := 'No of Batch Line Records updated with Pending AP Invoice = '||l_record_count;
		chm_claim_process_pkg.insert_batch_logs(-1, -1, vc.batch_id, NULL, g_msg_log, 'INSERT_MSI_AUTO_AP_INVOICE_REQUESTS', v_msg, g_source_app_id);

		COMMIT;

    END LOOP;

	chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'END Process',p_report_type => l_report_type);

EXCEPTION
    WHEN OTHERS THEN
		CHM_MSI_DEBUG_API.log_exp(p_transaction_id => -1, p_module => l_module, p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => l_report_type);
		
		SELECT 	COUNT(1)
		  INTO 		v_in_process_run_count_excep
		  FROM      chm_automation_runs
		  WHERE	    run_code = g_report_type AND status = 'IN_PROCESS' 
		  AND 		end_date IS NULL AND run_id = v_run_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
		END IF;		
	
END insert_msi_auto_ap_invoice_requests;
	
 PROCEDURE insert_claim_batch_creation_report_requests (
     p_to_email IN VARCHAR2 DEFAULT NULL, 
	 p_ref_name IN VARCHAR2 DEFAULT NULL,
	 p_batch_type IN VARCHAR2 DEFAULT g_msi_claim_batch_type, --Raj 3/12/25
	 p_from_date IN VARCHAR DEFAULT g_msi_claim_batch_from_date,
	 p_to_date IN VARCHAR DEFAULT g_msi_claim_batch_to_date
	 ) AS
	 
	l_request_id 	NUMBER;
	l_record_count	NUMBER;

	v_run_id		NUMBER;
	v_in_process_run_count_excep	NUMBER;
	
	l_report_type	VARCHAR2(4000):='MSI_CLAIM_BATCH_CREATION';
	l_module		VARCHAR2(4000):='CHM_MSI_SCHEDULE_REQUEST_PKG.INSERT_CLAIM_BATCH_CREATION_REPORT_REQUESTS';

	l_claim_type  VARCHAR2(100):='MSI_REBATE';
	l_auto_approve VARCHAR2(100):='N';
	v_msg			VARCHAR2(4000);	 

	l_filters	VARCHAR2(4000);
	l_batch_type VARCHAR2(4000):=p_batch_type; --'ALL_INSTALLERS';
	l_from_date	VARCHAR2(4000):=p_from_date;
	l_to_date	VARCHAR2(4000):=p_to_date;

BEGIN 

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process.',p_report_type => l_report_type);
	g_report_type:='INSERT_CLAIM_BATCH_CREATION_REPORT_REQUESTS';
	v_run_id := chm_automation_runs_pkg.start_automation_run(g_report_type);	
	
	l_filters:= '{	FILE_REFERENCE_NAME: "' || NVL(p_ref_name,l_report_type)||' -'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')|| '",
				INSTALLER: "",
				COUNTRY: "",
				REBATE_TYPE: "",
				TO_EMAIL: "' || p_to_email || '",
				REPORT_FORMAT: ".csv",
				FROM_DATE: "'||l_from_date||'" ,
				TO_DATE: "'||l_to_date||'"  , 
				BATCH_TYPE: "' || l_batch_type || '"}';


	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Report Request ID = '||l_request_id,p_report_type => l_report_type);

	INSERT INTO chm_msi_report_requests (status, user_id, 
			report_filters, report_type)
			VALUES (
				g_status_submitted,           
				g_user_num_id, 
				l_filters, 
				l_report_type
			) RETURNING report_request_id INTO l_request_id;

	COMMIT;

	chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Inserted Report Request Id ' ||l_request_id||'. END Process',p_report_type => l_report_type);

EXCEPTION
    WHEN OTHERS THEN
		CHM_MSI_DEBUG_API.log_exp(p_transaction_id => -1, p_module => l_module, p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => l_report_type);
		
		SELECT 	COUNT(1)
		  INTO 		v_in_process_run_count_excep
		  FROM      chm_automation_runs
		  WHERE	    run_code = g_report_type AND status = 'IN_PROCESS' 
		  AND 		end_date IS NULL AND run_id = v_run_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
		END IF;		
	
END insert_claim_batch_creation_report_requests;	
	

PROCEDURE insert_msi_auto_approval_requests (
     p_to_email IN VARCHAR2 DEFAULT NULL, 
	 p_ref_name IN VARCHAR2 DEFAULT NULL
	 ) AS

	l_request_id 	NUMBER;
	l_record_count	NUMBER;

	v_run_id		NUMBER;
	v_in_process_run_count_excep	NUMBER;
	
	l_report_type	VARCHAR2(4000):='MSI_AUTO_APPROVAL';
	l_module		VARCHAR2(4000):='CHM_MSI_SCHEDULE_REQUEST_PKG.INSERT_MSI_AUTO_APPROVAL_REQUESTS';

	l_claim_type  VARCHAR2(100):='MSI_REBATE';
	l_auto_approve VARCHAR2(100):='N';
	v_msg			VARCHAR2(4000);
	
	CURSOR c_batch (p_claim_type IN VARCHAR2) IS 
	SELECT 	batch_id FROM chm_msi_claim_batch
	WHERE 	claim_type=p_claim_type
	AND 	batch_status  = g_status_new
	ORDER BY 1;

BEGIN
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process.',p_report_type => l_report_type);
	g_report_type:='INSERT_MSI_AUTO_APPROVAL_REQUESTS';
	v_run_id := chm_automation_runs_pkg.start_automation_run(g_report_type);	
	
	/* --check for Auto Approval 
	l_auto_approve:=chm_msi_claim_process_pkg.is_auto_approve('MSI_REBATE');
	 */
	 
	FOR vc in c_batch(l_claim_type) LOOP 
	
		INSERT INTO chm_msi_report_requests (status, user_id, 
			report_filters, report_type)
			VALUES (
				g_status_submitted,           
				g_user_num_id, 
				'{	FILE_REFERENCE_NAME: "' || '[CLAIM BATCH ID : '||vc.batch_id||'] '||NVL(p_ref_name,l_report_type)||' - '||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')|| '",
					REPORT_TYPE: "' || l_report_type || '",
					TO_EMAIL: "' || NVL(p_to_email,g_activation_report_email) || '",
					BATCH_ID: "' || vc.batch_id || '"}', 
				l_report_type
			)	RETURNING report_request_id INTO l_request_id;

			CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Report Request ID = '||l_request_id,p_report_type => l_report_type);
					-- Commit after each batch update
		UPDATE chm_msi_claim_batch
		SET    batch_status = g_pending_approval_status
		WHERE  batch_id = vc.batch_id;

		v_msg:='Update Batch Status to '||g_pending_approval_status;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, vc.batch_id, NULL, g_msg_log, 'INSERT_MSI_AUTO_APPROVAL_REQUESTS', v_msg, g_source_app_id);		
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>v_msg,p_report_type => l_report_type);

		UPDATE chm_msi_claim_batch_lines
		SET    approval_status = g_pending_approval_status,
				line_status=g_pending_approval_status
		WHERE
				batch_id = vc.batch_id
			AND line_status = g_status_new;				

		v_msg:='Update Batch Line Status to '||g_pending_approval_status;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, vc.batch_id, NULL, g_msg_log, 'INSERT_MSI_AUTO_APPROVAL_REQUESTS', v_msg, g_source_app_id);		
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>v_msg,p_report_type => l_report_type);

					
		COMMIT;

    END LOOP;

	chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'END Process',p_report_type => l_report_type);

EXCEPTION
    WHEN OTHERS THEN
		CHM_MSI_DEBUG_API.log_exp(p_transaction_id => -1, p_module => l_module, p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => l_report_type);
		
		SELECT 	COUNT(1)
		  INTO 		v_in_process_run_count_excep
		  FROM      chm_automation_runs
		  WHERE	    run_code = g_report_type AND status = 'IN_PROCESS' 
		  AND 		end_date IS NULL AND run_id = v_run_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
		END IF;		
	
END insert_msi_auto_approval_requests;

--This procedure will take all the Device Data where  it is eligible for System Size Rebate
--It breaks the records into batches and assigns a BATCH ID in SYSTEM_SIZE_TIER_CALC_BATCH_ID
-- It inserts a row for each batch id in the report requests table so the scheduler can pick up and Process

PROCEDURE insert_system_size_calc_report_requests (
     p_to_email IN VARCHAR2 DEFAULT NULL, 
	 p_ref_name IN VARCHAR2 DEFAULT NULL
	 ) AS

	l_request_id 	NUMBER;
	l_record_count	NUMBER;

	CURSOR 	device_cursor IS
	SELECT 	DISTINCT site_id, system_size_rebate_item_number rebate_item_number, system_size_spa_number
	FROM 	chm_enlighten_site_device_attributes_v1 cesda
	WHERE 	system_size_spa_number IS NOT NULL
	AND 	system_size_tier_calc_batch_id IS NULL
	AND 	cesda.device_created_date>=g_device_attribute_derivation_cutoff_date
	AND 	is_tier_calculated(g_tier_5,cesda.chm_enlighten_device_id)='N';

    TYPE chm_enlighten_device_table_type IS TABLE OF device_cursor%ROWTYPE INDEX BY PLS_INTEGER;
    chm_enlighten_device_table chm_enlighten_device_table_type;

    l_batch_size 	CONSTANT PLS_INTEGER := NVL(g_system_size_batch_size,1000);
    l_counter 		PLS_INTEGER := 0;
    l_batch_id 		PLS_INTEGER ;
	l_report_type	VARCHAR2(4000):='SYSTEM_SIZE_TIER_REBATE';
	l_module		VARCHAR2(4000):='CHM_MSI_SCHEDULE_REQUEST_PKG.INSERT_SYSTEM_SIZE_CALC_REPORT_REQUESTS';

	v_run_id		NUMBER;
	v_in_process_run_count_excep	NUMBER;

BEGIN
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process. Batch Size = '||l_batch_size,p_report_type => l_report_type);
	g_report_type:='INSERT_SYSTEM_SIZE_CALC_REPORT_REQUESTS';
	v_run_id := chm_automation_runs_pkg.start_automation_run(g_report_type);
	
	
	--Get all Records that are ELIGIBLE to be PROCESSED
	--SO we can SPLIT the records into different BATCHES 
	--FOR EACH BATCH ID we will INSERT A REPORT REQUEST TO BE PICKED UP BY SCHEDULER 

    OPEN device_cursor;
    LOOP
        FETCH device_cursor BULK COLLECT INTO chm_enlighten_device_table LIMIT l_batch_size;
        EXIT WHEN chm_enlighten_device_table.COUNT = 0;

		--Fetch batch ID from Sequence

		SELECT 	CHM_MSI_BATCH_ID_SEQ.NEXTVAL
		INTO 	l_batch_id
		FROM 	dual;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Batch ID = '||l_batch_id,p_report_type => l_report_type);

        -- Update batch ID for the fetched records
        FORALL i IN 1 .. chm_enlighten_device_table.COUNT
		UPDATE 	chm_enlighten_device_attributes
		SET 	system_size_tier_calc_batch_id = l_batch_id
		WHERE 	system_size_spa_number = chm_enlighten_device_table(i).system_size_spa_number
		AND 	system_size_rebate_item_number=chm_enlighten_device_table(i).rebate_item_number
		AND 	site_id=chm_enlighten_device_table(i).site_id
		AND 	system_size_tier_calc_batch_id IS NULL;
		

		INSERT INTO chm_msi_report_requests (status, user_id, 
		report_filters, report_type)
		VALUES (
			g_status_submitted,           
			g_user_num_id, 
			'{	FILE_REFERENCE_NAME: "' || NVL(p_ref_name,l_report_type)||' -'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||' - [BATCH_ID= '||l_batch_id||' ]'|| '",
				REPORT_TYPE: "' || l_report_type || '",
				TO_EMAIL: "' || NVL(p_to_email,g_activation_report_email) || '",
				BATCH_ID: "' || l_batch_id || '"}', 
			l_report_type
		)	RETURNING report_request_id INTO l_request_id;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Report Request ID = '||l_request_id,p_report_type => l_report_type);
		        -- Commit after each batch update
        COMMIT;

    END LOOP;

    CLOSE device_cursor;

	chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'END Process',p_report_type => l_report_type);

EXCEPTION
    WHEN OTHERS THEN
		CHM_MSI_DEBUG_API.log_exp(p_transaction_id => -1, p_module => l_module, p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => l_report_type);
		
		SELECT 	COUNT(1)
		  INTO 		v_in_process_run_count_excep
		  FROM      chm_automation_runs
		  WHERE	    run_code = g_report_type AND status = 'IN_PROCESS' 
		  AND 		end_date IS NULL AND run_id = v_run_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
		END IF;			
END insert_system_size_calc_report_requests;


--This procedure will take all the Device Data where Disti and Order Type Information is not yet dervied
--It breaks the records into batches and assigns a BATCH ID in Attribute 2
-- It inserts a row for each batch id in the report requests table so the scheduler can pick up and Process

PROCEDURE insert_activation_report_requests (
     p_to_email IN VARCHAR2 DEFAULT NULL, 
	 p_ref_name IN VARCHAR2 DEFAULT NULL,
	 p_batch_type IN VARCHAR2 DEFAULT g_rebate_eligibility --Raj 3/12/25
	 ) AS

	l_request_id 	NUMBER;
	l_record_count	NUMBER;

	CURSOR 	device_cursor IS
	--To fetch New Records or Records where attributes are not yet Dervied
	SELECT 	cedd.chm_enlighten_device_id
	FROM 	chm_enlighten_device_details cedd,
			chm_enlighten_device_attributes ceda,
			chm_enlighten_site_master cesm
	WHERE 	cedd.chm_enlighten_device_id = ceda.chm_enlighten_device_id(+)
	AND  	cedd.site_id=cesm.id
	AND 	(NVL(ceda.msi_rebate_eligible,'N') ='N'
			OR ceda.disti_oracle_account_id IS NULL OR ceda.oracle_order_type IS NULL
			OR ceda.rebate_effective_date IS NULL
			OR ceda.product_type IS NULL OR ceda.product_family IS NULL
			)
	AND 	ceda.batch_id IS NULL  -- No batch ID assigned to the record
	--Raj 3/12/25
	AND 	p_batch_type=g_rebate_eligibility
	--AND 	NVL(cedd.creation_date,g_device_attribute_derivation_cutoff_date)>=g_device_attribute_derivation_cutoff_date;	
	AND 	NVL(cedd.creation_date,g_device_attribute_derivation_cutoff_date)>=TRUNC(SYSDATE)-g_device_attribute_derivation_cutoff_days
	AND     cesm.address_country IN (SELECT lookup_code FROM chm_lookup_values_v1 
									 WHERE lookup_type='CHM_MSI_ELIGIBLE_GEO'
									 AND enabled_flag='Y' 
									 AND SYSDATE BETWEEN NVL(start_date_active,SYSDATE-1) 
									 AND NVL(end_date_active, SYSDATE+1)
									 )
	AND     cesm.stage IN (SELECT description FROM chm_lookup_values_v1 
									 WHERE lookup_type='CHM_MSI_SITE_STAGE'
									 AND enabled_flag='Y' 
									 AND SYSDATE BETWEEN NVL(start_date_active,SYSDATE-1) 
									 AND NVL(end_date_active, SYSDATE+1)
									 )
	--To fetch Already processed Records where attributes are Dervied AND MSI Elgibile but SPA Numbers not derived
	UNION ALL 
	SELECT 	cedd.chm_enlighten_device_id
	FROM 	chm_enlighten_device_details cedd,
			chm_enlighten_device_attributes ceda,
			chm_enlighten_site_master cesm
	WHERE 	cedd.chm_enlighten_device_id = ceda.chm_enlighten_device_id
	AND  	cedd.site_id=cesm.id
	AND 	ceda.msi_rebate_eligible ='Y' 
	AND 	(unit_activation_spa_number IS NULL OR unit_activation_rebate_amount IS NULL
			OR system_attachment_spa_number IS NULL OR system_attachment_rebate_amount IS NULL
			 OR system_size_spa_number IS NULL) ----Raj 3/12/25
	AND 	ceda.batch_id IS NULL  -- No batch ID assigned to the record
	AND 	p_batch_type=g_rebate_calculation
	AND 	NVL(cedd.creation_date,g_device_attribute_derivation_cutoff_date)>=TRUNC(SYSDATE)-g_device_attribute_derivation_cutoff_days
	AND     cesm.address_country IN (SELECT lookup_code FROM chm_lookup_values_v1 
									 WHERE lookup_type='CHM_MSI_ELIGIBLE_GEO'
									 AND enabled_flag='Y' 
									 AND SYSDATE BETWEEN NVL(start_date_active,SYSDATE-1) 
									 AND NVL(end_date_active, SYSDATE+1)
									 )	
	;
	--AND 	NVL(cedd.created_date,g_device_attribute_derivation_cutoff_date)>=g_device_attribute_derivation_cutoff_date;		
		

    TYPE chm_enlighten_device_table_type IS TABLE OF chm_enlighten_device_details.chm_enlighten_device_id%TYPE INDEX BY PLS_INTEGER;
    chm_enlighten_device_table chm_enlighten_device_table_type;

    l_batch_size 	PLS_INTEGER := NVL(g_activation_batch_size,1000);
    l_counter 		PLS_INTEGER := 0;
    l_batch_id 		PLS_INTEGER ;
	l_report_type	VARCHAR2(4000):='DERIVE_ACTIVATION_ATTRIBUTES';
	l_module		VARCHAR2(4000):='CHM_MSI_SCHEDULE_REQUEST_PKG.INSERT_ACTIVATION_REPORT_REQUESTS';
	v_run_id		NUMBER;
	v_in_process_run_count_excep	NUMBER;
	

BEGIN
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process. Batch Size = '||l_batch_size,p_report_type => l_report_type);
	g_report_type:='INSERT_ACTIVATION_REPORT_REQUESTS';
	v_run_id := chm_automation_runs_pkg.start_automation_run(g_report_type);

	--Get all Records that are ELIGIBLE to be PROCESSED
	--SO we can SPLIT the records into different BATCHES 
	--FOR EACH BATCH ID we will INSERT A REPORT REQUEST TO BE PICKED UP BY SCHEDULER 

	IF p_batch_type=g_rebate_calculation THEN 
		l_batch_size := NVL(g_rebate_calculation_batch_size,1000);
	ELSE 
		l_batch_size := NVL(g_activation_batch_size,1000);
	END IF;

    OPEN device_cursor;
    LOOP
        FETCH device_cursor BULK COLLECT INTO chm_enlighten_device_table LIMIT l_batch_size;
        EXIT WHEN chm_enlighten_device_table.COUNT = 0;

		--Fetch batch ID from Sequence

		SELECT 	CHM_MSI_BATCH_ID_SEQ.NEXTVAL
		INTO 	l_batch_id
		FROM 	dual;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Batch ID = '||l_batch_id||' chm_enlighten_device_table.COUNT = '||chm_enlighten_device_table.COUNT,p_report_type => l_report_type);

        -- Update batch ID for the fetched records
        FORALL i IN 1 .. chm_enlighten_device_table.COUNT
		/*UPDATE 	chm_enlighten_device_details
		SET 	attribute2 = l_batch_id
		WHERE 	chm_enlighten_device_id = chm_enlighten_device_table(i);
		*/
		
		MERGE INTO chm_enlighten_device_attributes target
		USING (SELECT 	cedd.chm_enlighten_device_id,
				cedd.site_id site_id,
				1 device_quantity,
				cedd.sku item_number,
				cedd.serial_num serial_num,
				l_batch_id batch_id
		FROM 	chm_enlighten_device_details cedd
		WHERE 	chm_enlighten_device_id = chm_enlighten_device_table(i))  source
		ON (target.chm_enlighten_device_id = source.chm_enlighten_device_id)
		
		WHEN MATCHED THEN
		  UPDATE SET target.batch_id = source.batch_id,
					 target.last_batch_id = target.batch_id,
					 target.batch_process_count = NVL(target.batch_process_count,0)+1
		
		WHEN NOT MATCHED THEN
		  INSERT (chm_enlighten_device_id,
					site_id,
					device_quantity,
					item_number,
					serial_num,
					batch_id
					)
			VALUES (source.chm_enlighten_device_id,
					source.site_id,
					source.device_quantity,
					source.item_number,
					source.serial_num,
					source.batch_id
					);		
		

		INSERT INTO chm_msi_report_requests (status, user_id, 
		report_filters, report_type)
		VALUES (
			g_status_submitted,           
			g_user_num_id, 
			'{	FILE_REFERENCE_NAME: "' || NVL(p_ref_name,l_report_type)||' - '||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||' - [BATCH ID = '||l_batch_id||'] [BATCH TYPE = '||p_batch_type||'] '|| '",
				REPORT_TYPE: "' || l_report_type || '",
				TO_EMAIL: "' || NVL(p_to_email,g_activation_report_email) || '",
				BATCH_TYPE: "' || NVL(p_batch_type,'REBATE_ELIGIBILITY') || '",  
				BATCH_ID: "' || l_batch_id || '"}', 
			l_report_type
		)	RETURNING report_request_id INTO l_request_id;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Report Request ID = '||l_request_id,p_report_type => l_report_type);
		        -- Commit after each batch update
        COMMIT;

    END LOOP;

    CLOSE device_cursor;
	

	chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'END Process',p_report_type => l_report_type);

EXCEPTION
    WHEN OTHERS THEN
		CHM_MSI_DEBUG_API.log_exp(p_transaction_id => -1, p_module => l_module, p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => l_report_type);
		--chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
		SELECT 	COUNT(1)
		  INTO 		v_in_process_run_count_excep
		  FROM      chm_automation_runs
		  WHERE	    run_code = g_report_type AND status = 'IN_PROCESS' 
		  AND 		end_date IS NULL AND run_id = v_run_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
		END IF;		
		
END insert_activation_report_requests;


-- This is a COMMON procedure is launched by APEX scheduler for each different file type 
-- The scheduler will check if any previous automation for the file type is in progress
-- If In progress it will NOT pick the next request 
-- Else it will pick the next request and call the corresponding procedure to process data

PROCEDURE launch_msi_request (p_file_type IN VARCHAR2,p_request_id IN NUMBER DEFAULT NULL) AS

	v_in_process_run_count 	NUMBER;
	v_run_id 				NUMBER;
	v_batch_id 				NUMBER;
	l_report_request_id		NUMBER;
	v_in_process_run_count_excep NUMBER;
	v_msg             		VARCHAR2(4000);  
	l_request_count			NUMBER:=0;

BEGIN

	g_file_type:=p_file_type;
	g_report_type:=p_file_type;

    SELECT	COUNT(1)
    INTO 	v_in_process_run_count
    FROM    chm_automation_runs
    WHERE   run_code = p_file_type 
	AND 	status = g_status_in_process 
	AND 	end_date IS NULL;

    CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => - 1, p_log_type => g_msg_log, p_log_code => 'CHECKING IN PROCESS COUNT', p_log_msg => 'IN Process Run Count v_in_process_run_count =' || v_in_process_run_count, p_source_app_id => g_source_app_id);
	
    IF v_in_process_run_count = 0 THEN
		v_run_id := chm_automation_runs_pkg.start_automation_run(p_file_type);
		g_run_id := v_run_id;
		g_source_app_id := chm_util_pkg.getsourceapp('CHM');

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => v_run_id, p_log_type => g_msg_log, p_log_code => 'BEGIN_AUTOMATION', p_log_msg => 'Automation begins with RUN ID ' || v_run_id, p_source_app_id => g_source_app_id);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => v_run_id, p_log_type => g_msg_log, p_log_code => 'LAUNCH_MSI_REQUEST', p_log_msg => '1. Begin LAUNCH_MSI_REQUEST ' || v_run_id, p_source_app_id => g_source_app_id);
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id => v_run_id, p_module => 'LAUNCH_MSI_REQUEST', p_msg => '1. Begin Get Request Details', p_report_type => g_report_type);
		l_request_count:=0;
		
		FOR j IN (
			SELECT
					report_request_id, report_filters, user_id, status, file_name, 
					file_blob, mime_type, created_by, creation_date, last_updated_by, 
					last_updated_date, source_app_id
			FROM  	chm_msi_report_requests
			WHERE 	report_type = p_file_type
				AND status = g_status_submitted 
				AND (p_request_id IS NULL OR report_request_id = p_request_id )
			ORDER BY CREATION_DATE
			FETCH FIRST ROW ONLY
			) 
		LOOP
			l_request_count:=l_request_count+1;
			l_report_request_id := j.report_request_id;
			g_report_request_id := j.report_request_id;

			CHM_MSI_DEBUG_API.log_msg(p_transaction_id => l_report_request_id, p_module => 'LAUNCH_MSI_REQUEST', p_msg => '1. Get Request ID to process = ' || l_report_request_id || ' RUN ID = ' || g_run_id, p_report_type => g_report_type);
			CHM_MSI_DEBUG_API.log_msg(p_transaction_id => l_report_request_id, p_module => 'LAUNCH_MSI_REQUEST', p_msg => '1.1 report_filters = ' || j.report_filters || ' RUN ID = ' || g_run_id, p_report_type => g_report_type);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => v_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'LAUNCH_MSI_REQUEST', p_log_msg => '1. Get Request ID to process = ' || l_report_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => v_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'LAUNCH_MSI_REQUEST', p_log_msg => '1.1 report_filters = ' || j.report_filters || ' RUN ID = ' || g_run_id|| ' REPORT TYPE = '||g_report_type, p_source_app_id => g_source_app_id);

			BEGIN

				IF g_file_type='DERIVE_ACTIVATION_ATTRIBUTES' THEN 

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'CALLING DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => '2. START Calling DERIVE_ACTIVATION_ATTRIBUTES ' || g_run_id, p_source_app_id => g_source_app_id);

					chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'ENDING AUTOMATION SO NEXT REQUEST CAN BE PICKED UP', p_log_msg => 'Automation ended with RUN ID ' || g_run_id, p_source_app_id => g_source_app_id);
					COMMIT;

					derive_activation_attributes(g_report_request_id);

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'END CALLING DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => '3. END Calling DERIVE_ACTIVATION_ATTRIBUTES ' || g_run_id, p_source_app_id => g_source_app_id);

				END IF;

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET	  	status = g_status_failed, 
							attribute2 = g_run_id
					WHERE  	report_request_id = l_report_request_id;

					CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'update_request_status to ERROR ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);

					SELECT 	COUNT(1)
					INTO 		v_in_process_run_count_excep
					FROM      chm_automation_runs
					WHERE	    run_code = g_file_type AND status = 'IN_PROCESS' 
					AND 		end_date IS NULL AND run_id = v_run_id;


					IF v_in_process_run_count_excep > 0 THEN
					
						CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'Update Automation Status to ERROR ', g_report_type);
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
						p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => 'Update Automation Status to ERROR ', p_source_app_id => g_source_app_id);

						chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
					END IF;

					COMMIT;
					RETURN;
			END;

			BEGIN

				IF g_file_type='SYSTEM_SIZE_TIER_REBATE' THEN 

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'CALLING SYSTEM_SIZE_TIER_REBATE', p_log_msg => '2. START Calling system_size_tier_rebate ' || g_run_id, p_source_app_id => g_source_app_id);

					chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'ENDING AUTOMATION SO NEXT REQUEST CAN BE PICKED UP', p_log_msg => 'Automation ended with RUN ID ' || g_run_id, p_source_app_id => g_source_app_id);
					COMMIT;

					system_size_tier_rebate(g_report_request_id);

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'END CALLING SYSTEM_SIZE_TIER_REBATE', p_log_msg => '3. END Calling system_size_tier_rebate ' || g_run_id, p_source_app_id => g_source_app_id);
					
				END IF;				

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET	  	status = g_status_failed, 
							attribute2 = g_run_id
					WHERE  	report_request_id = l_report_request_id;

					CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'update_request_status to ERROR ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);
					
					SELECT 	COUNT(1)
					INTO 		v_in_process_run_count_excep
					FROM      chm_automation_runs
					WHERE	    run_code = g_file_type AND status = 'IN_PROCESS' 
					AND 		end_date IS NULL AND run_id = v_run_id;


					IF v_in_process_run_count_excep > 0 THEN
					
						CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'Update Automation Status to ERROR ', g_report_type);
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
						p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => 'Update Automation Status to ERROR ', p_source_app_id => g_source_app_id);

						chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
					END IF;

					COMMIT;
					RETURN;


			END;			

			BEGIN

				IF g_file_type='MSI_CLAIM_BATCH_CREATION' THEN 

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'CALLING CLAIM_BATCH_CREATION', p_log_msg => '2. START Calling CLAIM_BATCH_CREATION ' ||g_report_request_id||' -'|| g_run_id, p_source_app_id => g_source_app_id);

					--claim_batch_creation(g_report_request_id);
					CHM_MSI_CLAIM_PROCESS_PKG.create_claim_batch(g_report_request_id,g_run_id);

					chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'ENDING AUTOMATION SO NEXT REQUEST CAN BE PICKED UP', p_log_msg => 'Automation ended with RUN ID ' || g_run_id, p_source_app_id => g_source_app_id);
					COMMIT;

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'END CALLING CLAIM_BATCH_CREATION', p_log_msg => '3. END Calling CLAIM_BATCH_CREATION ' || g_run_id, p_source_app_id => g_source_app_id);
				END IF;					

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET	  	status = g_status_failed, 
							attribute2 = g_run_id
					WHERE  	report_request_id = l_report_request_id;

					CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'update_request_status to ERROR ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);

					SELECT 	COUNT(1)
					INTO 		v_in_process_run_count_excep
					FROM      chm_automation_runs
					WHERE	    run_code = g_file_type AND status = 'IN_PROCESS' 
					AND 		end_date IS NULL AND run_id = v_run_id;


					IF v_in_process_run_count_excep > 0 THEN
					
						CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'Update Automation Status to ERROR ', g_report_type);
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
						p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => 'Update Automation Status to ERROR ', p_source_app_id => g_source_app_id);

						chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
					END IF;

					COMMIT;
					RETURN;

			END;	
			
			BEGIN

				IF g_file_type='MSI_CLAIM_REPORT_PREVIEW' THEN 

					chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'ENDING AUTOMATION SO NEXT REQUEST CAN BE PICKED UP', p_log_msg => 'Automation ended with RUN ID ' || g_run_id, p_source_app_id => g_source_app_id);
					COMMIT;

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'CALLING MSI_CLAIM_REPORT_PREVIEW', p_log_msg => '2. START Calling MSI_CLAIM_REPORT_PREVIEW ' || g_run_id, p_source_app_id => g_source_app_id);

					CHM_MSI_CLAIM_REBATES_REPORT_PKG.CLAIMS_REBATE_REPORT(g_report_request_id,g_run_id);
					COMMIT;

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'END CALLING MSI_CLAIM_REPORT_PREVIEW', p_log_msg => '3. END Calling MSI_CLAIM_REPORT_PREVIEW ' || g_run_id, p_source_app_id => g_source_app_id);

				END IF;

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET	  	status = g_status_failed, 
							attribute2 = g_run_id
					WHERE  	report_request_id = l_report_request_id;

					CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'update_request_status to ERROR ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);
					SELECT 	COUNT(1)
					INTO 		v_in_process_run_count_excep
					FROM      chm_automation_runs
					WHERE	    run_code = g_file_type AND status = 'IN_PROCESS' 
					AND 		end_date IS NULL AND run_id = v_run_id;


					IF v_in_process_run_count_excep > 0 THEN
					
						CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'Update Automation Status to ERROR ', g_report_type);
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
						p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => 'Update Automation Status to ERROR ', p_source_app_id => g_source_app_id);

						chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
					END IF;

					COMMIT;
					RETURN;


			END;			

			BEGIN

				IF g_file_type='MSI_AUTO_APPROVAL' THEN 

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'CALLING SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg => '2. START Calling SUBMIT_AUTO_APPROVAL_REQUEST ' || g_run_id, p_source_app_id => g_source_app_id);



					chm_msi_claim_approval_pkg.submit_auto_approval_request(g_report_request_id);
					
					chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'ENDING AUTOMATION SO NEXT REQUEST CAN BE PICKED UP', p_log_msg => 'Automation ended with RUN ID ' || g_run_id, p_source_app_id => g_source_app_id);
					COMMIT;					

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'END CALLING SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg => '3. END Calling SUBMIT_AUTO_APPROVAL_REQUEST ' || g_run_id, p_source_app_id => g_source_app_id);

				END IF;

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET	  	status = g_status_failed, 
							attribute2 = g_run_id
					WHERE  	report_request_id = l_report_request_id;

					CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'update_request_status to ERROR ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);
					
					SELECT 	COUNT(1)
					INTO 		v_in_process_run_count_excep
					FROM      chm_automation_runs
					WHERE	    run_code = g_file_type AND status = 'IN_PROCESS' 
					AND 		end_date IS NULL AND run_id = v_run_id;


					IF v_in_process_run_count_excep > 0 THEN
					
						CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'Update Automation Status to ERROR ', g_report_type);
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
						p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => 'Update Automation Status to ERROR ', p_source_app_id => g_source_app_id);

						chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
					END IF;

					COMMIT;
					RETURN;
			END;
			
			BEGIN

				IF g_file_type='MSI_AUTO_AP_INVOICE' THEN 

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'CALLING AP_INVOICE_PROCESS', p_log_msg => '2. START Calling SUBMIT_AUTO_APPROVAL_REQUEST ' || g_run_id, p_source_app_id => g_source_app_id);

					chm_msi_claim_process_pkg.auto_ap_invoice_process(g_report_request_id);
					
					chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'ENDING AUTOMATION SO NEXT REQUEST CAN BE PICKED UP', p_log_msg => 'Automation ended with RUN ID ' || g_run_id, p_source_app_id => g_source_app_id);
					COMMIT;					

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'END CALLING AP_INVOICE_PROCESS', p_log_msg => '3. END Calling SUBMIT_AUTO_APPROVAL_REQUEST ' || g_run_id, p_source_app_id => g_source_app_id);

				END IF;

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET	  	status = g_status_failed, 
							attribute2 = g_run_id
					WHERE  	report_request_id = l_report_request_id;

					CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'update_request_status to ERROR ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_error_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);
					
					SELECT 	COUNT(1)
					INTO 		v_in_process_run_count_excep
					FROM      chm_automation_runs
					WHERE	    run_code = g_file_type AND status = 'IN_PROCESS' 
					AND 		end_date IS NULL AND run_id = v_run_id;


					IF v_in_process_run_count_excep > 0 THEN
					
						CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'Update Automation Status to ERROR ', g_report_type);
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
						p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => 'Update Automation Status to ERROR ', p_source_app_id => g_source_app_id);

						chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
					END IF;

					COMMIT;
					RETURN;


			END;
			
			BEGIN

				IF g_file_type='MSI_AP_INVOICE_CREATION' THEN 

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'CALLING MSI_AP_INVOICE_CREATION', p_log_msg => '2. START Calling MSI_AP_INVOICE_CREATION ' || g_run_id, p_source_app_id => g_source_app_id);

					chm_msi_claim_process_pkg.ap_invoice_process_request(g_report_request_id);
					
					chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'ENDING AUTOMATION SO NEXT REQUEST CAN BE PICKED UP', p_log_msg => 'Automation ended with RUN ID ' || g_run_id, p_source_app_id => g_source_app_id);
					COMMIT;					

					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'END CALLING MSI_AP_INVOICE_CREATION', p_log_msg => '3. END Calling MSI_AP_INVOICE_CREATION ' || g_run_id, p_source_app_id => g_source_app_id);

				END IF;

			EXCEPTION
				WHEN OTHERS THEN
					UPDATE 	chm_msi_report_requests
					SET	  	status = g_status_failed, 
							attribute2 = g_run_id
					WHERE  	report_request_id = l_report_request_id;

					CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'update_request_status to ERROR ' || 'No of Rows updated = ' || SQL%rowcount, g_report_type);
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_error_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);

					SELECT 	COUNT(1)
					INTO 		v_in_process_run_count_excep
					FROM      chm_automation_runs
					WHERE	    run_code = g_file_type AND status = 'IN_PROCESS' 
					AND 		end_date IS NULL AND run_id = v_run_id;


					IF v_in_process_run_count_excep > 0 THEN
					
						CHM_MSI_DEBUG_API.log_msg(g_run_id, 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', 'Update Automation Status to ERROR ', g_report_type);
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_error_log, 
						p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => 'Update Automation Status to ERROR ', p_source_app_id => g_source_app_id);

						chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
					END IF;

					COMMIT;
					RETURN;
			END;			




		END LOOP;
		IF l_request_count=0 THEN
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);
			CHM_MSI_DEBUG_API.log_msg(p_transaction_id => v_run_id, p_module => 'LAUNCH_MSI_REQUEST', p_msg => 'No request found. Exiting', p_report_type => g_report_type);			
		END IF;
    ELSE

      CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.LAUNCH_MSI_REQUEST', p_log_msg => 'Another Process Run in progress', p_source_app_id => g_source_app_id);
      CHM_MSI_DEBUG_API.log_msg(p_transaction_id => v_run_id, p_module => 'CHM_MSI_SCHEDULE_REQUEST_PKG.LAUNCH_MSI_REQUEST', p_msg => 'Another Process Run in progress', p_report_type => g_report_type);
      v_msg := 'RUN_IN_PROCESS';

    END IF;		
EXCEPTION
	WHEN OTHERS THEN
      CHM_MSI_DEBUG_API.log_exp(p_transaction_id => l_report_request_id, p_module => 'CHM_MSI_SCHEDULE_REQUEST_PKG.launch_msi_request', p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => g_report_type);
	  CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, 
					p_log_code => 'ERROR PROCESSING launch_msi_request', p_log_msg => '4. ERROR launch_msi_request ' || SQLCODE||' - '||SQLERRM||' Run ID = '||g_run_id, p_source_app_id => g_source_app_id);

      SELECT 	COUNT(1)
      INTO 		v_in_process_run_count_excep
      FROM      chm_automation_runs
      WHERE	    run_code = p_file_type AND status = 'IN_PROCESS' 
	  AND 		end_date IS NULL AND run_id = v_run_id;



    IF v_in_process_run_count_excep > 0 THEN
		chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed, g_report_type);
	END IF;
END launch_msi_request;


--Unit Activation Rebate Derivation
PROCEDURE derive_unit_activation_rebate(p_batch_id NUMBER)
AS 

	CURSOR c_msi_unit_activation_eligible_records IS
	SELECT  csda.*
	FROM 	chm_enlighten_site_device_attributes_v1 csda
	WHERE 	1=1 
	AND		(csda.item_number,csda.installer_sfdc_account_id) IN  --csda.disti_oracle_account_number) IN 
			(SELECT  item_number,installer_sfdc_account_id  --,sfdc_oracle_customer_number 
				FROM  chm_msi_spa_details_all_mv WHERE spa_line_type='UNIT_ACTIVATION'
				AND 	UPPER(status) = 'APPROVED')
	AND 	csda.batch_id=p_batch_id
	AND 	csda.msi_rebate_eligible = 'Y'
	AND 	(csda.unit_activation_spa_number IS NULL
			OR csda.unit_activation_rebate_amount IS NULL)
	AND 	rebate_effective_date >= TRUNC(SYSDATE) - g_device_attribute_derivation_cutoff_days;
	 -- Raj 3/12/25	

	CURSOR 	c_msi_unit_activation_spa (p_installer_sfdc_account_id varchar2, p_item_number varchar2, 
					  p_oracle_cust_account_number varchar2, p_effective_date date,
					  p_stage3_date date,
					  p_country varchar2, p_state varchar2, p_zip varchar2) IS
	--For SPAs where there is Disti. So we need to do disti validation
	SELECT * FROM (
		SELECT 	csda.*
		FROM	chm_msi_spa_details_all_mv csda
		WHERE 	1=1
		AND 	csda.spa_line_type='UNIT_ACTIVATION'
		AND 	UPPER(csda.status) = 'APPROVED'
		AND 	csda.installer_sfdc_account_id= p_installer_sfdc_account_id
		AND 	csda.item_number=p_item_number
		AND 	csda.sfdc_oracle_customer_number IS NOT NULL 
		AND 	csda.sfdc_oracle_customer_number=NVL(p_oracle_cust_account_number,csda.sfdc_oracle_customer_number)
		AND 	p_effective_date>= csda.spa_start_date 
		AND  	p_effective_date<=csda.spa_expiration_date
		AND 	p_stage3_date>= csda.spa_start_date 
		AND  	p_stage3_date<=csda.spa_expiration_date
		 AND 	(	p_country = csda.country AND csda.state IS NULL AND csda.zip IS NULL
					OR (p_country||NVL(p_state,'$STATE$') = csda.country||NVL(csda.state,'$STATE$')
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NULL
						)
					OR (p_country||NVL(p_zip,'$ZIP$') =csda.country||NVL(csda.zip,'$ZIP$')
						AND csda.country IS NOT NULL AND csda.state IS NULL AND csda.zip IS NOT NULL   
						)
					OR (p_country||NVL(p_state,'$STATE$')||NVL(p_zip,'$ZIP$') =csda.country||csda.state||csda.zip 
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NOT NULL
						)
				)
		--ORDER BY csda.item_priority ASC, csda.spa_final_approval_date_time DESC, csda.spa_number DESC FETCH FIRST ROW ONLY
		--For SPAs where there is no Disti. So we dont need to do disti validation
		UNION ALL
		SELECT 	csda.*
		FROM	chm_msi_spa_details_all_mv csda
		WHERE 	1=1
		AND 	csda.spa_line_type='UNIT_ACTIVATION'
		AND 	UPPER(csda.status) = 'APPROVED'
		AND 	csda.installer_sfdc_account_id= p_installer_sfdc_account_id
		AND 	csda.item_number=p_item_number
		AND 	csda.sfdc_oracle_customer_number IS  NULL 
		--AND 	csda.sfdc_oracle_customer_number=NVL(p_oracle_cust_account_number,csda.sfdc_oracle_customer_number)
		AND 	p_effective_date>= csda.spa_start_date 
		AND  	p_effective_date<=csda.spa_expiration_date
		AND 	p_stage3_date>= csda.spa_start_date 
		AND  	p_stage3_date<=csda.spa_expiration_date		
		 AND 	(	p_country = csda.country AND csda.state IS NULL AND csda.zip IS NULL
					OR (p_country||NVL(p_state,'$STATE$') = csda.country||NVL(csda.state,'$STATE$')
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NULL
						)
					OR (p_country||NVL(p_zip,'$ZIP$') =csda.country||NVL(csda.zip,'$ZIP$')
						AND csda.country IS NOT NULL AND csda.state IS NULL AND csda.zip IS NOT NULL   
						)
					OR (p_country||NVL(p_state,'$STATE$')||NVL(p_zip,'$ZIP$') =csda.country||csda.state||csda.zip 
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NOT NULL
						)
				)
	)
	ORDER BY item_priority ASC, spa_final_approval_date_time DESC, spa_number DESC FETCH FIRST ROW ONLY
	;	

	l_record_count	NUMBER;
	l_spa_payee_id	NUMBER;
	l_reason_code	VARCHAR2(4000);
	l_report_request_id	NUMBER:=g_report_request_id;
	l_msg			VARCHAR2(4000);
	l_attribute1	VARCHAR2(4000);

BEGIN 
	l_record_count:=0;
	l_reason_code:=NULL;

	FOR vc1 IN c_msi_unit_activation_eligible_records LOOP 
		l_record_count:=l_record_count+1;
		l_reason_code:='SPA_FOUND';
		l_spa_payee_id:=NULL;
		

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'Unit Activation SPA derivation for chm_enlighten_device_id = '||vc1.chm_enlighten_device_id, p_source_app_id => g_source_app_id);     
		
		l_msg:='Installer Account ID = '||vc1.installer_sfdc_account_id||
			   'Item = '||vc1.item_number||
			   'Disti Account = '||vc1.disti_oracle_account_number||
			   'Rebate Eff Date = '||vc1.rebate_effective_date||
			   'Stage 3 Date = '||vc1.stage_3_status_date||
			   'Country = '||vc1.address_country||
			   'State = '||vc1.address_state||
			   'Zip = '||vc1.address_zip;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     


		FOR vc2 IN c_msi_unit_activation_spa(vc1.installer_sfdc_account_id,vc1.item_number,
											 vc1.disti_oracle_account_number,
											 vc1.rebate_effective_date,vc1.stage_3_status_date,
											 vc1.address_country, vc1.address_state, vc1.address_zip
											 )
		LOOP
			l_reason_code:='ELIGIBLE_SPA_FOUND';
			l_spa_payee_id:=get_spa_payee(vc2.spa_number);

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'SPA = '||vc2.spa_number||' SPA Payee ID = '||l_spa_payee_id, p_source_app_id => g_source_app_id);     

			IF l_spa_payee_id IS NULL THEN 
				l_reason_code:='ELIGIBLE_SPA_FOUND_BUT_NO_SPA_PAYEE_FOUND';
				EXIT;
			END IF;

            UPDATE 	chm_enlighten_device_attributes ceda
			SET  	unit_activation_spa_number=vc2.spa_number
					,unit_activation_rebate_item_number=vc2.rebate_item_number
					,unit_activation_spa_line_id=vc2.chm_spa_line_id
					,unit_activation_rebate_amount=vc2.rebate_amount
					,unit_activation_rebate_eligibile_reason=l_reason_code
					,unit_activation_payee_id=l_spa_payee_id
					,unit_activation_payee_type='INSTALLER'
			WHERE  	ceda.chm_device_attribute_id=vc1.chm_device_attribute_id;

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'No of Attribute Records Updated = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     			

			l_attribute1:='{'||
				'"DISTI" : "'||NVL(vc2.disti_source,'NONE')||'",'||
				'"INSTALLER" : "'||NVL(vc2.installer_source,'NONE')||'",'||
				'"ITEM_SOURCE" : "'||NVL(vc2.item_source,'NONE')||'",'||
				'"ITEM_PRIORITY" : "'||NVL(vc2.item_priority,-1)||'"'||
				'}';

			INSERT INTO chm_enlighten_device_rebates
			(
				chm_enlighten_device_id ,
				chm_enlighten_site_id,
				spa_number,
				spa_line_id,
				device_item_number,
				rebate_item_number,
				rebate_type,
				rebate_tier,
				spa_original_amount,
				claim_date,
				rebate_currency, 
				rebate_amount,
				rebate_status, 
				claim_batch_id,
				claim_line_id,
				rebate_payee_type,
				rebate_payee_id,
				rebate_source,
				attribute1
			)
			VALUES (
				vc1.chm_enlighten_device_id,
				vc1.chm_enlighten_site_id,
				vc2.spa_number,
				vc2.chm_spa_line_id,
				vc2.item_number,
				vc2.rebate_item_number,
				'UNIT_ACTIVATION',
				NULL,
				vc2.rebate_amount,
				vc1.rebate_effective_date,
				vc2.spa_currency,
				vc2.rebate_amount,
				'ELIGIBLE_FOR_PAYMENT',
				NULL,
				NULL,
				'INSTALLER',
				l_spa_payee_id,
				'SYSTEM',
				l_attribute1
			);

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'No of Rebate Records Inserted = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						

		END LOOP;

		IF 	l_reason_code<>'ELIGIBLE_SPA_FOUND' 
			AND l_reason_code<>'ELIGIBLE_SPA_FOUND_BUT_NO_SPA_PAYEE_FOUND'
		THEN
			l_reason_code:='SPA_HAVING_INSTALLER_ITEM_FOUND_BUT_INELIGIBLE';
			--l_reason_description:='SPA With Installer and Item Found but Disti or Geo Or Effective Date not Eligible';
		END IF ;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'l_reason_code = '||l_reason_code, p_source_app_id => g_source_app_id);     						


		UPDATE 	chm_enlighten_device_attributes ceda
		SET		unit_activation_rebate_eligibile_reason=l_reason_code
		WHERE  	ceda.chm_device_attribute_id=vc1.chm_device_attribute_id;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'No of Rebate Records Updated with Reason Code '||l_reason_code||'=' ||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						

		IF MOD(l_record_count,100) = 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_UNIT_ACTIVATION_REBATE', p_msg => 'Unit Activation SPA derivation updated for 100 Records', p_report_type => g_report_type);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'Unit Activation SPA derivation updated for 100 Records', p_source_app_id => g_source_app_id);     
			COMMIT;
		END IF;
	

	END LOOP;
	
	l_reason_code:='NO_SPA_FOUND';
	
	UPDATE 	chm_enlighten_device_attributes csda
	SET		unit_activation_rebate_eligibile_reason=l_reason_code
	WHERE   csda.batch_id=p_batch_id
	AND 	csda.msi_rebate_eligible = 'Y'
	AND 	unit_activation_spa_number IS NULL;

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'No of Rebate Records Updated with Reason Code '||l_reason_code||'=' ||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'No of Records Processed = '||l_record_count, p_source_app_id => g_source_app_id);     

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN 
		ROLLBACK;
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_UNIT_ACTIVATION_REBATE', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);
END derive_unit_activation_rebate;

PROCEDURE derive_system_attachment_rebate(p_batch_id NUMBER)
AS 

	CURSOR c_msi_system_attachment_eligible_records IS
	SELECT  csda.*
	FROM 	chm_enlighten_site_device_attributes_v1 csda
	WHERE 	1=1 
	AND		(csda.item_number,csda.installer_sfdc_account_id) IN  --csda.disti_oracle_account_number) IN 
			(SELECT  item_number,installer_sfdc_account_id  --,sfdc_oracle_customer_number 
				FROM  chm_msi_spa_details_all_mv WHERE spa_line_type='SYSTEM_ATTACHMENT'
				AND 	UPPER(status) = 'APPROVED')
	AND 	csda.batch_id=p_batch_id
	AND 	csda.msi_rebate_eligible = 'Y'
	AND 	(csda.system_attachment_spa_number IS NULL
			OR csda.system_attachment_rebate_amount IS NULL)
	AND 	rebate_effective_date >= TRUNC(SYSDATE) - g_device_attribute_derivation_cutoff_days;			
			-- Raj 3/12/25	

	CURSOR 	c_msi_system_attachment_spa (
            p_site_id IN NUMBER, p_installer_sfdc_account_id varchar2, p_item_number varchar2, 
					  p_oracle_cust_account_number varchar2, p_effective_date date,
					  p_stage3_date DATE,
					  p_country varchar2, p_state varchar2, p_zip varchar2) IS
	--For SPAs where there is no Disti. So we  need to do disti validation
	SELECT * FROM (
		SELECT 	csda.*
		FROM	chm_msi_spa_details_all_mv csda
		WHERE 	1=1
		AND 	csda.spa_line_type='SYSTEM_ATTACHMENT'
		AND 	UPPER(csda.status) = 'APPROVED'
		AND 	csda.installer_sfdc_account_id= p_installer_sfdc_account_id
		AND 	csda.item_number=p_item_number
		AND 	csda.sfdc_oracle_customer_number IS NOT NULL
		AND 	csda.sfdc_oracle_customer_number=NVL(p_oracle_cust_account_number,csda.sfdc_oracle_customer_number)
		AND 	p_effective_date>= csda.spa_start_date 
		AND  	p_effective_date<=csda.spa_expiration_date
		AND 	p_stage3_date>= csda.spa_start_date 
		AND  	p_stage3_date<=csda.spa_expiration_date			
		AND 	(	p_country = csda.country AND csda.state IS NULL AND csda.zip IS NULL
					OR (p_country||NVL(p_state,'$STATE$') = csda.country||NVL(csda.state,'$STATE$')
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NULL
						)
					OR (p_country||NVL(p_zip,'$ZIP$') =csda.country||NVL(csda.zip,'$ZIP$')
						AND csda.country IS NOT NULL AND csda.state IS NULL AND csda.zip IS NOT NULL   
						)
					OR (p_country||NVL(p_state,'$STATE$')||NVL(p_zip,'$ZIP$') =csda.country||csda.state||csda.zip 
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NOT NULL
						)
				)
		AND 	EXISTS(SELECT 1 FROM chm_enlighten_site_device_attributes_v1 csda1
						WHERE 	csda1.site_id=p_site_id
						AND 	csda1.product_type=g_system_attachment_prereq_product_type
						AND  	csda1.rebate_effective_date>= csda.spa_start_date 
						AND 	csda1.rebate_effective_date<=csda.spa_expiration_date
						AND 	csda1.msi_rebate_eligible ='Y'
					)
	--	ORDER BY csda.item_priority ASC, csda.spa_final_approval_date_time DESC, csda.spa_number DESC FETCH FIRST ROW ONLY
		--For SPAs where there is no Disti. So we dont need to do disti validation
		UNION ALL
		SELECT 	csda.*
		FROM	chm_msi_spa_details_all_mv csda
		WHERE 	1=1
		AND 	csda.spa_line_type='SYSTEM_ATTACHMENT'
		AND 	UPPER(csda.status) = 'APPROVED'
		AND 	csda.installer_sfdc_account_id= p_installer_sfdc_account_id
		AND 	csda.item_number=p_item_number
		AND 	csda.sfdc_oracle_customer_number IS  NULL 
		--AND 	csda.sfdc_oracle_customer_number=NVL(p_oracle_cust_account_number,csda.sfdc_oracle_customer_number)
		AND 	p_effective_date>= csda.spa_start_date 
		AND  	p_effective_date<=csda.spa_expiration_date
		AND 	p_stage3_date>= csda.spa_start_date 
		AND  	p_stage3_date<=csda.spa_expiration_date			
		 AND 	(	p_country = csda.country AND csda.state IS NULL AND csda.zip IS NULL
					OR (p_country||NVL(p_state,'$STATE$') = csda.country||NVL(csda.state,'$STATE$')
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NULL
						)
					OR (p_country||NVL(p_zip,'$ZIP$') =csda.country||NVL(csda.zip,'$ZIP$')
						AND csda.country IS NOT NULL AND csda.state IS NULL AND csda.zip IS NOT NULL   
						)
					OR (p_country||NVL(p_state,'$STATE$')||NVL(p_zip,'$ZIP$') =csda.country||csda.state||csda.zip 
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NOT NULL
						)
				)
	)
	ORDER BY item_priority ASC, spa_final_approval_date_time DESC, spa_number DESC FETCH FIRST ROW ONLY;	

	l_record_count	NUMBER;
	l_spa_payee_id	NUMBER;
	l_reason_code	VARCHAR2(4000);
	l_report_request_id	NUMBER:=g_report_request_id;
	l_msg			VARCHAR2(4000);
	l_attribute1	VARCHAR2(4000);

BEGIN 
	l_record_count:=0;
	l_reason_code:=NULL;

	FOR vc1 IN c_msi_system_attachment_eligible_records LOOP 
		l_record_count:=l_record_count+1;
		l_reason_code:='SPA_FOUND';
		l_spa_payee_id:=NULL;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'System Attachment SPA derivation for chm_enlighten_device_id = '||vc1.chm_enlighten_device_id, p_source_app_id => g_source_app_id);     

		l_msg:='Site ID ='||vc1.site_id||
				'Installer Account ID = '||vc1.installer_sfdc_account_id||
			   'Item = '||vc1.item_number||
			   'Disti Account = '||vc1.disti_oracle_account_number||
			   'Rebate Eff Date = '||vc1.rebate_effective_date||
			   'Stage 3 Date = '||vc1.stage_3_status_date||
			   'Country = '||vc1.address_country||
			   'State = '||vc1.address_state||
			   'Zip = '||vc1.address_zip;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     



		FOR vc2 IN c_msi_system_attachment_spa(vc1.site_id,vc1.installer_sfdc_account_id,vc1.item_number,
											 vc1.disti_oracle_account_number,
											 vc1.rebate_effective_date,vc1.stage_3_status_date,
											 vc1.address_country, vc1.address_state, vc1.address_zip
											 )
		LOOP
			l_reason_code:='ELIGIBLE_SPA_FOUND';
			l_spa_payee_id:=get_spa_payee(vc2.spa_number);

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'SPA = '||vc2.spa_number||' SPA Payee ID = '||l_spa_payee_id, p_source_app_id => g_source_app_id);     

			IF l_spa_payee_id IS NULL THEN 
				l_reason_code:='ELIGIBLE_SPA_FOUND_BUT_NO_SPA_PAYEE_FOUND';
				EXIT;
			END IF;

            UPDATE 	chm_enlighten_device_attributes ceda
			SET  	system_attachment_spa_number=vc2.spa_number
					,system_attachment_rebate_item_number=vc2.rebate_item_number
					,system_attachment_spa_line_id=vc2.chm_spa_line_id
					,system_attachment_rebate_amount=vc2.rebate_amount
					,system_attachment_rebate_eligibile_reason=l_reason_code
					,system_attachment_payee_id=l_spa_payee_id
					,system_attachment_payee_type='INSTALLER'
			WHERE  	ceda.chm_device_attribute_id=vc1.chm_device_attribute_id;

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'No of Attribute Records Updated = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     			

			l_attribute1:='{'||
				'"DISTI" : "'||NVL(vc2.disti_source,'NONE')||'",'||
				'"INSTALLER" : "'||NVL(vc2.installer_source,'NONE')||'",'||
				'"ITEM_SOURCE" : "'||NVL(vc2.item_source,'NONE')||'",'||
				'"ITEM_PRIORITY" : "'||NVL(vc2.item_priority,-1)||'"'||
				'}';

			INSERT INTO chm_enlighten_device_rebates
			(
				chm_enlighten_device_id ,
				chm_enlighten_site_id,
				spa_number,
				spa_line_id,
				device_item_number,
				rebate_item_number,
				rebate_type,
				rebate_tier,
				spa_original_amount,
				claim_date,
				rebate_currency, 
				rebate_amount,
				rebate_status, 
				claim_batch_id,
				claim_line_id,
				rebate_payee_type,
				rebate_payee_id,
				rebate_source,
				attribute1
			)
			VALUES (
				vc1.chm_enlighten_device_id,
				vc1.chm_enlighten_site_id,
				vc2.spa_number,
				vc2.chm_spa_line_id,
				vc2.item_number,
				vc2.rebate_item_number,
				'SYSTEM_ATTACHMENT',
				NULL,
				vc2.rebate_amount,
				vc1.rebate_effective_date,
				vc2.spa_currency,
				vc2.rebate_amount,
				'ELIGIBLE_FOR_PAYMENT',
				NULL,
				NULL,
				'INSTALLER',
				l_spa_payee_id,
				'SYSTEM',
				l_attribute1
			);

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'No of Rebate Records Inserted = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						

		END LOOP;

		IF 	l_reason_code<>'ELIGIBLE_SPA_FOUND' 
			AND l_reason_code<>'ELIGIBLE_SPA_FOUND_BUT_NO_SPA_PAYEE_FOUND'
		THEN
			l_reason_code:='SPA_HAVING_INSTALLER_ITEM_FOUND_BUT_INELIGIBLE';
			--l_reason_description:='SPA With Installer and Item Found but Disti or Geo Or Effective Date not Eligible';
		END IF ;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'l_reason_code = '||l_reason_code, p_source_app_id => g_source_app_id);     						


		UPDATE 	chm_enlighten_device_attributes ceda
		SET		system_attachment_rebate_eligibile_reason=l_reason_code
		WHERE  	ceda.chm_device_attribute_id=vc1.chm_device_attribute_id;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'No of Rebate Records Updated with Reason Code = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						


		IF MOD(l_record_count,100) = 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_UNIT_ACTIVATION_REBATE', p_msg => 'Unit Activation SPA derivation updated for 100 Records', p_report_type => g_report_type);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'Unit Activation SPA derivation updated for 100 Records', p_source_app_id => g_source_app_id);     
			COMMIT;
		END IF;

	END LOOP;

	l_reason_code:='NO_SPA_FOUND';
	
	UPDATE 	chm_enlighten_device_attributes csda
	SET		system_attachment_rebate_eligibile_reason=l_reason_code
	WHERE   csda.batch_id=p_batch_id
	AND 	csda.msi_rebate_eligible = 'Y'
	AND 	system_attachment_spa_number IS NULL;

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'No of Rebate Records Updated with Reason Code '||l_reason_code||'=' ||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						


	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'No of Records Processed = '||l_record_count, p_source_app_id => g_source_app_id);     

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN 
		ROLLBACK;
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_SYSTEM_ATTACHMENT_REBATE', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_SYSTEM_ATTACHMENT_REBATE', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);
END derive_system_attachment_rebate;

PROCEDURE derive_system_size_rebate(p_batch_id NUMBER)
AS 

	CURSOR c_msi_system_size_eligible_records IS
	SELECT  csda.*
	FROM 	chm_enlighten_site_device_attributes_v1 csda
	WHERE 	1=1 
	AND		(csda.item_number,csda.installer_sfdc_account_id) IN  --csda.disti_oracle_account_number) IN 
			(	SELECT  item_number,installer_sfdc_account_id  --,sfdc_oracle_customer_number 
				FROM  	chm_msi_spa_details_all_mv WHERE spa_line_type='SYSTEM_SIZE'
				AND 	UPPER(status) = 'APPROVED')
	AND 	csda.batch_id=p_batch_id
	AND 	csda.msi_rebate_eligible = 'Y'
	AND 	csda.system_size_spa_number IS NULL
	AND 	rebate_effective_date >= TRUNC(SYSDATE) - g_device_attribute_derivation_cutoff_days;
	

	CURSOR 	c_msi_system_size_spa (p_installer_sfdc_account_id varchar2, p_item_number varchar2, 
					  p_oracle_cust_account_number varchar2, p_effective_date date,
					  p_stage3_date DATE,
					  p_country varchar2, p_state varchar2, p_zip varchar2) IS
	--For SPAs where there is no Disti. So we  need to do disti validation
	SELECT * FROM (
		SELECT 	csda.*
		FROM	chm_msi_spa_details_all_mv csda
		WHERE 	1=1
		AND 	csda.spa_line_type='SYSTEM_SIZE'
		AND 	UPPER(csda.status) = 'APPROVED'
		AND 	csda.rebate_tier = g_tier_1
		AND 	csda.installer_sfdc_account_id= p_installer_sfdc_account_id
		AND 	csda.item_number=p_item_number
		AND 	csda.sfdc_oracle_customer_number IS NOT NULL
		AND 	csda.sfdc_oracle_customer_number=NVL(p_oracle_cust_account_number,csda.sfdc_oracle_customer_number)
		AND 	p_effective_date>= csda.spa_start_date 
		AND  	p_effective_date<=csda.spa_expiration_date
		AND 	p_stage3_date>= csda.spa_start_date 
		AND  	p_stage3_date<=csda.spa_expiration_date			
		AND 	(	p_country = csda.country AND csda.state IS NULL AND csda.zip IS NULL
					OR (p_country||NVL(p_state,'$STATE$') = csda.country||NVL(csda.state,'$STATE$')
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NULL
						)
					OR (p_country||NVL(p_zip,'$ZIP$') =csda.country||NVL(csda.zip,'$ZIP$')
						AND csda.country IS NOT NULL AND csda.state IS NULL AND csda.zip IS NOT NULL   
						)
					OR (p_country||NVL(p_state,'$STATE$')||NVL(p_zip,'$ZIP$') =csda.country||csda.state||csda.zip 
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NOT NULL
						)
				)
		--ORDER BY csda.item_priority ASC, csda.spa_final_approval_date_time DESC, csda.spa_number DESC FETCH FIRST ROW ONLY
		--For SPAs where there is no Disti. So we dont need to do disti validation
		UNION ALL
		SELECT 	csda.*
		FROM	chm_msi_spa_details_all_mv csda
		WHERE 	1=1
		AND 	csda.spa_line_type='SYSTEM_SIZE'
		AND 	UPPER(csda.status) = 'APPROVED'
		AND 	csda.rebate_tier = g_tier_1
		AND 	csda.installer_sfdc_account_id= p_installer_sfdc_account_id
		AND 	csda.item_number=p_item_number
		AND 	csda.sfdc_oracle_customer_number IS NULL
		--AND 	csda.sfdc_oracle_customer_number=NVL(p_oracle_cust_account_number,csda.sfdc_oracle_customer_number)
		AND 	p_effective_date>= csda.spa_start_date 
		AND  	p_effective_date<=csda.spa_expiration_date
		AND 	p_stage3_date>= csda.spa_start_date 
		AND  	p_stage3_date<=csda.spa_expiration_date			
		AND 	(	p_country = csda.country AND csda.state IS NULL AND csda.zip IS NULL
					OR (p_country||NVL(p_state,'$STATE$') = csda.country||NVL(csda.state,'$STATE$')
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NULL
						)
					OR (p_country||NVL(p_zip,'$ZIP$') =csda.country||NVL(csda.zip,'$ZIP$')
						AND csda.country IS NOT NULL AND csda.state IS NULL AND csda.zip IS NOT NULL   
						)
					OR (p_country||NVL(p_state,'$STATE$')||NVL(p_zip,'$ZIP$') =csda.country||csda.state||csda.zip 
						AND csda.country IS NOT NULL AND csda.state IS NOT NULL AND csda.zip IS NOT NULL
						)
				)
	)
	ORDER BY item_priority ASC, spa_final_approval_date_time DESC, spa_number DESC FETCH FIRST ROW ONLY;			

	l_record_count	NUMBER;
	l_spa_payee_id	NUMBER;
	l_reason_code	VARCHAR2(4000);
	l_report_request_id	NUMBER:=g_report_request_id;
	l_msg			VARCHAR2(4000);
	
BEGIN 
	l_record_count:=0;
	l_reason_code:=NULL;

	FOR vc1 IN c_msi_system_size_eligible_records LOOP 
		l_record_count:=l_record_count+1;
		l_reason_code:='SPA_FOUND';
		l_spa_payee_id:=NULL;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'System Attachment SPA derivation for chm_enlighten_device_id = '||vc1.chm_enlighten_device_id, p_source_app_id => g_source_app_id);     


		l_msg:='Installer Account ID = '||vc1.installer_sfdc_account_id||
			   'Item = '||vc1.item_number||
			   'Disti Account = '||vc1.disti_oracle_account_number||
			   'Rebate Eff Date = '||vc1.rebate_effective_date||
			   'Stage 3 Date = '||vc1.stage_3_status_date||
			   'Country = '||vc1.address_country||
			   'State = '||vc1.address_state||
			   'Zip = '||vc1.address_zip;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     



		FOR vc2 IN c_msi_system_size_spa(vc1.installer_sfdc_account_id,vc1.item_number,
											 vc1.disti_oracle_account_number,vc1.rebate_effective_date,
											 vc1.stage_3_status_date,
											 vc1.address_country, vc1.address_state, vc1.address_zip
											 )
		LOOP
			l_reason_code:='ELIGIBLE_SPA_FOUND';
			l_spa_payee_id:=get_spa_payee(vc2.spa_number);

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'SPA = '||vc2.spa_number||' SPA Payee ID = '||l_spa_payee_id, p_source_app_id => g_source_app_id);     

			IF l_spa_payee_id IS NULL THEN 
				l_reason_code:='ELIGIBLE_SPA_FOUND_BUT_NO_SPA_PAYEE_FOUND';

				UPDATE 	chm_enlighten_device_attributes ceda
				SET		system_size_rebate_eligibile_reason=l_reason_code
				WHERE  	ceda.chm_device_attribute_id=vc1.chm_device_attribute_id;

				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'No of Rebate Records Updated with Reason Code '||l_reason_code||' = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						


				EXIT;
			END IF;

            UPDATE 	chm_enlighten_device_attributes ceda
			SET  	system_size_spa_number=vc2.spa_number
					,system_size_rebate_item_number=vc2.rebate_item_number
					,system_size_spa_line_id=vc2.chm_spa_line_id
					,system_size_rebate_eligibile_reason=l_reason_code
					,system_size_payee_id=l_spa_payee_id
					,system_size_payee_type='INSTALLER'
					,device_quantity=1
			WHERE  	ceda.chm_device_attribute_id=vc1.chm_device_attribute_id;

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'No of Attribute Records Updated = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     			
		END LOOP;

		IF 	l_reason_code<>'ELIGIBLE_SPA_FOUND' 
			AND l_reason_code<>'ELIGIBLE_SPA_FOUND_BUT_NO_SPA_PAYEE_FOUND'
		THEN
			l_reason_code:='SPA_HAVING_INSTALLER_ITEM_FOUND_BUT_INELIGIBLE';
			--l_reason_description:='SPA With Installer and Item Found but Disti or Geo Or Effective Date not Eligible';
		END IF ;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'l_reason_code = '||l_reason_code, p_source_app_id => g_source_app_id);     						


		UPDATE 	chm_enlighten_device_attributes ceda
		SET		system_size_rebate_eligibile_reason=l_reason_code
		WHERE  	ceda.chm_device_attribute_id=vc1.chm_device_attribute_id;

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'No of Rebate Records Updated with Reason Code '||l_reason_code||' = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						


		IF MOD(l_record_count,100) = 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_UNIT_ACTIVATION_REBATE', p_msg => 'Unit Activation SPA derivation updated for 100 Records', p_report_type => g_report_type);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'Unit Activation SPA derivation updated for 100 Records', p_source_app_id => g_source_app_id);     
			COMMIT;
		END IF;

	END LOOP;
	
	l_reason_code:='NO_SPA_FOUND';
	
	UPDATE 	chm_enlighten_device_attributes csda
	SET		system_size_rebate_eligibile_reason=l_reason_code
	WHERE   csda.batch_id=p_batch_id
	AND 	csda.msi_rebate_eligible = 'Y'
	AND 	system_size_spa_number IS NULL;

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_UNIT_ACTIVATION_REBATE', p_log_msg => 'No of Rebate Records Updated with Reason Code '||l_reason_code||'=' ||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						
	

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'No of Records Processed = '||l_record_count, p_source_app_id => g_source_app_id);     

	COMMIT;
EXCEPTION
	WHEN OTHERS THEN 
		ROLLBACK;
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_SYSTEM_SIZE_REBATE', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_SYSTEM_SIZE_REBATE', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);
END derive_system_size_rebate;

--Derive the Tier and Calculate System Size Rebate TGier Amount

PROCEDURE system_size_tier_rebate(p_request_id IN NUMBER) AS

l_batch_id 		VARCHAR2(4000);
l_report_type	VARCHAR2(4000):='SYSTEM_SIZE_TIER_REBATE';
l_module		VARCHAR2(4000):='CHM_MSI_SCHEDULE_REQUEST_PKG.SYSTEM_SIZE_TIER_REBATE';
l_report_request_id	NUMBER:=p_request_id;
l_record_count	NUMBER;
l_msg			VARCHAR2(4000);
v_in_process_run_count_excep	NUMBER;
v_run_id		NUMBER:=g_run_id;	
l_file_reference_name VARCHAR2(4000);
l_to_email    VARCHAR2(4000);

BEGIN

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process. Request ID  = '||p_request_id,p_report_type => l_report_type);
    CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'START Processing Request ID = ' || p_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'Update Request Status to In Process', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => l_module, p_msg => 'Update Request Status to In Process', p_report_type => g_report_type);
	
	update_request_status(g_report_request_id, g_status_in_process);

    COMMIT;



	SELECT
			jt.file_reference_name || '_Request_ID_' || l_report_request_id || '_' || g_user_id , 
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

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id ,p_report_type => l_report_type);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id, p_source_app_id => g_source_app_id);     

	l_msg:='Calling derive_system_size_tier_rebate for Batch ID = '||l_batch_id;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											

	derive_system_size_tier_rebate(l_batch_id);

	l_msg:='Calling release_system_size_batch_records for Batch ID = '||l_batch_id;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											


	release_system_size_batch_records(l_batch_id);

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'Update Request Status to Generated', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => l_module, p_msg => 'Update Request Status to Generated', p_report_type => g_report_type);
	
	update_request_status(g_report_request_id, g_status_generated);

	l_msg:='Completed derive_system_size_tier_rebate for Batch ID = '||l_batch_id;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											

    COMMIT;

EXCEPTION 
	WHEN OTHERS THEN
		release_system_size_batch_records(l_batch_id);
		chm_msi_debug_api.log_exp(p_transaction_id => g_report_request_id, p_module => 'CHM_MSI_SCHEDULE_REQUEST_PKG.SYSTEM_SIZE_TIER_REBATE', p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => g_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'SYSTEM_SIZE_TIER_REBATE', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);

		SELECT 	COUNT(1)
		INTO 	v_in_process_run_count_excep
		FROM	chm_automation_runs
		WHERE   run_code = g_file_type AND status = 'IN_PROCESS' 
		AND 	end_date IS NULL 
		AND 	run_id = v_run_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'SYSTEM_SIZE_TIER_REBATE', p_msg => 'ERROR OCCURRED. Closing Automation Run', p_report_type => g_report_type);
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed,g_report_type);
		END IF;

		SELECT 	COUNT(1)
		INTO 	v_in_process_run_count_excep
		FROM	chm_msi_report_requests
		WHERE   report_request_id=g_report_request_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'SYSTEM_SIZE_TIER_REBATE', p_msg => 'ERROR OCCURRED. Updating Request Status to Failed', p_report_type => g_report_type);
			update_request_status(g_report_request_id, g_status_failed);
		END IF;

		COMMIT;

END system_size_tier_rebate;


PROCEDURE derive_system_size_tier_rebate(p_batch_id NUMBER)
AS 

	CURSOR c_site_spa IS
	SELECT  DISTINCT csda.system_size_spa_number spa_number, 
			csda.site_id,
			 TRUNC(cmsh.spa_start_date) spa_start_date,
			 TRUNC(cmsh.spa_expiration_date) spa_expiration_date
	FROM 	chm_enlighten_device_attributes csda,
			chm_msi_spa_header cmsh
	WHERE 	1=1
	AND 	csda.system_size_spa_number=cmsh.spa_number
	AND 	csda.system_size_tier_calc_batch_id=p_batch_id;

	CURSOR c_msi_system_size_qty IS
	SELECT  csda.system_size_spa_number spa_number, csda.site_id,
			csda.system_size_rebate_item_number rebate_item_number, 
			SUM(csda.device_quantity) rebate_item_qty,
			csdq.quantity device_qty
	FROM 	chm_enlighten_site_device_attributes_v1 csda,
			chm_msi_site_device_qty_tmp csdq
	WHERE 	1=1
	AND 	csda.site_id=csdq.site_id
	AND 	csda.system_size_spa_number=csdq.spa_number
	AND  	csda.system_size_spa_number IS NOT NULL
	AND 	csda.system_size_tier_calc_batch_id=p_batch_id
	AND 	csda.msi_rebate_eligible = 'Y'
	GROUP BY  csda.system_size_spa_number, csda.site_id,
				csda.system_size_rebate_item_number,csdq.quantity;

	CURSOR c_msi_system_size_tier_rebate
	(p_spa_number VARCHAR2, p_rebate_item_number VARCHAR2, p_tier VARCHAR2)IS
	SELECT 		csda.*,
				'{'||
				'"DISTI" : "'||NVL(disti_source,'NONE')||'",'||
				'"INSTALLER" : "'||NVL(installer_source,'NONE')||'",'||
				'"ITEM_SOURCE" : "'||NVL(item_source,'NONE')||'",'||
				'"ITEM_PRIORITY" : "'||NVL(item_priority,-1)||'"'||
				'}' attribute_1
		FROM	chm_msi_spa_details_all_mv csda
		WHERE 	1=1
		AND 	csda.spa_line_type='SYSTEM_SIZE'
		AND 	UPPER(csda.status) = 'APPROVED'
		AND 	csda.rebate_tier = p_tier
		AND 	csda.spa_number=p_spa_number
		AND     csda.rebate_item_number=p_rebate_item_number
	ORDER BY item_priority ASC, spa_final_approval_date_time DESC, spa_number DESC FETCH FIRST ROW ONLY;					
		
	CURSOR c_devices
	(p_spa_number VARCHAR2, p_rebate_item_number VARCHAR2, 
	p_site_id VARCHAR2)
	IS
	SELECT 	system_size_rebate_item_number rebate_item_number, csda.* 
	FROM 	chm_enlighten_site_device_attributes_v1 csda
	WHERE 	csda.system_size_spa_number=p_spa_number
	AND     csda.system_size_rebate_item_number=p_rebate_item_number
	AND     csda.site_id=p_site_id
	AND 	csda.msi_rebate_eligible = 'Y'
	AND 	csda.system_size_tier_calc_batch_id=p_batch_id;

	CURSOR c_rebates (p_chm_enlighten_device_id IN NUMBER, p_tier IN VARCHAR2)
	IS 
	SELECT * FROM chm_enlighten_device_rebates cedr
	WHERE 	cedr.chm_enlighten_device_id=p_chm_enlighten_device_id
	AND 	cedr.rebate_type='SYSTEM_SIZE'
	AND 	cedr.rebate_tier=p_tier
	AND     cedr.rebate_source='SYSTEM';


	l_tier1_eligible	VARCHAR2(100);
	l_tier1_calculated	VARCHAR2(100);
	l_tier1_rebate_amount	NUMBER:=0;
	l_tier1_rebate_inserted NUMBER:=0;
	l_tier1_device_rebate_id	NUMBER:=0;

	l_tier2_eligible	VARCHAR2(100);
	l_tier2_calculated	VARCHAR2(100);
	l_tier2_rebate_amount	NUMBER:=0;	
	l_tier2_rebate_inserted NUMBER:=0;
	l_tier2_device_rebate_id	NUMBER:=0;

	l_tier3_eligible	VARCHAR2(100);
	l_tier3_calculated	VARCHAR2(100);
	l_tier3_rebate_amount	NUMBER:=0;	
	l_tier3_rebate_inserted NUMBER:=0;
	l_tier3_device_rebate_id	NUMBER:=0;

	l_tier4_eligible	VARCHAR2(100);
	l_tier4_calculated	VARCHAR2(100);
	l_tier4_rebate_amount	NUMBER:=0;	
	l_tier4_rebate_inserted NUMBER:=0;
	l_tier4_device_rebate_id	NUMBER:=0;

	l_tier5_eligible	VARCHAR2(100);
	l_tier5_calculated	VARCHAR2(100);
	l_tier5_rebate_amount	NUMBER:=0;		
	l_tier5_rebate_inserted NUMBER:=0;
	l_tier5_device_rebate_id	NUMBER:=0;

	l_tier1_calc_amount		NUMBER:=0;
	l_tier2_calc_amount		NUMBER:=0;
	l_tier3_calc_amount		NUMBER:=0;
	l_tier4_calc_amount		NUMBER:=0;
	l_tier5_calc_amount		NUMBER:=0;

	l_tier2_orig_rebate_amount	NUMBER:=0;
	l_tier2_calc_rebate_amount NUMBER:=0;

	l_tier3_orig_rebate_amount	NUMBER:=0;
	l_tier3_calc_rebate_amount NUMBER:=0;

	l_tier4_orig_rebate_amount	NUMBER:=0;
	l_tier4_calc_rebate_amount NUMBER:=0;

	l_tier5_orig_rebate_amount	NUMBER:=0;
	l_tier5_calc_rebate_amount NUMBER:=0;	

	l_msg 		VARCHAR2(4000);

	v_in_process_run_count_excep	NUMBER;
	v_run_id		NUMBER:=g_run_id;	
    l_report_request_id NUMBER:=g_report_request_id;
	l_total_paid_amount	NUMBER;
	l_date			DATE;
	l_record_count	NUMBER;
	l_site_data_inserted VARCHAR2(4000);
	
	cursor c_site IS 
	SELECT SITE_ID, QUANTITY, PRODUCT_TYPE
	FROM CHM_MSI_SITE_DEVICE_QTY_TMP;
	

BEGIN 

	l_msg:='Start System Size Calculation for Batch ID = '||p_batch_id;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											
	
	l_date:=SYSDATE;
	
	--Populate site temp Table
	--we are storing the total micros enabled at that side during the SPA period
	FOR vc_site_spa IN c_site_spa LOOP	

		INSERT INTO CHM_MSI_SITE_DEVICE_QTY_TMP (
				site_id, 
				spa_number, 
				spa_start_date, 
				spa_expiration_date,
				quantity, 
				product_type,
				created_by,
				creation_date,
				last_updated_by,
				last_updated_date)
			SELECT 	ceda.site_id,
					vc_site_spa.spa_number,
					vc_site_spa.spa_start_date,
					vc_site_spa.spa_expiration_date,
					SUM(ceda.device_quantity), 
					ceda.product_type,
					'SYSTEM',
					l_date,
					'SYSTEM',
					l_date
			FROM 	chm_enlighten_device_attributes ceda
			WHERE 	1=1
			AND     ceda.site_id=vc_site_spa.site_id
			AND 	ceda.product_type=g_system_size_product_type
			AND 	ceda.msi_rebate_eligible='Y'
			AND 	ceda.rebate_effective_date
			BETWEEN vc_site_spa.spa_start_date 
			AND 	vc_site_spa.spa_expiration_date
			GROUP 	BY ceda.site_id,
					ceda.product_type;
			
			l_record_count:=SQL%ROWCOUNT;
			
			l_msg:='No of Records Inserted into TMP Site Qty Table = '||l_record_count||' for Site ID= '||vc_site_spa.site_id||' SPA = '||vc_site_spa.spa_number||' Start Date = '||vc_site_spa.spa_start_date||' End Date = '||vc_site_spa.spa_expiration_date;
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											
			
			COMMIT;
	END LOOP;
	

	FOR vc IN c_site LOOP 
	
		l_msg:='Site ID = '||vc.site_id||' Qty = '||vc.quantity||' Product Type = '||vc.product_type;
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     											
		
	END LOOP;
		

	FOR vc1 IN c_msi_system_size_qty LOOP
		l_site_data_inserted := 'N';
		l_msg:='System Size SPA = '||vc1.spa_number||' Site ID ='||vc1.site_id||' Rebate Item Number = '||vc1.rebate_item_number||' Site Total Qty = '||vc1.device_qty||' Rebate Item Qty = '||vc1.rebate_item_qty;
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

		
-----------------------------------------------------------------	
		--Tier 1 Calculations 
-----------------------------------------------------------------

		l_tier1_eligible:='N';
		--Check Tier 1 Eligibility and Calculate
		FOR vc2 in c_msi_system_size_tier_rebate (vc1.spa_number, vc1.rebate_item_number,g_tier_1) LOOP
			l_msg:='Device Qty = '||vc1.device_qty||' Rebate Tier 1 Min Qty ='||vc2.rebate_tier_min_qty;
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										
			IF vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier1_eligible:='Y';

				l_msg:='Tier 1 Eligible = Y';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

				--Check if Tier 1 already calculated
				l_tier1_rebate_inserted:=0;
				FOR vc3 IN c_devices(vc1.spa_number, vc1.rebate_item_number, vc1.site_id) LOOP
					l_tier1_calculated:='N';
					l_tier1_rebate_amount:=0;

					l_msg:='Enlighten Device ID = '||vc3.chm_enlighten_device_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										


					FOR vc4 IN c_rebates(vc3.chm_enlighten_device_id,g_tier_1) LOOP
						l_tier1_calculated:='Y';
						l_msg:='Tier 1 Already Calculated. Device Rebate ID  = '||vc4.chm_device_rebate_id;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																
					END LOOP;

					IF l_tier1_calculated='N' THEN
						l_tier1_rebate_amount:=vc2.rebate_amount;

						l_msg:='Tier 1 Rebate Amount  = '||vc2.rebate_amount;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

						--INSERT INTO REBATES TABLE

						INSERT INTO chm_enlighten_device_rebates
						(
							chm_enlighten_device_id ,
							chm_enlighten_site_id,
							spa_number,
							spa_line_id,
							device_item_number,
							rebate_item_number,
							rebate_type,
							rebate_tier,
							spa_original_amount,
							claim_date,
							rebate_currency, 
							rebate_amount,
							rebate_status, 
							claim_batch_id,
							claim_line_id,
							rebate_payee_type,
							rebate_payee_id,
							rebate_source,
							attribute1
						)
						VALUES (
							vc3.chm_enlighten_device_id,
							vc3.chm_enlighten_site_id,
							vc2.spa_number,
							vc2.chm_spa_line_id,
							vc3.item_number,
							vc3.rebate_item_number,
							'SYSTEM_SIZE',
							g_tier_1,
							vc2.rebate_amount,
							vc3.rebate_effective_date,
							vc2.spa_currency,
							vc2.rebate_amount,
							'ELIGIBLE_FOR_PAYMENT',
							NULL,
							NULL,
							'INSTALLER',
							vc3.system_size_payee_id,
							'SYSTEM',
							vc2.attribute_1
						);

						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'No of Rebate Records Inserted = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);     						
						l_tier1_rebate_inserted:=l_tier1_rebate_inserted+1;

					END IF;

					update_batch_process_count(vc3.chm_enlighten_device_id);

				END LOOP; --vc3
				l_msg:='Tier 1 Rebate Records Inserted = '||l_tier1_rebate_inserted;
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			ELSE --vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier1_eligible:='N';
				l_msg:='Tier 1 Eligible = N';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			END IF; --vc1.device_qty>= vc2.rebate_tier_min_qty THEN

		END LOOP; --vc2	

-----------------------------------------------------------------	
		--Tier 2 Calculations 
-----------------------------------------------------------------		
		l_tier2_eligible:='N';
		l_total_paid_amount:=0;
		--Check Tier 2 Eligibility and Calculate

		FOR vc2 in c_msi_system_size_tier_rebate (vc1.spa_number, vc1.rebate_item_number,g_tier_2) LOOP

			l_msg:='Device Qty = '||vc1.device_qty||' Rebate Tier 2 Min Qty ='||vc2.rebate_tier_min_qty;
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			IF vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier2_eligible:='Y';

				l_msg:='Tier 2 Eligible = Y';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

				--Check if Tier 2 already calculated
				l_tier2_rebate_inserted:=0;

				FOR vc3 IN c_devices(vc1.spa_number, vc1.rebate_item_number, vc1.site_id) LOOP
					l_tier2_calculated:='N';
					l_tier2_rebate_amount:=0;

					l_msg:='Enlighten Device ID = '||vc3.chm_enlighten_device_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										


					FOR vc4 IN c_rebates(vc3.chm_enlighten_device_id,g_tier_2) LOOP
						l_tier2_calculated:='Y';
						l_msg:='Tier 2 Already Calculated. Rebate Line ID  = '||vc4.chm_device_rebate_id;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																
					END LOOP;

					-- Check if Tier 1 calc is there. If not Do not proceed
					--Else Proceed with Tier 2
					--We dont want to calculate Tier 2 if Tier 1 not already calculated

					l_tier1_calculated:=is_tier_calculated(g_tier_1,vc3.chm_enlighten_device_id,l_tier1_calc_amount,l_tier1_device_rebate_id);

					
					l_msg:='Tier 1 Calculated  = '||l_tier1_calculated||' l_tier1_device_rebate_id = '||l_tier1_device_rebate_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																					

					l_msg:='Tier 1 Calc Amount  = '||l_tier1_calc_amount;
					l_total_paid_amount:= NVL(l_tier1_calc_amount,0);					
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					IF l_tier2_calculated='N' AND l_tier1_calculated ='Y'
					THEN

						l_tier2_orig_rebate_amount:=vc2.rebate_amount;
						l_tier2_calc_rebate_amount:=vc2.rebate_amount-l_total_paid_amount;

						l_msg:='Tier 2 SPA Amount  = '||l_tier2_orig_rebate_amount||' Tier 2 Calc Rebate Amount = '||l_tier2_calc_rebate_amount;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

						--INSERT INTO REBATES TABLE

						INSERT INTO chm_enlighten_device_rebates
						(
							chm_enlighten_device_id ,
							chm_enlighten_site_id,
							spa_number,
							spa_line_id,
							device_item_number,
							rebate_item_number,
							rebate_type,
							rebate_tier,
							spa_original_amount,
							claim_date,
							rebate_currency, 
							rebate_amount,
							rebate_status, 
							claim_batch_id,
							claim_line_id,
							rebate_payee_type,
							rebate_payee_id,
							rebate_source,
							attribute1
						)
						VALUES (
							vc3.chm_enlighten_device_id,
							vc3.chm_enlighten_site_id,
							vc2.spa_number,
							vc2.chm_spa_line_id,
							vc3.item_number,
							vc3.rebate_item_number,
							'SYSTEM_SIZE',
							g_tier_2,
							l_tier2_orig_rebate_amount,
							vc3.rebate_effective_date,
							vc2.spa_currency,
							l_tier2_calc_rebate_amount,
							'ELIGIBLE_FOR_PAYMENT',
							NULL,
							NULL,
							'INSTALLER',
							vc3.system_size_payee_id,
							'SYSTEM',
							vc2.attribute_1
						);

						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'No of Rebate Records Inserted = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);								
						l_tier2_rebate_inserted:=l_tier2_rebate_inserted+1;

					END IF; 	

					update_batch_process_count(vc3.chm_enlighten_device_id);

				END LOOP; --vc3

				l_msg:='Tier 2 Rebate Records Inserted = '||l_tier2_rebate_inserted;				
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			ELSE --vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier2_eligible:='N';
				l_msg:='Tier 2 Eligible = N';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			END IF; --vc1.device_qty>= vc2.rebate_tier_min_qty THEN

		END LOOP; --vc2			



-----------------------------------------------------------------	
		--Tier 3 Calculations 
-----------------------------------------------------------------		
		l_tier3_eligible:='N';
		l_total_paid_amount:=0;
		--Check Tier 3 Eligibility and Calculate

		FOR vc2 in c_msi_system_size_tier_rebate (vc1.spa_number, vc1.rebate_item_number,g_tier_3) LOOP

			l_msg:='Device Qty = '||vc1.device_qty||' Rebate Tier 3 Min Qty ='||vc2.rebate_tier_min_qty;
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			IF vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier3_eligible:='Y';

				l_msg:='Tier 3 Eligible = Y';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

				--Check if Tier 2 already calculated
				l_tier3_rebate_inserted:=0;

				FOR vc3 IN c_devices(vc1.spa_number, vc1.rebate_item_number, vc1.site_id) LOOP
					l_tier3_calculated:='N';
					l_tier3_rebate_amount:=0;

					l_msg:='Enlighten Device ID = '||vc3.chm_enlighten_device_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										


					FOR vc4 IN c_rebates(vc3.chm_enlighten_device_id,g_tier_3) LOOP
						l_tier3_calculated:='Y';
						l_msg:='Tier 3 Already Calculated. Rebate Line ID  = '||vc4.chm_device_rebate_id;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																
					END LOOP;

					-- Check if Tier 2 calc is there. If not Do not proceed
					--Else Proceed with Tier 3
					--We dont want to calculate Tier 3 if Tier 2 not already calculated

					l_tier1_calculated:=is_tier_calculated(g_tier_1,vc3.chm_enlighten_device_id,l_tier1_calc_amount,l_tier1_device_rebate_id);
					l_tier2_calculated:=is_tier_calculated(g_tier_2,vc3.chm_enlighten_device_id,l_tier2_calc_amount,l_tier2_device_rebate_id);

					l_total_paid_amount:=NVL(l_tier1_calc_amount,0)+NVL(l_tier2_calc_amount,0);

					l_msg:='Tier 2 Calculated  = '||l_tier2_calculated||' l_tier2_device_rebate_id = '||l_tier2_device_rebate_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																					

					l_msg:='Tier 1 Calc Amount  = '||l_tier1_calc_amount||' Tier 2 Calc Amount  = '||l_tier2_calc_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					l_msg:='Total Paid Amount  = '||l_total_paid_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																


					IF l_tier3_calculated='N' AND l_tier2_calculated ='Y'
					THEN

						l_tier3_orig_rebate_amount:=vc2.rebate_amount;
						l_tier3_calc_rebate_amount:=vc2.rebate_amount-l_total_paid_amount;

						l_msg:='Tier 3 SPA Amount  = '||l_tier3_orig_rebate_amount||' Tier 3 Calc Rebate Amount = '||l_tier3_calc_rebate_amount;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

						--INSERT INTO REBATES TABLE

						INSERT INTO chm_enlighten_device_rebates
						(
							chm_enlighten_device_id ,
							chm_enlighten_site_id,
							spa_number,
							spa_line_id,
							device_item_number,
							rebate_item_number,
							rebate_type,
							rebate_tier,
							spa_original_amount,
							claim_date,
							rebate_currency, 
							rebate_amount,
							rebate_status, 
							claim_batch_id,
							claim_line_id,
							rebate_payee_type,
							rebate_payee_id,
							rebate_source,
							attribute1
						)
						VALUES (
							vc3.chm_enlighten_device_id,
							vc3.chm_enlighten_site_id,
							vc2.spa_number,
							vc2.chm_spa_line_id,
							vc3.item_number,
							vc3.rebate_item_number,
							'SYSTEM_SIZE',
							g_tier_3,
							l_tier3_orig_rebate_amount,
							vc3.rebate_effective_date,
							vc2.spa_currency,
							l_tier3_calc_rebate_amount,
							'ELIGIBLE_FOR_PAYMENT',
							NULL,
							NULL,
							'INSTALLER',
							vc3.system_size_payee_id,
							'SYSTEM',
							vc2.attribute_1
						);

						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'No of Rebate Records Inserted = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);								
						l_tier3_rebate_inserted:=l_tier3_rebate_inserted+1;

					END IF; 	

					update_batch_process_count(vc3.chm_enlighten_device_id);

				END LOOP; --vc3

				l_msg:='Tier 3 Rebate Records Inserted = '||l_tier3_rebate_inserted;				
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			ELSE --vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier3_eligible:='N';
				l_msg:='Tier 3 Eligible = N';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			END IF; --vc1.device_qty>= vc2.rebate_tier_min_qty THEN

		END LOOP; --vc2		


-----------------------------------------------------------------	
		--Tier 4 Calculations 
-----------------------------------------------------------------		
		l_tier4_eligible:='N';
		l_total_paid_amount:=0;
		
		--Check Tier 4 Eligibility and Calculate

		FOR vc2 in c_msi_system_size_tier_rebate (vc1.spa_number, vc1.rebate_item_number,g_tier_4) LOOP

			l_msg:='Device Qty = '||vc1.device_qty||' Rebate Tier 4 Min Qty ='||vc2.rebate_tier_min_qty;
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			IF vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier4_eligible:='Y';

				l_msg:='Tier 4 Eligible = Y';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

				--Check if Tier 4 already calculated
				l_tier4_rebate_inserted:=0;

				FOR vc3 IN c_devices(vc1.spa_number, vc1.rebate_item_number, vc1.site_id) LOOP
					l_tier4_calculated:='N';
					l_tier4_rebate_amount:=0;

					l_msg:='Enlighten Device ID = '||vc3.chm_enlighten_device_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										


					FOR vc4 IN c_rebates(vc3.chm_enlighten_device_id,g_tier_4) LOOP
						l_tier4_calculated:='Y';
						l_msg:='Tier 4 Already Calculated. Rebate Line ID  = '||vc4.chm_device_rebate_id;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																
					END LOOP;

					-- Check if Tier 3 calc is there. If not Do not proceed
					--Else Proceed with Tier 4
					--We dont want to calculate Tier 4 if Tier 3 not already calculated

					l_tier3_calculated:=is_tier_calculated(g_tier_3,vc3.chm_enlighten_device_id,l_tier3_calc_amount,l_tier3_device_rebate_id);

					l_msg:='Tier 3 Calculated  = '||l_tier3_calculated||' l_tier3_device_rebate_id = '||l_tier3_device_rebate_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																					

					l_msg:='Tier 3 Calc Amount  = '||l_tier3_calc_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					l_tier1_calculated:=is_tier_calculated(g_tier_1,vc3.chm_enlighten_device_id,l_tier1_calc_amount,l_tier1_device_rebate_id);
					l_tier2_calculated:=is_tier_calculated(g_tier_2,vc3.chm_enlighten_device_id,l_tier2_calc_amount,l_tier2_device_rebate_id);

					l_msg:='Tier 2 Calculated  = '||l_tier2_calculated||' l_tier2_device_rebate_id = '||l_tier2_device_rebate_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																					

					l_msg:='Tier 1 Calc Amount  = '||l_tier1_calc_amount||' Tier 2 Calc Amount  = '||l_tier2_calc_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					l_total_paid_amount:=NVL(l_tier1_calc_amount,0)+NVL(l_tier2_calc_amount,0)+NVL(l_tier3_calc_amount,0);

					l_msg:='Total Paid Amount  = '||l_total_paid_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					IF l_tier4_calculated='N' AND l_tier3_calculated ='Y'
					THEN

						l_tier4_orig_rebate_amount:=vc2.rebate_amount;
						l_tier4_calc_rebate_amount:=vc2.rebate_amount-l_total_paid_amount;

						l_msg:='Tier 4 SPA Amount  = '||l_tier4_orig_rebate_amount||' Tier 4 Calc Rebate Amount = '||l_tier4_calc_rebate_amount;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

						--INSERT INTO REBATES TABLE

						INSERT INTO chm_enlighten_device_rebates
						(
							chm_enlighten_device_id ,
							chm_enlighten_site_id,
							spa_number,
							spa_line_id,
							device_item_number,
							rebate_item_number,
							rebate_type,
							rebate_tier,
							spa_original_amount,
							claim_date,
							rebate_currency, 
							rebate_amount,
							rebate_status, 
							claim_batch_id,
							claim_line_id,
							rebate_payee_type,
							rebate_payee_id,
							rebate_source,
							attribute1
						)
						VALUES (
							vc3.chm_enlighten_device_id,
							vc3.chm_enlighten_site_id,
							vc2.spa_number,
							vc2.chm_spa_line_id,
							vc3.item_number,
							vc3.rebate_item_number,
							'SYSTEM_SIZE',
							g_tier_4,
							l_tier4_orig_rebate_amount,
							vc3.rebate_effective_date,
							vc2.spa_currency,
							l_tier4_calc_rebate_amount,
							'ELIGIBLE_FOR_PAYMENT',
							NULL,
							NULL,
							'INSTALLER',
							vc3.system_size_payee_id,
							'SYSTEM',
							vc2.attribute_1
						);

						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'No of Rebate Records Inserted = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);								
						l_tier4_rebate_inserted:=l_tier4_rebate_inserted+1;

					END IF; 	

					update_batch_process_count(vc3.chm_enlighten_device_id);

				END LOOP; --vc3

				l_msg:='Tier 4 Rebate Records Inserted = '||l_tier4_rebate_inserted;				
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			ELSE --vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier4_eligible:='N';
				l_msg:='Tier 4 Eligible = N';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			END IF; --vc1.device_qty>= vc2.rebate_tier_min_qty THEN

		END LOOP; --vc2		


-----------------------------------------------------------------	
		--Tier 5 Calculations 
-----------------------------------------------------------------		

		l_tier5_eligible:='N';
		l_total_paid_amount:=0;
		--Check Tier 5 Eligibility and Calculate

		FOR vc2 in c_msi_system_size_tier_rebate (vc1.spa_number, vc1.rebate_item_number,g_tier_5) LOOP

			l_msg:='Device Qty = '||vc1.device_qty||' Rebate Tier 5 Min Qty ='||vc2.rebate_tier_min_qty;
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			IF vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier5_eligible:='Y';

				l_msg:='Tier 5 Eligible = Y';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

				--Check if Tier 5 already calculated
				l_tier5_rebate_inserted:=0;

				FOR vc3 IN c_devices(vc1.spa_number, vc1.rebate_item_number, vc1.site_id) LOOP
					l_tier5_calculated:='N';
					l_tier5_rebate_amount:=0;

					l_msg:='Enlighten Device ID = '||vc3.chm_enlighten_device_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										


					FOR vc4 IN c_rebates(vc3.chm_enlighten_device_id,g_tier_5) LOOP
						l_tier5_calculated:='Y';
						l_msg:='Tier 5 Already Calculated. Rebate Line ID  = '||vc4.chm_device_rebate_id;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																
					END LOOP;

					-- Check if Tier 4 calc is there. If not Do not proceed
					--Else Proceed with Tier 5
					--We dont want to calculate Tier 5 if Tier 4 not already calculated

					l_tier4_calculated:=is_tier_calculated(g_tier_4,vc3.chm_enlighten_device_id,l_tier4_calc_amount,l_tier4_device_rebate_id);

					l_msg:='Tier 4 Calculated  = '||l_tier4_calculated||' l_tier4_device_rebate_id = '||l_tier4_device_rebate_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																					

					l_msg:='Tier 4 Calc Amount  = '||l_tier4_calc_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					l_tier3_calculated:=is_tier_calculated(g_tier_3,vc3.chm_enlighten_device_id,l_tier3_calc_amount,l_tier3_device_rebate_id);

					l_msg:='Tier 3 Calculated  = '||l_tier3_calculated||' l_tier3_device_rebate_id = '||l_tier3_device_rebate_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																					

					l_msg:='Tier 3 Calc Amount  = '||l_tier3_calc_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					l_tier1_calculated:=is_tier_calculated(g_tier_1,vc3.chm_enlighten_device_id,l_tier1_calc_amount,l_tier1_device_rebate_id);
					l_tier2_calculated:=is_tier_calculated(g_tier_2,vc3.chm_enlighten_device_id,l_tier2_calc_amount,l_tier2_device_rebate_id);

					l_msg:='Tier 2 Calculated  = '||l_tier2_calculated||' l_tier2_device_rebate_id = '||l_tier2_device_rebate_id;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																					

					l_msg:='Tier 1 Calc Amount  = '||l_tier1_calc_amount||' Tier 2 Calc Amount  = '||l_tier2_calc_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

					l_total_paid_amount:=NVL(l_tier1_calc_amount,0)+NVL(l_tier2_calc_amount,0)+NVL(l_tier3_calc_amount,0)+NVL(l_tier4_calc_amount,0);

					l_msg:='Total Paid Amount  = '||l_total_paid_amount;
					CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																



					IF l_tier5_calculated='N' AND l_tier4_calculated ='Y'
					THEN

						l_tier5_orig_rebate_amount:=vc2.rebate_amount;
						l_tier5_calc_rebate_amount:=vc2.rebate_amount-l_total_paid_amount;

						l_msg:='Tier 5 SPA Amount  = '||l_tier5_orig_rebate_amount||' Tier 5 Calc Rebate Amount = '||l_tier5_calc_rebate_amount;
						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     																

						--INSERT INTO REBATES TABLE

						INSERT INTO chm_enlighten_device_rebates
						(
							chm_enlighten_device_id ,
							chm_enlighten_site_id,
							spa_number,
							spa_line_id,
							device_item_number,
							rebate_item_number,
							rebate_type,
							rebate_tier,
							spa_original_amount,
							claim_date,
							rebate_currency, 
							rebate_amount,
							rebate_status, 
							claim_batch_id,
							claim_line_id,
							rebate_payee_type,
							rebate_payee_id,
							rebate_source,
							attribute1
						)
						VALUES (
							vc3.chm_enlighten_device_id,
							vc3.chm_enlighten_site_id,
							vc2.spa_number,
							vc2.chm_spa_line_id,
							vc3.item_number,
							vc3.rebate_item_number,
							'SYSTEM_SIZE',
							g_tier_5,
							l_tier5_orig_rebate_amount,
							vc3.rebate_effective_date,
							vc2.spa_currency,
							l_tier5_calc_rebate_amount,
							'ELIGIBLE_FOR_PAYMENT',
							NULL,
							NULL,
							'INSTALLER',
							vc3.system_size_payee_id,
							'SYSTEM',
							vc2.attribute_1
						);

						CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'No of Rebate Records Inserted = '||SQL%ROWCOUNT, p_source_app_id => g_source_app_id);								
						l_tier5_rebate_inserted:=l_tier5_rebate_inserted+1;

					END IF; 	

					update_batch_process_count(vc3.chm_enlighten_device_id);

				END LOOP; --vc3

				l_msg:='Tier 5 Rebate Records Inserted = '||l_tier5_rebate_inserted;				
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			ELSE --vc1.device_qty>= vc2.rebate_tier_min_qty THEN
				l_tier5_eligible:='N';
				l_msg:='Tier 5 Eligible = N';
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

			END IF; --vc1.device_qty>= vc2.rebate_tier_min_qty THEN

		END LOOP; --vc2	

	l_msg:='Completed Calculations for Batch ID = '||p_batch_id;
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => l_msg, p_source_app_id => g_source_app_id);     										

	END LOOP;	
	
	--refresh rebates MV
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'Refresh Rebates MV', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_msg => 'Refresh Rebates MV', p_report_type => g_report_type);
	
	BEGIN
		CHM_MV_REFRESH_UTIL.REFRESH_MVIEW('CHM_MSI_DATA_MVIEWS');
	EXCEPTION
		WHEN OTHERS THEN 
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'Error during Refresh Rebates MV '||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_msg => 'Error during Refresh Rebates MV '||SQLERRM, p_report_type => g_report_type);
	END;

EXCEPTION 
	WHEN OTHERS THEN
		chm_msi_debug_api.log_exp(p_transaction_id => g_report_request_id, p_module => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_SYSTEM_SIZE_TIER_REBATE', p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => g_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_SYSTEM_SIZE_TIER_REBATE', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);

		SELECT 	COUNT(1)
		INTO 	v_in_process_run_count_excep
		FROM	chm_automation_runs
		WHERE   run_code = g_file_type AND status = 'IN_PROCESS' 
		AND 	end_date IS NULL 
		AND 	run_id = v_run_id;


		IF v_in_process_run_count_excep > 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_msg => 'ERROR OCCURRED. Closing Automation Run', p_report_type => g_report_type);
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed,g_report_type);
		END IF;

		SELECT 	COUNT(1)
		INTO 	v_in_process_run_count_excep
		FROM	chm_msi_report_requests
		WHERE   report_request_id=g_report_request_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_SYSTEM_SIZE_TIER_REBATE', p_msg => 'ERROR OCCURRED. Updating Request Status to Failed', p_report_type => g_report_type);
			update_request_status(g_report_request_id, g_status_failed);
		END IF;

		COMMIT;			
END derive_system_size_tier_rebate;


-- This Procedure will be called internally by the launch_msi_request for TYPE DERIVE_ACTIVATION_ATTRIBUTES
-- This will process all RECORDS for particular BATCH ID 
-- It will INSERT data into Additional Attributes Table if not already present
-- Derive Attributes - Product Type, Product Family, 
-- 						disti_oracle_account_id ,disti_oracle_account_number, order_type
-- 						MSI Eligible Yes or No 

PROCEDURE derive_activation_attributes(p_request_id IN NUMBER) AS

    l_batch_id 		VARCHAR2(4000);
	l_batch_type 	VARCHAR2(4000);
	l_report_type	VARCHAR2(4000):='DERIVE_ACTIVATION_ATTRIBUTES';
	l_module		VARCHAR2(4000):='CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES';
	l_report_request_id	NUMBER:=p_request_id;
	l_record_count	NUMBER;
	v_in_process_run_count_excep	NUMBER;
	v_run_id		NUMBER:=g_run_id;

	TYPE item_rt IS RECORD(
	item_number		VARCHAR2(4000),
	product_type	VARCHAR2(4000),
	product_family	VARCHAR2(4000));

	TYPE item_info_t IS TABLE OF item_rt;

	TYPE shipment_rt IS RECORD
	(item_number	VARCHAR2(4000),
	serial_number	VARCHAR2(4000), 
	disti_oracle_account_id NUMBER,
	disti_oracle_account_number VARCHAR2(4000), 
	order_type		VARCHAR2(4000));

	TYPE shipment_info_t IS TABLE OF shipment_rt;

	TYPE rebate_rt IS RECORD(
	chm_enlighten_device_id	NUMBER
	);

	TYPE rebate_info_t IS TABLE OF rebate_rt;	


	TYPE site_eligible_rt IS RECORD(
	chm_enlighten_device_id	NUMBER,
	reason_code				VARCHAR2(4000)
	);

	TYPE site_eligible_t IS TABLE OF site_eligible_rt;	

	TYPE order_eligible_rt IS RECORD(
	chm_enlighten_device_id	NUMBER,
	reason_code				VARCHAR2(4000)
	);

	TYPE order_eligible_t IS TABLE OF order_eligible_rt;	

	TYPE date_eligible_rt IS RECORD(
	chm_enlighten_device_id	NUMBER,
	reason_code				VARCHAR2(4000)
	);

	TYPE date_eligible_t IS TABLE OF date_eligible_rt;	


	l_items_tbl   			item_info_t;
	l_shipments_tbl			shipment_info_t;
	l_rebate_eligible_tbl	rebate_info_t;
	l_site_eligible_tbl		site_eligible_t;
	l_order_eligible_tbl	order_eligible_t;
	l_date_eligible_tbl		date_eligible_t;

l_file_reference_name VARCHAR2(4000);
l_to_email VARCHAR2(4000);

BEGIN

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process. Request ID  = '||p_request_id,p_report_type => l_report_type);
    CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'START Processing Request ID = ' || p_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Update Request Status to In Process', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'Update Request Status to In Process', p_report_type => g_report_type);
	
	update_request_status(g_report_request_id, g_status_in_process);

    COMMIT;


	SELECT
			jt.file_reference_name || '_Request_ID_' || l_report_request_id || '_' || g_user_id, 
			jt.to_email,jt.batch_id,jt.batch_type
	INTO
			l_file_reference_name, 
			l_to_email, l_batch_id,
			l_batch_type --Raj 3/12/2025
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
			batch_type VARCHAR2 ( 4000 ) PATH '$.BATCH_TYPE', 
			batch_id VARCHAR2 ( 4000 ) PATH '$.BATCH_ID' 
		  )
		)
	  jt;	

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id ||' Batch Type = '||l_batch_type ,p_report_type => l_report_type);
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id||' Batch Type = '||l_batch_type, p_source_app_id => g_source_app_id);     

	IF l_batch_type=g_rebate_eligibility THEN --
		--First Insert a Record in the Attribute Table if no record exists
		l_record_count:=0;

		/*
		INSERT INTO chm_enlighten_device_attributes
		(chm_enlighten_device_id ,
		--chm_enlighten_site_id ,
		site_id,
		device_quantity,
		item_number,
		serial_num,
		attribute2
		)
		--product_family,
		--product_type
		SELECT 	cedd.chm_enlighten_device_id,
			--	cedd.chm_enlighten_site_id,
		  cedd.site_id,
				1,
				cedd.sku,
		  cedd.serial_num,
				l_batch_id
		FROM 	chm_enlighten_device_details cedd
				--chm_item_category_mv cic
		WHERE 	cedd.attribute2 =  l_batch_id
		AND 	cedd.chm_enlighten_device_id NOT IN 
				(SELECT chm_enlighten_device_id FROM chm_enlighten_device_attributes);


		l_record_count:=SQL%ROWCOUNT;
		COMMIT;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Device Attribute Records Inserted  = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'l_record_count = ' || l_record_count||' No of Device Attribute Records Inserted  = '||l_record_count, p_source_app_id => g_source_app_id);     
		*/
		
		/*
		UPDATE 	chm_enlighten_device_attributes ceda
		SET 	attribute2=l_batch_id
		WHERE 	chm_enlighten_device_id IN 
				(SELECT chm_enlighten_device_id FROM chm_enlighten_device_details cedd
				WHERE cedd.attribute2=l_batch_id);

		l_record_count:=SQL%ROWCOUNT;
		COMMIT;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Device Attribute Records Updated with Batch ID  = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'l_record_count = ' || l_record_count||' No of Device Attribute Records Updated with Batch ID  = '||l_record_count, p_source_app_id => g_source_app_id);     
		*/

		--Reset Reason Code
		l_record_count:=0;

		UPDATE 	chm_enlighten_device_attributes ceda
		SET 	msi_rebate_eligibile_reason=NULL
		WHERE 	batch_id=l_batch_id;
		/*chm_enlighten_device_id IN 
							(SELECT chm_enlighten_device_id FROM chm_enlighten_device_attributes_v1 ceda
							WHERE 	ceda.batch_id=l_batch_id		
							);
		*/

		l_record_count:=SQL%ROWCOUNT;
		COMMIT;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Records for which Reason Code is Reset   = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'l_record_count = ' || l_record_count||' No of Records for which Reason Code is Reset   = '||l_record_count, p_source_app_id => g_source_app_id);     

		
		
		--NOW Update Attributes
		--Product Type Update
		l_record_count:=0;

		SELECT 	DISTINCT item_number, product_type, product_family
		BULK 	COLLECT INTO l_items_tbl
		FROM 	chm_item_category_mv cic
		WHERE 	item_number IN 
							(SELECT item_number FROM chm_enlighten_device_attributes_v1 ceda
							WHERE 	ceda.batch_id=l_batch_id
							AND 	ceda.product_type IS NULL		
				);

		l_record_count:=l_items_tbl.COUNT;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Item Records Collected to Update Product Type  = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'No of Item Records Collected to Update Product Type  = '||l_record_count, p_source_app_id => g_source_app_id);     	

		FORALL indx IN 1 .. l_items_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	product_type=l_items_tbl(indx).product_type,
					product_family=l_items_tbl(indx).product_family
			WHERE	ceda.item_number = l_items_tbl(indx).item_number
			AND 	ceda.batch_id=l_batch_id
			AND 	ceda.product_type IS NULL;
			
			/*ceda.chm_enlighten_device_id IN 
							(SELECT chm_enlighten_device_id FROM chm_enlighten_device_attributes_v1 ceda
							WHERE 	ceda.batch_id=l_batch_id
							AND 	ceda.product_type IS NULL		
							);
			*/
			
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update Product Type  = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update Product Type  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;



		--S/N Disti and Order Type Updates from Oracle Shipment Detail
		l_record_count:=0;

		SELECT 	DISTINCT enphase_product_name item_number, serial_number, 
						cust_account_id disti_oracle_account_id ,
						cust_account_number disti_oracle_account_number,
						sales_order_type order_type
		BULK 	COLLECT INTO l_shipments_tbl
		FROM 	--chm_oracle_shipment_serial_number_details cship
				chm_msi_ship_details_tbl
		WHERE 	(enphase_product_name, serial_number)  IN 
							(SELECT sku, serial_num 
							FROM 	chm_enlighten_device_attributes_v1 cedav
							WHERE 	cedav.batch_id=l_batch_id
							AND 	(cedav.disti_oracle_account_id IS NULL OR cedav.oracle_order_type IS NULL)		
				);

		l_record_count:=l_shipments_tbl.COUNT;
		
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Shipment Records Collected to Update Order Type and Disti  = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'No of Shipment Records Collected to Update Order Type and Disti  = '||l_record_count, p_source_app_id => g_source_app_id);     	

		FORALL indx IN 1 .. l_shipments_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	disti_oracle_account_id=l_shipments_tbl(indx).disti_oracle_account_id,
					disti_oracle_account_number=l_shipments_tbl(indx).disti_oracle_account_number,
					oracle_order_type=l_shipments_tbl(indx).order_type
			WHERE	ceda.item_number = l_shipments_tbl(indx).item_number
			AND 	ceda.serial_num = l_shipments_tbl(indx).serial_number
			AND 	ceda.batch_id=l_batch_id
			AND     (ceda.disti_oracle_account_id IS NULL OR ceda.oracle_order_type IS NULL);
			
			/*ceda.chm_enlighten_device_id IN 
							(SELECT chm_enlighten_device_id 
							FROM chm_enlighten_device_attributes_v1 cedav
							WHERE 	cedav.batch_id=l_batch_id
							AND 	(cedav.disti_oracle_account_id IS NULL OR cedav.oracle_order_type IS NULL)		
							);
			*/
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update Disti and Order Type  = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update Disti and Order Type  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;	



		--Rebate Effective Date Update 
		l_record_count:=0;

		--Update statement
		UPDATE 	chm_enlighten_device_attributes ceda
		SET		rebate_effective_date= 
					(SELECT TRUNC(NVL(first_interval_end_date,created_date))
						--TO_DATE(SUBSTR(created_date,1,10),'YYYY-MM-DD')
					--TRUNC(NVL(first_interval_end_date,created_date))
					FROM chm_enlighten_device_details cedd 
					where cedd.chm_enlighten_device_id= ceda.chm_enlighten_device_id)	
		WHERE 	ceda.batch_id=l_batch_id
		AND 	ceda.rebate_effective_date IS NULL;
		
		/*ceda.chm_enlighten_device_id IN 
							(SELECT chm_enlighten_device_id 
							FROM chm_enlighten_device_attributes_v1 cedav
							WHERE 	cedav.batch_id=l_batch_id
							AND 	cedav.rebate_effective_date IS NULL	
							);
		*/
		l_record_count:=SQL%ROWCOUNT;
		COMMIT;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Device Attribute Records Updated with Effective Date  = '||l_record_count,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'No of Device Attribute Records Updated with Effective Date  = '||l_record_count, p_source_app_id => g_source_app_id);     

		--MSI_REBATE_ELIGIBLE if Site Stage > =3, 
		--Oracle Disti is derived, 
		--Order Type is Dervied and NOT RMA, 
		--Product Type is derived

		l_record_count:=0;

		SELECT 	DISTINCT chm_enlighten_device_id
		BULK 	COLLECT INTO l_rebate_eligible_tbl
		FROM 	chm_enlighten_site_device_attributes_v1 csdav1
		WHERE 	csdav1.msi_rebate_eligible='N'
		AND 	csdav1.stage>=3
		AND 	csdav1.disti_oracle_account_id IS NOT NULL 
		AND 	csdav1.rebate_effective_date IS NOT NULL
		AND 	csdav1.oracle_order_type IN (SELECT lookup_code 
							  FROM chm_lookup_values_v1 clv
							  WHERE lookup_type='CHM_MSI_REVENUE_ORDER_TYPE'
							  AND 	enabled_flag='Y'
							  AND   SYSDATE BETWEEN NVL(start_date_active,SYSDATE-1) 
							  AND   NVL(end_date_active, SYSDATE+1)
							)
		/*AND 	csdav1.chm_enlighten_device_id IN 
							(	SELECT chm_enlighten_device_id 
								FROM chm_enlighten_device_attributes_v1 cedav
								WHERE 	cedav.batch_id=l_batch_id
							)*/
		AND 	csdav1.batch_id=l_batch_id
		AND 	csdav1.product_type 	IS NOT NULL
		AND 	csdav1.product_family 	IS NOT NULL
		AND 	csdav1.stage_3_status_date IS NOT NULL;	


		l_record_count:=l_rebate_eligible_tbl.COUNT;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Device Records Collected to Update MSI Eligibility  = '||l_record_count,p_report_type => l_report_type);	
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'No of Device Records Collected to Update MSI Eligibility  = '||l_record_count, p_source_app_id => g_source_app_id);     	

		FORALL indx IN 1 .. l_rebate_eligible_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	msi_rebate_eligible	='Y'
					,msi_rebate_eligibility_derived_date=SYSDATE
					,msi_rebate_eligibile_reason='ELIGIBLE'
			WHERE 	chm_enlighten_device_id=l_rebate_eligible_tbl(indx).chm_enlighten_device_id;

		
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update MSI Eligibility  = '||l_record_count,p_report_type => l_report_type);	
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update MSI Eligibility  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;	

		--Update Site Ineligible Reason Code 

		l_record_count:=0;

		SELECT 	DISTINCT chm_enlighten_device_id, 'INELIGIBLE_SITE_STAGE_VALUE ='||csdav1.stage reason_code
		BULK 	COLLECT INTO l_site_eligible_tbl
		FROM 	chm_enlighten_site_device_attributes_v1 csdav1
		WHERE 	csdav1.msi_rebate_eligible <> 'Y'
		AND 	csdav1.stage<3
		AND 	csdav1.batch_id=l_batch_id;
		/*AND 	csdav1.chm_enlighten_device_id IN 
							(	SELECT chm_enlighten_device_id 
								FROM chm_enlighten_device_attributes_v1 cedav
								WHERE 	cedav.batch_id=l_batch_id
							);
		*/


		l_record_count:=l_site_eligible_tbl.COUNT;
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'No of Site Records Collected to Update MSI Eligibility  = '||l_record_count,p_report_type => l_report_type);	
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'No of Site Records Collected to Update MSI Eligibility  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		

		FORALL indx IN 1 .. l_site_eligible_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	msi_rebate_eligible	='N'
					,msi_rebate_eligibility_derived_date=SYSDATE
					,msi_rebate_eligibile_reason=DECODE(msi_rebate_eligibile_reason,
					NULL, l_site_eligible_tbl(indx).reason_code, 
					msi_rebate_eligibile_reason||';'||l_site_eligible_tbl(indx).reason_code)
			WHERE 	chm_enlighten_device_id=l_site_eligible_tbl(indx).chm_enlighten_device_id;

		
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update MSI Reason Code  = '||l_record_count,p_report_type => l_report_type);	
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update MSI Reason Code  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;	

		--Update Invalid Effective Date Reason Code 

		l_record_count:=0;

		SELECT 	DISTINCT chm_enlighten_device_id, 'INELIGIBLE_REBATE_DATE' reason_code
		BULK 	COLLECT INTO l_date_eligible_tbl
		FROM 	chm_enlighten_site_device_attributes_v1 csdav1
		WHERE 	csdav1.msi_rebate_eligible <> 'Y'
		AND 	csdav1.rebate_effective_date IS NULL
		AND 	csdav1.batch_id=l_batch_id;
		/*AND 	csdav1.chm_enlighten_device_id IN 
							(	SELECT chm_enlighten_device_id 
								FROM chm_enlighten_device_attributes_v1 cedav
								WHERE 	cedav.batch_id=l_batch_id
							);	
		*/

		l_record_count:=l_date_eligible_tbl.COUNT;

		FORALL indx IN 1 .. l_date_eligible_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	msi_rebate_eligible	='N'
					,msi_rebate_eligibility_derived_date=SYSDATE
					,msi_rebate_eligibile_reason=DECODE(msi_rebate_eligibile_reason,
					NULL, l_date_eligible_tbl(indx).reason_code, 
					msi_rebate_eligibile_reason||';'||l_date_eligible_tbl(indx).reason_code)
			WHERE 	chm_enlighten_device_id=l_date_eligible_tbl(indx).chm_enlighten_device_id;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update Rebate Date Reason Code  = '||l_record_count,p_report_type => l_report_type);		
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update Rebate Date Reason Code  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;		

	--Update Invalid Item Number Ineligible Reason Code 

		l_record_count:=0;

		SELECT 	DISTINCT chm_enlighten_device_id, 'INVALID_ITEM' reason_code
		BULK 	COLLECT INTO l_order_eligible_tbl
		FROM 	chm_enlighten_site_device_attributes_v1 csdav1
		WHERE 	csdav1.msi_rebate_eligible <> 'Y'
		AND 	csdav1.product_type IS NULL
		AND 	csdav1.batch_id=l_batch_id;

		l_record_count:=l_order_eligible_tbl.COUNT;

		FORALL indx IN 1 .. l_order_eligible_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	msi_rebate_eligible	='N'
					,msi_rebate_eligibility_derived_date=SYSDATE
					,msi_rebate_eligibile_reason=DECODE(msi_rebate_eligibile_reason,
					NULL, l_order_eligible_tbl(indx).reason_code, 
					msi_rebate_eligibile_reason||';'||l_order_eligible_tbl(indx).reason_code)
			WHERE 	chm_enlighten_device_id=l_order_eligible_tbl(indx).chm_enlighten_device_id;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update MSI Reason Code  = '||l_record_count,p_report_type => l_report_type);		
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update MSI Reason Code  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;	


	--Update Serial Number Ineligible Reason Code 

		l_record_count:=0;

		SELECT 	DISTINCT chm_enlighten_device_id, 'INVALID_SERIAL_NUMBER' reason_code
		BULK 	COLLECT INTO l_order_eligible_tbl
		FROM 	chm_enlighten_site_device_attributes_v1 csdav1
		WHERE 	csdav1.msi_rebate_eligible <> 'Y'
		AND 	csdav1.oracle_order_type IS NULL
		AND 	csdav1.batch_id=l_batch_id;

		l_record_count:=l_order_eligible_tbl.COUNT;

		FORALL indx IN 1 .. l_order_eligible_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	msi_rebate_eligible	='N'
					,msi_rebate_eligibility_derived_date=SYSDATE
					,msi_rebate_eligibile_reason=DECODE(msi_rebate_eligibile_reason,
					NULL, l_order_eligible_tbl(indx).reason_code, 
					msi_rebate_eligibile_reason||';'||l_order_eligible_tbl(indx).reason_code)
			WHERE 	chm_enlighten_device_id=l_order_eligible_tbl(indx).chm_enlighten_device_id;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update MSI Reason Code  = '||l_record_count,p_report_type => l_report_type);		
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update MSI Reason Code  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;	

		--Update Order Type Ineligible Reason Code 

		l_record_count:=0;

		SELECT 	DISTINCT chm_enlighten_device_id, 'INELIGIBLE_ORDER_TYPE' reason_code
		BULK 	COLLECT INTO l_order_eligible_tbl
		FROM 	chm_enlighten_site_device_attributes_v1 csdav1
		WHERE 	csdav1.msi_rebate_eligible <> 'Y'
		AND 	NVL(csdav1.oracle_order_type,'$ORDER_TYPE$') NOT IN (SELECT lookup_code 
							  FROM chm_lookup_values_v1 clv
							  WHERE lookup_type='CHM_MSI_REVENUE_ORDER_TYPE'
							  AND 	enabled_flag='Y'
							  AND   SYSDATE BETWEEN NVL(start_date_active,SYSDATE-1) 
							  AND   NVL(end_date_active, SYSDATE+1))
		AND 	csdav1.batch_id=l_batch_id;

		l_record_count:=l_order_eligible_tbl.COUNT;

		FORALL indx IN 1 .. l_order_eligible_tbl.COUNT
			UPDATE 	chm_enlighten_device_attributes ceda
			SET 	msi_rebate_eligible	='N'
					,msi_rebate_eligibility_derived_date=SYSDATE
					,msi_rebate_eligibile_reason=DECODE(msi_rebate_eligibile_reason,
					NULL, l_order_eligible_tbl(indx).reason_code, 
					msi_rebate_eligibile_reason||';'||l_order_eligible_tbl(indx).reason_code)
			WHERE 	chm_enlighten_device_id=l_order_eligible_tbl(indx).chm_enlighten_device_id;

		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Completed Update MSI Reason Code  = '||l_record_count,p_report_type => l_report_type);		
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Completed Update MSI Reason Code  = '||l_record_count, p_source_app_id => g_source_app_id);     	
		COMMIT;	
	END IF; --l_batch_type=g_rebate_eligibility

	--For all Eligible Records Derive SPA

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Calling Derive Unit Activation Rebate',p_report_type => l_report_type);			
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Calling Derive Unit Activation Rebate', p_source_app_id => g_source_app_id);     	
	derive_unit_activation_rebate(l_batch_id);

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Calling System Attachment Rebate',p_report_type => l_report_type);			
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Calling System Attachment Rebate', p_source_app_id => g_source_app_id);     	
	derive_system_attachment_rebate(l_batch_id);

	CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'Calling System Size Rebate',p_report_type => l_report_type);			
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Calling System Size Rebate', p_source_app_id => g_source_app_id);     	
	derive_system_size_rebate(l_batch_id);

	--CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Calling System Size Tier Rebate', p_source_app_id => g_source_app_id);     	
	--derive_system_size_tier_rebate(l_batch_id);	

	--Release the batch so the record can be picked up again
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Release Batch Records for Batch Id '||l_batch_id, p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'Release Batch Records for Batch Id '||l_batch_id, p_report_type => g_report_type);
	
	release_batch_records(l_batch_id);

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Update Request Status to Generated', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'Update Request Status to Generated', p_report_type => g_report_type);
	
	update_request_status(g_report_request_id, g_status_generated);

    COMMIT;
	
	--refresh rebates MV
	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Refresh Rebates MV', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'Refresh Rebates MV', p_report_type => g_report_type);
	
	BEGIN
		CHM_MV_REFRESH_UTIL.REFRESH_MVIEW('CHM_MSI_DATA_MVIEWS');
	EXCEPTION
		WHEN OTHERS THEN 
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'Error during Refresh Rebates MV '||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'Error during Refresh Rebates MV '||SQLERRM, p_report_type => g_report_type);
	END;

	CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'End DERIVE_ACTIVATION_ATTRIBUTES procedure', p_source_app_id => g_source_app_id);
	chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'End DERIVE_ACTIVATION_ATTRIBUTES procedure', p_report_type => g_report_type);

EXCEPTION
    WHEN OTHERS THEN

		--Release the batch so the record can be picked up again
		release_batch_records(l_batch_id);	

		chm_msi_debug_api.log_exp(p_transaction_id => g_report_request_id, p_module => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => g_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.DERIVE_ACTIVATION_ATTRIBUTES', p_log_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'ERROR OCCURRED. Refer Error Message.'||SQLCODE||'-'||SQLERRM, p_report_type => g_report_type);

		SELECT 	COUNT(1)
		INTO 	v_in_process_run_count_excep
		FROM	chm_automation_runs
		WHERE   run_code = g_file_type AND status = 'IN_PROCESS' AND end_date IS NULL 
		AND 	run_id = v_run_id;


		IF v_in_process_run_count_excep > 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'ERROR OCCURRED. Closing Automation Run', p_report_type => g_report_type);
			chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_failed,g_report_type);
		END IF;

		SELECT 	COUNT(1)
		INTO 	v_in_process_run_count_excep
		FROM	chm_msi_report_requests
		WHERE   report_request_id=g_report_request_id;

		IF v_in_process_run_count_excep > 0 THEN
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'DERIVE_ACTIVATION_ATTRIBUTES', p_msg => 'ERROR OCCURRED. Updating Request Status to Failed', p_report_type => g_report_type);
			update_request_status(g_report_request_id, g_status_failed);
		END IF;

		COMMIT;	
END derive_activation_attributes;


END CHM_MSI_SCHEDULE_REQUEST_PKG;

/
