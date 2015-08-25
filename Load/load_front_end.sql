-- Run from root of project
-- psql -d sandbox_front_end_tmp -h restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com -U postgres -W --echo-all < Load/load_front_end.sql
-- VsOCWIozIelwQcRgR4w3

-- Common
-- Analytics
\i 'Common/analytics_front_end/add_criteria_report_markets.sql'
\i 'Common/analytics_front_end/add_criteria_report_markets.sql'
\i 'Common/analytics_front_end/clear_test_data.sql'
\i 'Common/analytics_front_end/get_current_month.sql'
\i 'Common/analytics_front_end/validate_comparison_values.sql'
\i 'Common/analytics_front_end/calculate_report_value.sql'
\i 'Common/analytics_front_end/create_criteria_report.sql'
\i 'Common/analytics_front_end/get_report_name_call.sql'
\i 'Common/analytics_front_end/validate_test_data.sql'

-- Common
-- Restrictions
\i 'Common/restrictions_front end/create_report_fe.sql'
\i 'Common/restrictions_front end/get_report_active_restrictions.sql'
\i 'Common/restrictions_front end/get_total_health_plan_count_fe.sql'
\i 'Common/restrictions_front end/get_health_plan_count.sql'
\i 'Common/restrictions_front end/get_report_restrictioned_drugs_fe.sql'

-- Analytics
-- Rpt Coverage Tier Drug
\i 'Analytics/Scripts/rpt_coverage_tier_drug/common_front_end/test_001_007_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_drug/test_001/test_001_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_drug/test_002/test_002_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_drug/test_003/test_003_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_drug/test_004/test_004_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_drug/test_005/test_005_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_drug/test_006/test_006_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_drug/test_007/test_007_validate_test_data.sql'

-- Analytics
-- Rpt Coverage Tier Geo
\i 'Analytics/Scripts/rpt_coverage_tier_geo/common_front_end/test_001_002_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/common_front_end/test_003_006_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/common_front_end/test_007_010_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/common_front_end/test_011_014_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/common_front_end/test_015_016_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_001/test_001_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_002/test_002_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_003/test_003_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_004/test_004_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_005/test_005_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_006/test_006_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_007/test_007_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_008/test_008_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_009/test_009_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_010/test_010_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_011/test_011_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_012/test_012_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_013/test_013_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_014/test_014_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_015/test_015_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_geo/test_016/test_016_validate_test_data.sql'

-- Restrictions
\i 'Restrictions/scripts/test 001/test_001_validate_test_data.sql'
\i 'Restrictions/scripts/test 003/test_003_validate_test_data.sql'
\i 'Restrictions/scripts/test 005/test_005_validate.sql'
\i 'Restrictions/scripts/test 007/test_007_validate.sql'
\i 'Restrictions/scripts/test 009/test_009_validation.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_test_2.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_validate_custom_account.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_validate_custom_account_criteria.sql'
