CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_4_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
    drug_name varchar := 'DRUG_002';
  
    dim_tier_name varchar := 'Tier 1';
  
    is_tier_preferred boolean := false;
  
BEGIN

expected_value = '[{"drug_name":"' || drug_name || '","dim_tier_name":"' || dim_tier_name || '","is_tier_preferred":' || is_tier_preferred || ',"dim_tier_id":1,"dim_tier_type_id":1,"avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":100,"total_lives":250,"health_plan_count":1,"total_health_plan_count":3}]';

PERFORM ana_rpt_cov_tier_drg_selection_4_test_01_02_validate_data(expected_value,'001', drug_name, dim_tier_name, is_tier_preferred);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;