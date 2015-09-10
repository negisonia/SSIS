CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value varchar, test_number varchar, drug_name varchar, qualifier_name varchar) --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  actual_value varchar;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  report_select_columns varchar;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_restrictions_drug_test_001_017_create_fe_data() INTO criteria_report_id;

report_select_columns  = 'drug_id, drug_name, qualifier_name, avg_copay, lis_lives, total_lis_lives, lives, total_lives, health_plan_count, total_health_plan_count'
--Query the actual value
SELECT calculate_report_value(report_select_columns, get_report_name_call('rpt_coverage_tier_restrictions', ARRAY[criteria_report_id,current_month_int]), 'drug_name=''' || drug_name || ''' AND qualifier_name=''' || qualifier_name ||'''') INTO actual_value;

PERFORM validate_comparison_values_varchar(actual_value, expected_value,'ana_rpt_coverage_restrictions_drug_test_'|| test_number ||'_validate_data-error: EXPECTED ' || report_select_columns  || ' FOR drug_name ' || drug_name || ' and qualifier_name ' || qualifier_name ||' TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
