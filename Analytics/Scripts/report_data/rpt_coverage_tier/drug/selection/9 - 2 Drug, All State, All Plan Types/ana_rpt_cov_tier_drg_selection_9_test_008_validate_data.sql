CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_9_test_008_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
    drug_name varchar := 'DRUG_003';
  
    dim_tier_name varchar := 'Tier 3';
  
    is_tier_preferred boolean := true;
  
BEGIN

expected_value = '[{"drug_name":"' || drug_name || '","dim_tier_name":"' || dim_tier_name || '","is_tier_preferred":' || is_tier_preferred || ',"dim_tier_id":3,"dim_tier_type_id":1,"avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":60,"total_lives":1041,"health_plan_count":2,"total_health_plan_count":16}]';

PERFORM ana_rpt_cov_tier_drg_selection_9_test_01_10_validate_data(expected_value,'008', drug_name, dim_tier_name, is_tier_preferred);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;