-- Run from root of project
-- psql -d sandbox_admin -h restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com -U postgres -W < Load/load_admin.sql
-- VsOCWIozIelwQcRgR4w3

-- Common
\i 'Common/call_functions_from_table.sql'
\i 'Common/common_create_test_data_functions.sql'
\i 'Common/common_get_table_id_by_name.sql'

-- Common Admin
\i 'Common/admin/common_cleanup.sql'
\i 'Common/admin/create_client.sql'
\i 'Common/admin/common_create_client_custom_criteria_group.sql'
\i 'Common/admin/common_create_custom_criteria_group.sql'
\i 'Common/admin/common_create_custom_criteria_group_criteria.sql'
\i 'Common/admin/common_create_report.sql'
\i 'Common/admin/common_create_report_client.sql'
\i 'Common/admin/common_create_report_criteria.sql'
\i 'Common/admin/common_create_report_drugs.sql'
\i 'Common/admin/common_insert_test_data_functions_table.sql'
\i 'Common/admin/create_custom_account.sql'
\i 'Common/admin/create_foreign_tables.sql'
\i 'Common/admin/res_validate_criteria_restriction.sql'
\i 'Common/admin/res_validate_custom_criteria_restriction.sql'
\i 'Common/admin/res_validate_report_drug.sql'
\i 'Common/admin/test_data_client.sql'
\i 'Common/admin/test_data_client_custom_criteria_groups.sql'
\i 'Common/admin/test_data_custom_accounts.sql'
\i 'Common/admin/test_data_custom_criteria_groups.sql'
\i 'Common/admin/test_data_reports.sql'


\i 'Restrictions/scripts/test 009/test_009_validation.sql'
\i 'Restrictions/scripts/test 011/test_011_validation.sql'