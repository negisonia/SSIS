CREATE OR REPLACE FUNCTION test_003_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value INTEGER := 150;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  drug_001_id INTEGER;
BEGIN

-- Current Month
SELECT extract(month from date_trunc('month', current_date)) INTO current_month_int;
-- Create Criteria Report Id
SELECT test_001_006_create_fe_test_data() INTO criteria_report_id;
-- Get Drug 001 id
SELECT id from drugs where name = 'DRUG_001' limit 1 INTO drug_001_id;
--Query the actual value
SELECT SUM(lives) from rpt_coverage_tier_drug(criteria_report_id,current_month_int) where drug_id = drug_001_id INTO actual_value;

IF actual_value != expected_value THEN
  SELECT throw_error('test_003_validate_test_data-error: EXPECTED VALUE OF ' || expected_value || ' GOT ' || actual_value ||);
END IF; 

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;