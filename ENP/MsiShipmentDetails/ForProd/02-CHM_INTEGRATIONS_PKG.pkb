create or replace PACKAGE BODY CHM_INTEGRATIONS_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Body                                                                                                                   *
    * Package Name                   : CHM_INTEGRATIONS_PKG                                                                                                                  *
    * Purpose                        : Package Body for CHM Integrations                                                                                                     *
    * Created By                     : Gurpreet Singh                                                                                                                        *
    * Created Date                   : 19-Jun-2023                                                                                                                           *     
    **************************************************************************************************************************************************************************
    * Date          By                             Company Name                     Version          Details                                                                 * 
    * -----------   ---------------------------    ---------------------------      -------------    ------------------------------------------------------------------------*
    * 19-Jun-2023   Gurpreet Singh                 Transform Edge                   1.0              Intial Version                                                          * 
	* 19-Nov-2024   Dhivagar                       Transform Edge                   1.1              COnverting Instance Id Datatype from Number to Varchar                  *
    * 25-Mar-2025   Raja Ratnakar Reddy            Selectiva                        1.2              Addition of new procedures                                              *
    *************************************************************************************************************************************************************************/

AS
    --Procedure to validate integration and update integrations & integration runs table
    PROCEDURE VALIDATE_INTEGRATION(
        P_IN_INTEGRATION_IDENTIFIER     IN      VARCHAR2,
        P_IN_OIC_INSTANCE_ID            IN      VARCHAR2,                            ---- V1.1 added by Dhivagar
        P_OUT_STATUS                    OUT     VARCHAR2,
        P_OUT_MESSAGE                   OUT     VARCHAR2
    )
    AS
        L_COUNT         NUMBER;
        L_OUTAGE        VARCHAR2(1);
        L_SYSDATE       DATE    :=SYSDATE;
    BEGIN

        INSERT INTO CHM_INTEGRATION_RUNS(
             CHM_INTEGRATION_RUN_ID
            ,INTEGRATION_IDENTIFIER
        )
        VALUES(
             P_IN_OIC_INSTANCE_ID
            ,P_IN_INTEGRATION_IDENTIFIER
        );
        COMMIT;


        SELECT  COUNT(1) INTO L_COUNT
        FROM    CHM_INTEGRATIONS
        WHERE   1=1
        AND     IDENTIFIER      = P_IN_INTEGRATION_IDENTIFIER
        AND     ENABLED_FLAG    = 'Y'
        ;

        --If integration is enabled
        IF L_COUNT >=1 
        THEN

            SELECT  OUTAGE_FLAG INTO L_OUTAGE
            FROM    CHM_INTEGRATIONS
            WHERE   1=1
            AND     IDENTIFIER      = P_IN_INTEGRATION_IDENTIFIER;


            --if integration is not in outage mode
            IF L_OUTAGE ='N' THEN
                P_OUT_STATUS    := 'ENABLED';
                P_OUT_MESSAGE   := 'Integration is valid and enabled';

                UPDATE  CHM_INTEGRATIONS 
                SET      LAST_RUN_ID        = P_IN_OIC_INSTANCE_ID
                        ,LAST_RUN_DATE      = L_SYSDATE
                        ,LAST_RUN_STATUS    = 'Running'
                WHERE   IDENTIFIER      = P_IN_INTEGRATION_IDENTIFIER;

                UPDATE CHM_INTEGRATION_RUNS
                SET      PHASE                      = 'Running'
                        ,STATUS                     = 'Normal'
                        ,LAST_COMPLETED_STAGE       = 'Validation'                    
                        ,LOG                        = 'Integration Validated Successfully. '
                WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
                COMMIT;
            --if integration is in outage mode
            ELSE
                P_OUT_STATUS    := 'OUTAGE';
                P_OUT_MESSAGE   := 'Integration is in outage mode';

                UPDATE  CHM_INTEGRATIONS 
                SET      LAST_RUN_ID        = P_IN_OIC_INSTANCE_ID
                        ,LAST_RUN_DATE      = L_SYSDATE 
                        ,LAST_RUN_STATUS    = 'Outage Active'                        
                WHERE   IDENTIFIER      = P_IN_INTEGRATION_IDENTIFIER;

                UPDATE CHM_INTEGRATION_RUNS
                SET      PHASE                      = 'Completed'
                        ,STATUS                     = 'Outage Active'                    
                        ,LAST_COMPLETED_STAGE       = 'Validation'                    
                        ,LOG                        = 'Integration Validated Successfully. '
                        ,ERROR_MESSAGE              = 'Integration is in outage mode. '
                        ,COMPLETION_DATE            = sysdate
                WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
                COMMIT;

            END IF;


        --if integration is not registered in CHM or disabled    
        ELSE
            P_OUT_STATUS    := 'DISABLED';
            P_OUT_MESSAGE   := 'Integration is invalid or disabled';

            UPDATE  CHM_INTEGRATIONS 
            SET      LAST_RUN_ID        = P_IN_OIC_INSTANCE_ID
                    ,LAST_RUN_DATE      = L_SYSDATE
                    ,LAST_RUN_STATUS    = 'Disabled'
            WHERE   IDENTIFIER          = P_IN_INTEGRATION_IDENTIFIER;

            UPDATE CHM_INTEGRATION_RUNS
            SET      PHASE                      = 'Completed'
                    ,STATUS                     = 'Disabled'
                    ,LAST_COMPLETED_STAGE       = 'Validation'                    
                    ,LOG                        = 'Integration Validated Successfully. '
                    ,ERROR_MESSAGE              = 'Integration is invalid or disabled. '
                    ,COMPLETION_DATE            = sysdate
            WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
            COMMIT;

        END IF;



    END VALIDATE_INTEGRATION;

    --Procedure to update integrations and integration runs table
    PROCEDURE UPDATE_INTEGRATION_RUN(
        P_IN_INTEGRATION_IDENTIFIER     IN      VARCHAR2,
        P_IN_OIC_INSTANCE_ID            IN      VARCHAR2,                                         ---- V1.1 added by Dhivagar
        P_IN_LAST_RUN_STATUS            IN      VARCHAR2,
        P_IN_LAST_COMPLETED_STAGE       IN      VARCHAR2,
        P_IN_ERROR_MESSAGE              IN      VARCHAR2,
        P_IN_LOG                        IN      VARCHAR2,
        P_IN_PHASE                      IN      VARCHAR2,
        P_IN_STATUS                     IN      VARCHAR2,
        P_IN_COMPLETION_DATE            IN      DATE,
        P_IN_TOTAL_FETCHED_RECORDS      IN      NUMBER,
        P_IN_TOTAL_SUCCESS_RECORDS      IN      NUMBER,
        P_IN_TOTAL_ERROR_RECORDS        IN      NUMBER,
        P_IN_JIRA_TICKET                IN      VARCHAR2,
        P_OUT_STATUS                    OUT     VARCHAR2,
        P_OUT_MESSAGE                   OUT     VARCHAR2
    )
    AS
    BEGIN

        UPDATE  CHM_INTEGRATIONS 
        SET     LAST_RUN_STATUS             = nvl(P_IN_LAST_RUN_STATUS,LAST_RUN_STATUS)
        WHERE   IDENTIFIER                  = P_IN_INTEGRATION_IDENTIFIER;

        UPDATE CHM_INTEGRATION_RUNS
        SET      LAST_COMPLETED_STAGE       = nvl(P_IN_LAST_COMPLETED_STAGE,LAST_COMPLETED_STAGE)
                ,ERROR_MESSAGE              = nvl(P_IN_ERROR_MESSAGE,ERROR_MESSAGE)
                ,LOG                        = LOG||nvl2(P_IN_LOG,chr(10)||P_IN_LOG,'')
                ,PHASE                      = nvl(P_IN_PHASE,PHASE)
                ,STATUS                     = nvl(P_IN_STATUS,STATUS)
                ,COMPLETION_DATE            = nvl(P_IN_COMPLETION_DATE,COMPLETION_DATE)
                ,TOTAL_FETCHED_RECORDS      = nvl(P_IN_TOTAL_FETCHED_RECORDS,TOTAL_FETCHED_RECORDS)
                ,TOTAL_SUCCESS_RECORDS      = nvl(P_IN_TOTAL_SUCCESS_RECORDS,TOTAL_SUCCESS_RECORDS)
                ,TOTAL_ERROR_RECORDS        = nvl(P_IN_TOTAL_ERROR_RECORDS,TOTAL_ERROR_RECORDS)
                ,JIRA_TICKET                = nvl(P_IN_JIRA_TICKET,JIRA_TICKET)
        WHERE   CHM_INTEGRATION_RUN_ID      = P_IN_OIC_INSTANCE_ID;            
        COMMIT;

    END UPDATE_INTEGRATION_RUN;

    --Additions for v1.2 starts

    --Procedure to update integration run table   
    PROCEDURE FINISH_INTEGRATION_RUN (
         P_IN_OIC_INSTANCE_ID               IN VARCHAR2
        ,P_OUT_TOTAL_FETCHED_RECORDS        OUT NUMBER
        ,P_OUT_TOTAL_SUCCESS_RECORDS        OUT NUMBER
        ,P_OUT_TOTAL_ERROR_RECORDS          OUT NUMBER
    )
    AS
    BEGIN

        UPDATE CHM_INTEGRATION_RUNS
        SET 
             PHASE                  = 'Completed'
            ,STATUS                 = 'Success'
            ,LAST_COMPLETED_STAGE   = 'Data Merge'
            ,LOG                    = LOG || CHR(10) ||'Integration completed successfully'
            ,LAST_UPDATE_DATE       = SYSDATE
            ,COMPLETION_DATE        = SYSDATE
        WHERE CHM_INTEGRATION_RUN_ID = P_IN_OIC_INSTANCE_ID;
        COMMIT;

        UPDATE CHM_INTEGRATIONS
        SET 
             LAST_RUN_STATUS        = 'Success'
        WHERE LAST_RUN_ID = P_IN_OIC_INSTANCE_ID;
        COMMIT;

        SELECT 
                NVL(TOTAL_FETCHED_RECORDS,0), NVL(TOTAL_SUCCESS_RECORDS,0) , NVL(TOTAL_ERROR_RECORDS,0) 
        INTO    P_OUT_TOTAL_FETCHED_RECORDS, P_OUT_TOTAL_SUCCESS_RECORDS, P_OUT_TOTAL_ERROR_RECORDS
        FROM CHM_INTEGRATION_RUNS 
        WHERE CHM_INTEGRATION_RUN_ID = P_IN_OIC_INSTANCE_ID;

    END FINISH_INTEGRATION_RUN;

    --Procedure to update log
    PROCEDURE UPDATE_LOG (
         P_IN_LOG                IN VARCHAR2
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
    AS

    BEGIN
        UPDATE CHM_INTEGRATION_RUNS
        SET 
             LOG                        = LOG || CHR(10) || P_IN_LOG
            ,LAST_UPDATE_DATE           = SYSDATE
        WHERE CHM_INTEGRATION_RUN_ID    = P_IN_OIC_INSTANCE_ID;
        COMMIT;
    END UPDATE_LOG;

    --Procedure to check if any record failed
    PROCEDURE CHECK_FAILED_RECORDS (
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    )
    AS
        L_COUNT NUMBER;
    BEGIN
        SELECT NVL(TOTAL_ERROR_RECORDS,0) INTO L_COUNT
        FROM CHM_INTEGRATION_RUNS
        WHERE CHM_INTEGRATION_RUN_ID = P_IN_OIC_INSTANCE_ID;

        IF L_COUNT > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Few Records failed to merge, please check the logs in LOG column of CHM_INTEGRATION_RUNS table for current CHM_INTEGRATION_RUN_ID = '||P_IN_OIC_INSTANCE_ID);
        END IF;

    END CHECK_FAILED_RECORDS;

    --Additions for v1.2 ends

END CHM_INTEGRATIONS_PKG;
/
