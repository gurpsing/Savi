CREATE OR REPLACE PACKAGE CHM_COUNTRY_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_COUNTRY_PKG                                                                                                                       *
    * Purpose                        : Package for CHM Countries Integrations                                                                                                *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 27-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 27-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    TYPE REC_COUNTRY IS RECORD (
         ENTERPRISE_ID              NUMBER           
        ,LANGUAGE                   VARCHAR2(4000)   
        ,TERRITORY_CODE             VARCHAR2(4000)   
        ,TERRITORY_SHORT_NAME       VARCHAR2(4000)
        ,NLS_TERRITORY              VARCHAR2(4000)
        ,DESCRIPTION                VARCHAR2(4000)
        ,ALTERNATE_TERRITORY_CODE   VARCHAR2(4000)
        ,ISO_TERRITORY_CODE         VARCHAR2(4000)
        ,CURRENCY_CODE              VARCHAR2(4000)
        ,EU_CODE                    VARCHAR2(4000)
        ,ISO_NUMERIC_CODE           VARCHAR2(4000)
        ,OBSOLETE_FLAG              CHAR(1)
        ,ENABLED_FLAG               CHAR(1)   
    );
    
    TYPE TBL_COUNTRY IS TABLE OF REC_COUNTRY;
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_COUNTRY			        IN      TBL_COUNTRY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    );
    
END CHM_COUNTRY_PKG;
/
