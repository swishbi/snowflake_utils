/* 
This script sets up the Snowflake environment for the data warehouse.
These commands should be run in the Snowflake UI.
THIS WILL OVERWRITE THE EXISTING ENVIRONMENT.
*/

-- assign admin roles to warehouse
use role accountadmin;
grant usage on warehouse COMPUTE_WH to role SYSADMIN;
grant usage on warehouse COMPUTE_WH to role USERADMIN;

alter account set QUOTED_IDENTIFIERS_IGNORE_CASE = TRUE;

-- create roles
use role useradmin;
create or replace role ANALYST comment = 'Analyst role can read data in analytics.marts.';
create or replace role DEVELOPER comment = 'Developer role can read data in raw and analytics, and write data in analytics.dev.';
create or replace role AUTOMATION comment = 'Automation role can read data in raw and write data in analytics.';
create or replace role LOADER comment = 'Loader role can read and write data in raw.';

-- create users
create or replace user LOADER with
    password = 'loader'  -- be sure to change this password later!
    default_role = LOADER
    default_warehouse = LOADER_WH;

create or replace user AUTOMATION with
    password = 'automation'  -- be sure to change this password later!
    default_role = AUTOMATION
    default_warehouse = AUTOMATION_WH;

-- make sure to run this command after the setup script
-- alter user LOADER set password = '<secure password>'
-- alter user AUTOMATION set password = '<secure password>'
    
grant role LOADER to user LOADER;
grant role AUTOMATION to user AUTOMATION;

-- hierarchy [Analyst < Developer < Automation]
grant role ANALYST to role DEVELOPER;
grant role DEVELOPER to role AUTOMATION;
grant role AUTOMATION to role SYSADMIN;

-- create warehouses for each role
use role sysadmin;
create or replace warehouse ANALYST_WH with 
    warehouse_size = 'XSMALL'
    initially_suspended = true
    auto_suspend = 600
    auto_resume = true;
    
create or replace warehouse DEVELOPER_WH with
    warehouse_size = 'XSMALL'
    initially_suspended = true
    auto_suspend = 600
    auto_resume = true;
    
create or replace warehouse AUTOMATION_WH with
    warehouse_size = 'XSMALL'
    initially_suspended = true
    auto_suspend = 600
    auto_resume = true;
    
create or replace warehouse LOADER_WH with
    warehouse_size = 'XSMALL'
    initially_suspended = true
    auto_suspend = 600
    auto_resume = true;

-- create databases
create or replace database RAW comment = 'Stores unprocessed, original data from various sources.';
create or replace database ANALYTICS comment = 'Contains staged, cleaned, transformed, and structured data optimized for querying and reporting.';

-- grant warehouse usage to roles
use role securityadmin;
grant usage on warehouse AUTOMATION_WH to role AUTOMATION;
grant usage on warehouse DEVELOPER_WH to role DEVELOPER;
grant usage on warehouse ANALYST_WH to role ANALYST;
grant usage on warehouse LOADER_WH to role LOADER;

-- grant database
grant usage on database RAW to role LOADER;
grant usage on database RAW to role DEVELOPER;
grant usage on database ANALYTICS to role ANALYST;

grant create schema on database RAW to role LOADER;
grant create schema on database ANALYTICS to role DEVELOPER;

-- grant usage
grant usage on future schemas in database RAW to role DEVELOPER;
grant select on future tables in database RAW to role DEVELOPER;

grant usage on future schemas in database ANALYTICS to role DEVELOPER;
grant select on future tables in database ANALYTICS to role DEVELOPER;
grant select on future views in database ANALYTICS to role DEVELOPER;