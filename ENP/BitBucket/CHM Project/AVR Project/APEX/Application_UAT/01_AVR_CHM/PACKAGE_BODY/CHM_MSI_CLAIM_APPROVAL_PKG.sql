--------------------------------------------------------
--  DDL for Package Body CHM_MSI_CLAIM_APPROVAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHM_MSI_CLAIM_APPROVAL_PKG" AS

/*************************************************************************************************************************************************************************
    * Type                      : PL/SQL Package                                                                                                                        
    * Package Name        		: CHM_MSI_CLAIM_APPROVAL_PKG                                                                                                                         
    * Purpose                   : Package for Claim Rebates Approval                                                                                                
    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            	: 10-FEB-2025  
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------

    *************************************************************************************************************************************************************************/
	g_instance_name			VARCHAR2(2000):= chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'SERVER_NAME' );
    g_approved_status         VARCHAR2(50) := 'APPROVED';
    g_rejected_status         VARCHAR2(50) := 'REJECTED';
    g_valid_status            VARCHAR2(50) := 'VALID';
	g_new_status            VARCHAR2(50) := 'NEW';
    g_pending_approval_status VARCHAR2(50) := 'PENDING_APPROVAL';
    g_source_app_id           NUMBER := chm_util_pkg.getsourceapp('FILE');
	g_msg_log VARCHAR2(50) := 'MESSAGE';
	g_debug_log VARCHAR2(50) := 'DEBUG_MESSAGE';
	g_error_log VARCHAR2(50) := 'ERROR';
	g_warning_log VARCHAR2(50) := 'WARNING';
	g_success_log VARCHAR2(50) := 'SUCCESS';
    g_auto_approve_comments		VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_PROFILE_OPTIONS','CHM_MSI_REBATE_BATCH_AUTO_APPROVAL_COMMENTS');
	g_msi_rebate_auto_approve_email_to	VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_MSI_CLAIM_EMAILS','MSI_REBATE_AUTO_APPROVE_EMAIL_TO');
	g_msi_rebate_auto_approve_email_cc	VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_MSI_CLAIM_EMAILS','MSI_REBATE_AUTO_APPROVE_EMAIL_CC');
	g_msi_rebate_auto_approve_email_bcc	VARCHAR2(4000):=CHM_UTIL_PKG.get_lookup_value('CHM_MSI_CLAIM_EMAILS','MSI_REBATE_AUTO_APPROVE_EMAIL_BCC');
	g_report_type			VARCHAR2(4000);
	g_status_completed          				VARCHAR2(50) := 'COMPLETED';
    g_status_failed 						VARCHAR2(50) := 'FAILED';	
	g_run_id				NUMBER;
	g_report_request_id		NUMBER;
	g_status_in_process 					VARCHAR2(50) := 'IN_PROCESS';
    g_user_id								VARCHAR2(4000):=CHM_UTIL_PKG.GETUSERNAME();
	g_status_generated 					VARCHAR2(50) := 'GENERATED';

	FUNCTION check_requester_is_not_approver(p_user_id IN VARCHAR2, p_claim_type IN VARCHAR2)
	RETURN BOOLEAN
	AS 

	l_count	NUMBER:=0;

	BEGIN 
		SELECT 	COUNT(*)
		INTO	l_count
		FROM (
				SELECT primary_approver approver
				FROM   chm_claim_approval_matrix
				WHERE	transaction_type = p_claim_type
				UNION 
				SELECT backup_approver approver
				FROM   chm_claim_approval_matrix
				WHERE	transaction_type = p_claim_type
			)
        WHERE	UPPER(approver)=UPPER(p_user_id);

		IF l_count=0 THEN 
			RETURN TRUE;
		ELSE 
			RETURN FALSE;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			RETURN FALSE;
	END check_requester_is_not_approver;	

	PROCEDURE submit_auto_approval_request (
		p_request_id		IN NUMBER
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
		l_module		VARCHAR2(4000):='CHM_MSI_CLAIM_APPROVAL_PKG.SUBMIT_AUTO_APPROVAL_REQUEST';
		l_report_request_id	NUMBER:=p_request_id;	
		l_submitter_comments	VARCHAR2(4000):='Auto Approving Batch '||SYSTIMESTAMP;
		l_req_ref VARCHAR2(4000):='Auto Approve Request ID '||p_request_id;

    BEGIN

		g_run_id:=-1;
		g_report_request_id:=p_request_id;
		CHM_MSI_DEBUG_API.log_msg(p_transaction_id=>-1,p_module=> l_module, p_msg=>'START Process. Request ID  = '||p_request_id,p_report_type => l_report_type);
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg => 'START Processing Request ID = ' || p_request_id || ' RUN ID = ' || g_run_id, p_source_app_id => g_source_app_id);

		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => p_request_id, p_log_type => g_msg_log, p_log_code => 'CHM_MSI_SCHEDULE_REQUEST_PKG.SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg => 'Update Request Status to In Process', p_source_app_id => g_source_app_id);
		chm_msi_debug_api.log_msg(p_transaction_id => g_report_request_id, p_module => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_msg => 'Update Request Status to In Process', p_report_type => g_report_type);

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
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg => 'File_reference_name  = '||l_file_reference_name||' To Email = '||l_to_email||' Batch ID = '|| l_batch_id||' Batch Type = '||l_batch_type, p_source_app_id => g_source_app_id);     

		BEGIN 
			SELECT 	batch_status 
			INTO 	l_batch_status
			FROM 	chm_msi_claim_batch
			WHERE 	batch_id=l_batch_id;
		EXCEPTION 
			WHEN OTHERS THEN 
				l_batch_status:=NULL;
				v_msg:='Error Getting Batch Status = '||SQLERRM;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);			
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     

		END;

		v_msg:='Batch ID '||l_batch_id||' Status = '||l_batch_status;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);			
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     

		IF NVL(l_batch_status,'X')=g_pending_approval_status THEN 
			-- Getting file id, claim type from chm_msi_claim_batch table
			SELECT file_id,claim_type
			INTO   v_file_id,v_claim_type
			FROM   chm_msi_claim_batch
			WHERE  batch_id = l_batch_id;

			v_msg:='Get File ID and Claim Type. File ID = '||v_file_id||' Claim Type = '||v_claim_type;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);			
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     


			INSERT INTO chm_msi_claim_request (
				req_ref_no,
				batch_id,
				total_approval_level,
				submitter_comments,
				source_app_id
			) VALUES (
				l_req_ref,
				l_batch_id,
				v_approvers_count,
				l_submitter_comments,
				g_source_app_id
			) RETURN msi_claim_req_id,
					 req_ref_no INTO v_request_id, v_req_ref_no;

			v_msg:='Inserted Claim  Request. Request ID = '||v_request_id||' Reference = '||v_req_ref_no;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     	


			INSERT INTO chm_msi_claim_request_approval (
				msi_claim_req_id,
				approval_level,
				approval_role,
				primary_approver,
				backup_approver,
				source_app_id
			) VALUES (
				v_request_id,
				100,
				'SYSTEM',
				'SYSTEM',
				'SYSTEM',
				g_source_app_id
			);

			v_msg:='Inserted Claim Approval Request';
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     	


			FOR j IN (
				SELECT
					cl.payee_id    installer_id,
					v_claim_type   claim_type,
					claim_date,
					spa_number,
					(select count(*) from chm_msi_claim_batch_lines cmc where cmc.batch_id=l_batch_id) total_batch_lines,
					(select count(*) from chm_msi_claim_batch_lines cmc where cmc.batch_id=l_batch_id
					and cmc.line_status<>g_pending_approval_status) num_lines_not_submitted,
					COUNT(1)       num_lines_submitted,
					ROUND(SUM(NVL(user_extended_claim_amount,extended_claim_amount)),2) total_claim_amt, 
					SUM(CASE WHEN is_overridden = 'Y' THEN 1  ELSE 0 END )  num_lines_overridden,
					SUM(CASE WHEN is_overridden = 'Y' THEN 0  ELSE 1 END )  num_lines_not_overridden,
					SUM(CASE WHEN is_overridden = 'Y' THEN 0  
							 ELSE round((NVL(user_extended_claim_amount,extended_claim_amount)),2) END )  lines_not_overridden_claim_amount,
					SUM(CASE WHEN is_overridden = 'Y' THEN round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
							 ELSE 0 	END )  lines_overridden_claim_amount,
					SUM(CASE WHEN rebate_type='UNIT_ACTIVATION' THEN 
							round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
						 ELSE 0 END) unit_incentive_amount,

					SUM(CASE WHEN rebate_type='SYSTEM_ATTACHMENT' THEN 
							  round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
						 ELSE 0 END) system_attachment_amount,				

					SUM(CASE WHEN rebate_type='SYSTEM_SIZE' THEN 
						 round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
						ELSE 0 END) system_size_amount,				
					currency
				FROM  chm_msi_claim_batch_lines cl
				WHERE  cl.batch_id = l_batch_id
				AND 	cl.line_status = g_pending_approval_status
				GROUP BY cl.payee_id, claim_date, spa_number, currency
			) LOOP
				INSERT INTO chm_msi_claim_request_summary (
					msi_claim_req_id,
					installer_id,
					claim_type,
					claim_date,
					spa_number,
					total_batch_lines,
					total_lines_submitted,
					total_lines_not_submitted,
					total_lines_overridden,
					total_lines_not_overridden,
					total_claim_amount,
					lines_overridden_claim_amount,
					lines_not_overridden_claim_amount,
					source_app_id,
					unit_incentive_amount,
					system_attachment_amount,
					system_size_amount,
					currency 
				) VALUES (
					v_request_id,
					j.installer_id,
					j.claim_type,
					j.claim_date,
					j.spa_number,
					j.total_batch_lines,
					j.num_lines_submitted,
					j.num_lines_not_submitted,
					j.num_lines_overridden,
					j.num_lines_not_overridden,
					j.total_claim_amt,
					j.lines_overridden_claim_amount,
					j.lines_not_overridden_claim_amount,
					g_source_app_id,
					j.unit_incentive_amount,
					j.system_attachment_amount,
					j.system_size_amount,
					j.currency
				);

				v_msg:='Inserted Claim Request Summary Record. Num Lines Submitted = '||j.num_lines_submitted||' Num Lines Overriden = '||j.num_lines_overridden||'Total Claim Amount = '||j.total_claim_amt;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     
			END LOOP;

			UPDATE chm_msi_claim_batch
			SET    batch_status = g_approved_status,
				   attribute15='Y' --auto approved
			WHERE  batch_id = l_batch_id;

			v_msg:='Update Batch Status to '||g_approved_status;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     

			UPDATE chm_msi_claim_batch_lines
			SET    approval_status = g_approved_status,
					line_status=g_approved_status
			WHERE
					batch_id = l_batch_id
				AND line_status = g_pending_approval_status;

			v_msg:='Update Batch Lines Status to '||g_approved_status;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     	

			COMMIT;		

			UPDATE chm_msi_claim_request_approval
			SET
				pr_approval_status = g_approved_status,
				pr_approval_remarks = g_auto_approve_comments,
				pr_approval_date = systimestamp
			WHERE
					msi_claim_req_id = v_request_id;

			v_msg:='Updating Primary Approver Action and Comments. Action = '||g_approved_status||' Comments = '||g_auto_approve_comments;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, l_batch_id, NULL, g_msg_log, 'SUBMIT_AUTO_APPROVAL_REQUEST', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     
			--chm_automation_runs_pkg.end_automation_run(v_run_id,g_status_completed,g_report_type);

			CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_generated);


			--Send Auto Approval Email
			BEGIN 
				v_msg:='Sending Email';
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, l_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		
				CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     

				send_msi_auto_approval_email(v_request_id,g_approved_status);
			EXCEPTION 
				WHEN OTHERS THEN 
					CHM_MSI_CLAIM_PROCESS_PKG.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, 'EXCEPTION',
														   'SUBMIT_AUTO_APPROVAL_REQUEST', dbms_utility.format_error_stack
																					  || ', '
																					  || dbms_utility.format_error_backtrace, g_source_app_id
																					  );

					chm_msi_debug_api.log_exp(l_batch_id, 'chm_msi_claim_approval_pkg.
					', sqlcode, dbms_utility.format_error_stack
																									   || ', '
																									   || dbms_utility.format_error_backtrace

								);

			END;
		ELSE 
			v_msg:='Batch '||l_batch_id||' is not in Pending Approval Status. Exiting';
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, l_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		
			CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => l_report_request_id, p_log_type => g_msg_log, p_log_code => 'SUBMIT_AUTO_APPROVAL_REQUEST', p_log_msg =>v_msg, p_source_app_id => g_source_app_id);     
			CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_failed);			
		END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            CHM_MSI_CLAIM_PROCESS_PKG.insert_batch_logs(v_run_id, v_file_id, l_batch_id, NULL, 'EXCEPTION',
                                                   'SUBMIT_AUTO_APPROVAL_REQUEST', dbms_utility.format_error_stack
                                                                              || ', '
                                                                              || dbms_utility.format_error_backtrace, g_source_app_id
                                                                              );

            chm_msi_debug_api.log_exp(l_batch_id, 'chm_msi_claim_approval_pkg.
            ', sqlcode, dbms_utility.format_error_stack
                                                                                               || ', '
                                                                                               || dbms_utility.format_error_backtrace
                                                                                               );

			CHM_MSI_SCHEDULE_REQUEST_PKG.update_request_status(g_report_request_id, g_status_failed);			
    END submit_auto_approval_request;

    PROCEDURE submit_approval_request (
        p_batch_id           IN chm_msi_claim_request.batch_id%TYPE,
        p_req_ref            IN chm_msi_claim_request.req_ref_no%TYPE,
        p_submitter_comments IN chm_msi_claim_request.submitter_comments%TYPE
    ) AS

        v_run_id             NUMBER;
        v_file_id            NUMBER;
        v_claim_type         VARCHAR2(4000);
        v_approvers_count    NUMBER;
        v_request_id         NUMBER;
        v_min_approval_level NUMBER;
        v_primary_approver   VARCHAR2(4000);
        v_backup_approver    VARCHAR2(4000);
        v_req_ref_no         VARCHAR2(4000);
		v_msg				 VARCHAR2(4000);
    BEGIN
        v_run_id := chm_claim_run_id_seq.nextval;

		v_msg:='Submit Approval Run ID = '||v_run_id;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);		

        -- Getting file id, claim type from chm_msi_claim_batch table
        SELECT file_id,claim_type
        INTO   v_file_id,v_claim_type
        FROM   chm_msi_claim_batch
        WHERE  batch_id = p_batch_id;

		v_msg:='Get File ID and Claim Type. File ID = '||v_file_id||' Claim Type = '||v_claim_type;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);			

         -- Getting file id, claim type from chm_msi_claim_batch table
        SELECT 	COUNT(1),MIN(approval_level)
        INTO	v_approvers_count,v_min_approval_level
        FROM    chm_claim_approval_matrix
        WHERE	transaction_type = v_claim_type;

		v_msg:='Get Approver Count and Min Approval Level. Approver Count = '||v_approvers_count||' Min Approver Level = '||v_min_approval_level;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);			

        INSERT INTO chm_msi_claim_request (
            req_ref_no,
            batch_id,
            total_approval_level,
            submitter_comments,
            source_app_id
        ) VALUES (
            p_req_ref,
            p_batch_id,
            v_approvers_count,
            p_submitter_comments,
            g_source_app_id
        ) RETURN msi_claim_req_id,
                 req_ref_no INTO v_request_id, v_req_ref_no;

		v_msg:='Inserted Claim  Request. Request ID = '||v_request_id||' Reference = '||v_req_ref_no;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);



        FOR i IN (
            SELECT	approval_level,
					approval_role,
					primary_approver,
					backup_approver
            FROM	chm_claim_approval_matrix
            WHERE	transaction_type = v_claim_type
        ) LOOP
            INSERT INTO chm_msi_claim_request_approval (
                msi_claim_req_id,
                approval_level,
                approval_role,
                primary_approver,
                backup_approver,
                source_app_id
            ) VALUES (
                v_request_id,
                i.approval_level,
                i.approval_role,
                i.primary_approver,
                i.backup_approver,
               g_source_app_id
            );

			v_msg:='Inserted Claim Approval Request. Approver Level = '||i.approval_level||' Approver Role = '||i.approval_role||'Primary Approver = '||i.primary_approver||' Backup Approver = '||i.backup_approver;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);

        END LOOP;

        FOR j IN (
            SELECT
                cl.payee_id    installer_id,
                v_claim_type   claim_type,
                claim_date,
				spa_number,
				(select count(*) from chm_msi_claim_batch_lines cmc where cmc.batch_id=p_batch_id) total_batch_lines,
				(select count(*) from chm_msi_claim_batch_lines cmc where cmc.batch_id=p_batch_id
				and cmc.line_status<>g_new_status) num_lines_not_submitted,
                COUNT(1)       num_lines_submitted,
                ROUND(SUM(NVL(user_extended_claim_amount,extended_claim_amount)),2) total_claim_amt, 
                SUM(CASE WHEN is_overridden = 'Y' THEN 1  ELSE 0 END )  num_lines_overridden,
				SUM(CASE WHEN is_overridden = 'Y' THEN 0  ELSE 1 END )  num_lines_not_overridden,
				SUM(CASE WHEN is_overridden = 'Y' THEN 0  
						 ELSE round((NVL(user_extended_claim_amount,extended_claim_amount)),2) END )  lines_not_overridden_claim_amount,
				SUM(CASE WHEN is_overridden = 'Y' THEN round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
						 ELSE 0 	END )  lines_overridden_claim_amount,
				SUM(CASE WHEN rebate_type='UNIT_ACTIVATION' THEN 
						round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
					 ELSE 0 END) unit_incentive_amount,

				SUM(CASE WHEN rebate_type='SYSTEM_ATTACHMENT' THEN 
						  round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
					 ELSE 0 END) system_attachment_amount,				

				SUM(CASE WHEN rebate_type='SYSTEM_SIZE' THEN 
					 round((NVL(user_extended_claim_amount,extended_claim_amount)),2)
					ELSE 0 END) system_size_amount,				
                currency
            FROM  chm_msi_claim_batch_lines cl
            WHERE  cl.batch_id = p_batch_id
			AND 	cl.line_status = g_new_status
            GROUP BY cl.payee_id, claim_date, spa_number, currency
        ) LOOP
            INSERT INTO chm_msi_claim_request_summary (
                msi_claim_req_id,
                installer_id,
                claim_type,
                claim_date,
				spa_number,
				total_batch_lines,
                total_lines_submitted,
				total_lines_not_submitted,
                total_lines_overridden,
				total_lines_not_overridden,
                total_claim_amount,
				lines_overridden_claim_amount,
				lines_not_overridden_claim_amount,
                source_app_id,
				unit_incentive_amount,
				system_attachment_amount,
				system_size_amount,
                currency 
            ) VALUES (
                v_request_id,
                j.installer_id,
                j.claim_type,
                j.claim_date,
				j.spa_number,
				j.total_batch_lines,
                j.num_lines_submitted,
				j.num_lines_not_submitted,
                j.num_lines_overridden,
				j.num_lines_not_overridden,
                j.total_claim_amt,
				j.lines_overridden_claim_amount,
				j.lines_not_overridden_claim_amount,
                g_source_app_id,
				j.unit_incentive_amount,
				j.system_attachment_amount,
				j.system_size_amount,
                j.currency
            );

			v_msg:='Inserted Claim Request Summary Record. Num Lines Submitted = '||j.num_lines_submitted||' Num Lines Overriden = '||j.num_lines_overridden||'Total Claim Amount = '||j.total_claim_amt;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);

        END LOOP;

        SELECT primary_approver, backup_approver
        INTO   v_primary_approver, v_backup_approver
        FROM   chm_claim_approval_matrix
        WHERE
                approval_level = v_min_approval_level
         AND transaction_type = v_claim_type;

        send_request_email(v_request_id, v_primary_approver, v_backup_approver);

		v_msg:='Email Sent to Primary and Backup Approver = '||v_primary_approver||' , '||v_backup_approver;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);


        UPDATE chm_msi_claim_batch
        SET    batch_status = g_pending_approval_status
        WHERE  batch_id = p_batch_id;

		v_msg:='Update Batch Status to  = '||g_pending_approval_status;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);


        UPDATE 	chm_msi_claim_batch_lines
        SET    	approval_status = g_pending_approval_status,
				line_status=g_pending_approval_status
        WHERE   batch_id = p_batch_id
            AND line_status = g_new_status; 

		v_msg:='Update Batch Lines Status to  = '||g_pending_approval_status;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, g_msg_log, 'SUBMIT_APPROVAL_REQUEST', v_msg, g_source_app_id);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            CHM_MSI_CLAIM_PROCESS_PKG.insert_batch_logs(v_run_id, v_file_id, p_batch_id, NULL, 'EXCEPTION',
                                                   'SUBMIT_APPROVAL_REQUEST', dbms_utility.format_error_stack
                                                                              || ', '
                                                                              || dbms_utility.format_error_backtrace, g_source_app_id
                                                                              );

            chm_msi_debug_api.log_exp(p_batch_id, 'chm_msi_claim_approval_pkg.
            ', sqlcode, dbms_utility.format_error_stack
                                                                                               || ', '
                                                                                               || dbms_utility.format_error_backtrace
                                                                                               );

    END submit_approval_request;

    --Reviewed with Team
    PROCEDURE claim_request_approval (
        p_claim_req_id    IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_approver        IN chm_msi_claim_request_approval.primary_approver%TYPE,
        p_approval_status IN chm_msi_claim_request_approval.pr_approval_status%TYPE,
        p_comments        IN chm_msi_claim_request_approval.pr_approval_remarks%TYPE
    ) AS

        v_run_id                NUMBER;
        v_min_appr_level        NUMBER;
        v_next_appr_count       NUMBER;
        v_next_approval_level   NUMBER;
        v_next_primary_approver VARCHAR2(4000);
        v_next_backup_approver  VARCHAR2(4000);
        v_req_ref_no            VARCHAR2(4000);
        v_batch_id              NUMBER;
        v_total_approval_level  NUMBER;
        v_total_approved_levels NUMBER;
        v_total_rejected_levels NUMBER;
        v_cur_approval_level    NUMBER;
        v_primary_approver      VARCHAR2(4000);
        v_backup_approver       VARCHAR2(4000);
        v_msg                   VARCHAR2(4000); 
		v_record_count			NUMBER;
    BEGIN
        v_run_id := chm_claim_run_id_seq.nextval;


        SELECT 	batch_id
        INTO 	v_batch_id
        FROM    chm_msi_claim_request
        WHERE   msi_claim_req_id = p_claim_req_id;

		v_msg:='Approval Run ID = '||v_run_id;
		chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_REQUEST_APPROVAL', v_msg, g_source_app_id);		

        SELECT  MIN(approval_level)
        INTO 	v_cur_approval_level
        FROM    chm_msi_claim_request_approval
        WHERE
            ( primary_approver = p_approver
              OR backup_approver = p_approver )
            AND pr_approval_status IS NULL
            AND bk_approval_status IS NULL
            AND msi_claim_req_id = p_claim_req_id;

        SELECT primary_approver,backup_approver
        INTO   v_primary_approver,v_backup_approver
        FROM   chm_msi_claim_request_approval
        WHERE
                msi_claim_req_id = p_claim_req_id
		AND 	approval_level = v_cur_approval_level;


        IF v_primary_approver = p_approver THEN
            UPDATE chm_msi_claim_request_approval
            SET
                pr_approval_status = p_approval_status,
                pr_approval_remarks = p_comments,
                pr_approval_date = systimestamp
            WHERE
                    msi_claim_req_id = p_claim_req_id
                AND primary_approver = p_approver
                AND approval_level = v_cur_approval_level;

			v_msg:='Updating Primary Approver Action and Comments. Action = '||p_approval_status||' Comments = '||p_comments;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		



        ELSE
            IF v_backup_approver = p_approver THEN
                UPDATE chm_msi_claim_request_approval
                SET
                    bk_approval_status = p_approval_status,
                    bk_approval_remarks = p_comments,
                    bk_approval_date = systimestamp
                WHERE
                        msi_claim_req_id = p_claim_req_id
                    AND backup_approver = p_approver
                    AND approval_level = v_cur_approval_level;

			v_msg:='Updating Backup Approver Action and Comments. Action = '||p_approval_status||' Comments = '||p_comments;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		



            END IF;
        END IF;

        IF ( p_approval_status = g_approved_status ) THEN
            SELECT 	COUNT(1)
            INTO 	v_next_appr_count
            FROM    chm_msi_claim_request_approval
            WHERE
                    msi_claim_req_id = p_claim_req_id
                AND approval_level > v_cur_approval_level;

            IF v_next_appr_count > 0 THEN
                SELECT 	MIN(approval_level) next_approval_level
                INTO 	v_next_approval_level
                FROM	chm_msi_claim_request_approval
                WHERE
                        msi_claim_req_id = p_claim_req_id
                    AND approval_level > v_cur_approval_level;

                SELECT  primary_approver,
						backup_approver
                INTO
                    v_next_primary_approver,
                    v_next_backup_approver
                FROM  chm_msi_claim_request_approval
                WHERE
                        msi_claim_req_id = p_claim_req_id
                    AND approval_level = v_next_approval_level;

				v_msg:='Getting Next Primary Approver and Backup Approver. Next Primary Approver = '||v_next_primary_approver||' Next Backup Approver = '||v_next_backup_approver;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		

                send_request_email(p_claim_req_id, v_next_primary_approver, v_next_backup_approver);

				v_msg:='Email sent to Next Primary Approver and Backup Approver. Next Primary Approver = '||v_next_primary_approver||' Next Backup Approver = '||v_next_backup_approver;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		


            END IF;

        ELSE
            IF ( p_approval_status = g_rejected_status ) THEN
                UPDATE chm_msi_claim_batch
                SET    batch_status = g_rejected_status
                WHERE  batch_id = v_batch_id;

				v_msg:='Set Batch Status to '||g_rejected_status;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		


				UPDATE 	chm_msi_claim_batch_lines
				SET		approval_status = g_rejected_status,
						line_status=g_rejected_status
				WHERE
						batch_id = v_batch_id
					AND line_status = g_pending_approval_status;					

				v_msg:='Set Batch Lines Status to '||g_rejected_status;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		

				v_msg:='Reset Rebate Lines Status to Eligible for Payment';
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		
				v_record_count:=chm_msi_claim_process_pkg.reset_rebate_lines_status(v_batch_id);

				v_msg:='No of Lines Reset = '||v_record_count;
				chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		

            END IF;
        END IF;

        SELECT  total_approval_level
        INTO 	v_total_approval_level
        FROM	chm_msi_claim_request
        WHERE   msi_claim_req_id = p_claim_req_id;

        SELECT	COUNT(1)
        INTO 	v_total_approved_levels
        FROM	chm_msi_claim_request_approval
        WHERE   msi_claim_req_id = p_claim_req_id
          AND 	( pr_approval_status = g_approved_status OR bk_approval_status = g_approved_status );

        SELECT  COUNT(1)
        INTO 	v_total_rejected_levels
        FROM	chm_msi_claim_request_approval
        WHERE   msi_claim_req_id = p_claim_req_id
		AND 	(pr_approval_status = g_rejected_status OR bk_approval_status = g_rejected_status );

        IF  v_total_approval_level = v_total_approved_levels
            AND v_total_rejected_levels = 0
        THEN
            UPDATE chm_msi_claim_batch
            SET    batch_status = g_approved_status
            WHERE  batch_id = v_batch_id;

			v_msg:='Update Batch Status to '||g_approved_status;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		


            UPDATE chm_msi_claim_batch_lines
            SET    approval_status = g_approved_status,
					line_status=g_approved_status
            WHERE
                    batch_id = v_batch_id
                AND line_status = g_pending_approval_status;

			v_msg:='Update Batch Lines Status to '||g_approved_status;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		


			v_msg:='Send Email to Requester';
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		

            send_response_email(p_claim_req_id, g_approved_status);
        END IF;

        IF v_total_rejected_levels > 0 THEN
            UPDATE 	chm_msi_claim_batch
            SET     batch_status = g_rejected_status
            WHERE   batch_id = v_batch_id;

			v_msg:='Update Batch Status to '||g_rejected_status;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		


            UPDATE 	chm_msi_claim_batch_lines
            SET    	approval_status = g_rejected_status,
					line_status=g_rejected_status
            WHERE   batch_id = v_batch_id
              AND 	line_status = g_pending_approval_status;

			v_msg:='Update Batch Lines Status to '||g_rejected_status;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		

			v_msg:='Reset Rebate Lines Status to Eligible for Payment';
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		
			v_record_count:=chm_msi_claim_process_pkg.reset_rebate_lines_status(v_batch_id);

			v_msg:='No of Lines Reset = '||v_record_count;
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		


			v_msg:='Send Email to Requester';
			chm_msi_claim_process_pkg.insert_batch_logs(v_run_id, -1, v_batch_id, NULL, g_msg_log, 'CLAIM_APPROVAL', v_msg, g_source_app_id);		

            send_response_email(p_claim_req_id, g_rejected_status);
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            CHM_MSI_CLAIM_PROCESS_PKG.insert_batch_logs(v_run_id, p_claim_req_id, NULL, NULL, 'EXCEPTION',
                                                   'CLAIM_REQUEST_APPROVAL', dbms_utility.format_error_stack
                                                                             || ', '
                                                                             || dbms_utility.format_error_backtrace, g_source_app_id)
                                                                             ;

            chm_msi_debug_api.log_exp(p_claim_req_id, 'chm_msi_claim_approval_pkg.claim_request_approval', sqlcode, dbms_utility.format_error_stack
                                                                                                            || ', '
                                                                                                            || dbms_utility.format_error_backtrace
                                                                                                            );

    END claim_request_approval;

    PROCEDURE send_request_email (
        p_claim_req_id     IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_primary_approver IN chm_msi_claim_request_approval.primary_approver%TYPE,
        p_backup_approver  IN chm_msi_claim_request_approval.backup_approver%TYPE
    ) AS

        v_req_ref_no             VARCHAR2(4000);
        v_dist_name              VARCHAR2(4000);
        v_oracle_acc_no          VARCHAR2(4000);
        v_placeholders           CLOB;
        v_request_summary_table  CLOB;
        v_approval_history_table CLOB;
        v_pr_approver            VARCHAR2(4000);
        v_bk_approver            VARCHAR2(4000);
        v_approval_count         NUMBER;
        v_approval_url           VARCHAR2(4000);
        v_mail_url               VARCHAR2(2000);
        v_application_id         NUMBER;
        v_appr_page_no           NUMBER;
        v_appr_page_item         VARCHAR2(100);
        l_mail_id                NUMBER;
        l_mail_to                VARCHAR2(4000);
        l_subject                VARCHAR2(2000);
        l_body_text              CLOB;
        l_html_body              CLOB;
        l_cc_email               VARCHAR2(4000) DEFAULT '';
        l_bcc_email              VARCHAR2(4000) DEFAULT '';
		v_batch_id				 NUMBER;
		v_msg				     VARCHAR2(4000);

    BEGIN

        SELECT  req_ref_no,batch_id
        INTO 	v_req_ref_no,v_batch_id
        FROM    chm_msi_claim_request
        WHERE   msi_claim_req_id = p_claim_req_id;

        -- Getting Aproval URL from lookup -- added by Sandhini on 18/10/2023

        v_mail_url := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CLAIM_APPROVAL_URL');
        v_application_id := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CHM_APPLICATION_ID');
        v_appr_page_no := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CLAIM_APPROVAL_PAGE_NO');
        v_appr_page_item := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CLAIM_APPROVAL_PAGE_ITEM');
        v_approval_url := '<a href="'
                          || v_mail_url
                          || apex_page.get_url(p_application => v_application_id, p_page => v_appr_page_no, p_items => v_appr_page_item
                          , p_values => p_claim_req_id)
                          || '">Click here to Open Request</a>';

        apex_json.initialize_clob_output;
        apex_json.open_object;
        apex_json.write('REQ_REF_NO', v_req_ref_no);
        apex_json.write('APPROVAL_URL', v_approval_url);
        apex_json.write('CLAIM_REQ_ID', p_claim_req_id);
        v_request_summary_table := v_request_summary_table
                                   || '<table>'
                                   || '<tr bgcolor="#f57f17" style = "color:white; text-align: center;">'
                                   || '<th>Installer Name</th>'
                                   || '<th>SFDC Customer Key</th>'
                                   || '<th>Claim Type</th>'
                                   || '<th>Claim Date</th>'
                                   || '<th>Total No of Claim Lines submitted for Approval</th>'
                                   || '<th>No of Lines with Manual Override</th>'
                                   || '<th>Total Claim Amount</th>'
                                   || '<th>Currency</th>'
                                   || '</tr>';

        FOR i IN (
            SELECT
                --dp.oracle_party_name      oracle_party_name,
                --dp.oracle_account_number  oracle_account_number,
				csam.account_name		  installer_name,
				csam.customer_key		  sfdc_customer_key,
                req.claim_type            claim_type,
                req.claim_date            claim_date,
                req.spa_number            spa_number,
                req.total_lines_submitted total_lines_submitted,
                req.total_lines_overridden  total_lines_override,
                req.total_claim_amount    total_claim_amount,
                req.currency              currency
            FROM
                     chm_msi_claim_request_summary req
                --JOIN chm_dist_profile_master dp ON req.dist_id = dp.dist_id
				JOIN chm_sfdc_account_master csam ON req.installer_id=csam.chm_account_id
            WHERE
                msi_claim_req_id = p_claim_req_id
        ) LOOP
            v_request_summary_table := v_request_summary_table
                                       || '<tr style = "text-align: center;">'
                                       || '<td>'
                                       || i.installer_name
                                       || '</td>'
                                       || '<td>'
                                       || i.sfdc_customer_key
                                       || '</td>'
                                       || '<td>'
                                       || i.claim_type
                                       || '</td>'
                                       || '<td>'
                                       || to_char(i.claim_date, chm_const_pkg.gettimestampformat)
                                       || '</td>'
                                      -- || '<td>'
                                      -- || i.spa_number
                                      -- || '</td>'
                                       || '<td>'
                                       || i.total_lines_submitted
                                       || '</td>'
                                       || '<td>'
                                       || i.total_lines_override
                                       || '</td>'
                                       || '<td>'
                                       || i.total_claim_amount
                                       || '</td>'
                                       || '<td>'
                                       || i.currency
                                       || '</td>'
                                       || '</tr>';
        END LOOP;

        v_request_summary_table := v_request_summary_table || '</table>';
        apex_json.write('REQUEST_SUMMARY', v_request_summary_table);

		SELECT  COUNT(1)
        INTO 	v_approval_count
        FROM    chm_msi_claim_request_approval
        WHERE   msi_claim_req_id = p_claim_req_id
         AND 	( pr_approval_status IS NOT NULL OR bk_approval_status IS NOT NULL );

        IF v_approval_count > 0 THEN
            v_approval_history_table := v_approval_history_table
                                        || '<u>Approval History:</u> <br><br> <table>'
                                        || '<tr bgcolor="#f57f17" style = "color:white; text-align: center;">'
                                        || '<th>Approval Level</th>'
                                        || '<th>Approval Role</th>'
                                        || '<th>Approver</th>'
                                        || '<th>Approval Status</th>'
                                        || '<th>Comments</th>'
                                        || '<th>Updated Date</th>'
                                        || '</tr>';

            FOR j IN (
                SELECT
                    approval_level,
                    approval_role,
                    primary_approver,
                    pr_approval_status,
                    pr_approval_remarks,
                    pr_approval_date,
                    backup_approver,
                    bk_approval_status,
                    bk_approval_remarks,
                    bk_approval_date
                FROM chm_msi_claim_request_approval
                WHERE   msi_claim_req_id = p_claim_req_id
				AND 	( pr_approval_status IS NOT NULL OR bk_approval_status IS NOT NULL )
            ) LOOP
                SELECT	firstname|| ' '|| lastname
                INTO	v_pr_approver
                FROM    chm_user_management
                WHERE	user_name = j.primary_approver;

                SELECT
                    firstname
                    || ' '
                    || lastname
                INTO v_bk_approver
                FROM
                    chm_user_management
                WHERE
                    user_name = j.backup_approver;

                IF ( j.pr_approval_status IS NOT NULL ) THEN
                    v_approval_history_table := v_approval_history_table
                                                || '<tr style = "text-align: center;">'
                                                || '<td>'
                                                || j.approval_level
                                                || '</td>'
                                                || '<td>'
                                                || j.approval_role
                                                || '</td>'
                                                || '<td>'
                                                || v_pr_approver
                                                || '</td>'
                                                || '<td>'
                                                || j.pr_approval_status
                                                || '</td>'
                                                || '<td>'
                                                || j.pr_approval_remarks
                                                || '</td>'
                                                || '<td>'
                                                || j.pr_approval_date
                                                || '</td>'
                                                || '</tr>';
                ELSE
                    v_approval_history_table := v_approval_history_table
                                                || '<tr style = "text-align: center;">'
                                                || '<td>'
                                                || j.approval_level
                                                || '</td>'
                                                || '<td>'
                                                || j.approval_role
                                                || '</td>'
                                                || '<td>'
                                                || v_bk_approver
                                                || '</td>'
                                                || '<td>'
                                                || j.bk_approval_status
                                                || '</td>'
                                                || '<td>'
                                                || j.bk_approval_remarks
                                                || '</td>'
                                                || '<td>'
                                                || j.bk_approval_date
                                                || '</td>'
                                                || '</tr>';
                END IF;

            END LOOP;

            v_approval_history_table := v_approval_history_table || '</table>';
        END IF;

        apex_json.write('APPROVAL_HISTORY', nvl(v_approval_history_table, ' '));
        apex_json.close_object;
        v_placeholders := apex_json.get_clob_output;
        apex_json.free_output;        


        l_mail_to := (
            CASE
                WHEN lower(p_primary_approver) LIKE '%@enphaseenergy.com' THEN
                    p_primary_approver
                ELSE p_primary_approver || '@enphaseenergy.com'
            END
        )
                     || ','
                     || (
            CASE
                WHEN lower(p_backup_approver) LIKE '%@enphaseenergy.com' THEN
                    p_backup_approver
                ELSE p_backup_approver || '@enphaseenergy.com'
            END
        );


		v_msg:='Send Request Email to =  '||l_mail_to;
		chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, v_batch_id, NULL, g_msg_log, 'SEND_REQUEST_EMAIL', v_msg, g_source_app_id);		

         -- Send email
         CHM_MSI_UTIL_PKG.chm_mail(p_mail_to => l_mail_to, p_body => l_body_text, p_sub => NULL, p_cc => l_cc_email, p_bcc => l_bcc_email,
                                 p_mail_id => l_mail_id, p_template_static_id => 'CLAIM_APPROVAL_REQUEST', p_placeholder => v_placeholders);     


		v_msg:='Email sent to =  '||l_mail_to;
		chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, v_batch_id, NULL, g_msg_log, 'SEND_REQUEST_EMAIL', v_msg, g_source_app_id);		


    EXCEPTION
        WHEN OTHERS THEN
            chm_msi_debug_api.log_exp(p_claim_req_id, 'chm_msi_claim_approval_pkg.send_request_email', sqlcode, dbms_utility.format_error_stack
                                                                                                        || ', '
                                                                                                        || dbms_utility.format_error_backtrace
                                                                                                        );
    END send_request_email;

    PROCEDURE send_response_email (
        p_claim_req_id    IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_approval_status IN chm_msi_claim_request_approval.pr_approval_status%TYPE
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
        l_subject                VARCHAR2(2000);
        l_body_text              CLOB;
        l_html_body              CLOB;
        l_cc_email               VARCHAR2(4000) DEFAULT '';
        l_bcc_email              VARCHAR2(4000) DEFAULT '';
		v_batch_id				 NUMBER;
		v_msg					 VARCHAR2(4000);

    BEGIN
        SELECT  req_ref_no,created_by,batch_id
        INTO    v_req_ref_no,v_submitter,v_batch_id
        FROM	chm_msi_claim_request
        WHERE	msi_claim_req_id = p_claim_req_id;

        v_mail_url := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CLAIM_APPROVAL_URL');
        v_application_id := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CHM_APPLICATION_ID');
        v_appr_page_no := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CLAIM_APPROVAL_PAGE_NO');
        v_appr_page_item := chm_util_pkg.get_lookup_value('CHM_APPLICATION_URL_LOV', 'CLAIM_APPROVAL_PAGE_ITEM');
        v_approval_url := '<a href="'
                          || v_mail_url
                          || apex_page.get_url(p_application => v_application_id, p_page => v_appr_page_no, p_items => v_appr_page_item
                          , p_values => p_claim_req_id)
                          || '">Click here to Open Request</a>';

        apex_json.initialize_clob_output;
        apex_json.open_object;
        apex_json.write('REQ_REF_NO', v_req_ref_no);
        apex_json.write('REQ_APPROVAL_STATUS', p_approval_status);
        apex_json.write('APPROVAL_URL', v_approval_url);
        apex_json.write('CLAIM_REQ_ID', p_claim_req_id);
        v_approval_history_table := v_approval_history_table
                                    || '<u>Approval History:</u> <br> <table>'
                                    || '<tr bgcolor="#f57f17" style = "color:white">'
                                    || '<th>Approval Level</th>'
                                    || '<th>Approval Role</th>'
                                    || '<th>Approver</th>'
                                    || '<th>Approval Status</th>'
                                    || '<th>Comments</th>'
                                    || '<th>Updated Date</th>'
                                    || '</tr>';

        FOR j IN (
            SELECT
                approval_level,
                approval_role,
                primary_approver,
                pr_approval_status,
                pr_approval_remarks,
                pr_approval_date,
                backup_approver,
                bk_approval_status,
                bk_approval_remarks,
                bk_approval_date
            FROM
                chm_msi_claim_request_approval
            WHERE
                    msi_claim_req_id = p_claim_req_id
                AND ( pr_approval_status IS NOT NULL
                      OR bk_approval_status IS NOT NULL )
        ) LOOP
            SELECT
                firstname
                || ' '
                || lastname
            INTO v_pr_approver
            FROM
                chm_user_management
            WHERE
                user_name = j.primary_approver;

            SELECT
                firstname
                || ' '
                || lastname
            INTO v_bk_approver
            FROM
                chm_user_management
            WHERE
                user_name = j.backup_approver;

            IF ( j.pr_approval_status IS NOT NULL ) THEN
                v_approval_history_table := v_approval_history_table
                                            || '<tr>'
                                            || '<td>'
                                            || j.approval_level
                                            || '</td>'
                                            || '<td>'
                                            || j.approval_role
                                            || '</td>'
                                            || '<td>'
                                            || v_pr_approver
                                            || '</td>'
                                            || '<td>'
                                            || j.pr_approval_status
                                            || '</td>'
                                            || '<td>'
                                            || j.pr_approval_remarks
                                            || '</td>'
                                            || '<td>'
                                            || j.pr_approval_date
                                            || '</td>'
                                            || '</tr>';
            ELSE
                v_approval_history_table := v_approval_history_table
                                            || '<tr>'
                                            || '<td>'
                                            || j.approval_level
                                            || '</td>'
                                            || '<td>'
                                            || j.approval_role
                                            || '</td>'
                                            || '<td>'
                                            || v_bk_approver
                                            || '</td>'
                                            || '<td>'
                                            || j.bk_approval_status
                                            || '</td>'
                                            || '<td>'
                                            || j.bk_approval_remarks
                                            || '</td>'
                                            || '<td>'
                                            || j.bk_approval_date
                                            || '</td>'
                                            || '</tr>';
            END IF;

        END LOOP;

        v_approval_history_table := v_approval_history_table || '</table>';
        apex_json.write('APPROVAL_HISTORY', v_approval_history_table);
        apex_json.close_object;
        v_placeholders := apex_json.get_clob_output;
        apex_json.free_output;

        -- Send email to Submitter

        apex_mail.send(p_from => 'donotreply@enphaseenergy.com', p_to =>(
            CASE
                WHEN lower(v_submitter) LIKE '%@enphaseenergy.com' THEN
                    v_submitter
                ELSE
                    v_submitter || '@enphaseenergy.com'
            END
        ), p_template_static_id => 'CLAIM_APPROVAL_RESPONSE', p_placeholders => v_placeholders);

        apex_mail.push_queue();

        -- Send email to previous Approver

        FOR i IN (
            SELECT
					CASE
						WHEN pr_approval_status IS NOT NULL
							 AND bk_approval_status IS NULL THEN
							primary_approver
						WHEN pr_approval_status IS NULL
							 AND bk_approval_status IS NOT NULL THEN
							backup_approver
						ELSE
							primary_approver
					END previous_approver
            FROM   	chm_msi_claim_request_approval
            WHERE  	msi_claim_req_id = p_claim_req_id
			AND 	(pr_approval_status IS NOT NULL OR bk_approval_status IS NOT NULL )
        ) LOOP


            l_mail_to :=
                CASE
                    WHEN lower(i.previous_approver) LIKE '%@enphaseenergy.com' THEN
                        i.previous_approver
                    ELSE i.previous_approver || '@enphaseenergy.com'
                END;

			v_msg:='Send Response Email to  =  '||l_mail_to;
			chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, v_batch_id, NULL, g_msg_log, 'SEND_RESPONSE_EMAIL', v_msg, g_source_app_id);		

         -- Send email
         CHM_MSI_UTIL_PKG.chm_mail(p_mail_to => l_mail_to, p_body => l_body_text, p_sub => NULL, p_cc => l_cc_email, p_bcc => l_bcc_email,
                                 p_mail_id => l_mail_id, p_template_static_id => 'CLAIM_APPROVAL_REQUEST', p_placeholder => v_placeholders);     




        -- Prepare template for the email notification
            CHM_MSI_UTIL_PKG.prepare_mail_template(p_static_id => 'CLAIM_APPROVAL_RESPONSE', p_placeholders => v_placeholders, p_subject => l_subject
            , p_html_body => l_html_body, p_body_text => l_body_text);

            chm_msi_debug_api.log_msg(p_claim_req_id, 'chm_msi_claim_approval_pkg.send_response_email', 'Sending Email for the Claim Approval Response - Request ID -'
                                                                                                || p_claim_req_id
                                                                                                || ' with following mail parameters : '
                                                                                                || ' Mail ID - '
                                                                                                || l_mail_id
                                                                                                || '; TO Email(s) - '
                                                                                                || l_mail_to
                                                                                                || '; Subject - '
                                                                                                || l_subject
                                                                                                || '; Mail Body - '
                                                                                                || l_html_body);

            -- Send email
            CHM_MSI_UTIL_PKG.chm_send_mail(p_mail_to => l_mail_to, p_body => l_body_text, p_sub => l_subject, p_cc => l_cc_email, p_bcc => l_bcc_email
            ,
                                      p_mail_id => l_mail_id, p_body_html => l_html_body);


			v_msg:='Email sent to =  '||l_mail_to;
			chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, v_batch_id, NULL, g_msg_log, 'SEND_RESPONSE_EMAIL', v_msg, g_source_app_id);		


        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            chm_msi_debug_api.log_exp(p_claim_req_id, 'chm_msi_claim_approval_pkg.send_response_email', sqlcode, dbms_utility.format_error_stack
                                                                                                         || ', '
                                                                                                         || dbms_utility.format_error_backtrace
                                                                                                         );
    END send_response_email;


    PROCEDURE send_msi_auto_approval_email (
        p_claim_req_id    IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_approval_status IN chm_msi_claim_request_approval.pr_approval_status%TYPE
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

    BEGIN
        SELECT  req_ref_no,created_by,batch_id
        INTO    v_req_ref_no,v_submitter,v_batch_id
        FROM	chm_msi_claim_request
        WHERE	msi_claim_req_id = p_claim_req_id;


		l_mail_to := g_msi_rebate_auto_approve_email_to;
		l_mail_cc := g_msi_rebate_auto_approve_email_cc;
		l_mail_bcc := g_msi_rebate_auto_approve_email_bcc;

		/*
		 l_body_text := EMPTY_CLOB(); -- Initialize the CLOB
		 l_body_text := l_body_text || 'This is an auto generated email.';
		 l_body_text := l_body_text || '';
		 l_body_text := l_body_text || '';
		 l_body_text := l_body_text || 'MSI CLAIM BATCH ID = '||v_batch_id||' has been '||p_approval_status; -- Append the data

		 */

		l_placeholders:='{' ||' "BATCH_ID":'||apex_json.stringify(TO_CHAR(v_batch_id))||', "STATUS": "Approved", "COMMENTS":'||apex_json.stringify(g_auto_approve_comments)||', "INSTANCE":'||apex_json.stringify(g_instance_name)||' }';

		chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, v_batch_id, NULL, g_msg_log, 'SEND_RESPONSE_EMAIL', l_placeholders, g_source_app_id);		
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_RESPONSE_EMAIL', p_log_msg => l_placeholders, p_source_app_id => g_source_app_id);


		v_msg:='Send Auto Approval Email to  =  '||l_mail_to;
		chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, v_batch_id, NULL, g_msg_log, 'SEND_RESPONSE_EMAIL', v_msg, g_source_app_id);		



		chm_msi_util_pkg.chm_mail(
		p_mail_to        => l_mail_to,
		p_cc             =>	l_mail_cc,
		p_bcc            => l_mail_bcc,
		p_template_static_id => 'CHM_MSI_AUTO_APPROVAL_NOTIFICATION',
		p_placeholder =>  l_placeholders,
		p_add_attachment => FALSE,
		p_mail_id        => l_mail_id);

		chm_msi_claim_process_pkg.insert_batch_logs(-1, -1, v_batch_id, NULL, g_msg_log, 'SEND_RESPONSE_EMAIL', 'l_mail_id = '||l_mail_id, g_source_app_id);		
		CHM_MSI_SCHEDULE_REQUEST_PKG.insert_report_logs(p_run_id => g_run_id, p_report_request_id => g_report_request_id, p_log_type => g_msg_log, p_log_code => 'SEND_RESPONSE_EMAIL', p_log_msg => 'l_mail_id = '||l_mail_id, p_source_app_id => g_source_app_id);


	EXCEPTION
        WHEN OTHERS THEN
            chm_msi_debug_api.log_exp(p_claim_req_id, 'chm_msi_claim_approval_pkg.send_msi_auto_approval_email', sqlcode, dbms_utility.format_error_stack
                                                                                                         || ', '
                                                                                                         || dbms_utility.format_error_backtrace
                                                                                                         );
    END send_msi_auto_approval_email;

END chm_msi_claim_approval_pkg;

/
