CREATE OR REPLACE FUNCTION test_002_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value INTEGER := 4;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
BEGIN

-- Current Month
SELECT extract(month from date_trunc('month', current_date)) INTO current_month_int;
-- Create Criteria Report Id
SELECT test_001_007_create_fe_test_data() INTO criteria_report_id;
--Query the actual value
SELECT total_health_plan_count from rpt_coverage_tier_drug(criteria_report_id,current_month_int) limit 1 INTO actual_value;

IF actual_value != expected_value THEN
  SELECT throw_error('test_002_validate_test_data-error: EXPECTED VALUE OF ' || expected_value || ' GOT ' || actual_value ||);
END IF; 

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;