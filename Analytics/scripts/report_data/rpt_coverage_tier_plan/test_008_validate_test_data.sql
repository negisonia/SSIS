CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_008_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value boolean;
  actual_value boolean;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  health_plan_names varchar[];
  plan_name varchar;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() INTO criteria_report_id;
--Query the actual value

health_plan_names := ARRAY['TEST_PLAN_008','TEST_PLAN_009','TEST_PLAN_010','TEST_PLAN_012','TEST_PLAN_013','TEST_PLAN_017','TEST_PLAN_018','TEST_PLAN_019'];

-- Validate Pharmacy Flag
FOREACH plan_name IN ARRAY health_plan_names
  LOOP

    SELECT calculate_report_value_boolean('has_pharmacy', get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || plan_name || '''') INTO actual_value;
    expected_value = TRUE;

    PERFORM validate_comparison_values_boolean(actual_value, expected_value,'ana_rpt_coverage_tier_plan_test_008_validate_data-error: EXPECTED has_pharmacy TO BE ');

END LOOP;


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
