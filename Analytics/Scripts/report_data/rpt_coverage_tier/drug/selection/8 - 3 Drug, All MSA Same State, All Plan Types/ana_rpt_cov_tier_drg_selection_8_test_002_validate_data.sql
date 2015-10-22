CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_8_test_002_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
  drug_name varchar := 'DRUG_001';
  
  dim_tier_name varchar := 'Tier 2';
  
BEGIN

expected_value = format('[{"drug_name":"%s","dim_tier_name":"%s","dim_tier_id":2,"dim_tier_type_id":1,"is_tier_preferred":false,"avg_copay":10.00,"lis_lives":0,"total_lis_lives":0,"lives":50,"total_lives":730,"health_plan_count":1,"total_health_plan_count":9}]', drug_name, dim_tier_name);

PERFORM ana_rpt_cov_tier_drg_selection_8_test_01_07_validate_data(expected_value,'002', drug_name, dim_tier_name);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;