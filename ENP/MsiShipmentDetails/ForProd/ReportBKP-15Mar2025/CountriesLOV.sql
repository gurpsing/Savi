SELECT country  FROM (SELECT -1 rownumber ,'N/A' country FROM DUAL
UNION
SELECT ROW_NUMBER() OVER (ORDER BY country) AS rownumber, country 
FROM (SELECT DISTINCT country FROM hz_locations) order by country
) order by rownumber