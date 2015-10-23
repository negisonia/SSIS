CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_7_test_002_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
    drug_name varchar := 'DRUG_003';
  
    dim_tier_name varchar := 'Tier 1';
  
    is_tier_preferred boolean := false;
  
BEGIN

expected_value = '[{"drug_name":"' || drug_name || '","dim_tier_name":"' || dim_tier_name || '","is_tier_preferred":' || is_tier_preferred || ',"dim_tier_id":1,"dim_tier_type_id":1,"avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":85,"total_lives":480,"health_plan_count":1,"total_health_plan_count":6}]';

PERFORM ana_rpt_cov_tier_drg_selection_7_test_01_05_validate_data(expected_value,'002', drug_name, dim_tier_name, is_tier_preferred);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;