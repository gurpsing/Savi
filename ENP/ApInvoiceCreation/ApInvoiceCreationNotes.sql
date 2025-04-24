select * from poz_suppliers_v where vendor_id='300000147854070';

VENDOR_NAME (CLEAN SOLAR, INC.)
VENDOR_ID (300000147854070)
SEGMENT1 (1076)
PARTY_ID (300000147854067)
VENDOR_TYPE_LOOKUP_CODE (INSTALLER)
ATTRIBUTE1 (0002021)    --CHM_MSI_CLAIM_AP_INVOICES.INSTALLER_NUMBER



select 
     pv.vendor_id
    ,pv.vendor_name
    ,pv.segment1
    ,pvs.vendor_site_id
    ,pvs.vendor_site_code
FROM
     poz_suppliers_v pv
    ,poz_supplier_sites_all_m pvs
WHERE 1=1
AND pv.vendor_id               =   pvs.vendor_id
AND pv.vendor_type_lookup_code = 'INSTALLER'
AND (select count(1) from poz_supplier_sites_all_m pvs1
    where pvs1.vendor_id = pv.vendor_id
) >1

9876990609


API:
https://fa-emrp-dev2-saasfaprod1.fa.ocs.oraclecloud.com/fscmRestApi/resources/11.13.18.05/standardLookups/:StandardLookupName/child/lookupCodes?expand=lookupsDFF&links=canonical&onlyData=true


{
    "items": [
        {
            "LookupCode": "DE",
            "Meaning": "Germany",
            "Description": "ENE NLD Business Unit",
            "EnabledFlag": "Y",
            "StartDateActive": "2025-04-02",
            "EndDateActive": null,
            "DisplaySequence": 10,
            "Tag": "240",
            "CreatedBy": "kannanr@enphaseenergy.com",
            "CreationDate": "2025-04-09T10:43:51.885+00:00",
            "LastUpdateDate": "2025-04-24T05:06:48.181+00:00",
            "LastUpdateLogin": "32577E5AC7283742E0632955310AC45D",
            "LastUpdatedBy": "SVC_INT_ADMIN",
            "lookupsDFF": [
                {
                    "LookupType": "ENE_AP_MSI_BU_NAME",
                    "LookupCode": "DE",
                    "ViewApplicationId": 0,
                    "SetId": 0,
                    "businessUnit": null,
                    "orderType": "EUR",
                    "warehouse": "Net 7",
                    "subinventory": null,
                    "numberOfDays": null,
                    "source": null,
                    "uom": null,
                    "listPrice": null,
                    "moq": null,
                    "priceList": null,
                    "freightTerms": null,
                    "freightTerms_Display": null,
                    "fob": null,
                    "fob_Display": null,
                    "shipMethod": null,
                    "modeOfTransport": null,
                    "serviceLevel": null,
                    "__FLEX_Context": null,
                    "__FLEX_Context_DisplayValue": null
                }
            ]
        },
        {
            "LookupCode": "IT",
            "Meaning": "Italy",
            "Description": "ENE NLD Business Unit",
            "EnabledFlag": "Y",
            "StartDateActive": null,
            "EndDateActive": null,
            "DisplaySequence": 20,
            "Tag": "240",
            "CreatedBy": "kannanr@enphaseenergy.com",
            "CreationDate": "2025-04-09T10:44:54.584+00:00",
            "LastUpdateDate": "2025-04-24T05:06:48.234+00:00",
            "LastUpdateLogin": "32577E5AC7283742E0632955310AC45D",
            "LastUpdatedBy": "SVC_INT_ADMIN",
            "lookupsDFF": [
                {
                    "LookupType": "ENE_AP_MSI_BU_NAME",
                    "LookupCode": "IT",
                    "ViewApplicationId": 0,
                    "SetId": 0,
                    "businessUnit": null,
                    "orderType": "EUR",
                    "warehouse": "Net 7",
                    "subinventory": null,
                    "numberOfDays": null,
                    "source": null,
                    "uom": null,
                    "listPrice": null,
                    "moq": null,
                    "priceList": null,
                    "freightTerms": null,
                    "freightTerms_Display": null,
                    "fob": null,
                    "fob_Display": null,
                    "shipMethod": null,
                    "modeOfTransport": null,
                    "serviceLevel": null,
                    "__FLEX_Context": null,
                    "__FLEX_Context_DisplayValue": null
                }
            ]
        },
        {
            "LookupCode": "GB",
            "Meaning": "United Kingdom",
            "Description": "ENE NLD Business Unit",
            "EnabledFlag": "Y",
            "StartDateActive": null,
            "EndDateActive": null,
            "DisplaySequence": 30,
            "Tag": "240",
            "CreatedBy": "kannanr@enphaseenergy.com",
            "CreationDate": "2025-04-09T10:45:11.760+00:00",
            "LastUpdateDate": "2025-04-24T05:06:48.239+00:00",
            "LastUpdateLogin": "32577E5AC7283742E0632955310AC45D",
            "LastUpdatedBy": "SVC_INT_ADMIN",
            "lookupsDFF": [
                {
                    "LookupType": "ENE_AP_MSI_BU_NAME",
                    "LookupCode": "GB",
                    "ViewApplicationId": 0,
                    "SetId": 0,
                    "businessUnit": null,
                    "orderType": "EUR",
                    "warehouse": "Net 7",
                    "subinventory": null,
                    "numberOfDays": null,
                    "source": null,
                    "uom": null,
                    "listPrice": null,
                    "moq": null,
                    "priceList": null,
                    "freightTerms": null,
                    "freightTerms_Display": null,
                    "fob": null,
                    "fob_Display": null,
                    "shipMethod": null,
                    "modeOfTransport": null,
                    "serviceLevel": null,
                    "__FLEX_Context": null,
                    "__FLEX_Context_DisplayValue": null
                }
            ]
        },
        {
            "LookupCode": "ES",
            "Meaning": "Spain",
            "Description": "ENE ESP Business Unit",
            "EnabledFlag": "Y",
            "StartDateActive": null,
            "EndDateActive": null,
            "DisplaySequence": 40,
            "Tag": "270",
            "CreatedBy": "kannanr@enphaseenergy.com",
            "CreationDate": "2025-04-09T10:45:26.244+00:00",
            "LastUpdateDate": "2025-04-24T05:06:48.243+00:00",
            "LastUpdateLogin": "32577E5AC7283742E0632955310AC45D",
            "LastUpdatedBy": "SVC_INT_ADMIN",
            "lookupsDFF": [
                {
                    "LookupType": "ENE_AP_MSI_BU_NAME",
                    "LookupCode": "ES",
                    "ViewApplicationId": 0,
                    "SetId": 0,
                    "businessUnit": null,
                    "orderType": "EUR",
                    "warehouse": "Net 7",
                    "subinventory": null,
                    "numberOfDays": null,
                    "source": null,
                    "uom": null,
                    "listPrice": null,
                    "moq": null,
                    "priceList": null,
                    "freightTerms": null,
                    "freightTerms_Display": null,
                    "fob": null,
                    "fob_Display": null,
                    "shipMethod": null,
                    "modeOfTransport": null,
                    "serviceLevel": null,
                    "__FLEX_Context": null,
                    "__FLEX_Context_DisplayValue": null
                }
            ]
        },
        {
            "LookupCode": "US",
            "Meaning": "United States",
            "Description": "ENE USA Business Unit",
            "EnabledFlag": "Y",
            "StartDateActive": null,
            "EndDateActive": null,
            "DisplaySequence": 50,
            "Tag": "270",
            "CreatedBy": "gusingh@enphaseenergy.com",
            "CreationDate": "2025-04-18T09:52:09.512+00:00",
            "LastUpdateDate": "2025-04-24T05:06:48.247+00:00",
            "LastUpdateLogin": "32577E5AC7283742E0632955310AC45D",
            "LastUpdatedBy": "SVC_INT_ADMIN",
            "lookupsDFF": [
                {
                    "LookupType": "ENE_AP_MSI_BU_NAME",
                    "LookupCode": "US",
                    "ViewApplicationId": 0,
                    "SetId": 0,
                    "businessUnit": null,
                    "orderType": "EUR",
                    "warehouse": "Net 7",
                    "subinventory": null,
                    "numberOfDays": null,
                    "source": null,
                    "uom": null,
                    "listPrice": null,
                    "moq": null,
                    "priceList": null,
                    "freightTerms": null,
                    "freightTerms_Display": null,
                    "fob": null,
                    "fob_Display": null,
                    "shipMethod": null,
                    "modeOfTransport": null,
                    "serviceLevel": null,
                    "__FLEX_Context": null,
                    "__FLEX_Context_DisplayValue": null
                }
            ]
        }
    ],
    "count": 5,
    "hasMore": false,
    "limit": 25,
    "offset": 0,
    "links": []
}