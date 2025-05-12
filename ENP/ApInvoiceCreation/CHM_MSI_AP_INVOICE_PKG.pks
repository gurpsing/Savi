create or replace PACKAGE CHM_MSI_AP_INVOICE_PKG    
/*******************************************************************************************************
* Type                           : PL/SQL Package Specification                                        *
* Package Name                   : CHM_MSI_AP_INVOICE_PKG                                              *
* Purpose                        : Package Specification for CHM MSI AP Invoice Creation               *
* Created By                     : Gurpreet Singh                                                      *
* Created Date                   : 18-Apr-2025                                                         *     
********************************************************************************************************
* Date          By                             Version          Details                                * 
* -----------   ---------------------------    -------------    ---------------------------------------*
* 18-Apr-2025   Gurpreet Singh                 1.0              Intial Version                         * 
*******************************************************************************************************/
AS
    --Procedure to group invoices   
    PROCEDURE GROUP_INVOICES (
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    );

    --Procedure to update import request status
    PROCEDURE UPDATE_IMPORT_REQ_STATUS (
         P_IN_LOAD_REQUEST_ID       IN VARCHAR2
        ,P_IN_IMPORT_REQUEST_ID     IN VARCHAR2
        ,P_IN_IMPORT_REQUEST_STATUS IN VARCHAR2
        ,P_OUT_TOTAL_RECORDS        OUT NUMBER
    );

    --Procedure to update interface status
    PROCEDURE UPDATE_INTERFACE_STATUS (
         P_IN_LOAD_REQUEST_ID       IN VARCHAR2
        ,P_IN_INVOICE_ID            IN VARCHAR2
        ,P_IN_REJECTION_REASON      IN VARCHAR2
        ,P_IN_INTERFACE_STATUS      IN VARCHAR2
    );

END CHM_MSI_AP_INVOICE_PKG;
/
