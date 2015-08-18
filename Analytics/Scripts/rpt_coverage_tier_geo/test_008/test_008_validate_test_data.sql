CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_008_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value double precision := 255;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_geo_test_007_010_create_fe_data() INTO criteria_report_id;

--Query the actual value
SELECT calculate_report_value('SUM(lives)', get_report_name_call('rpt_coverage_tier_geo', ARRAY[criteria_report_id,current_month_int]),'dim_tier_name=''Tier 1'' OR dim_tier_name=''Tier 2''') INTO actual_value;
--Compare actual and expected values
PERFORM validate_comparison_values(actual_value, expected_value,'ana_rpt_coverage_tier_geo_test_008_validate_data-error: EXPECTED TOTAL LIVES FOR TIER 001 TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;