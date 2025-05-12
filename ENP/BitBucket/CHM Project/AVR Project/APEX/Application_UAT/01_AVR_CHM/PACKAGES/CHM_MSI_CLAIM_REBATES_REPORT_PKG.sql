--------------------------------------------------------
--  DDL for Package CHM_MSI_CLAIM_REBATES_REPORT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHM_MSI_CLAIM_REBATES_REPORT_PKG" AS
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


	PROCEDURE claims_rebate_report (
			p_report_request_id IN NUMBER,
			p_run_id IN NUMBER);

END CHM_MSI_CLAIM_REBATES_REPORT_PKG;

/
