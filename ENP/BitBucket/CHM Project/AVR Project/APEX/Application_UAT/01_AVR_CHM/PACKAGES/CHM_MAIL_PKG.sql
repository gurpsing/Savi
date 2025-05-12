--------------------------------------------------------
--  DDL for Package CHM_MAIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHM_MAIL_PKG" 
/*************************************************************************************************************************************************************************
   * File Name
   * Component Name     : POS/INV/CLAIMS Notification - Enphase users and Distributor
   * Description        : Generic package for sending mail notification 
    * Type              : PL/SQL Package                                                                                                                     
    * Package Name      : CHM_MAIL_PKG                                                                                                                  
    * Purpose           : Package to send mail notification                                                                                                   
    * Created By        : Muskan Shrivastava                                                                                                                        
    * Created Date      : 17-Jun-2023                                                                                                                           
    **************************************************************************************************************************************************************************
    * Date                    By                            Company Name                     Version           Details                                                                 
    * -----------            ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------
    * 17-Jun-2023             Muskan Shrivastava            Transform Edge                    1.0             Intial Version               
    * 15-JAN-2024            Muskan Shrivastava            Transform Edge                    1.1             Commented out CHM_MAIL procedure as it is no longer in use 
    *************************************************************************************************************************************************************************/
AS



  PROCEDURE chm_mail (
    p_mail_to            IN VARCHAR2
    ,p_body               IN VARCHAR2  DEFAULT NULL
    ,p_sub                IN VARCHAR2  DEFAULT NULL
    ,p_cc                 IN VARCHAR2 DEFAULT NULL
    ,p_bcc                IN VARCHAR2 DEFAULT NULL
    ,p_template_static_id IN VARCHAR2
    ,p_placeholder        IN VARCHAR2
    ,p_add_attachment  IN BOOLEAN DEFAULT FALSE
    ,p_mail_id                OUT NUMBER 
  );
  

  
  PROCEDURE chm_add_attachment (
    p_mail_id    IN NUMBER,
    p_attachment IN BLOB,
    p_filename   IN VARCHAR2,
    p_mime_type  IN VARCHAR2
  );
  
  PROCEDURE chm_send_mail (
    p_mail_to   IN VARCHAR2,        -- V1.5 16-SEP-2024
    p_body      IN CLOB,
    p_sub       IN VARCHAR2,
    p_cc        IN VARCHAR2 DEFAULT NULL,
    p_bcc       IN VARCHAR2 DEFAULT NULL,
    p_body_html IN CLOB DEFAULT NULL,
    p_add_attachment  IN BOOLEAN DEFAULT FALSE,
    p_mail_id   OUT NUMBER
  ) ;

  PROCEDURE prepare_mail_template (
    p_static_id    IN VARCHAR2,
    p_placeholders IN CLOB,
    p_subject      OUT VARCHAR2,
    p_html_body    OUT CLOB,
    p_body_text    OUT CLOB
  ) ;
END chm_mail_pkg;

/
