CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value double precision := 350.50;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
BEGIN

-- Current Month
SELECT extract(month from date_trunc('month', current_date)) INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_geo_test_001_002_create_fe_data() INTO criteria_report_id;
--Query the actual value
SELECT total_lives from rpt_coverage_tier_geo(criteria_report_id,current_month_int) where market_name='STATE_001' limit 1 INTO actual_value;

IF actual_value IS NULL OR actual_value != expected_value THEN
  SELECT throw_error('ana_rpt_coverage_tier_geo_test_001_validate_data-error: EXPECTED VALUE OF ' || concat_ws(' GOT ', expected_value, actual_value));
END IF;

SELECT total_lives from rpt_coverage_tier_geo(criteria_report_id,current_month_int) where market_name='STATE_002' limit 1 INTO actual_value;

IF actual_value IS NULL OR actual_value != expected_value THEN
  SELECT throw_error('ana_rpt_coverage_tier_geo_test_001_validate_data-error: EXPECTED VALUE OF ' || concat_ws(' GOT ', expected_value, actual_value));
END IF;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
