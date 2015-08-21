CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_provider_test_003_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value double precision;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_provider_test_001_008_create_fe_data() INTO criteria_report_id;
--Query the actual value
SELECT calculate_report_value('primary_dim_tier_id_lives', get_report_name_call('rpt_coverage_tier_provider', ARRAY[criteria_report_id,current_month_int]),'drug_name=''DRUG_001'' AND provider_name=''TEST_PROVIDER_002''') INTO actual_value;
expected_value = 'Tier 2';

PERFORM validate_comparison_values_varchar(actual_value, expected_value,'ana_rpt_coverage_tier_provider_test_003_validate_data-error: EXPECTED primary_dim_tier_id_lives FOR DRUG_001 AND TEST_PROVIDER_002 TO BE ');

SELECT calculate_report_value('primary_dim_tier_id_lives', get_report_name_call('rpt_coverage_tier_provider', ARRAY[criteria_report_id,current_month_int]),'drug_name=''DRUG_003'' AND provider_name=''TEST_PROVIDER_002''') INTO actual_value;
expected_value = 'Tier 2';

PERFORM validate_comparison_values_varchar(actual_value, expected_value,'ana_rpt_coverage_tier_provider_test_003_validate_data-error: EXPECTED primary_dim_tier_id_lives FOR DRUG_003 AND TEST_PROVIDER_002 TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
