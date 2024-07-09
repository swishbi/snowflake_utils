/*
This script sets up Saml-based SSO between Microsoft Entra ID (formerly Azure AD) and Snowflake.
These commands should be run in the Snowflake UI.
*/

use role accountadmin;
create or replace security integration microsoft_entra_id
  TYPE = saml2
  ENABLED = true
  SAML2_ISSUER = 'https://sts.windows.net...'
  SAML2_SSO_URL = 'https://login.microsoftonline.com...'
  SAML2_PROVIDER = 'custom'
  SAML2_X509_CERT = 'MIIC...'
  SAML2_SNOWFLAKE_ISSUER_URL = 'https://<account>.snowflakecomputing.com'
  SAML2_SNOWFLAKE_ACS_URL = 'https://<account>.snowflakecomputing.com/fed/login';

alter security integration microsoft_entra_id set SAML2_ENABLE_SP_INITIATED = true;
alter security integration microsoft_entra_id set SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'Microsoft Entra ID';