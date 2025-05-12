create or replace PACKAGE CHM_INTEGRATIONS_PKG
    
    /*************************************************************************************************************************************************************************
    * Type                           : PL/SQL Package Specification                                                                                                          *
    * Package Name                   : CHM_INTEGRATIONS_PKG                                                                                                                  *
    * Purpose                        : Package Specification for CHM Integrations                                                                                            *
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
        P_IN_OIC_INSTANCE_ID            IN      VARCHAR2,                           ---- V1.1 added by Dhivagar
        P_OUT_STATUS                    OUT     VARCHAR2,
        P_OUT_MESSAGE                   OUT     VARCHAR2
    );

    --Procedure to update integrations & integration runs table
    PROCEDURE UPDATE_INTEGRATION_RUN(
        P_IN_INTEGRATION_IDENTIFIER     IN      VARCHAR2,
        P_IN_OIC_INSTANCE_ID            IN      VARCHAR2,                           ---- V1.1 added by Dhivagar
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
    );

    --Additions for v1.2 starts

    --Procedure to update integration run table   
    PROCEDURE FINISH_INTEGRATION_RUN (
         P_IN_OIC_INSTANCE_ID               IN VARCHAR2
        ,P_OUT_TOTAL_FETCHED_RECORDS        OUT NUMBER
        ,P_OUT_TOTAL_SUCCESS_RECORDS        OUT NUMBER
        ,P_OUT_TOTAL_ERROR_RECORDS          OUT NUMBER
    );


    --Procedure to update log
    PROCEDURE UPDATE_LOG (
         P_IN_LOG                IN VARCHAR2
        ,P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    );

    --Procedure to check if any record failed
    PROCEDURE CHECK_FAILED_RECORDS (
        P_IN_OIC_INSTANCE_ID    IN VARCHAR2
    );

    --Additions for v1.2 ends



END CHM_INTEGRATIONS_PKG;
/
