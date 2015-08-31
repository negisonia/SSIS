CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_003_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value double precision;
  actual_value INTEGER;
  expected_value_varchar varchar;
  actual_value_varchar varchar;
  expected_value_boolean boolean;
  actual_value_boolean boolean;
  plan_name varchar;
  current_month_int INTEGER;
  criteria_report_id INTEGER;
  health_plan_names varchar[];
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() INTO criteria_report_id;

health_plan_names := ARRAY['TEST_PLAN_013','TEST_PLAN_013'];

-- Validate that is Tier 3 Preferred for each plan in the array
FOREACH plan_name IN ARRAY health_plan_names
  LOOP

    SELECT calculate_report_value('dim_tier_id', get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || plan_name || '''') INTO actual_value;
    expected_value = 3;

    PERFORM validate_comparison_values(actual_value, expected_value,'ana_rpt_coverage_tier_plan_test_003_validate_data-error: EXPECTED dim_tier_id FOR PLAN ' || plan_name || ' TO BE ');

    SELECT calculate_report_value_varchar('dim_tier_name', get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || plan_name || '''') INTO actual_value_varchar;
    expected_value_varchar = 'Tier 3';

    PERFORM validate_comparison_values_varchar(actual_value_varchar, expected_value_varchar,'ana_rpt_coverage_tier_plan_test_003_validate_data-error: EXPECTED dim_tier_name FOR PLAN ' || plan_name || ' TO BE ');

    SELECT calculate_report_value_boolean('is_tier_preferred', get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || plan_name || '''') INTO actual_value_boolean;
    expected_value_boolean = TRUE;

    PERFORM validate_comparison_values_boolean(actual_value_boolean, expected_value_boolean,'ana_rpt_coverage_tier_plan_test_003_validate_data-error: EXPECTED is_tier_preferred FOR PLAN ' || plan_name || ' TO BE ');

END LOOP;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
