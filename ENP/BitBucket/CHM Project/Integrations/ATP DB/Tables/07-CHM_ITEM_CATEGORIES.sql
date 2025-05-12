CREATE SEQUENCE CHM_ITEM_CATEGORY_SEQ           INCREMENT BY 1 MINVALUE 1;

CREATE TABLE CHM_ITEM_CATEGORIES(
     CHM_ITEM_CATEGORY_ID   		    NUMBER   DEFAULT  CHM_ITEM_CATEGORY_SEQ.NEXTVAL		 PRIMARY KEY
    ,SOURCE_CATEGORY_ID	                NUMBER              UNIQUE NOT NULL 
    ,LANGUAGE	                        VARCHAR2(4000)      NOT NULL
    ,CATEGORY_NAME 	                    VARCHAR2(4000)      NOT NULL            
    ,DESCRIPTION	                    VARCHAR2(4000)              
    ,CATEGORY_CONTENT_CODE	            VARCHAR2(4000)
    ,CATEGORY_CODE	                    VARCHAR2(4000)
    ,DISABLE_DATE	                    DATE
    ,SUMMARY_FLAG	                    CHAR(1)
    ,ATTRIBUTE_CATEGORY	                VARCHAR2(4000)
    ,ATTRIBUTE1	                        VARCHAR2(4000)
    ,ATTRIBUTE2	                        VARCHAR2(4000)
    ,ATTRIBUTE3	                        VARCHAR2(4000)
    ,ATTRIBUTE4	                        VARCHAR2(4000)
    ,ATTRIBUTE5	                        VARCHAR2(4000)
    ,ATTRIBUTE6	                        VARCHAR2(4000)
    ,ATTRIBUTE7	                        VARCHAR2(4000)
    ,ATTRIBUTE8	                        VARCHAR2(4000)
    ,ATTRIBUTE9	                        VARCHAR2(4000)
    ,ATTRIBUTE10	                    VARCHAR2(4000)
    ,ATTRIBUTE11	                    VARCHAR2(4000)
    ,ATTRIBUTE12	                    VARCHAR2(4000)
    ,ATTRIBUTE13	                    VARCHAR2(4000)
    ,ATTRIBUTE14	                    VARCHAR2(4000)
    ,ATTRIBUTE15	                    VARCHAR2(4000)  
    ,IS_SEEDED          		        CHAR(1)             DEFAULT 'Y'
    ,ENABLED_FLAG        		        CHAR(1)             
    ,START_DATE_ACTIVE  		        DATE                
    ,END_DATE_ACTIVE    		        DATE         
    ,OIC_INSTANCE_ID    		        NUMBER         
    ,CREATED_BY         		        VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,CREATION_DATE      		        DATE                DEFAULT SYSDATE
    ,LAST_UPDATED_BY    		        VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,LAST_UPDATE_DATE   		        DATE                DEFAULT SYSDATE
);