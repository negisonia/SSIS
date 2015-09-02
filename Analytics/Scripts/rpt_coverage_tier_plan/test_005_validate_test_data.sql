CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_005_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value boolean;
  provider_name varchar;
  current_month_int INTEGER;
  criteria_report_id INTEGER;
  provider_names varchar[];
  value_exists boolean;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() INTO criteria_report_id;

provider_names := ARRAY['TEST_PROVIDER_002','TEST_PROVIDER_003','TEST_PROVIDER_004'];

expected_value = TRUE;
-- Validate provider exists
FOREACH provider_name IN ARRAY provider_names
  LOOP

    SELECT calculate_report_value_boolean(TRUE, get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'provider_name=''' || provider_name || '''') INTO value_exists;
    PERFORM validate_comparison_values_boolean(value_exists, expected_value,'ana_rpt_coverage_tier_plan_test_005_validate_data-error: EXPECTED ' || provider_name || ' TO EXIST ');

END LOOP;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
