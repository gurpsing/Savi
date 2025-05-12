--------------------------------------------------------
--  DDL for Package Body CHM_MSI_CLAIM_REBATES_REPORT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHM_MSI_CLAIM_REBATES_REPORT_PKG" AS
/*************************************************************************************************************************************************************************
    * Type                      : PL/SQL Package                                                                                                                        
    * Package Name        		: CHM_MSI_CLAIM_REBATES_REPORT_PKG                                                                                                                         
    * Purpose                   : Package for Claim Rebates Preview                                                                                                
    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            	: 10-FEB-2025  
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------

    *************************************************************************************************************************************************************************/

  g_sku_mapping_type 					VARCHAR2(50) := 'SKU';
  g_spa_mapping_type 					VARCHAR2(50) := 'SPA';
  g_approved_status 					VARCHAR2(50) := 'APPROVED';
  g_installer_account_record_type 		VARCHAR2(50) := 'INSTALLER';
  g_file_type 							VARCHAR2(50) := 'MSI_REBATE';
  g_msg_log 							VARCHAR2(50) := 'MESSAGE';
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
  g_run_id 								NUMBER;
  g_report_request_id 					NUMBER;
  g_source_app_id 						NUMBER:=chm_util_pkg.getsourceapp('CHM');
  g_user_id								VARCHAR2(4000):=CHM_UTIL_PKG.GETUSERNAME();
  g_enterprISe_id						NUMBER:=CHM_CONST_PKG.GETENTERPRISEID();
  g_ip_address							VARCHAR2(4000):=CHM_UTIL_PKG.GETIPADDRESS();
  g_user_agent							VARCHAR2(4000):=CHM_UTIL_PKG.GETIPADDRESS();
  l_row_count_sql 						NUMBER;
  g_status_completed          				VARCHAR2(50) := 'COMPLETED';
  g_activation_batch_size						NUMBER:=TO_NUMBER(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_ATTRIBUTE_BATCH_SIZE'));
  g_system_size_batch_size						NUMBER:=TO_NUMBER(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_SYSTEM_SIZE_BATCH_SIZE'));  
  g_activation_report_email						VARCHAR2(4000):= CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_ATTRIBUTE_EMAIL');
  g_device_attribute_derivation_cutoff_date 	DATE:= NVL(TO_DATE(CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_DEVICE_ATTRIBUTE_CUTOFF_DATE'),'DD-MON-RRRR'),TO_DATE('01-JAN-2025','DD-MON-RRRR'));
  g_system_attachment_prereq_product_type		VARCHAR2(4000):= CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_SYSTEM_ATTACHMENT_PRE_REQUISITE_PRODUCT_TYPE');


PROCEDURE claims_rebate_report (
    p_report_request_id IN NUMBER,
	p_run_id IN NUMBER
) AS

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
	l_context 							apex_exec.t_context;
	l_export 							apex_data_export.t_export;
	l_apex_mail_id					NUMBER;

BEGIN
    l_msg := 'START CLAIMS_REBATE_REPORT';
	g_report_request_id:=p_report_request_id;
	g_run_id:=p_run_id;

    CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
    ,p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg,p_source_app_id => g_source_app_id);

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
            to_timestamp_tz(jt.to_date, chm_const_pkg.getdateformattzr)
        INTO
            l_file_reference_name,
            l_batch_reference_name,
            l_installer_id,
            l_country,
            l_rebate_type,
            l_to_email,
            l_report_format,
            l_from_date,
            l_to_date
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
                        to_date VARCHAR2 ( 4000 ) PATH '$.TO_DATE'
						)
                )
            jt;

    EXCEPTION
       WHEN no_data_found THEN
			l_msg:='Submitted Request ID '||g_report_request_id||' not found';
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CLAIMS_REBATE_REPORT', 
							p_msg =>'NO DATA FOUND FOR THE REQUEST ID' , p_report_type=> g_report_type);

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
			, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg, p_source_app_id => g_source_app_id);


        WHEN OTHERS THEN 
			l_msg:='Error while Processing Request ID '||g_report_request_id;
			chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id, p_module =>  'CLAIMS_REBATE_REPORT', 
							p_msg =>SQLERRM , p_report_type=> g_report_type);

			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
			, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg, p_source_app_id => g_source_app_id);

    END;

l_msg:='l_file_reference_name = '||l_file_reference_name||'l_batch_reference_name = '||l_batch_reference_name||' l_installer_id = '||l_installer_id||' l_country = '||l_country||' l_rebate_type = '||l_rebate_type||' l_to_email = '||l_to_email||' l_report_format = '||l_report_format||' l_from_date = '||l_from_date||' l_to_date = '||l_to_date;	
	chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
	, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg, p_source_app_id => g_source_app_id);


      -- If there is no such Request ID then we will exit the procedure
      --Added by Raj
    IF l_from_date IS NULL THEN 

		l_msg:='Request ID '||g_report_request_id||' Not Found. Exiting the Process';

		chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
		, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg, p_source_app_id => g_source_app_id);

		chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_failed);

		chm_msi_debug_api.log_msg(p_transaction_id => p_report_request_id , p_module =>  'CLAIMS_REBATE_REPORT', 
							p_msg =>'FROM DATE IS NULL FOR THE REQUEST ID. EXITING.' , p_report_type=> g_report_type);
        RETURN;
    END IF;


   --Added by Raj
    --We will update the request status as IN_PROCESS so its reflected on UI that its being processed
    BEGIN
        chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_in_process);
    EXCEPTION
        WHEN OTHERS THEN
            UPDATE chm_msi_report_requests
            SET    status = g_status_failed
            WHERE  report_request_id = l_report_request_id;

            chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_REBATES_REPORT_PKG.CLAIMS_REBATE_REPORT', 'chm_msi_schedule_request_pkg.update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);
			l_msg:='Error Updating Request Status to In Progress. Exiting';
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
			, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg, p_source_app_id => g_source_app_id);
			COMMIT;
            RETURN;
    END;

	l_msg:='START Inserting Records';

	chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
	, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg, p_source_app_id => g_source_app_id);


	INSERT INTO chm_msi_claim_rebates_report (
				report_request_id,
				chm_device_rebate_id,
				chm_enlighten_site_id,
				chm_enlighten_device_id,
				spa_number,
				spa_line_id,
				serial_number,
				hw_part_num,
				device_created_date,
				device_first_interval_end_date,
				product_type,
				product_family,
				device_item_number,
				rebate_item_number,
				rebate_type,
				rebate_tier,
				spa_original_amount,
				claim_date,
				rebate_currency,
				rebate_amount,
				rebate_source,
				rebate_status,
				claim_batch_id,
				claim_line_id,
				rebate_payee_type,
				rebate_payee_id,
				rebate_payee_name,
				rebate_payee_customer_key,
				rebate_payee_country,
				rebate_payee_geography,
				rebate_payee_account_owner,
				rebate_payee_enlighten_installer_id,
				disti_oracle_account_number,
				disti_sfdc_key,
				disti_oracle_name,
				oracle_order_type,
				enlighten_site_id,
				enlighten_site_name,
				enlighten_site_type,
				owner_id,
				installer_id,
				maintainer_id,
				site_first_interval_end_date,
				pcu_channel_count,
				envoy_count,
				acb_count,
				nsr_count,
				encharge_count,
				enpower_count,
				pcu_types,
				status_code,
				ac_voltage,
				site_created_date,
				measured_acv,
				is_lease,
				partner_id,
				system_host_id,
				enlighten_site_url,
				site_current_stage,
				stage_3_status_date,
				system_start_date,
				zero_touch,
				allow_api_access,
				location_access,
				rate_schedule,
				description,
				operational,
				interconnect_date,
				internet_connection_type,
				pcu_attachment_type,
				connection_type,
				sfdc_drip_campaign_flag,
				iqevc_count,
				consumption_ct,
				hems,
				address_id,
				address_1,
				address_2,
				address_city,
				address_state,
				address_zip,
				address_country,
				oracle_ap_invoice_number,
				oracle_ap_invoice_id
				)
		SELECT 
			l_report_request_id,
			chm_device_rebate_id,
			chm_enlighten_site_id,
			chm_enlighten_device_id,
			spa_number,
			spa_line_id,
			serial_number,
			hw_part_num,
			device_created_date,
			device_first_interval_end_date,
			product_type,
			product_family,
			device_item_number,
			rebate_item_number,
			rebate_type,
			rebate_tier,
			spa_original_amount,
			claim_date,
			rebate_currency,
			rebate_amount,
			rebate_source,
			rebate_status,
			claim_batch_id,
			claim_line_id,
			rebate_payee_type,
			rebate_payee_id,
			rebate_payee_name,
			rebate_payee_customer_key,
			rebate_payee_country,
			rebate_payee_geography,
			rebate_payee_account_owner,
			rebate_payee_enlighten_installer_id,
			disti_oracle_account_number,
			disti_sfdc_key,
			disti_oracle_name,
			oracle_order_type,
			enlighten_site_id,
			enlighten_site_name,
			enlighten_site_type,
			owner_id,
			installer_id,
			maintainer_id,
			site_first_interval_end_date,
			pcu_channel_count,
			envoy_count,
			acb_count,
			nsr_count,
			encharge_count,
			enpower_count,
			pcu_types,
			status_code,
			ac_voltage,
			site_created_date,
			measured_acv,
			is_lease,
			partner_id,
			system_host_id,
			enlighten_site_url,
			site_current_stage,
			stage_3_status_date,
			system_start_date,
			zero_touch,
			allow_api_access,
			location_access,
			rate_schedule,
			description,
			operational,
			interconnect_date,
			internet_connection_type,
			pcu_attachment_type,
			connection_type,
			sfdc_drip_campaign_flag,
			iqevc_count,
			consumption_ct,
			hems,
			address_id,
			address_1,
			address_2,
			address_city,
			address_state,
			address_zip,
			address_country,
			oracle_ap_invoice_number,
			oracle_ap_invoice_id
		FROM 	chm_msi_device_rebates_v1 cmdr
		WHERE 	1=1
		AND cmdr.claim_date BETWEEN TRUNC(l_from_date) AND TRUNC(l_to_date)
		--AND cmdr.address_country = nvl(l_country, cmdr.address_country)
		AND cmdr.rebate_type = nvl(l_rebate_type, cmdr.rebate_type)
		AND (l_country IS NULL 
			OR instr(':'
                       || l_country
                       || ':',
                       ':'
                       || cmdr.address_country
                       || ':') > 0 )
		AND ( l_installer_id IS NULL
			  OR instr(':'
					   || l_installer_id
					   || ':',
					   ':'
					   || to_char(cmdr.rebate_payee_id)
					   || ':') > 0 );

	l_rows_inserted:=SQL%ROWCOUNT;
	chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
	, p_log_code => 'CREATE_CLAIM_BATCH', p_log_msg => 'No of Batch Lines Inserted = ' || l_rows_inserted, p_source_app_id => g_source_app_id);

	UPDATE 	chm_msi_report_requests
	SET    	attribute1 = l_rows_inserted,
			last_updated_date=SYSDATE
	WHERE  	report_request_id = p_report_request_id;

	COMMIT;

    BEGIN
        chm_msi_schedule_request_pkg.update_request_status(l_report_request_id, g_status_generated);
    EXCEPTION
        WHEN OTHERS THEN
            UPDATE chm_msi_report_requests
            SET    status = g_status_failed
            WHERE  report_request_id = l_report_request_id;

            chm_msi_debug_api.log_msg(g_run_id, 'CHM_MSI_CLAIM_REBATES_REPORT_PKG.CLAIMS_REBATE_REPORT', 'chm_msi_schedule_request_pkg.update_request_status to ERROR '|| 'No of Rows Updated = '|| SQL%rowcount, g_report_type);
			l_msg:='Error Updating Request Status to In Progress. Exiting';
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
			, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => l_msg, p_source_app_id => g_source_app_id);

			COMMIT;
            RETURN;
    END;

 -----------------------------------------------------------------------


	SELECT  COUNT(1)
	INTO 	l_request_cnt
	FROM	chm_msi_report_requests
	WHERE   report_request_id = g_report_request_id 
	AND 	status = g_status_generated;

	IF l_request_cnt > 0 THEN
		BEGIN

		-- Send mail to the user with attachement

			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => 'Begin Notification Process', p_source_app_id => g_source_app_id);

			chm_msi_debug_api.log_msg(p_transaction_id => l_report_request_id, p_module => 'CLAIMS_REBATE_REPORT', p_msg => 'Begin Notification Process', p_report_type => g_report_type);

			l_context := apex_exec.open_query_context(p_location => apex_exec.c_location_local_db, 
			p_sql_query => 'SELECT * FROM CHM_MSI_CLAIM_REBATES_REPORT_V1 WHERE report_request_id = ' || g_report_request_id);

			IF l_report_format = g_csv_format THEN
			  l_export := apex_data_export.export(p_context => l_context, p_format => apex_data_export.c_format_csv);
			ELSIF l_report_format = g_xlsx_format THEN
			  l_export := apex_data_export.export(p_context => l_context, p_format => apex_data_export.c_format_xlsx);
			END IF;

			apex_exec.close(l_context);
			l_apex_mail_id := apex_mail.send(p_FROM => g_FROM_mail, p_to => l_to_email, p_template_static_id => 'CHM_MSI_PREVIEW_REPORT_GENERATION_NOTIFICATION', p_application_id => g_application_id, p_placeholders => '{' || '    "REQUEST_ID":' || apex_json.stringify(g_report_request_id) || '}');
			apex_mail.add_attachment(p_mail_id => l_apex_mail_id, p_attachment => l_export.content_blob, p_filename => l_file_reference_name, p_mime_type => l_export.mime_type);
			apex_mail.push_queue;
			chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'CLAIMS_REBATE_REPORT', p_log_msg => 'End Notification Process', p_source_app_id => g_source_app_id);
			chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'CLAIMS_REBATE_REPORT', p_msg => 'End Notification Process, ' || l_file_reference_name, p_report_type => g_report_type);

		EXCEPTION
			WHEN OTHERS THEN
			  apex_exec.close(l_context);
			  chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'CLAIMS_REBATE_REPORT', p_msg => 'ERROR Sending Email Notification ' || l_file_reference_name, p_report_type => g_report_type);
			  chm_msi_debug_api.log_exp(p_transaction_id => g_report_request_id, p_module => 'CLAIMS_REBATE_REPORT - Email Notification', p_sqlcode => sqlcode, p_sqlerrm => dbms_utility.format_error_stack || ', ' || dbms_utility.format_error_backtrace, p_report_type => g_report_type);

		END;
	END IF;

------------------------------------------------------------------------------------


EXCEPTION
    WHEN OTHERS THEN
		ROLLBACK;

		l_msg := SQLERRM;
        chm_msi_schedule_request_pkg.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_report_request_id, p_log_type => g_msg_log
        , p_log_code => 'CLAIM_BATCH_CREATION', p_log_msg => 'Error Occured '|| l_msg,p_source_app_id => g_source_app_id);

		UPDATE chm_msi_report_requests
        SET    status = g_status_failed
        WHERE  report_request_id = l_report_request_id;

		COMMIT;
END CLAIMS_REBATE_REPORT;

END CHM_MSI_CLAIM_REBATES_REPORT_PKG;

/
