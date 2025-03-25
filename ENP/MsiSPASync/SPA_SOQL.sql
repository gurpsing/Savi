Integration name:       CHMMSISpaDistiInstallerSyncSFDCtoCHM
Identifier:             CHMMSISPADISTIINSTALLERSYNCSFDCT
Description:            MSI SPA Distributor, Installer and Geo Restriction Sync from Sales force to CHM
Package:                com.enphase.msi
Version:                01.00.0000


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
--System Attachment (On SPA Level)     CHM_MSI_SPA_SYSTEM_ATTACHMENT_INCENTIVES -> CHM_MSI_SPA_SYSTEM_ATTACHMENTS
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
--Unit Activation   (On SPA Level)   CHM_MSI_SPA_UNIT_ACTIVATION_INCENTIVES -> CHM_MSI_SPA_UNIT_ACTIVATIONS
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
--System Size Incentive  (On SPA Level)  CHM_MSI_SPA_SYSTEM_SIZE_INCENTIVES_AUDIT   -> CHM_MSI_SPA_SYSTEM_SIZE_AUDIT     (System Size)
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
--Product     (Master Table) CHM_MSI_SPA_PRODUCTS
-------------------------------------------------------------------------------------------------------------
SELECT id
	,MSI_Eligible__c
	,MSI_System_Attachment_Eligible__c
    ,IsActive
    ,Name
    ,ProductCode
from Product2 
WHERE lastmodifieddate >= &LastModifiedDate


SELECT FIELDS(ALL) FROM Product2 LIMIT 5


-------------------------------------------------------------------------------------------------------------
--SPA Branch Installers  CHM_MSI_SPA_INSTALLERS
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
	,Installer_Name__c
	,SPA__c
	,Status__c
	,Installer_Enlighten_Id__c
FROM SPA_Branch_Installer__c
WHERE lastmodifieddate >= &P_LAST_MODIFIED_DATE


--LastModifiedDate is of format: (YYYY-MM-DDT00:00:00.000Z)
--2020-01-01T00:00:00.000Z


--SPA Geo Restrictions  CHM_MSI_SPA_GEO_DETAILS
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
	,Country__c
	,Zip_code__c
	,Status__c
	,State__c
	,SPA__c
FROM SPA_MSI_Geo_Detail__c
WHERE lastmodifieddate >= &P_LAST_MODIFIED_DATE




-------------------------------------------------------------------------------------------------------------
--SPA Distributor   CHM_MSI_SPA_DISTRIBUTOR
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT Id
	,IsDeleted
	,Name
	,CurrencyIsoCode
	,CreatedDate
	,CreatedById
	,LastModifiedDate
	,LastModifiedById
	,SystemModstamp
	,LastViewedDate
	,LastReferencedDate
	,SPATEST__c
	,Distributor_Account__c
	,SPA_Status__c
	,Oracle_Customer_Number__c
	,SPA_and_Opportunities__c
	,Line_Status__c
FROM SPA_Distributor__c
WHERE lastmodifieddate >= &P_LAST_MODIFIED_DATE


CHM_MSI_SPA_PRODUCTS_ID PK (SEQUENCE)
ATTRIBUTE1 to ATTRIBUTE15
OIC_INSTANCE_ID
CREATED_BY
CREATION_DATE
LAST_UPDATED_BY
LAST_UPDATED_DATE



<xsl:template match="/" xml:id="id_11">
      <nstrgmpr:query xml:id="id_12">
            <nstrgmpr:QueryParameters xml:id="id_62">
                  <ns28:P_LAST_MODIFIED_DATE xml:id="id_63">
                        <xsl:value-of xml:id="id_64" select="$g_last_run_date"/>
                  </ns28:P_LAST_MODIFIED_DATE>
            </nstrgmpr:QueryParameters>
            <nstrgmpr:QueryLocator xml:id="id_60">
                  <xsl:value-of xml:id="id_61" select="$L_QUERY_LOCATOR"/>
            </nstrgmpr:QueryLocator>
      </nstrgmpr:query>
</xsl:template>