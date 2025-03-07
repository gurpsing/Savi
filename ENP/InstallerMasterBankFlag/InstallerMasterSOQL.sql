/*******************************************************************************************************
* Name                  : InstallerMasterSOQL                                                          *
* Purpose               : SOQL to extract Installer Master                                             *
*                                                                                                      *
********************************************************************************************************
* Date          Author                  Company                 Version          Description           *
* -----------   ---------------------   ---------------------   -------          ----------------------*
* 22-Aug-2023   Gurpreet Singh          Transform Edge          1.0              Initial Version       *
* 09-Sep-2024   Gurpreet Singh          Transform Edge          1.1              New Field Additions   * 
* 03-Mar-2025   Raja Ratnakar Reddy     Selectiva               1.2              New Field Additions   * 
*******************************************************************************************************/
SELECT id
	,name
	,customer_key__c
	,account_type__c
	,owner_name__c
	,enlighten_installer_id__c
	,parent.name
	,parentid
	,recordtype.name
	,OWNER.alias
	,geography__c
	,territory__c
	,sub_territory__c
	,enlighten_admin__c
	,enlighten_installer_flag__c
	,billingstreet
	,billingcity
	,billingstate
	,billingpostalcode
	,shippingstreet
	,shippingcity
	,shippingstate
	,shippingpostalcode
	,country__c
	,createdby.name
	,createddate
	,lastmodifiedby.name
	,lastmodifieddate
	,BillingCountry
	,ShippingCountry
	,OwnerId
	,Oracle_Customer_Number__c
	,Relationship__c
	,CurrencyIsoCode
	,Channelinsight__CI_Synch__c
	,Region__c
	,Geography_Owner__c
	,Forecastable__c
	,Regions__c
	,Account_Status__c
	,Status__c
	,CHM__c                                     --added for v1.1
	,MergeID__c                                 --added for v1.1
	,Enlighten_Company_Duplicate_Key__c         --added for v1.1
    ,Is_InstallerBankAccount_Shared__c          --added for v1.2
FROM account
WHERE RecordType.Name = '&pRecordType'
	AND LastModifiedDate >= &pLastModifiedDate
