CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_001_validate_data() --FRONT END
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
SELECT ana_rpt_coverage_tier_geo_test_001_002_create_fe_data() INTO criteria_report_id;
--Query the actual value
SELECT total_lives from rpt_coverage_tier_geo(criteria_report_id,current_month_int) where market_name='STATE_002' limit 1 INTO actual_value;
expected_value = 335;

PERFORM validate_comparison_values(actual_value, expected_value,'ana_rpt_coverage_tier_geo_test_001_validate_data-error: EXPECTED TOTAL LIVES FOR STATE_001 TO BE ');

SELECT total_lives from rpt_coverage_tier_geo(criteria_report_id,current_month_int) where market_name='STATE_003' limit 1 INTO actual_value;
expected_value = 201;

PERFORM validate_comparison_values(actual_value, expected_value,'ana_rpt_coverage_tier_geo_test_001_validate_data-error: EXPECTED TOTAL LIVES FOR STATE_002 TO BE ');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
