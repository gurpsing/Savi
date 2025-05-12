CREATE OR REPLACE PACKAGE BODY CHM_ITEM_CATEGORY_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_ITEM_CATEGORY_PKG                                                                                                                 *
    * Purpose                        : Package Body for CHM Item Category Integrations                                                                                       *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 29-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 29-Jun-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
    * 20-Nov-2024   Dhivagar                       Transform Edge                   1.1              Changing OIC_INSTANCE_ID Datatype from Number to Varchar                *
    *************************************************************************************************************************************************************************/

AS
    
    --Procedure to merge data into CHM table
    PROCEDURE MERGE_DATA(
         P_IN_ITEM_CATEGORY			    IN      TBL_ITEM_CATEGORY
        ,P_IN_OIC_INSTANCE_ID           IN      VARCHAR2           ------- V1.1
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
        FOR i IN P_IN_ITEM_CATEGORY.FIRST .. P_IN_ITEM_CATEGORY.LAST 
        LOOP
            L_COUNT := L_COUNT +1;
            BEGIN
                
                --Merge in CHM table
                MERGE INTO CHM_ITEM_CATEGORIES tbl
                USING (
                    SELECT 
                         P_IN_ITEM_CATEGORY(i).SOURCE_CATEGORY_ID        SOURCE_CATEGORY_ID
                        ,P_IN_ITEM_CATEGORY(i).LANGUAGE                  LANGUAGE
                        ,P_IN_ITEM_CATEGORY(i).CATEGORY_NAME             CATEGORY_NAME
                        ,P_IN_ITEM_CATEGORY(i).DESCRIPTION               DESCRIPTION
                        ,P_IN_ITEM_CATEGORY(i).CATEGORY_CONTENT_CODE     CATEGORY_CONTENT_CODE
                        ,P_IN_ITEM_CATEGORY(i).CATEGORY_CODE             CATEGORY_CODE
                        ,P_IN_ITEM_CATEGORY(i).DISABLE_DATE              DISABLE_DATE
                        ,P_IN_ITEM_CATEGORY(i).SUMMARY_FLAG              SUMMARY_FLAG
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE_CATEGORY        ATTRIBUTE_CATEGORY
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE1                ATTRIBUTE1  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE2                ATTRIBUTE2  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE3                ATTRIBUTE3  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE4                ATTRIBUTE4  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE5                ATTRIBUTE5  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE6                ATTRIBUTE6  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE7                ATTRIBUTE7  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE8                ATTRIBUTE8  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE9                ATTRIBUTE9  
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE10               ATTRIBUTE10 
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE11               ATTRIBUTE11 
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE12               ATTRIBUTE12 
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE13               ATTRIBUTE13 
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE14               ATTRIBUTE14 
                        ,P_IN_ITEM_CATEGORY(i).ATTRIBUTE15               ATTRIBUTE15 
                        ,P_IN_ITEM_CATEGORY(i).ENABLED_FLAG              ENABLED_FLAG 
                        ,P_IN_ITEM_CATEGORY(i).START_DATE_ACTIVE         START_DATE_ACTIVE 
                        ,P_IN_ITEM_CATEGORY(i).END_DATE_ACTIVE           END_DATE_ACTIVE 
                        ,P_IN_OIC_INSTANCE_ID                           OIC_INSTANCE_ID
                    FROM DUAL
                ) tmp
                ON (    tbl.SOURCE_CATEGORY_ID      = tmp.SOURCE_CATEGORY_ID )
                WHEN NOT MATCHED THEN
                    INSERT (
                         SOURCE_CATEGORY_ID
                        ,LANGUAGE
                        ,CATEGORY_NAME
                        ,DESCRIPTION
                        ,CATEGORY_CONTENT_CODE
                        ,CATEGORY_CODE
                        ,DISABLE_DATE
                        ,SUMMARY_FLAG
                        ,ATTRIBUTE_CATEGORY
                        ,ATTRIBUTE1  
                        ,ATTRIBUTE2  
                        ,ATTRIBUTE3  
                        ,ATTRIBUTE4  
                        ,ATTRIBUTE5  
                        ,ATTRIBUTE6  
                        ,ATTRIBUTE7  
                        ,ATTRIBUTE8  
                        ,ATTRIBUTE9  
                        ,ATTRIBUTE10 
                        ,ATTRIBUTE11 
                        ,ATTRIBUTE12 
                        ,ATTRIBUTE13 
                        ,ATTRIBUTE14 
                        ,ATTRIBUTE15 
                        ,ENABLED_FLAG 
                        ,START_DATE_ACTIVE 
                        ,END_DATE_ACTIVE 
                        ,OIC_INSTANCE_ID
                    )
                    VALUES (
                         tmp.SOURCE_CATEGORY_ID
                        ,tmp.LANGUAGE
                        ,tmp.CATEGORY_NAME
                        ,tmp.DESCRIPTION
                        ,tmp.CATEGORY_CONTENT_CODE
                        ,tmp.CATEGORY_CODE
                        ,tmp.DISABLE_DATE
                        ,tmp.SUMMARY_FLAG
                        ,tmp.ATTRIBUTE_CATEGORY
                        ,tmp.ATTRIBUTE1  
                        ,tmp.ATTRIBUTE2  
                        ,tmp.ATTRIBUTE3  
                        ,tmp.ATTRIBUTE4  
                        ,tmp.ATTRIBUTE5  
                        ,tmp.ATTRIBUTE6  
                        ,tmp.ATTRIBUTE7  
                        ,tmp.ATTRIBUTE8  
                        ,tmp.ATTRIBUTE9  
                        ,tmp.ATTRIBUTE10 
                        ,tmp.ATTRIBUTE11 
                        ,tmp.ATTRIBUTE12 
                        ,tmp.ATTRIBUTE13 
                        ,tmp.ATTRIBUTE14 
                        ,tmp.ATTRIBUTE15 
                        ,tmp.ENABLED_FLAG 
                        ,tmp.START_DATE_ACTIVE 
                        ,tmp.END_DATE_ACTIVE 
                        ,tmp.OIC_INSTANCE_ID
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                         LANGUAGE                   = tmp.LANGUAGE
                        ,CATEGORY_NAME              = tmp.CATEGORY_NAME
                        ,DESCRIPTION                = tmp.DESCRIPTION
                        ,CATEGORY_CONTENT_CODE      = tmp.CATEGORY_CONTENT_CODE
                        ,CATEGORY_CODE              = tmp.CATEGORY_CODE
                        ,DISABLE_DATE               = tmp.DISABLE_DATE
                        ,SUMMARY_FLAG               = tmp.SUMMARY_FLAG
                        ,ATTRIBUTE_CATEGORY         = tmp.ATTRIBUTE_CATEGORY
                        ,ATTRIBUTE1                 = tmp.ATTRIBUTE1  
                        ,ATTRIBUTE2                 = tmp.ATTRIBUTE2  
                        ,ATTRIBUTE3                 = tmp.ATTRIBUTE3  
                        ,ATTRIBUTE4                 = tmp.ATTRIBUTE4  
                        ,ATTRIBUTE5                 = tmp.ATTRIBUTE5  
                        ,ATTRIBUTE6                 = tmp.ATTRIBUTE6  
                        ,ATTRIBUTE7                 = tmp.ATTRIBUTE7  
                        ,ATTRIBUTE8                 = tmp.ATTRIBUTE8  
                        ,ATTRIBUTE9                 = tmp.ATTRIBUTE9  
                        ,ATTRIBUTE10                = tmp.ATTRIBUTE10 
                        ,ATTRIBUTE11                = tmp.ATTRIBUTE11 
                        ,ATTRIBUTE12                = tmp.ATTRIBUTE12 
                        ,ATTRIBUTE13                = tmp.ATTRIBUTE13 
                        ,ATTRIBUTE14                = tmp.ATTRIBUTE14 
                        ,ATTRIBUTE15                = tmp.ATTRIBUTE15 
                        ,ENABLED_FLAG               = tmp.ENABLED_FLAG 
                        ,START_DATE_ACTIVE          = tmp.START_DATE_ACTIVE 
                        ,END_DATE_ACTIVE            = tmp.END_DATE_ACTIVE 
                        ,OIC_INSTANCE_ID			= tmp.OIC_INSTANCE_ID
                        ,LAST_UPDATE_DATE			= sysdate
                    WHERE	1=1
                    AND SOURCE_CATEGORY_ID          = tmp.SOURCE_CATEGORY_ID;
                
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
    
END CHM_ITEM_CATEGORY_PKG;
/





