CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_9_test_003_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
    drug_name varchar := 'DRUG_001';
  
    dim_tier_name varchar := 'Tier 3';
  
    is_tier_preferred varchar := 'true';
  
BEGIN

expected_value =  format('[{"drug_name":"%s","dim_tier_name":"%s","is_tier_preferred":%s,"dim_tier_id":3,"dim_tier_type_id":1,"avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":30,"total_lives":1041,"health_plan_count":1,"total_health_plan_count":16}]', drug_name, dim_tier_name, is_tier_preferred);

PERFORM ana_rpt_cov_tier_drg_selection_9_test_01_10_validate_data(expected_value,'003', drug_name, dim_tier_name, is_tier_preferred);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;