CREATE SEQUENCE CHM_PRICE_LIST_SEQ              INCREMENT BY 1 MINVALUE 1;

CREATE TABLE CHM_PRICE_LISTS(
     CHM_PRICE_LIST_ID   		        NUMBER   DEFAULT    CHM_PRICE_LIST_SEQ.NEXTVAL PRIMARY KEY
    ,SOURCE_PRICE_LIST_ID	            NUMBER              UNIQUE NOT NULL 
    ,LANGUAGE	                        VARCHAR2(4000)
    ,NAME	                            VARCHAR2(4000)
    ,DESCRIPTION	                    VARCHAR2(4000)
    ,ORG_ID	                            NUMBER              
    ,CATALOG_ID	                        NUMBER
    ,CHARGE_DEFINITION_ID	            NUMBER
    ,CURRENCY_CODE	                    VARCHAR2(4000)
    ,CALCULATION_METHOD_CODE	        VARCHAR2(4000)
    ,PRICE_LIST_TYPE_CODE	            VARCHAR2(4000)
    ,LINE_TYPE_CODE	                    VARCHAR2(4000)
    ,STATUS_CODE	                    VARCHAR2(4000)
    ,START_DATE_ACTIVE  		        DATE                
    ,END_DATE_ACTIVE    		        DATE
    ,OIC_INSTANCE_ID 	                NUMBER    
    ,IS_SEEDED          		        CHAR(1)             DEFAULT 'Y'
    ,CREATED_BY         		        VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,CREATION_DATE      		        DATE                DEFAULT SYSDATE
    ,LAST_UPDATED_BY    		        VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,LAST_UPDATE_DATE   		        DATE                DEFAULT SYSDATE
);