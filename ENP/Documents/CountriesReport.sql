/**************************************************************************************************************************
* Report Name           : CountriesReport                                                                                 *
* Purpose               : Report to extract Countries                                                                     *
*                                                                                                                         *
***************************************************************************************************************************
* Date          Author                  Company                 Version          Description                              *
* -----------   ---------------------   ---------------------   -------          -----------------------------------------*
* 14-Jul-2023   Gurpreet Singh          Transform Edge          1.0              Initial Version                          *
*                                                                                                                         *                                                                    
**************************************************************************************************************************/
SELECT 
     ft.enterprise_id
    ,ftt.language
    ,ft.territory_code
    ,ftt.territory_short_name
    ,ft.nls_territory
    ,ftt.description
    ,ft.alternate_territory_code
    ,ft.iso_territory_code
    ,ft.currency_code
    ,ft.eu_code
    ,ft.iso_numeric_code
    ,ft.obsolete_flag
    ,ft.enabled_flag 
FROM 
     fnd_territories_b  ft
    ,fnd_territories_tl ftt
WHERE 1=1
AND ft.territory_code  = ftt.territory_code 
AND ft.enterprise_id   = ftt.enterprise_id
