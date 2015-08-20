-- Run from root of project
-- psql -d sandbox_admin -h restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com -U postgres -W < Load/load_admin.sql
-- VsOCWIozIelwQcRgR4w3

-- Common
\i 'Common/common_get_table_id_by_name.sql'

-- Common Admin
\i 'Common/admin/create_client_admin.sql'
\i 'Common/admin/create_custom_account.sql'
\i 'Common/admin/create_report_admin.sql'
\i 'Common/admin/create_report_client_admin.sql'
\i 'Common/admin/create_report_criteria_groups_admin.sql'
\i 'Common/admin/create_report_drugs_admin.sql'
\i 'Common/admin/create_report_restrictions_admin.sql'
\i 'Common/admin/test_data_client.sql'
\i 'Common/admin/test_data_custom_accounts.sql'