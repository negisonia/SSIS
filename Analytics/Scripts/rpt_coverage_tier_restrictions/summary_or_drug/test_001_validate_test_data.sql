CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  actual_value varchar;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  health_plan_names varchar[];
  plan_name varchar;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_restrictions_drug_test_001_002_create_fe_data() INTO criteria_report_id;
--Query the actual value
SELECT calculate_report_value('sum_copay_lives', get_report_name_call('rpt_coverage_tier_restrictions', ARRAY[criteria_report_id,current_month_int]),'drug_name=''DRUG_001'' AND provider_name=''TEST_PROVIDER_002''') INTO actual_value;
expected_value = 500;

PERFORM validate_comparison_values(actual_value, expected_value,'ana_rpt_coverage_tier_provider_test_001_validate_data-error: EXPECTED sum_copay_lives FOR DRUG_001 AND TEST_PROVIDER_002 TO BE ');

SELECT calculate_report_value('sum_copay_lives', get_report_name_call('rpt_coverage_tier_provider', ARRAY[criteria_report_id,current_month_int]),'drug_name=''DRUG_003'' AND provider_name=''TEST_PROVIDER_002''') INTO actual_value;
expected_value = 3750;

PERFORM validate_comparison_values(actual_value, expected_value,'ana_rpt_coverage_tier_provider_test_001_validate_data-error: EXPECTED sum_copay_lives FOR DRUG_003 AND TEST_PROVIDER_002 TO BE ');



success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
