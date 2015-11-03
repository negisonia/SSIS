CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_validate_report_row(expected_value varchar, test_number varchar, drug_name varchar, qualifier_name varchar, criteria_report_id integer) --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  actual_value varchar;
  current_month_int INTEGER;
  report_select_columns varchar;
BEGIN

-- Current Month
SELECT ana_get_current_month() INTO current_month_int;

report_select_columns  = 'drug_name, qualifier_name, avg_copay, lis_lives, total_lis_lives, lives, total_lives, health_plan_count, total_health_plan_count';
--Query the actual value
SELECT ana_calculate_report_row_as_json(report_select_columns, 'rpt_coverage_restrictions_drug', ARRAY[criteria_report_id,current_month_int], format('drug_name=''%s'' AND qualifier_name=''%s''', drug_name, qualifier_name)) INTO actual_value;

PERFORM ana_compare_results(actual_value, expected_value,'ana_rpt_coverage_restrictions_drug_test_'|| test_number ||'_validate_data-error: EXPECTED FOR ROW RESULTS TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
