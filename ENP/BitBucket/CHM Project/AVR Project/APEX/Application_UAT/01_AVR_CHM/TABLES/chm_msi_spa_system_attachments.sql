
  CREATE TABLE "CHM_MSI_SPA_SYSTEM_ATTACHMENTS" 
   (	"CHM_MSI_SPA_SYS_ATTACHMENT_ID" NUMBER DEFAULT CHM.CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES_SEQ.NEXTVAL, 
	"ID" VARCHAR2(4000), 
	"MIN_QUANTITY" NUMBER, 
	"STATUS" VARCHAR2(4000) NOT NULL ENABLE, 
	"SFDC_CREATED_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"SFDC_LAST_UPDATE_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"SFDC_CREATED_BY" VARCHAR2(4000), 
	"SFDC_LAST_UPDATED_BY" VARCHAR2(4000), 
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
	"CREATED_BY" VARCHAR2(4000), 
	"CREATION_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"LAST_UPDATED_BY" VARCHAR2(4000), 
	"LAST_UPDATED_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"SOURCE_APP_ID" NUMBER, 
	"ENTERPRISE_ID" NUMBER, 
	"IP_ADDRESS" VARCHAR2(4000), 
	"USER_AGENT" VARCHAR2(4000), 
	"OIC_INSTANCE_ID" VARCHAR2(4000), 
	"IS_DELETED" VARCHAR2(4000), 
	"NAME" VARCHAR2(4000), 
	"CURRENCY_ISO_CODE" VARCHAR2(4000), 
	"SYSTEM_MOD_STAMP" VARCHAR2(4000), 
	"LAST_ACTIVITY_DATE" VARCHAR2(4000), 
	"LAST_VIEWED_DATE" VARCHAR2(4000), 
	"LAST_REFERENCED_DATE" VARCHAR2(4000), 
	"PER_UNIT_INCENTIVE" NUMBER(12,2) NOT NULL ENABLE, 
	"SPA" VARCHAR2(4000) NOT NULL ENABLE, 
	"UNIQUE_KEY" VARCHAR2(4000), 
	"PRODUCT" VARCHAR2(4000), 
	 CONSTRAINT "CHM_MSI_SPA_SYSTEM_ATTACHMENTS_PK" PRIMARY KEY ("CHM_MSI_SPA_SYS_ATTACHMENT_ID")
  USING INDEX  ENABLE
   ) ;

  CREATE INDEX "CHM_MSI_SPA_SYSTEM_ATTACHMENTS_ID_IDX" ON "CHM_MSI_SPA_SYSTEM_ATTACHMENTS" ("ID") 
  ;

  CREATE INDEX "CHM_MSI_SPA_SYS_ATTACH_SPA_IDX" ON "CHM_MSI_SPA_SYSTEM_ATTACHMENTS" ("SPA") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "AIU_CHM_MSI_SPA_SYSTEM_ATTACHMENT_TRG" AFTER
    INSERT OR UPDATE OR DELETE ON "CHM_MSI_SPA_SYSTEM_ATTACHMENTS"
    FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO chm_msi_spa_system_attachments_audit (
            chm_msi_spa_sys_attachment_audit_id,
            chm_msi_spa_sys_attachment_id,
            old_id,
            new_id,
            old_min_quantity,
            new_min_quantity,
            old_status,
            new_status,
            old_sfdc_created_date,
            new_sfdc_created_date,
            old_sfdc_last_update_date,
            new_sfdc_last_update_date,
            old_sfdc_created_by,
            new_sfdc_created_by,
            old_sfdc_last_updated_by,
            new_sfdc_last_updated_by,
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
			USER_AGENT,
			NEW_IS_DELETED,
			NEW_NAME,
			NEW_CURRENCY_ISO_CODE,
			NEW_SYSTEM_MOD_STAMP,
			NEW_LAST_VIEWED_DATE,
			NEW_LAST_REFERENCED_DATE,
			NEW_SPA,
			NEW_PER_UNIT_INCENTIVE,
			NEW_UNIQUE_KEY,
			NEW_PRODUCT
        ) VALUES (
            chm_msi_spa_system_attachment_incentives_audit_seq.NEXTVAL,
            :new.chm_msi_spa_sys_attachment_id,
            :old.id,
            :new.id,
            :old.min_quantity,
            :new.min_quantity,
            :old.status,
            :new.status,
            :old.sfdc_created_date,
            :new.sfdc_created_date,
            :old.sfdc_last_update_date,
            :new.sfdc_last_update_date,
            :old.sfdc_created_by,
            :new.sfdc_created_by,
            :old.sfdc_last_updated_by,
            :new.sfdc_last_updated_by,
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
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT()),
            :NEW.IS_DELETED,
			:NEW.NAME,
			:NEW.CURRENCY_ISO_CODE,
			:NEW.SYSTEM_MOD_STAMP,
			:NEW.LAST_VIEWED_DATE,
			:NEW.LAST_REFERENCED_DATE,
			:NEW.SPA,
			:NEW.PER_UNIT_INCENTIVE,
			:NEW.UNIQUE_KEY,
			:NEW.PRODUCT
        );

    ELSIF updating THEN
        INSERT INTO chm_msi_spa_system_attachments_audit (
            chm_msi_spa_sys_attachment_audit_id,
            chm_msi_spa_sys_attachment_id,
            old_id,
            new_id,
            old_min_quantity,
            new_min_quantity,
            old_status,
            new_status,
            old_sfdc_created_date,
            new_sfdc_created_date,
            old_sfdc_last_update_date,
            new_sfdc_last_update_date,
            old_sfdc_created_by,
            new_sfdc_created_by,
            old_sfdc_last_updated_by,
            new_sfdc_last_updated_by,
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
			USER_AGENT,
			OLD_IS_DELETED,
			NEW_IS_DELETED,
			OLD_NAME,
			NEW_NAME,
			OLD_CURRENCY_ISO_CODE,
			NEW_CURRENCY_ISO_CODE,
			OLD_SYSTEM_MOD_STAMP,
			NEW_SYSTEM_MOD_STAMP,
			OLD_LAST_VIEWED_DATE,
			NEW_LAST_VIEWED_DATE,
			OLD_LAST_REFERENCED_DATE,
			NEW_LAST_REFERENCED_DATE,
			OLD_SPA,
			NEW_SPA,
			OLD_PER_UNIT_INCENTIVE,
			NEW_PER_UNIT_INCENTIVE,
			OLD_UNIQUE_KEY,
			NEW_UNIQUE_KEY,
			OLD_PRODUCT,
			NEW_PRODUCT
        ) VALUES (
            chm_msi_spa_system_attachment_incentives_audit_seq.NEXTVAL,
            :old.chm_msi_spa_sys_attachment_id,
            :old.id,
            :new.id,
            :old.min_quantity,
            :new.min_quantity,
            :old.status,
            :new.status,
            :old.sfdc_created_date,
            :new.sfdc_created_date,
            :old.sfdc_last_update_date,
            :new.sfdc_last_update_date,
            :old.sfdc_created_by,
            :new.sfdc_created_by,
            :old.sfdc_last_updated_by,
            :new.sfdc_last_updated_by,
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
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT()),
			:OLD.IS_DELETED,
			:NEW.IS_DELETED,
			:OLD.NAME,
			:NEW.NAME,
			:OLD.CURRENCY_ISO_CODE,
			:NEW.CURRENCY_ISO_CODE,
			:OLD.SYSTEM_MOD_STAMP,
			:NEW.SYSTEM_MOD_STAMP,
			:OLD.LAST_VIEWED_DATE,
			:NEW.LAST_VIEWED_DATE,
			:OLD.LAST_REFERENCED_DATE,
			:NEW.LAST_REFERENCED_DATE,
			:OLD.SPA,
			:NEW.SPA,
			:OLD.PER_UNIT_INCENTIVE,
			:NEW.PER_UNIT_INCENTIVE,
			:OLD.UNIQUE_KEY,
			:NEW.UNIQUE_KEY,
			:OLD.PRODUCT,
			:NEW.PRODUCT
        );

    ELSIF deleting THEN
        INSERT INTO chm_msi_spa_system_attachments_audit (
            chm_msi_spa_sys_attachment_audit_id,
            chm_msi_spa_sys_attachment_id,
            old_id,
            new_id,
            old_min_quantity,
            new_min_quantity,
            old_status,
            new_status,
            old_sfdc_created_date,
            new_sfdc_created_date,
            old_sfdc_last_update_date,
            new_sfdc_last_update_date,
            old_sfdc_created_by,
            new_sfdc_created_by,
            old_sfdc_last_updated_by,
            new_sfdc_last_updated_by,
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
			USER_AGENT,
			OLD_IS_DELETED,
			OLD_NAME,
			OLD_CURRENCY_ISO_CODE,
			OLD_SYSTEM_MOD_STAMP,
			OLD_LAST_VIEWED_DATE,
			OLD_LAST_REFERENCED_DATE,
			OLD_SPA,
			OLD_PER_UNIT_INCENTIVE,
			OLD_UNIQUE_KEY,
			OLD_PRODUCT
        ) VALUES (
            chm_msi_spa_system_attachment_incentives_audit_seq.NEXTVAL,
            :old.chm_msi_spa_sys_attachment_id,
            :old.id,
            :new.id,
            :old.min_quantity,
            :new.min_quantity,
            :old.status,
            :new.status,
            :old.sfdc_created_date,
            :new.sfdc_created_date,
            :old.sfdc_last_update_date,
            :new.sfdc_last_update_date,
            :old.sfdc_created_by,
            :new.sfdc_created_by,
            :old.sfdc_last_updated_by,
            :new.sfdc_last_updated_by,
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
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT()),
			:OLD.IS_DELETED,
			:OLD.NAME,
			:OLD.CURRENCY_ISO_CODE,
			:OLD.SYSTEM_MOD_STAMP,
			:OLD.LAST_VIEWED_DATE,
			:OLD.LAST_REFERENCED_DATE,
			:OLD.SPA,
			:OLD.PER_UNIT_INCENTIVE,
			:OLD.UNIQUE_KEY,
			:OLD.PRODUCT
        );

    END IF;
END;
/
ALTER TRIGGER "AIU_CHM_MSI_SPA_SYSTEM_ATTACHMENT_TRG" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "BIU_CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES_TRG" 
  BEFORE INSERT OR UPDATE ON "CHM_MSI_SPA_SYSTEM_ATTACHMENTS"
  FOR EACH ROW
   BEGIN
      IF INSERTING THEN
        IF :new.CHM_MSI_SPA_SYS_ATTACHMENT_ID  IS NULL THEN
            :new.CHM_MSI_SPA_SYS_ATTACHMENT_ID   := CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES_SEQ.NEXTVAL;
        END IF;

       -- :NEW.attribute10 := chm_util_pkg.removespecialwords(:NEW.NAME);

        :NEW.CREATED_BY         := NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME());
        :NEW.CREATION_DATE      := NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP);
        :NEW.LAST_UPDATED_BY    := NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME());
        :NEW.LAST_UPDATED_DATE   := NVL(:NEW.LAST_UPDATED_DATE ,SYSTIMESTAMP) ;
        :NEW.IP_ADDRESS         := NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS());
        :NEW.USER_AGENT         := NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT());

        --We need to capture SYSDATE when CHM gets an update on Site 
        --where the stage crosses 3
        --Attribute 1 stores the date we captured that site crossed stage 3

      /*  IF NVL(:NEW.STAGE,0) >=3 THEN
          :NEW.ATTRIBUTE1 := TO_CHAR(SYSTIMESTAMP);
        END IF; */


      ELSIF updating THEN
        --We need to capture SYSDATE when CHM gets an update on Site 
        --where the stage crosses 3
        -- We dont wnat to update if ATTRIBUTE1 already cpatured this date earlier
        --so checking that OLD value is NULL and OLD stage is < 3 and new stage >=3

        --Attribute 1 stores the date we captured that site crossed stage 3

        /*IF :OLD.ATTRIBUTE1 IS NULL AND NVL(:OLD.STAGE,0)< 3 AND NVL(:NEW.STAGE,0) >=3 THEN
          :NEW.ATTRIBUTE1 := TO_CHAR(SYSTIMESTAMP);
        END IF;	*/

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

        --:NEW.attribute10 := chm_util_pkg.removespecialwords(:NEW.NAME);
              END IF;
       EXCEPTION
  WHEN OTHERS THEN
    chm_msi_debug_api.log_msg(:new.CHM_MSI_SPA_SYS_ATTACHMENT_ID || ', ' || :new.ID, 'BIU_CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES_TRG', SQLERRM);
    END;

/
ALTER TRIGGER "BIU_CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES_TRG" ENABLE;