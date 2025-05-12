--------------------------------------------------------
--  DDL for Package Body CHM_MAIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHM_MAIL_PKG" AS

/*********************************************************************
**
** Procedure: CHM_MAIL
** IN: p_mail_to – Contains the string of mails with ','(comma) separation of mails to whom the mail needs to be sent
** IN: p_body – Contains the body text of the mail
** IN: p_sub – Contains the subject of the mail
** IN: p_cc – Contains the string of mails with ','(comma) separation of that needs to be in CC in the mail
** IN: p_bcc – Contains the string of mails with ','(comma) separation of that needs to be in BCC in the mail
** IN: p_template_static_id – Contains the static id of the email template
** IN: p_placeholder – Contains the string of object of placeholders and values to be replaced in email template
**
* 15-JAN-2024  Muskan Shrivastava         Transform Edge            1.0               Commented out CHM_MAIL procedure as it is no longer in use
* 17-MAY-2024  Muskan Shrivastava         Transform Edge            1.2               Added 'CHM ' as in PROD Server name will come as space(' ') with colon(:) 
* 18-JUL-2024  Arasu M                    Transform Edge            1.3               Added a alternate mail ID for the external mail ID for CR ITSD-265465
* 20-AUG-2024  Kishore Kumar P            Transform Edge            1.4               Commented out the case statement for CR ITSD-272751 to send notification to distributors
* 16-SEP-2024  Jyothi Mishra              Techcoopers Selectiva     1.5               Updated the length of 'l_to_email' variable from 100 to 4000 as the 'buffer is too small' error is popping up

*********************************************************************/
  g_server_name      VARCHAR2(4000) := chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'SERVER_NAME' );

  g_mail_from        VARCHAR2(100) := 'donotreply@enphaseenergy.com';



 





  g_application_id   NUMBER := 101;
  g_chm_support_email VARCHAR2(4000) := 
                  chm_util_pkg.get_lookup_value ( p_lookup_type => 'CHM_PROFILE_OPTIONS', p_lookup_code => 'CHM_IT_SUPPORT' );

  g_app_id                  NUMBER := 101;


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
    l_to_email VARCHAR2(4000);      -- V1.5 16-SEP-2024
    l_sub         VARCHAR2(4000);
  BEGIN

--    g_chm_support_email := chm_util_pkg.get_lookup_value 
--                                          (
--                                              p_lookup_type => 'CHM_SUPPORT_MAILS_LOV',
--                                              p_lookup_code => 'chmitsupport@enphaseenergy.com'
--                                          );

l_to_email := p_mail_to;
-- V1.4 Commented out this below code by Kishore on 20-Aug-2024 for sending the email notification to distributors
 /*
    l_to_email :=
      CASE
        WHEN instr(p_mail_to, '@enphaseenergy.com') = 0 THEN
           g_chm_support_email --This is for omiting mail to be triggered for External Mail ID's CR ITSD-265465
        ELSE p_mail_to
      END; 
*/


      l_sub := 'CHM ' || g_server_name || ': ' || p_sub;            -- v1.2 - 17-MAY-2024 - Added 'CHM ' as in PROD Server name will come as space(' ') with colon(:) 

    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'CHM_MAIL_PKG.chm_mail package started');
    dbms_output.put_line('Mail will be sent to ' || p_mail_to);
    p_mail_id := apex_mail.send(p_to => l_to_email, p_from => g_mail_from, p_cc => p_cc, p_bcc => p_bcc, p_template_static_id => p_template_static_id
    ,
                               p_placeholders => p_placeholder, p_application_id => g_application_id);

    IF p_add_attachment = false THEN
      apex_mail.push_queue;
    END IF;
    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.chm_mail package');
  EXCEPTION
    WHEN OTHERS THEN
      p_mail_id := NULL;
      chm_debug_api.log_exp('', 'CHM_MAIL_PKG.chm_mail', sqlcode, sqlerrm
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
    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'Start CHM_MAIL_PKG.chm_add_attachment package');
    apex_mail.add_attachment(p_mail_id => p_mail_id, p_attachment => p_attachment, p_filename => p_filename, p_mime_type => p_mime_type
    );

    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.chm_add_attachment package');
  EXCEPTION
    WHEN OTHERS THEN
      chm_debug_api.log_exp('', 'CHM_MAIL_PKG.chm_add_attachment', sqlcode, sqlerrm
                                                                            || ', '
                                                                            || dbms_utility.format_error_stack
                                                                            || ', '
                                                                            || dbms_utility.format_error_backtrace);
  END chm_add_attachment;

  PROCEDURE chm_send_mail (
    p_mail_to        IN VARCHAR2,   
    p_body           IN CLOB,
    p_sub            IN VARCHAR2,
    p_cc             IN VARCHAR2 DEFAULT NULL,
    p_bcc            IN VARCHAR2 DEFAULT NULL,
    p_body_html      IN CLOB DEFAULT NULL,
    p_add_attachment IN BOOLEAN DEFAULT FALSE,
    p_mail_id        OUT NUMBER
  ) AS
    l_to_email VARCHAR2(4000);          -- V1.5 16-SEP-2024
  BEGIN

  l_to_email := p_mail_to;

  -- V1.4 Commented out this below code by Kishore on 20-Aug-2024 for sending the email notification to distributors


    -- l_to_email :=
    --   CASE
    --     WHEN instr(p_mail_to, '@enphaseenergy.com') > 0 THEN
    --       p_mail_to
    --     ELSE g_chm_support_email
    --   END;

    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_send_mail', 'Start CHM_MAIL_PKG.chm_send_mail package');
    dbms_output.put_line('Mail will be sent to ' || p_mail_to || 'p_sub: CHM ' || g_server_name || ': ' || p_sub);
    p_mail_id := apex_mail.send(p_to => l_to_email, p_from => g_mail_from, p_body => p_body, p_subj =>'CHM ' || g_server_name || ': ' || p_sub, p_cc => p_cc,        -- v1.2 - 17-MAY-2024 - Added 'CHM ' as in PROD Server name will come as space(' ') with colon(:) 
                               p_bcc => p_bcc, p_body_html => p_body_html);

    IF p_add_attachment = false THEN
      apex_mail.push_queue;
    END IF;
    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.chm_send_mail package');
  EXCEPTION
    WHEN OTHERS THEN
      p_mail_id := NULL;
      chm_debug_api.log_exp('', 'CHM_MAIL_PKG.chm_send_mail', sqlcode, sqlerrm
                                                                       || ', '
                                                                       || dbms_utility.format_error_stack
                                                                       || ', '
                                                                       || dbms_utility.format_error_backtrace);

  END chm_send_mail;

  PROCEDURE prepare_mail_template (
    p_static_id    IN VARCHAR2,
    p_placeholders IN CLOB,
    p_subject      OUT VARCHAR2,
    p_html_body    OUT CLOB,
    p_body_text    OUT CLOB
  ) AS

  l_subject VARCHAR2(4000);

  BEGIN
    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'Start CHM_MAIL_PKG.prepare_mail_template package');
    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'p_static_id - ' || p_static_id
                                                        || '; p_placeholders - ' || p_placeholders   
                                                        || '; p_subject - ' || p_subject
                                                        || '; p_html_body - ' || p_html_body
                            );
    l_subject := 'CHM ' || g_server_name || ': ' || p_subject;          -- v1.2 - 17-MAY-2024 - Added 'CHM ' as in PROD Server name will come as space(' ') with colon(:) 
    apex_mail.prepare_template(p_static_id => p_static_id, p_placeholders => p_placeholders, p_application_id => g_app_id, p_subject => l_subject
    , p_html => p_html_body,
                    p_text => p_body_text);

    chm_debug_api.log_msg('', 'CHM_MAIL_PKG.chm_mail', 'End CHM_MAIL_PKG.prepare_mail_template package');
  EXCEPTION
    WHEN OTHERS THEN
      p_subject := NULL;
      p_html_body := NULL;
      p_body_text := NULL;
      chm_debug_api.log_exp('', 'CHM_MAIL_PKG.prepare_mail_template', sqlcode, sqlerrm
                                                                               || ', '
                                                                               || dbms_utility.format_error_stack
                                                                               || ', '
                                                                               || dbms_utility.format_error_backtrace);

  END prepare_mail_template;

END chm_mail_pkg;

/
