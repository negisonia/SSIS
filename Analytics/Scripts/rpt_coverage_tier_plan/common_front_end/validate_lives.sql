CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test010_validate_lives(lives double precision, health_plan_name varchar)
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value double precision;
  actual_value double precision;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
BEGIN

SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() INTO criteria_report_id;

SELECT calculate_report_value('lives', get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || health_plan_name || '''') INTO actual_value;
expected_value = lives;

PERFORM validate_comparison_values(actual_value, expected_value,'ana_rpt_coverage_tier_plan_test_009_validate_data-error: EXPECTED lives FOR PLAN ' || health_plan_name || ' TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;