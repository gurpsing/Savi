-------------------------------------------------------------------------------------------------------------
--SPA/Quote     (CHM_MSI_SPA_HEADER)
-------------------------------------------------------------------------------------------------------------

SELECT Id
	,QuoteNumber
	,OwnerId
	,IsDeleted
	,Name
	,CurrencyIsoCode
	,RecordTypeId
	,CreatedDate
	,CreatedById
	,LastModifiedDate
	,LastModifiedById
	,SystemModstamp
	,LastViewedDate
	,LastReferencedDate
	,OpportunityId
	,Pricebook2Id
	,ContactId
	,IsSyncing
	,ShippingHandling
	,Tax
	,STATUS
	,ExpirationDate
	,Description
	,Subtotal
	,TotalPrice
	,LineItemCount
	,BillingStreet
	,BillingCity
	,BillingState
	,BillingPostalCode
	,BillingCountry
	,BillingLatitude
	,BillingLongitude
	,BillingGeocodeAccuracy
	,BillingAddress
	,ShippingStreet
	,ShippingCity
	,ShippingState
	,ShippingPostalCode
	,ShippingCountry
	,ShippingLatitude
	,ShippingLongitude
	,ShippingGeocodeAccuracy
	,ShippingAddress
	,QuoteToStreet
	,QuoteToCity
	,QuoteToState
	,QuoteToPostalCode
	,QuoteToCountry
	,QuoteToLatitude
	,QuoteToLongitude
	,QuoteToGeocodeAccuracy
	,QuoteToAddress
	,AdditionalStreet
	,AdditionalCity
	,AdditionalState
	,AdditionalPostalCode
	,AdditionalCountry
	,AdditionalLatitude
	,AdditionalLongitude
	,AdditionalGeocodeAccuracy
	,AdditionalAddress
	,BillingName
	,ShippingName
	,QuoteToName
	,AdditionalName
	,Email
	,Phone
	,Fax
	,ContractId
	,AccountId
	,Discount
	,GrandTotal
	,CanCreateQuoteLineItems
	,RelatedWorkId
	,Approval_Region__c
	,Custom_Account__c
	,Deal_Category__c
	,Distributor__c
	,Has_line_items_without_margin__c
	,Has_prices_outside_of_tier__c
	,New_Renewal__c
	,Quote_to_Buy_Budgetary__c
	,SPA_Back_Dated__c
	,SPA_Start_Date__c
	,Special_Pricing_Type__c
	,Count_of_Products_without_Margin__c
	,Days_Till_SPA_Expiry__c
	,Reduction_Reason__c
	,Account_Owner_Email_Address__c
	,DAM_Email_Address__c
	,Current_Quarter_POS__c
	,Current_Time_Stamp__c
	,Final_Approval_Time__c
	,Prior_Quarter_POS__c
	,Prior_to_Prior_Quarter_POS__c
	,Time_Submitted_2nd_Approval__c
	,Time_Submitted__c
	,Design_Status__c
	,Cancellation_Comments__c
	,SPA_Cancelled_Date__c
	,Approval_Submitter__c
	,SPA_Approver_Id__c
	,IsApprovedSPA__c
	,Enlighten_Installer_ID__c
	,Count_of_Available_SAR_S__c
	,Count_of_Available_SAR_with_Rebate__c
	,Is_Distributor_Related_SPA__c
	,LastRefreshedSPAPdfDate__c
	,RefreshSPAPdfs__c
	,Pricelist__c
	,Country__c
	,Distributors_List__c
	,ReOpened_Status__c
	,How_many_Tiers__c
	,Tier1_Min__c
	,Tier2_Min__c
	,Tier3_Min__c
	,Tier4_Min__c
	,Tier5_Min__c
	,Tier1_Max__c
	,Tier2_Max__c
	,Tier3_Max__c
	,Tier4_Max__c
	,Tier5_Max__c
	,Modified_Expiry_Date__c
	,Contact__c
	,Installer_bank_account_shared__c
	,Unit_incentive_count__c
	,System_attachment_count__c
	,System_size_count__c
FROM Quote
WHERE lastmodifieddate >= &LastModifiedDate
AND special_pricing_type__c IN (
		'MSI Installer'
		)

-------------------------------------------------------------------------------------------------------------
--System Attachment (On SPA Level)     CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES
-------------------------------------------------------------------------------------------------------------
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
FROM SPA_MSI_System_Attachment__c
WHERE lastmodifieddate >= &LastModifiedDate

-------------------------------------------------------------------------------------------------------------
--Unit Activation   (On SPA Level)   CHM_MSI_SPA_UNIT_ACTIVATION_INCENTIVES
-------------------------------------------------------------------------------------------------------------
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
from SPA_MSI_Unit_Activation__c 
WHERE lastmodifieddate >= &LastModifiedDate


-------------------------------------------------------------------------------------------------------------
--System Size Incentive  (On SPA Level)  CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES_AUDIT
-------------------------------------------------------------------------------------------------------------
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
from SPA_MSI_System_Size_Incentive__c 
WHERE lastmodifieddate >= &LastModifiedDate
 
-------------------------------------------------------------------------------------------------------------
--Product     (On SPA Level) CHM_MSI_SPA_PRODUCTS
-------------------------------------------------------------------------------------------------------------
SELECT id
	,MSI_Eligible__c
	,MSI_System_Attachment_Eligible__c
from Product2 
WHERE lastmodifieddate >= &LastModifiedDate



CHM_MSI_SPA_PRODUCTS_ID PK (SEQUENCE)
ATTRIBUTE1 to ATTRIBUTE15
OIC_INSTANCE_ID
CREATED_BY
CREATION_DATE
LAST_UPDATED_BY
LAST_UPDATED_DATE

