CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_002_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
BEGIN

-- Validate the Tier id and Name for each plan
PERFORM ana_rpt_coverage_tier_plan_test002_validate_tier_id_and_name(1, 'Tier 1', ARRAY['TEST_PLAN_008','TEST_PLAN_012']);
PERFORM ana_rpt_coverage_tier_plan_test002_validate_tier_id_and_name(2, 'Tier 2', ARRAY['TEST_PLAN_009','TEST_PLAN_010']);
PERFORM ana_rpt_coverage_tier_plan_test002_validate_tier_id_and_name(3, 'Tier 3', ARRAY['TEST_PLAN_013','TEST_PLAN_017']);
PERFORM ana_rpt_coverage_tier_plan_test002_validate_tier_id_and_name(9, 'NA', ARRAY['TEST_PLAN_018']);
PERFORM ana_rpt_coverage_tier_plan_test002_validate_tier_id_and_name(8, 'NC', ARRAY['TEST_PLAN_019']);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
