--------------------------------------------------------
--  DDL for Package CHM_MSI_DEBUG_API
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHM_MSI_DEBUG_API" 
/*------------------------------------------------------------------------------

    Name: chm_debug_api_pkg
    Purpose: This package will be used to register all bugs and log of the system

    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            : 10-FEB-2025  
    * updated By               : 
    * updated Date           : 
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------

    *************************************************************************************************************************************************************************/

AS
    PROCEDURE log_msg (
        p_transaction_id IN NUMBER,
        p_module         IN VARCHAR2,
        p_msg            IN VARCHAR2,
        p_report_type    IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE log_exp (
        p_transaction_id IN NUMBER,
        p_module         IN VARCHAR2,
        p_sqlcode        IN VARCHAR2,
        p_sqlerrm        IN VARCHAR2,
        p_report_type    IN VARCHAR2 DEFAULT NULL
    );

END CHM_MSI_DEBUG_API;

/
