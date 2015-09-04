-- Run from root of project
-- psql -d sandbox_data_warehouse_tmp -h restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com -U postgres -W --echo-all < Load/load_data_warehouse.sql
-- VsOCWIozIelwQcRgR4w3

-- Common
\i 'Common/data_warehouse/create_log_files.sql'
\i 'Common/data_warehouse/res_validate_criteria_restriction.sql'
\i 'Common/data_warehouse/res_validate_custom_criteria_restriction.sql'
\i 'Common/data_warehouse/res_validate_report_drug.sql'

-- Restrictions
\i 'Restrictions/scripts/test 002/test_002_validate_test_data.sql'
\i 'Restrictions/scripts/test 004/test_004_validate_test_data.sql'
\i 'Restrictions/scripts/test 006/test_006_validate.sql'
\i 'Restrictions/scripts/test 008/test_008_validate.sql'
\i 'Restrictions/scripts/test 010/test_010_validation.sql'
\i 'Restrictions/scripts/test 015/test_015_validate_test_data.sql'
