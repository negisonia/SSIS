CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_006_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
BEGIN

PERFORM ana_rpt_coverage_tier_plan_test006_validate_plan_type('HEALTH_PLAN_TYPE_001', ARRAY['TEST_PLAN_001','TEST_PLAN_010','TEST_PLAN_013','TEST_PLAN_017','TEST_PLAN_018']);
PERFORM ana_rpt_coverage_tier_plan_test006_validate_plan_type('HEALTH_PLAN_TYPE_006', ARRAY['TEST_PLAN_009','TEST_PLAN_012','TEST_PLAN_019']);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
