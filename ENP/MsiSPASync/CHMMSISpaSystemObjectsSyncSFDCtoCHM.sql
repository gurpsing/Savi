2025-04-01T00:00:00.000Z

--GETSPASYSTEMATTACHMENT

SELECT Id
	,IsDeleted
	,Name
	,CurrencyIsoCode
	,CreatedDate
	,CreatedById
	,LastModifiedDate
	,LastModifiedById
	,SystemModstamp
	,LastActivityDate
	,LastViewedDate
	,LastReferencedDate
	,Min_Quantity__c
	,Per_Unit_Incentive__c
	,SPA__c
	,Unique_key__c
	,Status__c
	,Product__c
	,Product__r.ProductCode
FROM SPA_MSI_System_Attachment__c
WHERE lastmodifieddate >= &LastModifiedDate


--GetSPAUNITACTIVATION

SELECT Id
	,IsDeleted
	,Name
	,CurrencyIsoCode
	,CreatedDate
	,CreatedById
	,LastModifiedDate
	,LastModifiedById
	,SystemModstamp
	,LastActivityDate
	,LastViewedDate
	,LastReferencedDate
	,Status__c
	,SPA__c
	,Min_Quantity__c
	,Per_Unit_Incentive__c
	,Product__c
	,Unique_key__c
	,Product__r.ProductCode
FROM SPA_MSI_Unit_Activation__c
WHERE lastmodifieddate >= &LastModifiedDate


--GetSystemSizeIncentiveDetails

SELECT Id
	,IsDeleted
	,Name
	,CurrencyIsoCode
	,CreatedDate
	,CreatedById
	,LastModifiedDate
	,LastModifiedById
	,SystemModstamp
	,LastActivityDate
	,LastViewedDate
	,LastReferencedDate
	,SPA__c
	,Tier_1_Incentive__c
	,Tier_2_Incentive__c
	,Tier_3_Incentive__c
	,Tier_4_Incentive__c
	,Tier_5_Incentive__c
	,Unique_key__c
	,Status__c
	,Product__c
	,Product__r.ProductCode
FROM SPA_MSI_System_Size_Incentive__c
WHERE lastmodifieddate >= &LastModifiedDate



--GetSystemSizeIncentiveDetail

SELECT Id
	,IsDeleted
	,Name
	,CurrencyIsoCode
	,CreatedDate
	,CreatedById
	,LastModifiedDate
	,LastModifiedById
	,SystemModstamp
	,LastActivityDate
	,LastViewedDate
	,LastReferencedDate
	,SPA__c
	,Min_Qty__c
	,Max_Qty__c
	,Tier_Incentive__c
	,Product__c
	,Tier_Name__c
FROM SPA_MSI_System_Size_for_CHM__c
WHERE lastmodifieddate >= &LastModifiedDate

