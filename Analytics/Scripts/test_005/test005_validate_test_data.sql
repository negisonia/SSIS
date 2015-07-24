CREATE OR REPLACE FUNCTION test_005_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value INTEGER := 150;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  drug_001_id INTEGER;
  tier_001_id INTEGER;
  tier_002_id INTEGER;
BEGIN

-- Current Month
SELECT extract(month from date_trunc('month', current_date)) INTO current_month_int;
-- Create Criteria Report Id
SELECT test_001_007_create_fe_test_data() INTO criteria_report_id;
-- Get Drug 001 id
SELECT id from drugs where name = 'DRUG_001' limit 1 INTO drug_001_id;
-- Get Tier id
SELECT id from dim_tier where name = 'TIER_001' limit 1 INTO tier_001_id;
SELECT id from dim_tier where name = 'TIER_002' limit 1 INTO tier_002_id;
--Query the actual value
SELECT SUM(health_plan_count) from rpt_coverage_tier_drug(criteria_report_id,current_month_int) where drug_id = drug_001_id and dim_tier_id = tier_001_id and dim_tier_id = tier_002_id INTO actual_value;


IF actual_value IS NULL OR actual_value != expected_value THEN
  SELECT throw_error('test_005_validate_test_data-error: EXPECTED VALUE OF ' || concat_ws('GOT ', expected_value, actual_value));
END IF; 

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
