CREATE SEQUENCE CHM_AR_TRX_TYPE_SEQ INCREMENT BY 1 MINVALUE 1;

CREATE TABLE CHM_AR_TRX_TYPES(
     CHM_TRX_TYPE_ID   		            NUMBER   DEFAULT  CHM_AR_TRX_TYPE_SEQ.NEXTVAL		    PRIMARY KEY
    ,SOURCE_TRX_TYPE_ID	                NUMBER              NOT NULL UNIQUE
    ,TRX_TYPE_SEQ_ID	                NUMBER              NOT NULL UNIQUE
    ,ORG_ID	                            NUMBER               
    ,NAME	                            VARCHAR2(4000)      
    ,DESCRIPTION	                    VARCHAR2(4000)      
    ,TYPE	                            VARCHAR2(4000)      
    ,DEFAULT_PRINTING_OPTION	        VARCHAR2(4000)      
    ,DEFAULT_STATUS	                    VARCHAR2(4000)      
    ,ALLOW_FREIGHT_FLAG	                CHAR(1)             
    ,ALLOW_OVERAPPLICATION_FLAG	        CHAR(1)             
    ,TAX_CALCULATION_FLAG	            CHAR(1)             
    ,STATUS	                            VARCHAR2(4000)      
    ,START_DATE	                        DATE                
    ,END_DATE	                        DATE
    ,IS_SEEDED          	            CHAR(1)             DEFAULT 'Y'             
    ,ATTRIBUTE1         		        VARCHAR2(4000)   
    ,ATTRIBUTE2         		        VARCHAR2(4000)   
    ,ATTRIBUTE3         		        VARCHAR2(4000)   
    ,ATTRIBUTE4         		        VARCHAR2(4000)   
    ,ATTRIBUTE5         		        VARCHAR2(4000)   
    ,ATTRIBUTE6         		        VARCHAR2(4000)   
    ,ATTRIBUTE7         		        VARCHAR2(4000)   
    ,ATTRIBUTE8         		        VARCHAR2(4000)   
    ,ATTRIBUTE9         		        VARCHAR2(4000)   
    ,ATTRIBUTE10        		        VARCHAR2(4000) 
    ,OIC_INSTANCE_ID    		        NUMBER     
    ,CREATED_BY         		        VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,CREATION_DATE      		        DATE                DEFAULT SYSDATE
    ,LAST_UPDATED_BY    		        VARCHAR2(4000)      DEFAULT 'INTEGRATIONS'
    ,LAST_UPDATE_DATE   		        DATE                DEFAULT SYSDATE
);
