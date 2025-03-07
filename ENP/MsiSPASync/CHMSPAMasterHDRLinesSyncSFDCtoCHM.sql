SELECT id
	,quotenumber
	,name
	,opportunity.name
	,opportunity.OWNER.name
	,opportunity.ownerid
	,opportunityid
	,account.name
	,accountid
	,account.customer_key__c
	,opportunity.geography__c
	,opportunity.stagename
	,STATUS
	,special_pricing_type__c
	,deal_category__c
	,quote_to_buy_budgetary__c
	,spa_back_dated__c
	,new_renewal__c
	,distributor__r.name
	,distributor__c
	,distributor__r.customer_key__c
	,spa_start_date__c
	,expirationdate
	,createddate
	,lastmodifieddate
	,createdby.name
	,lastmodifiedby.name
	,final_approval_time__c
	,totalprice
	,currencyisocode
	,opportunity.opportunity_logistics__c
	,distributor__r.oracle_customer_number__c
	,(
		SELECT linenumber
			,quantity
			,unitprice
			,rebate__c
			,final_list_price__c
			,totalprice
			,recommended_installer_price__c
			,margin__c
			,currencyisocode
			,approved_list_price__c
			,createddate
			,createdby.name
			,lastmodifiedby.name
			,lastmodifieddate
			,product2.name
			,product2.productcode
			,uom__c
		FROM quotelineitems
		)
FROM quote
WHERE lastmodifieddate >= &LastModifiedDate
	AND special_pricing_type__c IN (
		'C-SPA'
		,'D-SPA'
		)
	AND quote_to_buy_budgetary__c = 'Quote to Buy'
