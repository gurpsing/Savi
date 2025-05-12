CREATE OR REPLACE PACKAGE BODY CHM_ORGANIZATION_UNIT_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package                                                                                                                        *
    * Package Name                   : CHM_ORGANIZATION_UNIT_PKG                                                                                                             *
    * Purpose                        : Package for CHM Organization Units Integrations                                                                                       *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 23-Jul-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 23-Jul-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_BUSINESS_UNIT             IN      TBL_BUSINESS_UNIT
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2
        ,P_OUT_RECORDS_FETCHED          OUT     NUMBER
        ,P_OUT_RECORDS_MERGED           OUT     NUMBER
        ,P_OUT_ERROR_MESSAGE            OUT     VARCHAR2
    )
    AS
       L_COUNT              NUMBER :=0;
       L_MERGE_COUNT        NUMBER :=0;
       L_ERROR_MESSAGE      VARCHAR2(30000);
    BEGIN
    
        --For each record in input table type merge the record
        FOR i IN P_IN_BUSINESS_UNIT.FIRST .. P_IN_BUSINESS_UNIT.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_ORGANIZATION_UNITS tbl
                USING (
                    SELECT 
                         P_IN_BUSINESS_UNIT(i).SOURCE_ORG_ID                SOURCE_ORG_ID            
                        ,P_IN_BUSINESS_UNIT(i).NAME                         NAME                     
                        ,P_IN_BUSINESS_UNIT(i).SHORT_CODE                   SHORT_CODE               
                        ,P_IN_BUSINESS_UNIT(i).SET_OF_BOOKS_ID              SET_OF_BOOKS_ID          
                        ,P_IN_BUSINESS_UNIT(i).DEFAULT_LEGAL_CONTEXT_ID     DEFAULT_LEGAL_CONTEXT_ID 
                        ,P_IN_BUSINESS_UNIT(i).DATE_FROM                    DATE_FROM                
                        ,P_IN_BUSINESS_UNIT(i).DATE_TO                      DATE_TO                  
                        ,P_IN_OIC_INSTANCE_ID                               OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.SOURCE_ORG_ID      = tmp.SOURCE_ORG_ID )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SOURCE_ORG_ID            
                        ,NAME                     
                        ,SHORT_CODE               
                        ,SET_OF_BOOKS_ID          
                        ,DEFAULT_LEGAL_CONTEXT_ID 
                        ,DATE_FROM                
                        ,DATE_TO                  
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.SOURCE_ORG_ID            
                        ,tmp.NAME                     
                        ,tmp.SHORT_CODE               
                        ,tmp.SET_OF_BOOKS_ID          
                        ,tmp.DEFAULT_LEGAL_CONTEXT_ID 
                        ,tmp.DATE_FROM                
                        ,tmp.DATE_TO                  
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         NAME                           = tmp.NAME                     
                        ,SHORT_CODE                     = tmp.SHORT_CODE               
                        ,SET_OF_BOOKS_ID                = tmp.SET_OF_BOOKS_ID          
                        ,DEFAULT_LEGAL_CONTEXT_ID       = tmp.DEFAULT_LEGAL_CONTEXT_ID 
                        ,DATE_FROM                      = tmp.DATE_FROM                
                        ,DATE_TO                        = tmp.DATE_TO                  
                        ,OIC_INSTANCE_ID                = tmp.OIC_INSTANCE_ID                  
                        ,LAST_UPDATE_DATE               = sysdate
                    WHERE    1=1
                    AND SOURCE_ORG_ID                   = tmp.SOURCE_ORG_ID;
                
                L_MERGE_COUNT:= L_MERGE_COUNT+1;
                
            EXCEPTION
            WHEN OTHERS THEN 
                BEGIN L_ERROR_MESSAGE :=L_ERROR_MESSAGE||CHR(10)||CHR(9)||SQLERRM; EXCEPTION WHEN OTHERS THEN NULL; END;
            END;
        
        END LOOP;
        
        P_OUT_RECORDS_FETCHED   := L_COUNT;
        P_OUT_RECORDS_MERGED    := L_MERGE_COUNT;
        P_OUT_ERROR_MESSAGE     := substr(L_ERROR_MESSAGE,1,4000);
        
    END MERGE_DATA;
    
END CHM_ORGANIZATION_UNIT_PKG;
/
