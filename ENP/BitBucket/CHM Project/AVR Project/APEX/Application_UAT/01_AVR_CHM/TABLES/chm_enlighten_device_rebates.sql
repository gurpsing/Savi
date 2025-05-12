
  CREATE TABLE "CHM_ENLIGHTEN_DEVICE_REBATES" 
   (	"CHM_DEVICE_REBATE_ID" NUMBER DEFAULT CHM.CHM_ENLIGHTEN_DEVICE_DETAILS_SEQ.NEXTVAL, 
	"CHM_ENLIGHTEN_DEVICE_ID" NUMBER NOT NULL ENABLE, 
	"SPA_NUMBER" VARCHAR2(4000) NOT NULL ENABLE, 
	"SPA_LINE_ID" NUMBER NOT NULL ENABLE, 
	"DEVICE_ITEM_NUMBER" VARCHAR2(4000) NOT NULL ENABLE, 
	"REBATE_ITEM_NUMBER" VARCHAR2(4000) NOT NULL ENABLE, 
	"REBATE_TYPE" VARCHAR2(4000) NOT NULL ENABLE, 
	"REBATE_TIER" VARCHAR2(4000), 
	"SPA_ORIGINAL_AMOUNT" NUMBER, 
	"CLAIM_DATE" DATE NOT NULL ENABLE, 
	"REBATE_CURRENCY" VARCHAR2(4000) NOT NULL ENABLE, 
	"REBATE_AMOUNT" NUMBER NOT NULL ENABLE, 
	"REBATE_SOURCE" VARCHAR2(4000) NOT NULL ENABLE, 
	"REBATE_STATUS" VARCHAR2(4000) NOT NULL ENABLE, 
	"CLAIM_BATCH_ID" NUMBER, 
	"CLAIM_LINE_ID" NUMBER, 
	"REBATE_PAYEE_TYPE" VARCHAR2(4000) NOT NULL ENABLE, 
	"REBATE_PAYEE_ID" NUMBER NOT NULL ENABLE, 
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
	"LAST_UPDATE_DATE" TIMESTAMP (6) WITH TIME ZONE, 
	"IP_ADDRESS" VARCHAR2(4000), 
	"USER_AGENT" VARCHAR2(4000), 
	"CHM_ENLIGHTEN_SITE_ID" NUMBER, 
	"ORACLE_AP_INVOICE_ID" NUMBER, 
	"ORACLE_AP_INVOICE_NUMBER" VARCHAR2(4000), 
	 CONSTRAINT "CHM_ENLIGHTEN_DEVICE_REBATES_PK" PRIMARY KEY ("CHM_DEVICE_REBATE_ID")
  USING INDEX  ENABLE
   ) ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_AP_INV_ID_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("ORACLE_AP_INVOICE_ID") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_AP_INV_NUM_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("ORACLE_AP_INVOICE_NUMBER") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_CHM_ENLIGHTEN_DEVICE_ID_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("CHM_ENLIGHTEN_DEVICE_ID") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_CLAIM_BATCH_ID_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("CLAIM_BATCH_ID") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_DATE_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("CLAIM_DATE") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_EN_SITE_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("CHM_ENLIGHTEN_SITE_ID") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_PAYEE_ID_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("REBATE_PAYEE_ID") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_PAYEE_TYPE_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("REBATE_PAYEE_TYPE") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_SPA_NUMBER_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("SPA_NUMBER") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_STATUS_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("REBATE_STATUS") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_REBATES_TYPE_IDX" ON "CHM_ENLIGHTEN_DEVICE_REBATES" ("REBATE_TYPE") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BIU_CHM_ENLIGHTEN_DEVICE_REBATE" 
  BEFORE INSERT OR UPDATE ON CHM_ENLIGHTEN_DEVICE_REBATES
  FOR EACH ROW
   BEGIN
      IF INSERTING THEN

        :NEW.CREATED_BY         := NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME());
        :NEW.CREATION_DATE      := NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP);
        :NEW.LAST_UPDATED_BY    := NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME());
        :NEW.LAST_UPDATE_DATE   := NVL(:NEW.LAST_UPDATE_DATE ,SYSTIMESTAMP) ;
        :NEW.IP_ADDRESS         := NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS());
        :NEW.USER_AGENT         := NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT());

      ELSIF updating THEN
        :NEW.LAST_UPDATED_BY :=
            CASE
                WHEN :OLD.LAST_UPDATED_BY != :NEW.LAST_UPDATED_BY THEN
                    :NEW.LAST_UPDATED_BY
                ELSE CHM_UTIL_PKG.GETUSERNAME()
            END;

        :NEW.LAST_UPDATE_DATE :=
            CASE
                WHEN :OLD.LAST_UPDATE_DATE != :NEW.LAST_UPDATE_DATE THEN
                    :NEW.LAST_UPDATE_DATE
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
       EXCEPTION
  WHEN OTHERS THEN
    chm_msi_debug_api.log_msg(:NEW.CHM_DEVICE_REBATE_ID, 'BIU_CHM_ENLIGHTEN_DEVICE_REBATE', SQLERRM);
    END;

/
ALTER TRIGGER "BIU_CHM_ENLIGHTEN_DEVICE_REBATE" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "AIU_CHM_ENLIGHTEN_DEVICE_REBATES" AFTER
    INSERT OR UPDATE OR DELETE ON chm_enlighten_device_rebates
    FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO chm_enlighten_device_rebates_audit (
            chm_enlighten_device_rebates_audit_id,
            CHM_DEVICE_REBATE_ID,
            new_chm_enlighten_device_id,
            new_spa_number,
            new_spa_line_id,
            new_device_item_number,
            new_rebate_item_number,
            new_rebate_type,
            new_rebate_tier,
            new_spa_original_amount,
            new_claim_date,
            new_rebate_currency,
            new_rebate_amount,
            new_rebate_source,
            new_rebate_status,
            new_claim_batch_id,
            new_claim_line_id,
            new_rebate_payee_type,
            new_rebate_payee_id,
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
            new_last_update_date,
            new_ip_address,
            new_user_agent,
            new_chm_enlighten_site_id,
            new_oracle_ap_invoice_id,
            new_oracle_ap_invoice_number,
            action,
            CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,
			IP_ADDRESS,       
			USER_AGENT
        ) VALUES (
            chm_enlighten_device_rebates_audit_seq.NEXTVAL,
            :new.chm_device_rebate_id,
            :new.chm_enlighten_device_id,
            :new.spa_number,
            :new.spa_line_id,
            :new.device_item_number,
            :new.rebate_item_number,
            :new.rebate_type,
            :new.rebate_tier,
            :new.spa_original_amount,
            :new.claim_date,
            :new.rebate_currency,
            :new.rebate_amount,
            :new.rebate_source,
            :new.rebate_status,
            :new.claim_batch_id,
            :new.claim_line_id,
            :new.rebate_payee_type,
            :new.rebate_payee_id,
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
            :new.last_update_date,
            :new.ip_address,
            :new.user_agent,
            :new.chm_enlighten_site_id,
            :new.oracle_ap_invoice_id,
            :new.oracle_ap_invoice_number,
            'INSERT',
            NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATE_DATE ,SYSTIMESTAMP),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );

    ELSIF updating THEN
        INSERT INTO chm_enlighten_device_rebates_audit (
            chm_enlighten_device_rebates_audit_id,
            CHM_DEVICE_REBATE_ID,
            old_chm_enlighten_device_id,
            old_spa_number,
            old_spa_line_id,
            old_device_item_number,
            old_rebate_item_number,
            old_rebate_type,
            old_rebate_tier,
            old_spa_original_amount,
            old_claim_date,
            old_rebate_currency,
            old_rebate_amount,
            old_rebate_source,
            old_rebate_status,
            old_claim_batch_id,
            old_claim_line_id,
            old_rebate_payee_type,
            old_rebate_payee_id,
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
            old_last_update_date,
            old_ip_address,
            old_user_agent,
            old_chm_enlighten_site_id,
            old_oracle_ap_invoice_id,
            old_oracle_ap_invoice_number,
            new_chm_enlighten_device_id,
            new_spa_number,
            new_spa_line_id,
            new_device_item_number,
            new_rebate_item_number,
            new_rebate_type,
            new_rebate_tier,
            new_spa_original_amount,
            new_claim_date,
            new_rebate_currency,
            new_rebate_amount,
            new_rebate_source,
            new_rebate_status,
            new_claim_batch_id,
            new_claim_line_id,
            new_rebate_payee_type,
            new_rebate_payee_id,
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
            new_last_update_date,
            new_ip_address,
            new_user_agent,
            new_chm_enlighten_site_id,
            new_oracle_ap_invoice_id,
            new_oracle_ap_invoice_number,
            action,
            CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,  
			IP_ADDRESS,       
			USER_AGENT
        ) VALUES (
            chm_enlighten_device_rebates_audit_seq.NEXTVAL,
            :new.chm_device_rebate_id,
            :old.chm_enlighten_device_id,
            :old.spa_number,
            :old.spa_line_id,
            :old.device_item_number,
            :old.rebate_item_number,
            :old.rebate_type,
            :old.rebate_tier,
            :old.spa_original_amount,
            :old.claim_date,
            :old.rebate_currency,
            :old.rebate_amount,
            :old.rebate_source,
            :old.rebate_status,
            :old.claim_batch_id,
            :old.claim_line_id,
            :old.rebate_payee_type,
            :old.rebate_payee_id,
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
            :old.last_update_date,
            :old.ip_address,
            :old.user_agent,
            :old.chm_enlighten_site_id,
            :old.oracle_ap_invoice_id,
            :old.oracle_ap_invoice_number,
            :new.chm_enlighten_device_id,
            :new.spa_number,
            :new.spa_line_id,
            :new.device_item_number,
            :new.rebate_item_number,
            :new.rebate_type,
            :new.rebate_tier,
            :new.spa_original_amount,
            :new.claim_date,
            :new.rebate_currency,
            :new.rebate_amount,
            :new.rebate_source,
            :new.rebate_status,
            :new.claim_batch_id,
            :new.claim_line_id,
            :new.rebate_payee_type,
            :new.rebate_payee_id,
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
            :new.last_update_date,
            :new.ip_address,
            :new.user_agent,
            :new.chm_enlighten_site_id,
            :new.oracle_ap_invoice_id,
            :new.oracle_ap_invoice_number,
            'UPDATE',
            NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATE_DATE ,SYSTIMESTAMP),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );

    ELSIF deleting THEN
        INSERT INTO chm_enlighten_device_rebates_audit (
            chm_enlighten_device_rebates_audit_id,
            CHM_DEVICE_REBATE_ID,
            old_chm_enlighten_device_id,
            old_spa_number,
            old_spa_line_id,
            old_device_item_number,
            old_rebate_item_number,
            old_rebate_type,
            old_rebate_tier,
            old_spa_original_amount,
            old_claim_date,
            old_rebate_currency,
            old_rebate_amount,
            old_rebate_source,
            old_rebate_status,
            old_claim_batch_id,
            old_claim_line_id,
            old_rebate_payee_type,
            old_rebate_payee_id,
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
            old_last_update_date,
            old_ip_address,
            old_user_agent,
            old_chm_enlighten_site_id,
            old_oracle_ap_invoice_id,
            old_oracle_ap_invoice_number,
            action,
            CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,    
			IP_ADDRESS,       
			USER_AGENT
        ) VALUES (
            chm_enlighten_device_rebates_audit_seq.NEXTVAL,
            :old.chm_device_rebate_id,
            :old.chm_enlighten_device_id,
            :old.spa_number,
            :old.spa_line_id,
            :old.device_item_number,
            :old.rebate_item_number,
            :old.rebate_type,
            :old.rebate_tier,
            :old.spa_original_amount,
            :old.claim_date,
            :old.rebate_currency,
            :old.rebate_amount,
            :old.rebate_source,
            :old.rebate_status,
            :old.claim_batch_id,
            :old.claim_line_id,
            :old.rebate_payee_type,
            :old.rebate_payee_id,
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
            :old.last_update_date,
            :old.ip_address,
            :old.user_agent,
            :old.chm_enlighten_site_id,
            :old.oracle_ap_invoice_id,
            :old.oracle_ap_invoice_number,
            'DELETE',
            NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATE_DATE ,SYSTIMESTAMP),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );

    END IF;
END;
/
ALTER TRIGGER "AIU_CHM_ENLIGHTEN_DEVICE_REBATES" ENABLE;