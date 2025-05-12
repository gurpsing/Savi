--------------------------------------------------------
--  DDL for Package CHM_MSI_SCHEDULE_REQUEST_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHM_MSI_SCHEDULE_REQUEST_PKG" AS
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
		
		g_rebate_eligibility					VARCHAR2(50) := 'REBATE_ELIGIBILITY';
		g_rebate_calculation					VARCHAR2(50) := 'REBATE_CALCULATION';
		g_msi_claim_batch_type				VARCHAR2(4000):= CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEFAULT_CLAIM_BATCH_TYPE');
		g_msi_claim_batch_from_date			VARCHAR2(4000):= CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEFAULT_CLAIM_BATCH_FROM_DATE');
		g_msi_claim_batch_to_date				VARCHAR2(4000):= TO_CHAR(TRUNC(SYSDATE-1),'DD-MON-RRRR')||' America/Los_Angeles';

		PROCEDURE insert_report_logs (
			p_run_id IN NUMBER, 
			p_report_request_id IN NUMBER DEFAULT NULL, 
			p_log_type IN VARCHAR2, 
			p_log_code IN VARCHAR2, 
			p_log_msg IN VARCHAR2, 
			p_source_app_id IN NUMBER
			);

		PROCEDURE insert_msi_auto_ap_invoice_requests (
		 p_to_email IN VARCHAR2 DEFAULT NULL, 
		 p_ref_name IN VARCHAR2 DEFAULT NULL
		 );

		PROCEDURE update_request_status (p_report_request_id IN NUMBER, p_status VARCHAR2);

		PROCEDURE insert_claim_batch_creation_report_requests (
		 p_to_email IN VARCHAR2 DEFAULT NULL, 
		 p_ref_name IN VARCHAR2 DEFAULT NULL,
		 p_batch_type IN VARCHAR2 DEFAULT g_msi_claim_batch_type, --Raj 3/12/25
		 p_from_date IN VARCHAR DEFAULT g_msi_claim_batch_from_date,
		 p_to_date IN VARCHAR DEFAULT g_msi_claim_batch_to_date
		 );

		PROCEDURE insert_activation_report_requests (
			 p_to_email IN VARCHAR2 DEFAULT NULL, 
			 p_ref_name IN VARCHAR2 DEFAULT NULL,
			 p_batch_type IN VARCHAR2 DEFAULT g_rebate_eligibility
			 );
			 
		PROCEDURE insert_msi_auto_approval_requests (
			 p_to_email IN VARCHAR2 DEFAULT NULL, 
			 p_ref_name IN VARCHAR2 DEFAULT NULL
			 ) ;
			 
		PROCEDURE insert_system_size_calc_report_requests (
		 p_to_email IN VARCHAR2 DEFAULT NULL, 
		 p_ref_name IN VARCHAR2 DEFAULT NULL
		 );		 

		PROCEDURE launch_msi_request 
			(p_file_type IN VARCHAR2,
			p_request_id IN NUMBER DEFAULT NULL
			);

		PROCEDURE derive_activation_attributes(p_request_id IN NUMBER);
		
		FUNCTION get_spa_payee(p_spa_number IN VARCHAR2) RETURN NUMBER;
		
		PROCEDURE derive_unit_activation_rebate(p_batch_id NUMBER);
		
		PROCEDURE derive_system_attachment_rebate(p_batch_id NUMBER);
		
		FUNCTION is_tier_calculated(p_tier IN VARCHAR2,
									p_chm_enlighten_device_id IN NUMBER, 
									p_tier_calc_amount OUT NUMBER,
									p_chm_device_rebate_id OUT NUMBER
		)
		RETURN VARCHAR2;
		
		FUNCTION is_tier_calculated(p_tier IN VARCHAR2,
								p_chm_enlighten_device_id IN NUMBER
		)	RETURN VARCHAR2;
		
		PROCEDURE system_size_tier_rebate(p_request_id IN NUMBER);
		
		PROCEDURE update_batch_process_count(p_chm_enlighten_device_id IN NUMBER);
		
		PROCEDURE derive_system_size_tier_rebate(p_batch_id NUMBER);
		
		PROCEDURE release_batch_records(p_batch_id NUMBER);
		
		PROCEDURE release_system_size_batch_records(p_batch_id NUMBER);
		
		FUNCTION get_request_type(p_request_id IN NUMBER) RETURN VARCHAR2;
		
		FUNCTION get_user_id(p_user_name IN VARCHAR2) RETURN NUMBER;
		
	END CHM_MSI_SCHEDULE_REQUEST_PKG;

/
