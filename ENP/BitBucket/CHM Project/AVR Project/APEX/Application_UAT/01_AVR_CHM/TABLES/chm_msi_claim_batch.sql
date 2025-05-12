
  CREATE TABLE "CHM_MSI_CLAIM_BATCH" 
   (	"BATCH_ID" NUMBER NOT NULL ENABLE, 
	"FILE_ID" NUMBER, 
	"PAYEE_ID" NUMBER, 
	"PAYEE_TYPE" VARCHAR2(4000), 
	"BATCH_STATUS" VARCHAR2(4000), 
	"BATCH_START_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"BATCH_END_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"BATCH_SOURCE" VARCHAR2(100), 
	"CLAIM_TYPE" VARCHAR2(100), 
	"BATCH_REFERENCE" VARCHAR2(4000), 
	"RUN_ID" NUMBER, 
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
	"CREATED_BY" VARCHAR2(50), 
	"CREATION_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"LAST_UPDATED_BY" VARCHAR2(50), 
	"LAST_UPDATED_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"SOURCE_APP_ID" NUMBER, 
	"ENTERPRISE_ID" NUMBER, 
	"IP_ADDRESS" VARCHAR2(4000), 
	"USER_AGENT" VARCHAR2(4000), 
	"REPORT_REQUEST_ID" NUMBER, 
	"AP_INVOICE_REQUEST_ID" NUMBER
   ) ;

  CREATE INDEX "CHM_MSI_CLAIM_BATCH_CALIM_TYPE_IDX" ON "CHM_MSI_CLAIM_BATCH" ("CLAIM_TYPE") 
  ;

  CREATE UNIQUE INDEX "CHM_MSI_CLAIM_BATCH_ID_IDX" ON "CHM_MSI_CLAIM_BATCH" ("BATCH_ID") 
  ;

  CREATE INDEX "CHM_MSI_CLAIM_BATCH_INV_REQUEST_ID_IDX" ON "CHM_MSI_CLAIM_BATCH" ("AP_INVOICE_REQUEST_ID") 
  ;

  CREATE INDEX "CHM_MSI_CLAIM_BATCH_REP_REQUEST_ID_IDX" ON "CHM_MSI_CLAIM_BATCH" ("REPORT_REQUEST_ID") 
  ;

  CREATE INDEX "CHM_MSI_CLAIM_BATCH_SOURCE_IDX" ON "CHM_MSI_CLAIM_BATCH" ("BATCH_SOURCE") 
  ;

  CREATE INDEX "CHM_MSI_CLAIM_BATCH_STATUS_IDX" ON "CHM_MSI_CLAIM_BATCH" ("BATCH_STATUS") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "AIU_CHM_MSI_CLAIM_BATCH" 
AFTER INSERT OR UPDATE OR DELETE ON CHM_MSI_CLAIM_BATCH
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO CHM_MSI_CLAIM_BATCH_AUDIT (
            BATCH_AUDIT_ID
,BATCH_ID
,NEW_FILE_ID
,NEW_PAYEE_ID
,NEW_PAYEE_TYPE
,NEW_BATCH_STATUS
,NEW_BATCH_SOURCE
,NEW_BATCH_START_DATE
,NEW_BATCH_END_DATE
,NEW_CLAIM_TYPE
,NEW_BATCH_REFERENCE
,NEW_RUN_ID
,ACTION
,NEW_ATTRIBUTE_CONTEXT
,NEW_ATTRIBUTE1
,NEW_ATTRIBUTE2
,NEW_ATTRIBUTE3
,NEW_ATTRIBUTE4
,NEW_ATTRIBUTE5
,NEW_ATTRIBUTE6
,NEW_ATTRIBUTE7
,NEW_ATTRIBUTE8
,NEW_ATTRIBUTE9
,NEW_ATTRIBUTE10
,NEW_ATTRIBUTE11
,NEW_ATTRIBUTE12
,NEW_ATTRIBUTE13
,NEW_ATTRIBUTE14
,NEW_ATTRIBUTE15
,NEW_CREATED_BY
,NEW_CREATION_DATE
,NEW_LAST_UPDATED_BY
,NEW_LAST_UPDATED_DATE
,NEW_SOURCE_APP_ID
,NEW_ENTERPRISE_ID
,NEW_IP_ADDRESS
,NEW_USER_AGENT
,NEW_REPORT_REQUEST_ID
,NEW_AP_INVOICE_REQUEST_ID
,CREATED_BY      
,CREATION_DATE    
,LAST_UPDATED_BY  
,LAST_UPDATED_DATE
,SOURCE_APP_ID    
,ENTERPRISE_ID    
,IP_ADDRESS       
,USER_AGENT
        ) VALUES (
           CHM_MSI_CLAIM_BATCH_AUDIT_SEQ.NEXTVAL,
            :NEW.BATCH_ID,
            :NEW.FILE_ID,
            :NEW.PAYEE_ID,
            :NEW.PAYEE_TYPE,
            :NEW.BATCH_STATUS,
            :NEW.BATCH_SOURCE,
            :NEW.BATCH_START_DATE,
            :NEW.BATCH_END_DATE,
            :NEW.CLAIM_TYPE,
            :NEW.BATCH_REFERENCE,
            :NEW.RUN_ID,
            'INSERT',
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
            :new.REPORT_REQUEST_ID,
			:new.AP_INVOICE_REQUEST_ID,
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
        INSERT INTO CHM_MSI_CLAIM_BATCH_AUDIT (
            BATCH_AUDIT_ID,
			BATCH_ID,
			OLD_FILE_ID,
			NEW_FILE_ID,
			OLD_PAYEE_ID,
			NEW_PAYEE_ID,
			OLD_PAYEE_TYPE,
			NEW_PAYEE_TYPE,
			OLD_BATCH_STATUS,
			NEW_BATCH_STATUS,
			OLD_BATCH_SOURCE,
			NEW_BATCH_SOURCE,
			OLD_BATCH_START_DATE,
			NEW_BATCH_START_DATE,
			OLD_BATCH_END_DATE,
			NEW_BATCH_END_DATE,
			OLD_CLAIM_TYPE,
			NEW_CLAIM_TYPE,
			OLD_BATCH_REFERENCE,
			NEW_BATCH_REFERENCE,
			OLD_RUN_ID,
			NEW_RUN_ID,
			ACTION,
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
			OLD_REPORT_REQUEST_ID,
			NEW_REPORT_REQUEST_ID,
			OLD_AP_INVOICE_REQUEST_ID,
			NEW_AP_INVOICE_REQUEST_ID,
			CREATED_BY,
			CREATION_DATE,
			LAST_UPDATED_BY,
			LAST_UPDATED_DATE,
			SOURCE_APP_ID,
			ENTERPRISE_ID,
			IP_ADDRESS,
			USER_AGENT
        ) VALUES (
            CHM_MSI_CLAIM_BATCH_AUDIT_SEQ.NEXTVAL,
            :NEW.BATCH_ID,
            :OLD.FILE_ID,
            :NEW.FILE_ID,
            :OLD.PAYEE_ID,
            :NEW.PAYEE_ID,
            :OLD.PAYEE_TYPE,
            :NEW.PAYEE_TYPE,
            :OLD.BATCH_STATUS,
            :NEW.BATCH_STATUS,
            :OLD.BATCH_SOURCE,
            :NEW.BATCH_SOURCE,
            :OLD.BATCH_START_DATE,
            :NEW.BATCH_START_DATE,
            :OLD.BATCH_END_DATE,
            :NEW.BATCH_END_DATE,
            :OLD.CLAIM_TYPE,
            :NEW.CLAIM_TYPE,
            :OLD.BATCH_REFERENCE,
            :NEW.BATCH_REFERENCE,
            :OLD.RUN_ID,
            :NEW.RUN_ID,
            'UPDATE',
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
			:old.REPORT_REQUEST_ID,
			:new.REPORT_REQUEST_ID,
			:old.AP_INVOICE_REQUEST_ID,
			:new.AP_INVOICE_REQUEST_ID,
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
        INSERT INTO CHM_MSI_CLAIM_BATCH_AUDIT (
            BATCH_AUDIT_ID
			,BATCH_ID
			,NEW_FILE_ID
			,NEW_PAYEE_ID
			,NEW_PAYEE_TYPE
			,NEW_BATCH_STATUS
			,NEW_BATCH_SOURCE
			,NEW_BATCH_START_DATE
			,NEW_BATCH_END_DATE
			,NEW_CLAIM_TYPE
			,NEW_BATCH_REFERENCE
			,NEW_RUN_ID
			,ACTION
			,NEW_ATTRIBUTE_CONTEXT
			,NEW_ATTRIBUTE1
			,NEW_ATTRIBUTE2
			,NEW_ATTRIBUTE3
			,NEW_ATTRIBUTE4
			,NEW_ATTRIBUTE5
			,NEW_ATTRIBUTE6
			,NEW_ATTRIBUTE7
			,NEW_ATTRIBUTE8
			,NEW_ATTRIBUTE9
			,NEW_ATTRIBUTE10
			,NEW_ATTRIBUTE11
			,NEW_ATTRIBUTE12
			,NEW_ATTRIBUTE13
			,NEW_ATTRIBUTE14
			,NEW_ATTRIBUTE15
			,NEW_CREATED_BY
			,NEW_CREATION_DATE
			,NEW_LAST_UPDATED_BY
			,NEW_LAST_UPDATED_DATE
			,NEW_SOURCE_APP_ID
			,NEW_ENTERPRISE_ID
			,NEW_IP_ADDRESS
			,NEW_USER_AGENT
			,NEW_REPORT_REQUEST_ID
			,NEW_AP_INVOICE_REQUEST_ID
			,CREATED_BY      
			,CREATION_DATE    
			,LAST_UPDATED_BY  
			,LAST_UPDATED_DATE
			,SOURCE_APP_ID    
			,ENTERPRISE_ID    
			,IP_ADDRESS       
			,USER_AGENT
        ) VALUES (
           CHM_MSI_CLAIM_BATCH_AUDIT_SEQ.NEXTVAL,
            :old.BATCH_ID,
            :old.FILE_ID,
            :old.PAYEE_ID,
            :old.PAYEE_TYPE,
            :old.BATCH_STATUS,
            :old.BATCH_SOURCE,
            :old.BATCH_START_DATE,
            :old.BATCH_END_DATE,
            :old.CLAIM_TYPE,
            :old.BATCH_REFERENCE,
            :old.RUN_ID,
            'DELETE',
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
            :old.REPORT_REQUEST_ID,
			:old.AP_INVOICE_REQUEST_ID,
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
ALTER TRIGGER "AIU_CHM_MSI_CLAIM_BATCH" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "BIU_CHM_MSI_CLAIM_BATCH" BEFORE
    INSERT OR UPDATE ON CHM_MSI_CLAIM_BATCH
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.BATCH_ID IS NULL THEN
            :NEW.BATCH_ID := CHM_MSI_CLAIM_BATCH_SEQ.NEXTVAL;
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
ALTER TRIGGER "BIU_CHM_MSI_CLAIM_BATCH" ENABLE;