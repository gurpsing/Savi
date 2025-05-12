
  CREATE TABLE "CHM_ENLIGHTEN_DEVICE_DETAILS" 
   (	"CHM_ENLIGHTEN_DEVICE_ID" NUMBER DEFAULT CHM.CHM_ENLIGHTEN_DEVICE_DETAILS_SEQ.NEXTVAL, 
	"SITE_ID" NUMBER, 
	"SERIAL_NUM" VARCHAR2(4000), 
	"TYPE" VARCHAR2(4000), 
	"HW_PART_NUM" VARCHAR2(4000), 
	"SKU" VARCHAR2(4000), 
	"RETIRED" VARCHAR2(4000), 
	"CREATED_DATE" DATE, 
	"FIRST_INTERVAL_END_DATE" DATE, 
	"PARENT_SERIAL_NUM" NUMBER, 
	"PV_MODULE_MANUFACTURER_NAME" VARCHAR2(4000), 
	"PV_MODULE_MODEL_NAME" VARCHAR2(4000), 
	"PV_MODULE_DCW" NUMBER, 
	"PV_MODULE_CELL_COUNT" NUMBER, 
	"SW_VERSION" VARCHAR2(4000), 
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
	 CONSTRAINT "UNIQUE_SERIAL_NUM" UNIQUE ("SERIAL_NUM")
  USING INDEX  ENABLE, 
	 CONSTRAINT "PK_CHM_ENLIGHTEN_DEVICE_ID" PRIMARY KEY ("CHM_ENLIGHTEN_DEVICE_ID")
  USING INDEX  ENABLE
   ) ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_DETAILS_BATCH_IDX" ON "CHM_ENLIGHTEN_DEVICE_DETAILS" ("ATTRIBUTE2") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_DETAILS_FIRST_DATE_IDX" ON "CHM_ENLIGHTEN_DEVICE_DETAILS" ("FIRST_INTERVAL_END_DATE") 
  ;

  CREATE INDEX "CHM_ENLIGHTEN_DEVICE_DETAILS_SKU_IDX" ON "CHM_ENLIGHTEN_DEVICE_DETAILS" ("SKU") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "AIU_CHM_ENLIGHTEN_DEVICE_DETAILS_TRG" AFTER
    INSERT OR UPDATE OR DELETE ON chm_enlighten_device_details
    FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO chm_enlighten_device_details_audit (
            chm_enlighten_device_details_audit_id,
            CHM_ENLIGHTEN_DEVICE_ID,
            new_site_id,
            new_serial_num,
            new_type,
            new_hw_part_num,
            new_sku,
            new_retired,
            new_created_date,
            new_first_interval_end_date,
            new_parent_serial_num,
            new_pv_module_manufacturer_name,
            new_pv_module_model_name,
            new_pv_module_dcw,
            new_pv_module_cell_count,
            new_sw_version,
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
            action,
			CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,
			--SOURCE_APP_ID ,   
			--ENTERPRISE_ID,    
			IP_ADDRESS,       
			USER_AGENT
        ) VALUES (
            chm_enlighten_device_details_audit_seq.NEXTVAL,
            :new.CHM_ENLIGHTEN_DEVICE_ID,
            :new.site_id,
            :new.serial_num,
            :new.type,
            :new.hw_part_num,
            :new.sku,
            :new.retired,
            :new.created_date,
            :new.first_interval_end_date,
            :new.parent_serial_num,
            :new.pv_module_manufacturer_name,
            :new.pv_module_model_name,
            :new.pv_module_dcw,
            :new.pv_module_cell_count,
            :new.sw_version,
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
            'INSERT',
			NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATE_DATE ,SYSTIMESTAMP),
			--NVL(:NEW.SOURCE_APP_ID, CHM_UTIL_PKG.GETSOURCEAPP('CHM')),
			--NVL(:NEW.ENTERPRISE_ID, CHM_CONST_PKG.GETENTERPRISEID()),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );

    ELSIF updating THEN
        INSERT INTO chm_enlighten_device_details_audit (
            chm_enlighten_device_details_audit_id,
            CHM_ENLIGHTEN_DEVICE_ID,
            old_site_id,
            new_site_id,
            old_serial_num,
            new_serial_num,
            old_type,
            new_type,
            old_hw_part_num,
            new_hw_part_num,
            old_sku,
            new_sku,
            old_retired,
            new_retired,
            old_created_date,
            new_created_date,
            old_first_interval_end_date,
            new_first_interval_end_date,
            old_parent_serial_num,
            new_parent_serial_num,
            old_pv_module_manufacturer_name,
            new_pv_module_manufacturer_name,
            old_pv_module_model_name,
            new_pv_module_model_name,
            old_pv_module_dcw,
            new_pv_module_dcw,
            old_pv_module_cell_count,
            new_pv_module_cell_count,
            old_sw_version,
            new_sw_version,
            old_attribute1,
            new_attribute1,
            old_attribute2,
            new_attribute2,
            old_attribute3,
            new_attribute3,
            old_attribute4,
            new_attribute4,
            old_attribute5,
            new_attribute5,
            old_attribute6,
            new_attribute6,
            old_attribute7,
            new_attribute7,
            old_attribute8,
            new_attribute8,
            old_attribute9,
            new_attribute9,
            old_attribute10,
            new_attribute10,
            old_attribute11,
            new_attribute11,
            old_attribute12,
            new_attribute12,
            old_attribute13,
            new_attribute13,
            old_attribute14,
            new_attribute14,
            old_attribute15,
            new_attribute15,
            old_created_by,
            new_created_by,
            old_creation_date,
            new_creation_date,
            old_last_updated_by,
            new_last_updated_by,
            old_last_update_date,
            new_last_update_date,
            old_ip_address,
            new_ip_address,
            old_user_agent,
            new_user_agent,
            action,
			CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,
			--SOURCE_APP_ID ,   
			--ENTERPRISE_ID,    
			IP_ADDRESS,       
			USER_AGENT
        ) VALUES (
            chm_enlighten_device_details_audit_seq.NEXTVAL,
            :old.CHM_ENLIGHTEN_DEVICE_ID,
            :old.site_id,
            :new.site_id,
            :old.serial_num,
			:new.serial_num,
            :old.type,
			:new.type,
            :old.hw_part_num,
			:new.hw_part_num,
            :old.sku,
			:new.sku,
            :old.retired,
			:new.retired,
            :old.created_date,
			:new.created_date,
            :old.first_interval_end_date,
			:new.first_interval_end_date,
            :old.parent_serial_num,
			:new.parent_serial_num,
            :old.pv_module_manufacturer_name,
			:new.pv_module_manufacturer_name,
            :old.pv_module_model_name,
			:new.pv_module_model_name,
            :old.pv_module_dcw,
			:new.pv_module_dcw,
            :old.pv_module_cell_count,
			:new.pv_module_cell_count,
            :old.sw_version,
			:new.sw_version,
            :old.attribute1,
			:new.attribute1,
            :old.attribute2,
			:new.attribute2,
            :old.attribute3,
			:new.attribute3,
            :old.attribute4,
			:new.attribute4,
            :old.attribute5,
			:new.attribute5,
            :old.attribute6,
			:new.attribute6,
            :old.attribute7,
			:new.attribute7,
            :old.attribute8,
			:new.attribute8,
            :old.attribute9,
			:new.attribute9,
            :old.attribute10,
			:new.attribute10,
            :old.attribute11,
			:new.attribute11,
            :old.attribute12,
			:new.attribute12,
            :old.attribute13,
			:new.attribute13,
            :old.attribute14,
			:new.attribute14,
            :old.attribute15,
			:new.attribute15,
            :old.created_by,
			:new.created_by,
            :old.creation_date,
			:new.creation_date,
            :old.last_updated_by,
			:new.last_updated_by,
            :old.last_update_date,
			:new.last_update_date,
            :old.ip_address,
			:new.ip_address,
            :old.user_agent,
			:new.user_agent,
			'UPDATE',
			NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATE_DATE ,SYSTIMESTAMP),
			--NVL(:NEW.SOURCE_APP_ID, CHM_UTIL_PKG.GETSOURCEAPP('CHM')),
			--NVL(:NEW.ENTERPRISE_ID, CHM_CONST_PKG.GETENTERPRISEID()),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );

    ELSIF deleting THEN
        INSERT INTO chm_enlighten_device_details_audit (
            chm_enlighten_device_details_audit_id,
            CHM_ENLIGHTEN_DEVICE_ID,
            old_site_id,
            old_serial_num,
            old_type,
            old_hw_part_num,
            old_sku,
            old_retired,
            old_created_date,
            old_first_interval_end_date,
            old_parent_serial_num,
            old_pv_module_manufacturer_name,
            old_pv_module_model_name,
            old_pv_module_dcw,
            old_pv_module_cell_count,
            old_sw_version,
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
            action,
			CREATED_BY,       
			CREATION_DATE,    
			LAST_UPDATED_BY,  
			LAST_UPDATED_DATE,
			--SOURCE_APP_ID ,   
			--ENTERPRISE_ID,    
			IP_ADDRESS,       
			USER_AGENT
        ) VALUES (
            chm_enlighten_device_details_audit_seq.NEXTVAL,
            :old.CHM_ENLIGHTEN_DEVICE_ID,
            :old.site_id,
            :old.serial_num,
            :old.type,
            :old.hw_part_num,
            :old.sku,
            :old.retired,
            :old.created_date,
            :old.first_interval_end_date,
            :old.parent_serial_num,
            :old.pv_module_manufacturer_name,
            :old.pv_module_model_name,
            :old.pv_module_dcw,
            :old.pv_module_cell_count,
            :old.sw_version,
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
            'DELETE',
			NVL(:NEW.CREATED_BY , CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.CREATION_DATE ,SYSTIMESTAMP),
			NVL(:NEW.LAST_UPDATED_BY, CHM_UTIL_PKG.GETUSERNAME()),
			NVL(:NEW.LAST_UPDATE_DATE ,SYSTIMESTAMP),
			--NVL(:NEW.SOURCE_APP_ID, CHM_UTIL_PKG.GETSOURCEAPP('CHM')),
			--NVL(:NEW.ENTERPRISE_ID, CHM_CONST_PKG.GETENTERPRISEID()),
			NVL(:NEW.IP_ADDRESS,CHM_UTIL_PKG.GETIPADDRESS()),
			NVL(:NEW.USER_AGENT,CHM_UTIL_PKG.GETUSERAGENT())
        );

    END IF;
END;
/
ALTER TRIGGER "AIU_CHM_ENLIGHTEN_DEVICE_DETAILS_TRG" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "BIU_CHM_ENLIGHTEN_DEVICE_DETAILS" 
  BEFORE INSERT OR UPDATE ON CHM_ENLIGHTEN_DEVICE_DETAILS
  FOR EACH ROW
   BEGIN
      IF INSERTING THEN
        IF :new.CHM_ENLIGHTEN_DEVICE_ID  IS NULL THEN
            :new.CHM_ENLIGHTEN_DEVICE_ID   := CHM_ENLIGHTEN_SITE_MASTER_SEQ.NEXTVAL;
        END IF; 

       -- :NEW.attribute10 := chm_util_pkg.removespecialwords(:NEW.TYPE);

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

        --:NEW.attribute10 := chm_util_pkg.removespecialwords(:NEW.TYPE);
              END IF;
       EXCEPTION
  WHEN OTHERS THEN
    CHM_MSI_DEBUG_API.log_msg(:new.SITE_ID, 'BIU_CHM_ENLIGHTEN_DEVICE_DETAILS', SQLERRM);
    END;

/
ALTER TRIGGER "BIU_CHM_ENLIGHTEN_DEVICE_DETAILS" ENABLE;