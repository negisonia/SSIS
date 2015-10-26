CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_drug_validate_report_row(expected_value varchar, test_number varchar, drug_name varchar, dim_tier_name varchar, is_tier_preferred varchar, criteria_report_id integer)
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  actual_value varchar;
  current_month_int INTEGER;
  report_select_columns varchar;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;

report_select_columns  = 'drug_name, dim_tier_name, is_tier_preferred, dim_tier_id, dim_tier_type_id, avg_copay, lis_lives, total_lis_lives, lives, total_lives, health_plan_count, total_health_plan_count';
--Query the actual value
SELECT calculate_report_value_json(report_select_columns, get_report_name_call('rpt_coverage_tier_drug', ARRAY[criteria_report_id,current_month_int]), 'drug_name=''' || drug_name || ''' AND dim_tier_name=''' || dim_tier_name || ''' AND is_tier_preferred=''' || is_tier_preferred || ''' ') INTO actual_value;

PERFORM validate_comparison_values_varchar(actual_value, expected_value,'ana_rpt_coverage_tier_drug_test_'|| test_number ||'_validate_data-error: EXPECTED FOR ROW RESULTS TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;