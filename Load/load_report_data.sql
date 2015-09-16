-- Run from root of project
-- psql -d sandbox_report_data -h restrictions20-psql94.cayadjd1xwwj.us-east-1.rds.amazonaws.com -U postgres -W < Load/load_report_data.sql
-- VsOCWIozIelwQcRgR4w3

--psql -d sandbox_report_data -h localhost -U postgres -W < Load/load_report_data.sql

-- Common
\i 'Common/common_get_table_id_by_name.sql'

-- Common
-- Analytics
\i 'Common/front_end/add_criteria_report_markets.sql'
\i 'Common/front_end/calculate_report_value.sql'
\i 'Common/front_end/calculate_report_value_varchar.sql'
\i 'Common/front_end/clear_test_data.sql'
\i 'Common/front_end/create_criteria_report.sql'
\i 'Common/front_end/get_current_month.sql'
\i 'Common/front_end/get_report_name_call.sql'
\i 'Common/front_end/validate_comparison_values.sql'
\i 'Common/front_end/validate_comparison_values_varchar.sql'
\i 'Common/front_end/validate_test_data.sql'
\i 'Common/front_end/calculate_report_value_boolean.sql'
\i 'Common/front_end/validate_comparison_values_boolean.sql'
\i 'Common/front_end/validate_comparison_values_varchar.sql'
\i 'Common/front_end/res_rpt_summary_table_validate_data.sql'
\i 'Common/front_end/common_get_dim_criteria.sql'
\i 'Common/front_end/get_report_id_by_criteria_report_id.sql'
\i 'Common/front_end/res_validate_report_drug.sql'
\i 'Common/front_end/res_validate_criteria_restriction.sql'
\i 'Common/front_end/res_validate_custom_criteria_restriction.sql'

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
\i 'Analytics/Scripts/rpt_coverage_tier_provider/common_front_end/test_001_008_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/common_front_end/test_009_016_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_001_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_002_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_003_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_004_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_005_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_006_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_007_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_008_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_009_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_010_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_011_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_012_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_013_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_014_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_015_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_provider/test_016_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/common_front_end/test_001_010_create_fe_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/common_front_end/validate_copay.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/common_front_end/validate_dim_tier_id_and_name.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/common_front_end/validate_has_restriction.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/common_front_end/validate_has_restriction_set.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/common_front_end/validate_lives.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/common_front_end/validate_plan_type.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_001_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_002_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_003_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_004_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_005_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_006_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_007_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_008_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_009_validate_test_data.sql'
\i 'Analytics/Scripts/rpt_coverage_tier_plan/test_010_validate_test_data.sql'

-- Restrictions
\i 'Restrictions/scripts/test 001/test_001_validate_test_data.sql'
\i 'Restrictions/scripts/test 003/test_003_validate_test_data.sql'
\i 'Restrictions/scripts/test 005/test_005_validate.sql'
\i 'Restrictions/scripts/test 007/test_007_validate.sql'
\i 'Restrictions/scripts/test 009/test_009_validation.sql'
\i 'Restrictions/scripts/test 016/test_016_validate_test_data.sql'
\i 'Restrictions/scripts/test 017/test_017_validate_test_data.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_test_2.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_validate_custom_account.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_validate_custom_account_criteria.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_create_fe_test_data.sql'
\i 'Restrictions/scripts/custom_accounts/ca_etl_test_3.sql'

