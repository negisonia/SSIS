CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_drug_test_006_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value INTEGER := 3;
  actual_value INTEGER;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  drug_002_id INTEGER;
  tier_001_id INTEGER;
  tier_002_id INTEGER;
BEGIN

-- Current Month
SELECT extract(month from date_trunc('month', current_date)) INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_drug_test_001_007_create_fe_data() INTO criteria_report_id;

--Query the actual value
SELECT calculate_report_value('SUM(health_plan_count)', get_report_name_call('rpt_coverage_tier_drug', ARRAY[criteria_report_id,current_month_int]),'(dim_tier_name=''Tier 1'' OR dim_tier_name=''Tier 2'') AND drug_name=''DRUG_002'' AND is_tier_preferred IS FALSE') INTO actual_value;

IF actual_value IS NULL OR actual_value != expected_value THEN
  SELECT throw_error('test_006_validate_test_data-error: EXPECTED VALUE OF ' || concat_ws(' GOT ', expected_value, actual_value));
END IF; 

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
