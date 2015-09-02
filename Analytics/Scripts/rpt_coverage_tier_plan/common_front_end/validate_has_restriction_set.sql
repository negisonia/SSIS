CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test007_validate_has_restriction_set(has_ql boolean, has_pa boolean, has_st boolean, has_or boolean, health_plan_name varchar)
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
BEGIN

PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction('has_quantity_limit', has_ql, health_plan_name);
PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction('has_prior_authorization', has_pa, health_plan_name);
PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction('has_step_therapy', has_st, health_plan_name);
PERFORM ana_rpt_coverage_tier_plan_test007_validate_has_restriction('has_other_restriction', has_or, health_plan_name);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;