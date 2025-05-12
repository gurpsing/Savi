--------------------------------------------------------
--  DDL for Package Body CHM_MSI_DEBUG_API_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHM_MSI_DEBUG_API_PKG" AS
/*------------------------------------------------------------------------------

    Name: chm_debug_api
    Purpose: This package will be used to register all bugs and log of the system

    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            : 10-FEB-2025  
    * updated By               : 
    * updated Date           : 
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------

    *************************************************************************************************************************************************************************/

  PROCEDURE log_msg (
    p_transaction_id IN NUMBER,
    p_module         IN VARCHAR2,
    p_msg            IN VARCHAR2,
    p_report_type    IN VARCHAR2 DEFAULT NULL
  ) AS
    PRAGMA autonomous_transaction;
  BEGIN
    INSERT INTO chm_msi_debug_log (
      dbug_id,
      dbug_transaction_id,
      dbug_module,
      dbug_msg,
      dbug_created_by,
      dbug_created_date,
      report_type
    ) VALUES (
      chm_msi_debug_log_seq.NEXTVAL,
      p_transaction_id,
      p_module,
      p_msg,
      'SYSTEM',
      systimestamp,
      p_report_type
    );

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END log_msg;

  PROCEDURE log_exp (
    p_transaction_id IN NUMBER,
    p_module         IN VARCHAR2,
    p_sqlcode        IN VARCHAR2,
    p_sqlerrm        IN VARCHAR2,
    p_report_type    IN VARCHAR2 DEFAULT NULL
  ) AS
    PRAGMA autonomous_transaction;
  BEGIN
    INSERT INTO chm_msi_debug_log (
      dbug_id,
      dbug_transaction_id,
      dbug_module,
      dbug_sqlcode,
      dbug_sqlerrm,
      dbug_created_by,
      dbug_created_date,
      report_type
    ) VALUES (
      chm_msi_debug_log_seq.NEXTVAL,
      p_transaction_id,
      p_module,
      p_sqlcode,
      p_sqlerrm,
      chm_util_pkg.getusername(),
      systimestamp,
      p_report_type
    );

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END log_exp;


END CHM_MSI_DEBUG_API_PKG;

/
