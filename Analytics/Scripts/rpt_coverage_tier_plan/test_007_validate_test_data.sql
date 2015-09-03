CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_007_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  health_plan_names varchar[];
  plan_name varchar;
BEGIN

-- TEST PLAN 008
-- QL, PA, ST, OR
PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction_set(false,true,true,false,'TEST_PLAN_008');

-- TEST PLAN 009
PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction_set(true,false,true,false,'TEST_PLAN_009');

-- TEST PLAN 010
PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction_set(true,false,false,false,'TEST_PLAN_010');

-- TEST PLAN 012
PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction_set(true,true,true,true,'TEST_PLAN_012');

health_plan_names := ARRAY['TEST_PLAN_013','TEST_PLAN_017','TEST_PLAN_018','TEST_PLAN_019'];
FOREACH plan_name IN ARRAY health_plan_names
  LOOP

    PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction_set(false,false,false,false,plan_name);

END LOOP;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
