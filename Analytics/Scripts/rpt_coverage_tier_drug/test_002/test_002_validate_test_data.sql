CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_drug_test_002_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value INTEGER := 5;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
BEGIN

-- Current Month
SELECT extract(month from date_trunc('month', current_date)) INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_drug_test_001_007_create_fe_data() INTO criteria_report_id;
--Query the actual value
SELECT total_health_plan_count from rpt_coverage_tier_drug(criteria_report_id,current_month_int) limit 1 INTO actual_value;

IF actual_value IS NULL OR actual_value != expected_value THEN
  SELECT throw_error('test_002_validate_test_data-error: EXPECTED VALUE OF ' || concat_ws('GOT ', expected_value, actual_value));
END IF; 

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
