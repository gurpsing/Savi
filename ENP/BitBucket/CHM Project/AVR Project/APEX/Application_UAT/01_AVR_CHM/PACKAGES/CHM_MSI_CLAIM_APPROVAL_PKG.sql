--------------------------------------------------------
--  DDL for Package CHM_MSI_CLAIM_APPROVAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHM_MSI_CLAIM_APPROVAL_PKG" AS 

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


    PROCEDURE submit_auto_approval_request (
		p_request_id		IN NUMBER
    );

	PROCEDURE submit_approval_request (
        p_batch_id           IN chm_msi_claim_request.batch_id%TYPE,
        p_req_ref            IN chm_msi_claim_request.req_ref_no%TYPE,
        p_submitter_comments IN chm_msi_claim_request.submitter_comments%TYPE
    );

    PROCEDURE claim_request_approval (
        p_claim_req_id    IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_approver        IN chm_msi_claim_request_approval.primary_approver%TYPE,
        p_approval_status IN chm_msi_claim_request_approval.pr_approval_status%TYPE,
        p_comments        IN chm_msi_claim_request_approval.pr_approval_remarks%TYPE
    );

    PROCEDURE send_request_email (
        p_claim_req_id     IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_primary_approver IN chm_msi_claim_request_approval.primary_approver%TYPE,
        p_backup_approver  IN chm_msi_claim_request_approval.backup_approver%TYPE
    );

    PROCEDURE send_response_email (
        p_claim_req_id    IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_approval_status IN chm_msi_claim_request_approval.pr_approval_status%TYPE
    );

	FUNCTION check_requester_is_not_approver
		(p_user_id IN VARCHAR2,
		 p_claim_type IN VARCHAR2
		 )
	RETURN BOOLEAN;


	PROCEDURE send_msi_auto_approval_email (
        p_claim_req_id    IN chm_msi_claim_request.msi_claim_req_id%TYPE,
        p_approval_status IN chm_msi_claim_request_approval.pr_approval_status%TYPE
    );	

END chm_msi_claim_approval_pkg;

/
