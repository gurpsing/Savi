--------------------------------------------------------
--  DDL for Package CHM_MSI_UTIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHM_MSI_UTIL_PKG" AS 

/*************************************************************************************************************************************************************************
    * Type                      : PL/SQL Package                                                                                                                        
    * Package Name        		: CHM_MSI_UTIL_PKG                                                                                                                         
    * Purpose                   : Package for Utilities                                                                                                
    * Created By                : Rajkumar Varahagiri                                                                                                                  
    * Created Date            	: 10-FEB-2025  
    **************************************************************************************************************************************************************************
    * Date                    By                                             Company Name                Version          Details                                                                 
    * -----------            ---------------------------         ---------------------------      -------------       ------------------------------------------------------------------------

    *************************************************************************************************************************************************************************/
FUNCTION get_user_email(p_user_id IN NUMBER) 
RETURN VARCHAR2;

PROCEDURE chm_send_mail (
    p_mail_to        IN VARCHAR2,   
    p_body           IN CLOB,
    p_sub            IN VARCHAR2,
    p_cc             IN VARCHAR2 DEFAULT NULL,
    p_bcc            IN VARCHAR2 DEFAULT NULL,
    p_body_html      IN CLOB DEFAULT NULL,
    p_add_attachment IN BOOLEAN DEFAULT FALSE,
    p_mail_id        OUT NUMBER
  );

PROCEDURE chm_add_attachment (
    p_mail_id    IN NUMBER,
    p_attachment IN BLOB,
    p_filename   IN VARCHAR2,
    p_mime_type  IN VARCHAR2
  ); 

  PROCEDURE chm_mail (
    p_mail_to            IN VARCHAR2,
    p_body               IN VARCHAR2 DEFAULT NULL,
    p_sub                IN VARCHAR2 DEFAULT NULL,
    p_cc                 IN VARCHAR2 DEFAULT NULL,
    p_bcc                IN VARCHAR2 DEFAULT NULL,
    p_template_static_id IN VARCHAR2,
    p_placeholder        IN VARCHAR2,
    p_add_attachment     IN BOOLEAN DEFAULT FALSE,
    p_mail_id            OUT NUMBER
  );

PROCEDURE prepare_mail_template (
    p_static_id    IN VARCHAR2,
    p_placeholders IN CLOB,
    p_subject      OUT VARCHAR2,
    p_html_body    OUT CLOB,
    p_body_text    OUT CLOB
  );  

END CHM_MSI_UTIL_PKG;

/
