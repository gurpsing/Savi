------------------------------------------------------------------------------------------------------------
--MSI Installer
------------------------------------------------------------------------------------------------------------

SELECT * FROM CHM_MSI_SPA_INSTALLERS;


SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,Installer_Name__c  ,SPA__c  ,Status__c  ,Installer_Enlighten_Id__c,CreatedBy.Name,LastModifiedBy.Name FROM SPA_Branch_Installer__c WHERE lastmodifieddate >= &P_LAST_MODIFIED_DATE and Status__c in ('Approved')





------------------------------------------------------------------------------------------------------------
--MSI Distributors
------------------------------------------------------------------------------------------------------------

SELECT * FROM CHM_MSI_SPA_DISTRIBUTOR;



SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastViewedDate  ,LastReferencedDate  ,SPATEST__c  ,Distributor_Account__c  ,SPA_Status__c  ,Oracle_Customer_Number__c  ,SPA_and_Opportunities__c  ,Line_Status__c,CreatedBy.Name,LastModifiedBy.Name FROM SPA_Distributor__c WHERE lastmodifieddate >= &P_LAST_MODIFIED_DATE and Line_Status__c in ('Approved')






------------------------------------------------------------------------------------------------------------
--MSI Geo Restriction
------------------------------------------------------------------------------------------------------------

SELECT * FROM CHM_MSI_SPA_GEO_DETAILS;



SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,Country__c  ,Zip_code__c  ,Status__c  ,State__c  ,SPA__c,CreatedBy.Name,LastModifiedBy.Name FROM SPA_MSI_Geo_Detail__c WHERE lastmodifieddate >= &P_LAST_MODIFIED_DATE and Status__c in ('Approved')



------------------------------------------------------------------------------------------------------------
--MSI System Attachment
------------------------------------------------------------------------------------------------------------


SELECT * FROM CHM_MSI_SPA_SYSTEM_ATTACHMENTS;


SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,Min_Quantity__c  ,Per_Unit_Incentive__c  ,SPA__c  ,Unique_key__c  ,Status__c  ,Product__c,Product__r.ProductCode,Product__r.name ,CreatedBy.Name,LastModifiedBy.Name FROM SPA_MSI_System_Attachment__c WHERE lastmodifieddate >= &LastModifiedDate and Status__c in ('Approved')



------------------------------------------------------------------------------------------------------------
--MSI Unit Activations
------------------------------------------------------------------------------------------------------------

SELECT * FROM CHM_MSI_SPA_UNIT_ACTIVATIONS;


SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,Status__c  ,SPA__c  ,Min_Quantity__c  ,Per_Unit_Incentive__c  ,Product__c  ,Unique_key__c,Product__r.ProductCode,Product__r.name ,CreatedBy.Name,LastModifiedBy.Name from SPA_MSI_Unit_Activation__c  WHERE lastmodifieddate >= &LastModifiedDate and Status__c in ('Approved')





------------------------------------------------------------------------------------------------------------
--MSI System Size Incentive
------------------------------------------------------------------------------------------------------------

SELECT * FROM CHM_MSI_SYS_SIZE_INCENTIVE;

SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,SPA__c  ,Tier_1_Incentive__c  ,Tier_2_Incentive__c  ,Tier_3_Incentive__c  ,Tier_4_Incentive__c  ,Tier_5_Incentive__c  ,Unique_key__c  ,Status__c  ,Product__c, Product__r.ProductCode,Product__r.name ,CreatedBy.Name,LastModifiedBy.Name  from SPA_MSI_System_Size_Incentive__c  WHERE lastmodifieddate >= &LastModifiedDate and Status__c in ('Approved')




------------------------------------------------------------------------------------------------------------
--MSI System Size Incentive CHM
------------------------------------------------------------------------------------------------------------

SELECT * FROM CHM_MSI_SYS_SIZE_INCENTIVE_CHM;

SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,SPA__c  ,Min_Qty__c  ,Max_Qty__c  ,Tier_Incentive__c  ,Product__c  ,Tier_Name__c ,CreatedBy.Name,LastModifiedBy.Name   FROM SPA_MSI_System_Size_for_CHM__c  WHERE lastmodifieddate >= &LastModifiedDate


SELECT Id  ,IsDeleted  ,Name  ,CurrencyIsoCode  ,CreatedDate  ,CreatedById  ,LastModifiedDate  ,LastModifiedById  ,SystemModstamp  ,LastActivityDate  ,LastViewedDate  ,LastReferencedDate  ,SPA__c  ,Min_Qty__c  ,Max_Qty__c  ,Tier_Incentive__c  ,Product__c  ,Tier_Name__c, Product__r.ProductCode,Product__r.name ,CreatedBy.Name,LastModifiedBy.Name   FROM SPA_MSI_System_Size_for_CHM__c  WHERE lastmodifieddate >= &LastModifiedDate AND Status__c in ('Approved')


