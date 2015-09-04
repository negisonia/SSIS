CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_004_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value boolean;
  plan_name varchar;
  current_month_int INTEGER;
  criteria_report_id INTEGER;
  health_plan_names varchar[];
  value_exists boolean;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() INTO criteria_report_id;

health_plan_names := ARRAY['TEST_PLAN_008','TEST_PLAN_009','TEST_PLAN_010','TEST_PLAN_012','TEST_PLAN_013','TEST_PLAN_017','TEST_PLAN_018','TEST_PLAN_019'];

expected_value = TRUE;
-- Validate that is Tier 3 Preferred for each plan in the array
FOREACH plan_name IN ARRAY health_plan_names
  LOOP

    SELECT calculate_report_value_boolean(TRUE, get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || plan_name || '''') INTO value_exists;
    PERFORM validate_comparison_values_boolean(value_exists, expected_value,'ana_rpt_coverage_tier_plan_test_004_validate_data-error: EXPECTED ' || plan_name || ' TO EXIST ');

END LOOP;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
