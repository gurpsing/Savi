
  CREATE TABLE "CHM_MSI_CLAIM_FILES" 
   (	"FILE_ID" NUMBER NOT NULL ENABLE, 
	"FILE_NAME" VARCHAR2(4000) NOT NULL ENABLE, 
	"FILE_PATH" VARCHAR2(4000) NOT NULL ENABLE, 
	"FILE_CONTENT" CLOB, 
	"SHEET_NAME" VARCHAR2(250) NOT NULL ENABLE, 
	"FILE_STATUS" VARCHAR2(50) NOT NULL ENABLE, 
	"BATCH_REFERENCE" VARCHAR2(4000), 
	"FILE_TYPE" VARCHAR2(100), 
	"FILE_BLOB" BLOB, 
	"CLAIM_TYPE" VARCHAR2(100), 
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
	"CREATED_BY" VARCHAR2(250) NOT NULL ENABLE, 
	"CREATION_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"LAST_UPDATED_BY" VARCHAR2(250), 
	"LAST_UPDATED_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"SOURCE_APP_ID" NUMBER NOT NULL ENABLE, 
	"ENTERPRISE_ID" NUMBER, 
	"IP_ADDRESS" VARCHAR2(4000), 
	"USER_AGENT" VARCHAR2(4000) NOT NULL ENABLE
   ) ;
  CREATE UNIQUE INDEX "CHM_MSI_CLAIM_FILES_CON" ON "CHM_MSI_CLAIM_FILES" ("FILE_ID") 
  ;
ALTER TABLE "CHM_MSI_CLAIM_FILES" ADD CONSTRAINT "CHM_MSI_CLAIM_FILES_CON" PRIMARY KEY ("FILE_ID")
  USING INDEX "CHM_MSI_CLAIM_FILES_CON"  ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "AIU_CHM_MSI_CLAIM_FILES" 
AFTER INSERT OR UPDATE OR DELETE ON CHM_MSI_CLAIM_FILES
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO CHM_MSI_CLAIM_FILES_AUDIT (
            FILE_AUDIT_ID,
            FILE_ID,
            NEW_FILE_NAME,
            NEW_FILE_PATH,
            NEW_FILE_CONTENT,
            NEW_SHEET_NAME,
            NEW_FILE_STATUS,
            NEW_CLAIM_TYPE,
            ACTION,
            NEW_BATCH_REFERENCE,
            NEW_FILE_TYPE,
            new_attribute_context,
            new_attribute1,
            new_attribute2,
            new_attribute3,
            new_attribute4,
            new_attribute5,
            new_attribute6,
            new_attribute7,
            new_attribute8,
            new_attribute9,
            new_attribute10,
            new_attribute11,
            new_attribute12,
            new_attribute13,
            new_attribute14,
            new_attribute15,
            new_created_by,
            new_creation_date,
            new_last_updated_by,
            new_last_updated_date,
            new_source_app_id,
            new_enterprise_id,
            new_ip_address,
            new_user_agent,
			CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,
			SOURCE_APP_ID ,   
			ENTERPRISE_ID,    
			IP_ADDRESS,       
			USER_AGENT 
        )
        VALUES (
            CHM_CLAIM_FILES_AUDIT_SEQ.NEXTVAL,
            :NEW.FILE_ID,
            :NEW.FILE_NAME,
            :NEW.FILE_PATH,
            :NEW.FILE_CONTENT,
            :NEW.SHEET_NAME,
            :NEW.FILE_STATUS,
            :NEW.CLAIM_TYPE,
            'INSERT',
            :NEW.BATCH_REFERENCE,
            :NEW.FILE_TYPE,
            :new.attribute_context,
            :new.attribute1,
            :new.attribute2,
            :new.attribute3,
            :new.attribute4,
            :new.attribute5,
            :new.attribute6,
            :new.attribute7,
            :new.attribute8,
            :new.attribute9,
            :new.attribute10,
            :new.attribute11,
            :new.attribute12,
            :new.attribute13,
            :new.attribute14,
            :new.attribute15,
            :new.created_by,
            :new.creation_date,
            :new.last_updated_by,
            :new.last_updated_date,
            :new.source_app_id,
            :new.enterprise_id,
            :new.ip_address,
            :new.user_agent,
			NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATED_DATE ,SYSTIMESTAMP),
			NVL(:NEW.SOURCE_APP_ID, CHM_UTIL_PKG.GETSOURCEAPP('CHM')),
			NVL(:NEW.ENTERPRISE_ID, CHM_CONST_PKG.GETENTERPRISEID()),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );
    END IF;

    IF UPDATING THEN
        INSERT INTO CHM_MSI_CLAIM_FILES_AUDIT (
            FILE_AUDIT_ID,
            FILE_ID,
            OLD_FILE_NAME,
            NEW_FILE_NAME,
            OLD_FILE_PATH,
            NEW_FILE_PATH,
            OLD_FILE_CONTENT,
            NEW_FILE_CONTENT,
            OLD_SHEET_NAME,
            NEW_SHEET_NAME,
            OLD_FILE_STATUS,
            NEW_FILE_STATUS,
            OLD_CLAIM_TYPE,
            NEW_CLAIM_TYPE,
            ACTION,
            OLD_BATCH_REFERENCE,
            NEW_BATCH_REFERENCE,
            OLD_FILE_TYPE,
            NEW_FILE_TYPE,
            new_attribute_context,
            new_attribute1,
            new_attribute2,
            new_attribute3,
            new_attribute4,
            new_attribute5,
            new_attribute6,
            new_attribute7,
            new_attribute8,
            new_attribute9,
            new_attribute10,
            new_attribute11,
            new_attribute12,
            new_attribute13,
            new_attribute14,
            new_attribute15,
            new_created_by,
            new_creation_date,
            new_last_updated_by,
            new_last_updated_date,
            new_source_app_id,
            new_enterprise_id,
            new_ip_address,
            new_user_agent,
			old_attribute_context,
            old_attribute1,
            old_attribute2,
            old_attribute3,
            old_attribute4,
            old_attribute5,
            old_attribute6,
            old_attribute7,
            old_attribute8,
            old_attribute9,
            old_attribute10,
            old_attribute11,
            old_attribute12,
            old_attribute13,
            old_attribute14,
            old_attribute15,
            old_created_by,
            old_creation_date,
            old_last_updated_by,
            old_last_updated_date,
            old_source_app_id,
            old_enterprise_id,
            old_ip_address,
            old_user_agent,
			CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,
			SOURCE_APP_ID ,   
			ENTERPRISE_ID,    
			IP_ADDRESS,       
			USER_AGENT 
        )
        VALUES (
            CHM_CLAIM_FILES_AUDIT_SEQ.NEXTVAL,
            :NEW.FILE_ID,
            :OLD.FILE_NAME,
            :NEW.FILE_NAME,
            :OLD.FILE_PATH,
            :NEW.FILE_PATH,
            :OLD.FILE_CONTENT,
            :NEW.FILE_CONTENT,
            :OLD.SHEET_NAME,
            :NEW.SHEET_NAME,
            :OLD.FILE_STATUS,
            :NEW.FILE_STATUS,
            :OLD.CLAIM_TYPE,
            :NEW.CLAIM_TYPE,
            'UPDATE',
            :OLD.BATCH_REFERENCE,
            :NEW.BATCH_REFERENCE,
            :OLD.FILE_TYPE,
            :NEW.FILE_TYPE,
            :new.attribute_context,
            :new.attribute1,
            :new.attribute2,
            :new.attribute3,
            :new.attribute4,
            :new.attribute5,
            :new.attribute6,
            :new.attribute7,
            :new.attribute8,
            :new.attribute9,
            :new.attribute10,
            :new.attribute11,
            :new.attribute12,
            :new.attribute13,
            :new.attribute14,
            :new.attribute15,
            :new.created_by,
            :new.creation_date,
            :new.last_updated_by,
            :new.last_updated_date,
            :new.source_app_id,
            :new.enterprise_id,
            :new.ip_address,
            :new.user_agent,
			:old.attribute_context,
            :old.attribute1,
            :old.attribute2,
            :old.attribute3,
            :old.attribute4,
            :old.attribute5,
            :old.attribute6,
            :old.attribute7,
            :old.attribute8,
            :old.attribute9,
            :old.attribute10,
            :old.attribute11,
            :old.attribute12,
            :old.attribute13,
            :old.attribute14,
            :old.attribute15,
            :old.created_by,
            :old.creation_date,
            :old.last_updated_by,
            :old.last_updated_date,
            :old.source_app_id,
            :old.enterprise_id,
            :old.ip_address,
            :old.user_agent,
			NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATED_DATE ,SYSTIMESTAMP),
			NVL(:NEW.SOURCE_APP_ID, CHM_UTIL_PKG.GETSOURCEAPP('CHM')),
			NVL(:NEW.ENTERPRISE_ID, CHM_CONST_PKG.GETENTERPRISEID()),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );
    END IF;

    IF DELETING THEN
        INSERT INTO CHM_MSI_CLAIM_FILES_AUDIT (
            FILE_AUDIT_ID,
            FILE_ID,
            OLD_FILE_NAME,
            OLD_FILE_PATH,
            OLD_FILE_CONTENT,
            OLD_SHEET_NAME,
            OLD_FILE_STATUS,
            OLD_CLAIM_TYPE,
            ACTION,
            OLD_BATCH_REFERENCE,
            OLD_FILE_TYPE,
            old_attribute_context,
            old_attribute1,
            old_attribute2,
            old_attribute3,
            old_attribute4,
            old_attribute5,
            old_attribute6,
            old_attribute7,
            old_attribute8,
            old_attribute9,
            old_attribute10,
            old_attribute11,
            old_attribute12,
            old_attribute13,
            old_attribute14,
            old_attribute15,
            old_created_by,
            old_creation_date,
            old_last_updated_by,
            old_last_updated_date,
            old_source_app_id,
            old_enterprise_id,
            old_ip_address,
            old_user_agent,
			CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,
			SOURCE_APP_ID ,   
			ENTERPRISE_ID,    
			IP_ADDRESS,       
			USER_AGENT 
        )
        VALUES (
            CHM_CLAIM_FILES_AUDIT_SEQ.NEXTVAL,
            :OLD.FILE_ID,
            :OLD.FILE_NAME,
            :OLD.FILE_PATH,
            :OLD.FILE_CONTENT,
            :OLD.SHEET_NAME,
            :OLD.FILE_STATUS,
            :OLD.CLAIM_TYPE,
            'DELETE',
            :OLD.BATCH_REFERENCE,
            :OLD.FILE_TYPE,
            :old.attribute_context,
            :old.attribute1,
            :old.attribute2,
            :old.attribute3,
            :old.attribute4,
            :old.attribute5,
            :old.attribute6,
            :old.attribute7,
            :old.attribute8,
            :old.attribute9,
            :old.attribute10,
            :old.attribute11,
            :old.attribute12,
            :old.attribute13,
            :old.attribute14,
            :old.attribute15,
            :old.created_by,
            :old.creation_date,
            :old.last_updated_by,
            :old.last_updated_date,
            :old.source_app_id,
            :old.enterprise_id,
            :old.ip_address,
            :old.user_agent,
			NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATED_DATE ,SYSTIMESTAMP),
			NVL(:NEW.SOURCE_APP_ID, CHM_UTIL_PKG.GETSOURCEAPP('CHM')),
			NVL(:NEW.ENTERPRISE_ID, CHM_CONST_PKG.GETENTERPRISEID()),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );
    END IF;
END;
/
ALTER TRIGGER "AIU_CHM_MSI_CLAIM_FILES" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "BIU_CHM_MSI_CLAIM_FILES" BEFORE
    INSERT OR UPDATE ON CHM_MSI_CLAIM_FILES
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.FILE_ID IS NULL THEN
            :NEW.FILE_ID := CHM_CLAIM_FILES_SEQ.NEXTVAL;
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
ALTER TRIGGER "BIU_CHM_MSI_CLAIM_FILES" ENABLE;