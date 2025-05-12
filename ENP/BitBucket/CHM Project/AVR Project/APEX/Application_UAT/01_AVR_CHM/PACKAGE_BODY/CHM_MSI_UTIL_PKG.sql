--------------------------------------------------------
--  DDL for Package Body CHM_MSI_UTIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHM_MSI_UTIL_PKG" AS 

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
  g_instance_name			VARCHAR2(2000):= chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'SERVER_NAME' );
  g_mail_from        VARCHAR2(100) := NVL(chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_MSI_CLAIM_EMAILS', p_lookup_code => 'MSI_EMAIL_FROM' ),'donotreply@enphaseenergy.com');  
  g_application_id   NUMBER := NVL(chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'APPLICATION_ID' ),101);  
  g_server_name      VARCHAR2(4000) := chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'SERVER_NAME' );
  --g_mail_from        VARCHAR2(100) := 'donotreply@enphaseenergy.com';
  --g_application_id   NUMBER := 101;
  g_chm_support_email VARCHAR2(4000) := chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'CHM_IT_SUPPORT' );
  g_app_id                  NUMBER := 101;

PROCEDURE chm_send_mail (
    p_mail_to        IN VARCHAR2,   
    p_body           IN CLOB,
    p_sub            IN VARCHAR2,
    p_cc             IN VARCHAR2 DEFAULT NULL,
    p_bcc            IN VARCHAR2 DEFAULT NULL,
    p_body_html      IN CLOB DEFAULT NULL,
    p_add_attachment IN BOOLEAN DEFAULT FALSE,
    p_mail_id        OUT NUMBER
  )

  AS
    l_to_email VARCHAR2(4000);         
  BEGIN

	l_to_email := p_mail_to;

    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_send_mail', 'Start CHM_MAIL_PKG.chm_send_mail package');
    dbms_output.put_line('Mail will be sent to ' || p_mail_to || 'p_sub: CHM ' || g_server_name || ': ' || p_sub);
    p_mail_id := apex_mail.send(p_to => l_to_email, p_from => g_mail_from, p_body => p_body, p_subj =>'CHM ' || g_server_name || ': ' || p_sub, p_cc => p_cc,        -- v1.2 - 17-MAY-2024 - Added 'CHM ' as in PROD Server name will come as space(' ') with colon(:) 
                               p_bcc => p_bcc, p_body_html => p_body_html);

    IF p_add_attachment = false THEN
      apex_mail.push_queue;
    END IF;
    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.chm_send_mail package');
  EXCEPTION
    WHEN OTHERS THEN
      p_mail_id := NULL;
      chm_msi_debug_api.log_exp('', 'CHM_MAIL_PKG.chm_send_mail', sqlcode, sqlerrm
                                                                       || ', '
                                                                       || dbms_utility.format_error_stack
                                                                       || ', '
                                                                       || dbms_utility.format_error_backtrace);

  END chm_send_mail;

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
  ) AS
    l_to_email VARCHAR2(4000);     
    l_sub         VARCHAR2(4000);
  BEGIN


	l_to_email := p_mail_to;


      l_sub := g_server_name || ': ' || p_sub;            -- v1.2 - 17-MAY-2024 - Added 'CHM ' as in PROD Server name will come as space(' ') with colon(:) 

    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'CHM_MAIL_PKG.chm_mail package started');
    dbms_output.put_line('Mail will be sent to ' || p_mail_to);
    p_mail_id := apex_mail.send(p_to => l_to_email, p_from => g_mail_from, p_cc => p_cc, p_bcc => p_bcc, p_template_static_id => p_template_static_id
    ,
                               p_placeholders => p_placeholder, p_application_id => g_application_id);

    IF p_add_attachment = false THEN
      apex_mail.push_queue;
    END IF;
    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.chm_mail package');
  EXCEPTION
    WHEN OTHERS THEN
      p_mail_id := NULL;
      chm_msi_debug_api.log_exp('', 'CHM_MAIL_PKG.chm_mail', sqlcode, sqlerrm
                                                                  || ', '
                                                                  || dbms_utility.format_error_stack
                                                                  || ', '
                                                                  || dbms_utility.format_error_backtrace);

  END chm_mail;



  PROCEDURE chm_add_attachment (
    p_mail_id    IN NUMBER,
    p_attachment IN BLOB,
    p_filename   IN VARCHAR2,
    p_mime_type  IN VARCHAR2
  ) AS
  BEGIN
    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'Start CHM_MAIL_PKG.chm_add_attachment package');
    apex_mail.add_attachment(p_mail_id => p_mail_id, p_attachment => p_attachment, p_filename => p_filename, p_mime_type => p_mime_type
    );

    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.chm_add_attachment package');
  EXCEPTION
    WHEN OTHERS THEN
      chm_msi_debug_api.log_exp('', 'CHM_MAIL_PKG.chm_add_attachment', sqlcode, sqlerrm
                                                                            || ', '
                                                                            || dbms_utility.format_error_stack
                                                                            || ', '
                                                                            || dbms_utility.format_error_backtrace);
  END chm_add_attachment;

PROCEDURE prepare_mail_template (
    p_static_id    IN VARCHAR2,
    p_placeholders IN CLOB,
    p_subject      OUT VARCHAR2,
    p_html_body    OUT CLOB,
    p_body_text    OUT CLOB
  ) AS

  l_subject VARCHAR2(4000);

  BEGIN
    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'Start CHM_MAIL_PKG.prepare_mail_template package');
    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'p_static_id - ' || p_static_id
                                                        || '; p_placeholders - ' || p_placeholders   
                                                        || '; p_subject - ' || p_subject
                                                        || '; p_html_body - ' || p_html_body
                            );
    l_subject := 'CHM ' || g_server_name || ': ' || p_subject;          -- v1.2 - 17-MAY-2024 - Added 'CHM ' as in PROD Server name will come as space(' ') with colon(:) 
    apex_mail.prepare_template(p_static_id => p_static_id, p_placeholders => p_placeholders, p_application_id => g_app_id, p_subject => l_subject
    , p_html => p_html_body,
                    p_text => p_body_text);

    chm_msi_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.prepare_mail_template package');
  EXCEPTION
    WHEN OTHERS THEN
      p_subject := NULL;
      p_html_body := NULL;
      p_body_text := NULL;
      chm_msi_debug_api.log_exp('', 'CHM_MAIL_PKG.prepare_mail_template', sqlcode, sqlerrm
                                                                               || ', '
                                                                               || dbms_utility.format_error_stack
                                                                               || ', '
                                                                               || dbms_utility.format_error_backtrace);

  END prepare_mail_template;

FUNCTION get_user_email(p_user_id IN NUMBER) 
RETURN VARCHAR2
AS
CURSOR c_user IS
SELECT * FROM chm_user_management
where user_id=p_user_id;

v_email		VARCHAR2(4000);

BEGIN 
	FOR vc IN c_user LOOP
		v_email:=vc.user_name;
	END LOOP;

	IF  instr(lower(v_email), '@enphaseenergy.com') > 0 THEN
		RETURN v_email;
	ELSE
		RETURN NULL;
	END IF;
EXCEPTION
	WHEN OTHERS THEN 
		RETURN NULL;
END get_user_email;


END CHM_MSI_UTIL_PKG;

/
