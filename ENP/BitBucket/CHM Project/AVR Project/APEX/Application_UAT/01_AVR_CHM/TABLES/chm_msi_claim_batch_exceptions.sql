
  CREATE TABLE "CHM_MSI_CLAIM_BATCH_EXCEPTIONS" 
   (	"EXCEPTION_ID" NUMBER, 
	"BATCH_ID" NUMBER, 
	"LINE_ID" NUMBER, 
	"RUN_ID" NUMBER, 
	"CURRENT_FLAG" VARCHAR2(1), 
	"ERROR_TYPE" VARCHAR2(240), 
	"ERROR_CODE" VARCHAR2(240), 
	"ERROR_MESSAGE" VARCHAR2(4000), 
	"START_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"END_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"ATTRIBUTE_CONTEXT" VARCHAR2(4000), 
	"ATTRIBUTE1" VARCHAR2(4000), 
	"ATTRIBUTE2" VARCHAR2(4000), 
	"ATTRIBUTE3" VARCHAR2(4000), 
	"ATTRIBUTE4" VARCHAR2(4000), 
	"ATTRIBUTE5" VARCHAR2(4000), 
	"ATTRIBUTE6" VARCHAR2(4000), 
	"ATTRIBUTE7" VARCHAR2(4000), 
	"ATTRIBUTE8" VARCHAR2(4000), 
	"ATTRIBUTE9" VARCHAR2(4000), 
	"ATTRIBUTE10" VARCHAR2(4000), 
	"ATTRIBUTE11" VARCHAR2(4000), 
	"ATTRIBUTE12" VARCHAR2(4000), 
	"ATTRIBUTE13" VARCHAR2(4000), 
	"ATTRIBUTE14" VARCHAR2(4000), 
	"ATTRIBUTE15" VARCHAR2(4000), 
	"CREATED_BY" VARCHAR2(250), 
	"CREATION_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"LAST_UPDATED_BY" VARCHAR2(250), 
	"LAST_UPDATED_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"SOURCE_APP_ID" NUMBER, 
	"ENTERPRISE_ID" NUMBER, 
	"IP_ADDRESS" VARCHAR2(4000), 
	"USER_AGENT" VARCHAR2(4000)
   ) ;

  CREATE INDEX "CHM_MSI_CLAIM_BATCH_LINE_BATCH_ID_IDX" ON "CHM_MSI_CLAIM_BATCH_EXCEPTIONS" ("BATCH_ID") 
  ;

  CREATE INDEX "CHM_MSI_CLAIM_BATCH_LINE_ID_IDX" ON "CHM_MSI_CLAIM_BATCH_EXCEPTIONS" ("LINE_ID") 
  ;

  CREATE UNIQUE INDEX "CHM_MSI_CLAIM_EXCEPTION_ID_IDX" ON "CHM_MSI_CLAIM_BATCH_EXCEPTIONS" ("EXCEPTION_ID") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BIU_CHM_MSI_CLAIM_BATCH_EXCEPTIONS" 
BEFORE INSERT OR UPDATE ON CHM_MSI_CLAIM_BATCH_EXCEPTIONS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.EXCEPTION_ID IS NULL THEN
            :NEW.EXCEPTION_ID := CHM_MSI_CLAIM_BATCH_EXCEPTIONS_SEQ.NEXTVAL;
        END IF;
       :NEW.CREATED_BY         := NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME());
        :NEW.CREATION_DATE      := NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP);
        :NEW.LAST_UPDATED_BY    := NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME());
        :NEW.LAST_UPDATED_DATE  := NVL(:NEW.LAST_UPDATED_DATE ,SYSTIMESTAMP) ;
        :NEW.SOURCE_APP_ID      := NVL(:NEW.SOURCE_APP_ID, CHM_UTIL_PKG.GETSOURCEAPP('CHM'));
        :NEW.ENTERPRISE_ID      := NVL(:NEW.ENTERPRISE_ID, CHM_CONST_PKG.GETENTERPRISEID());
        :NEW.IP_ADDRESS         := NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS());
        :NEW.USER_AGENT         := NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT());

      ELSIF UPDATING THEN
       :NEW.LAST_UPDATED_BY :=
            CASE
                WHEN :OLD.LAST_UPDATED_BY != :NEW.LAST_UPDATED_BY THEN
                    :NEW.LAST_UPDATED_BY
                ELSE CHM_UTIL_PKG.GETUSERNAME()
            END;

        :NEW.LAST_UPDATED_DATE :=
            CASE
                WHEN :OLD.LAST_UPDATED_DATE != :NEW.LAST_UPDATED_DATE THEN
                    :NEW.LAST_UPDATED_DATE
                ELSE SYSTIMESTAMP
            END;

        :NEW.IP_ADDRESS :=
            CASE
                WHEN :OLD.IP_ADDRESS != :NEW.IP_ADDRESS THEN
                    :NEW.IP_ADDRESS
                ELSE CHM_UTIL_PKG.GETIPADDRESS()
            END;

        :NEW.USER_AGENT :=
            CASE
                WHEN :OLD.USER_AGENT != :NEW.USER_AGENT THEN
                    :NEW.USER_AGENT
                ELSE CHM_UTIL_PKG.GETUSERAGENT()
            END;

      END IF;
   END;


/
ALTER TRIGGER "BIU_CHM_MSI_CLAIM_BATCH_EXCEPTIONS" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "AIU_CHM_MSI_CLAIM_BATCH_EXCEPTIONS" AFTER
  INSERT OR UPDATE OR DELETE ON CHM_MSI_CLAIM_BATCH_EXCEPTIONS
  FOR EACH ROW
BEGIN
  IF inserting THEN
    INSERT INTO CHM_MSI_CLAIM_BATCH_EXCEPTIONS_audit (
      exception_audit_id,
      exception_id,
      new_batch_id,
      new_line_id,
      new_run_id,
      new_current_flag,
      new_error_code,
      new_error_message,
      new_start_date,
      new_end_date,
      new_error_type,
      action,
      enterprise_id,
      source_app_id,
      created_by,
      creation_date,
      ip_address,
      user_agent
    ) VALUES (
      CHM_MSI_CLAIM_BATCH_EXCEPTIONS_audit_seq.NEXTVAL,
      :new.exception_id,
      :new.batch_id,
      :new.line_id,
      :new.run_id,
      :new.current_flag,
      :new.error_code,
      :new.error_message,
      :new.start_date,
      :new.end_date,
      :new.error_type,
      'insert',
      chm_const_pkg.getenterpriseid(),
      chm_util_pkg.getsourcesystem('chm'),
      chm_util_pkg.getusername(),
      systimestamp,
      chm_util_pkg.getipaddress(),
      chm_util_pkg.getuseragent()
    );

  END IF;

  IF updating THEN
    INSERT INTO CHM_MSI_CLAIM_BATCH_EXCEPTIONS_audit (
      exception_audit_id,
      exception_id,
      old_batch_id,
      new_batch_id,
      old_line_id,
      new_line_id,
      old_run_id,
      new_run_id,
      old_current_flag,
      new_current_flag,
      old_error_code,
      new_error_code,
      old_error_message,
      new_error_message,
      old_start_date,
      new_start_date,
      old_end_date,
      new_end_date,
      old_error_type,
      new_error_type,
      action,
      enterprise_id,
      source_app_id,
      created_by,
      creation_date,
      ip_address,
      user_agent
    ) VALUES (
      CHM_MSI_CLAIM_BATCH_EXCEPTIONS_audit_seq.NEXTVAL,
      :new.exception_id,
      :old.batch_id,
      :new.batch_id,
      :old.line_id,
      :new.line_id,
      :old.run_id,
      :new.run_id,
      :old.current_flag,
      :new.current_flag,
      :old.error_code,
      :new.error_code,
      :old.error_message,
      :new.error_message,
      :old.start_date,
      :new.start_date,
      :old.end_date,
      :new.end_date,
      :old.error_type,
      :new.error_type,
      'update',
      chm_const_pkg.getenterpriseid(),
      chm_util_pkg.getsourcesystem('chm'),
      chm_util_pkg.getusername(),
      systimestamp,
      chm_util_pkg.getipaddress(),
      chm_util_pkg.getuseragent()
    );

  END IF;

  IF deleting THEN
    INSERT INTO CHM_MSI_CLAIM_BATCH_EXCEPTIONS_audit (
      exception_audit_id,
      exception_id,
      old_batch_id,
      old_line_id,
      old_run_id,
      old_current_flag,
      old_error_code,
      old_error_message,
      old_start_date,
      old_end_date,
      old_error_type,
      action,
      enterprise_id,
      source_app_id,
      created_by,
      creation_date,
      ip_address,
      user_agent
    ) VALUES (
      CHM_MSI_CLAIM_BATCH_EXCEPTIONS_audit_seq.NEXTVAL,
      :old.exception_id,
      :old.batch_id,
      :old.line_id,
      :old.run_id,
      :old.current_flag,
      :old.error_code,
      :old.error_message,
      :old.start_date,
      :old.end_date,
      :old.error_type,
      'delete',
      chm_const_pkg.getenterpriseid(),
      chm_util_pkg.getsourcesystem('chm'),
      chm_util_pkg.getusername(),
      systimestamp,
      chm_util_pkg.getipaddress(),
      chm_util_pkg.getuseragent()
    );

  END IF;

END;



/
ALTER TRIGGER "AIU_CHM_MSI_CLAIM_BATCH_EXCEPTIONS" ENABLE;