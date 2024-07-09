/*
This script sets up user provisioning between Microsoft Entra ID (formerly Azure AD) and Snowflake.
These commands should be run in the Snowflake UI.
*/

use role accountadmin;

create or replace role AAD_PROVISIONER;

grant create user on account to role AAD_PROVISIONER;
grant create role on account to role AAD_PROVISIONER;

grant role AAD_PROVISIONER to role ACCOUNTADMIN;
create or replace security integration aad_provisioning
    type = scim
    scim_client = 'azure'
    run_as_role = 'AAD_PROVISIONER';
    
select system$generate_scim_access_token('AAD_PROVISIONING');