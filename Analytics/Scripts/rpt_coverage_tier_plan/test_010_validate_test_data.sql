CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_010_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value double precision;
  actual_value double precision;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  health_plan_names varchar[];
  plan_name varchar;
BEGIN

-- Current Month
SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() INTO criteria_report_id;

-- Validate that each plan has the correct copay
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(20, 'TEST_PLAN_008');
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(85, 'TEST_PLAN_009');
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(85, 'TEST_PLAN_010');
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(85, 'TEST_PLAN_012');
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(20, 'TEST_PLAN_013');
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(40, 'TEST_PLAN_017');
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(25, 'TEST_PLAN_018');
  PERFORM ana_rpt_coverage_tier_plan_test010_validate_lives(50, 'TEST_PLAN_019');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
