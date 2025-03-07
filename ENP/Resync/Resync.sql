select 'CHM_SFDC_ACCOUNT_MASTER' Table_Name,count(*) from CHM_SFDC_ACCOUNT_MASTER
union
select 'CHM_SFDC_ACCOUNT_SITES' Table_Name,count(*) from CHM_SFDC_ACCOUNT_SITES
union
select 'CHM_SPA_HEADER' Table_Name,count(*) from CHM_SPA_HEADER
union
select 'CHM_SPA_LINES' Table_Name,count(*) from CHM_SPA_LINES
union
select 'CHM_ACCOUNTING_PERIODS' Table_Name,count(*) from CHM_ACCOUNTING_PERIODS
union
select 'CHM_ITEM_CATEGORIES' Table_Name,count(*) from CHM_ITEM_CATEGORIES
union
select 'CHM_ITEM_CATEGORY_ASSIGNMENTS' Table_Name,count(*) from CHM_ITEM_CATEGORY_ASSIGNMENTS
union
select 'CHM_DIST_SITE_USES' Table_Name,count(*) from CHM_DIST_SITE_USES
union
select 'CHM_SPA_ADDITIONAL_DIST' Table_Name,count(*) from CHM_SPA_ADDITIONAL_DIST
;

