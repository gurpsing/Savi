create or replace PACKAGE BODY CHM_MSI_AP_INVOICE_PKG
/*******************************************************************************************************
* Type                           : PL/SQL Package Body                                                 *
* Package Name                   : CHM_MSI_AP_INVOICE_PKG                                              *
* Purpose                        : Package Body for for CHM MSI AP Invoice Creation                    *
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
    )
    AS
        l_import_set NUMBER;
    BEGIN
        --Update Invoice Headers
        UPDATE  CHM_MSI_CLAIM_AP_INVOICE_HEADER hdr
        SET      OIC_INSTANCE_ID        = P_IN_OIC_INSTANCE_ID
                ,BU_NAME                = (SELECT description       FROM chm_msi_ap_bu_name_lookup lkp WHERE lkp.lookup_code = hdr.country and rownum=1)
                ,SUPPLIER_NUMBER        = (SELECT supplier_number   FROM CHM_MSI_SUPPLIERS sup WHERE sup.INSTALLER_NUMBER = hdr.INSTALLER_NUMBER and rownum=1)
                ,SUPPLIER_NAME          = (SELECT supplier_name     FROM CHM_MSI_SUPPLIERS sup WHERE sup.INSTALLER_NUMBER = hdr.INSTALLER_NUMBER and rownum=1)
                ,SUPPLIER_SITE          = (SELECT supplier_site     FROM CHM_MSI_SUPPLIERS sup WHERE sup.INSTALLER_NUMBER = hdr.INSTALLER_NUMBER and rownum=1)
                ,LOAD_REQUEST_ID	    = NULL 
                ,LOAD_REQUEST_STATUS    = NULL	
                ,IMPORT_REQUEST_ID	    = NULL
                ,IMPORT_REQUEST_STATUS  = NULL
                ,REJECTION_REASON  = NULL
        where   ORACLE_AP_INTERFACE_STATUS IN ('NEW', 'REJECTED');
        COMMIT;
        
        --Update Invoice Lines
        UPDATE  CHM_MSI_CLAIM_AP_INVOICES line
        SET      OIC_INSTANCE_ID = P_IN_OIC_INSTANCE_ID
                ,BU_NAME = (SELECT bu_name FROM CHM_MSI_CLAIM_AP_INVOICE_HEADER hdr WHERE hdr.oracle_ap_invoice_id = line.oracle_ap_invoice_id and rownum=1)
        where   ORACLE_AP_INTERFACE_STATUS IN ('NEW', 'REJECTED');
        COMMIT;
        
        FOR rec IN (    SELECT DISTINCT bu_name FROM CHM_MSI_CLAIM_AP_INVOICE_HEADER inv 
                        WHERE  bu_name IS NOT NULL AND OIC_INSTANCE_ID = P_IN_OIC_INSTANCE_ID )
        LOOP
            SELECT 
                CHM_MSI_AP_INV_IMPORT_SET_SEQ.NEXTVAL INTO l_import_set
            FROM DUAL;
            
            UPDATE CHM_MSI_CLAIM_AP_INVOICE_HEADER
            SET
                IMPORT_SET = l_import_set 
            WHERE bu_name = rec.bu_name and oic_instance_id = P_IN_OIC_INSTANCE_ID;
            
            UPDATE CHM_MSI_CLAIM_AP_INVOICES line
            SET
                IMPORT_SET = l_import_set 
                ,DIST_CODE_COMBINATION = (SELECT TAG FROM chm_msi_ap_bu_name_lookup lkp WHERE lkp.description = line.bu_name and rownum=1 )
                                        ||'.0000.213000.000.00000.A00.000.0000'
            WHERE bu_name = rec.bu_name and oic_instance_id = P_IN_OIC_INSTANCE_ID;
            
            COMMIT;
            
        END LOOP;


    END GROUP_INVOICES;

END CHM_MSI_AP_INVOICE_PKG;
/
