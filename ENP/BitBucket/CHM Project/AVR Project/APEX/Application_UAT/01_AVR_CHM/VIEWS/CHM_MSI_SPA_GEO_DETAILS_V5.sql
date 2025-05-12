--------------------------------------------------------
--  DDL for View CHM_MSI_SPA_GEO_DETAILS_V5
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CHM_MSI_SPA_GEO_DETAILS_V5" ("CHM_MSI_SPA_GEO_DETAIL_ID", "ID", "SPA", "COUNTRY", "SFDC_STATE", "SFDC_ZIP", "STATE", "ZIP") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
    cg.CHM_MSI_SPA_GEO_DETAIL_ID,
cg.ID,cg.SPA ,cg.country, cg.state sfdc_state,cg.zip sfdc_zip,
    CASE WHEN cg.state IS NULL THEN NULL ELSE trim(regexp_substr(cg.state, '[^;]+', 1, state_level.lv)) END AS state,
    CASE WHEN cg.zip IS NULL THEN NULL ELSE trim(regexp_substr(cg.zip, '[^;]+', 1, zip_level.lv)) END AS zip
FROM
    CHM_MSI_SPA_GEO_DETAILS cg,
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT NVL(MAX(REGEXP_COUNT(zip, ';') + 1), 1)
                          FROM CHM_MSI_SPA_GEO_DETAILS
                          WHERE UPPER(NVL(is_deleted, 'FALSE')) = 'FALSE'
                            AND UPPER(NVL(status, 'xx')) = 'APPROVED')) zip_level,
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT NVL(MAX(REGEXP_COUNT(state, ';') + 1), 1)
                          FROM CHM_MSI_SPA_GEO_DETAILS
                          WHERE UPPER(NVL(is_deleted, 'FALSE')) = 'FALSE'
                            AND UPPER(NVL(status, 'xx')) = 'APPROVED')) state_level
WHERE
    UPPER(NVL(cg.is_deleted, 'FALSE')) = 'FALSE'
    AND UPPER(NVL(cg.status, 'xx')) = 'APPROVED'
    AND (cg.state IS NOT NULL OR cg.zip IS NOT NULL OR (cg.state IS NULL AND cg.zip IS NULL AND state_level.lv = 1 AND zip_level.lv = 1))
    AND (cg.state IS NULL OR regexp_substr(cg.state, '[^;]+', 1, state_level.lv) IS NOT NULL)
    AND (
        (cg.zip IS NOT NULL AND regexp_substr(cg.zip, '[^;]+', 1, zip_level.lv) IS NOT NULL)
        OR (cg.zip IS NULL AND zip_level.lv = 1)
    )
;
