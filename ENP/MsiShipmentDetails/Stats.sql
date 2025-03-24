select * from CHM_MSI_SPA_INSTALLERS;

select count(*),'All Data' type from chm_msi_ship_details_tbl where oic_instance_id is not null and  sync_for_date is not null
union
select count(*),'US Data' type from chm_msi_ship_details_tbl where oic_instance_id is not null and country ='US' and  sync_for_date is not null
union
select count(*),'Non-US Data' type from chm_msi_ship_details_tbl where oic_instance_id is not null and country <>'US' and  sync_for_date is not null;


select sales_order_type,count(*) from chm_msi_ship_details_tbl 
where oic_instance_id is not null and  sync_for_date is not null
group by rollup(sales_order_type) order by 1;

select sales_order_type,country,count(*) from chm_msi_ship_details_tbl 
where oic_instance_id is not null and  sync_for_date is not null
group by sales_order_type,country order by 1;

select trunc(sync_for_date,'MON') "Date",count(*),SUM(decode(country,'US',1,0)) US_DATA,SUM(decode(country,'US',0,1)) NON_US_DATA  from chm_msi_ship_details_tbl 
where oic_instance_id is not null and sync_for_date is not null
group by rollup (trunc(sync_for_date,'MON')) order by 1;


select to_char(trunc(sync_for_date),'DD-MON-YYYY') "Date",count(*)  from chm_msi_ship_details_tbl 
where oic_instance_id is not null and sync_for_date is not null
group by trunc(sync_for_date) order by trunc(sync_for_date);

create table chm_msi_ship_details_tbl_bkp
as select * from chm_msi_ship_details_tbl;

select count(*) from chm_msi_ship_details_tbl;

select * from all_objects where object_name='CHM_MSI_SHIPMENT_DETAIL_PKG';

select * from chm_integration_runs 
where chm_integration_run_id='FLyTOgbnEfC7NC82xKA_Rg';


