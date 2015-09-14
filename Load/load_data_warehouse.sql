-- Run from root of project
-- psql -d sandbox_data_warehouse -h restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com -U postgres -W < Load/load_data_warehouse.sql
-- VsOCWIozIelwQcRgR4w3

-- Common
\i 'Common/common_get_table_id_by_name.sql'

-- Common datawarehouse
\i 'Common/data_warehouse/create_log_files.sql'
\i 'Common/data_warehouse/res_validate_criteria_restriction.sql'
\i 'Common/data_warehouse/res_validate_custom_criteria_restriction.sql'
\i 'Common/data_warehouse/res_validate_report_drug.sql'

-- Restrictions
-- Custom accounts
\i 'Restrictions/scripts/custom_accounts/ca_etl_test_1.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_validate_custom_account.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_validate_custom_account_criteria.sql'

\i 'Restrictions/scripts/test 002/test_002_validate_test_data.sql'
\i 'Restrictions/scripts/test 004/test_004_validate_test_data.sql'
\i 'Restrictions/scripts/test 006/test_006_validate.sql'
\i 'Restrictions/scripts/test 008/test_008_validate.sql'
\i 'Restrictions/scripts/test 010/test_010_validation.sql'
\i 'Restrictions/scripts/test 015/test_015_validate_test_data.sql'
