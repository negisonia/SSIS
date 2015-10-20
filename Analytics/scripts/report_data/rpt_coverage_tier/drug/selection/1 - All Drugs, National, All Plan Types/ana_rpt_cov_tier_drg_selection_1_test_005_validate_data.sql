CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_1_test_005_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
  drug_name varchar := 'DRUG_002';
  
  dim_tier_name varchar := 'Tier 1';
  
BEGIN

expected_value = format('[{"drug_name":"%s","dim_tier_name":"%s","dim_tier_id":1,"dim_tier_type_id":1,"is_tier_preferred":false,"avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":100,"total_lives":1341,"health_plan_count":1,"total_health_plan_count":20}]', drug_name, dim_tier_name);

PERFORM ana_rpt_cov_tier_drg_selection_1_test_01_13_validate_data(expected_value,'005', drug_name, dim_tier_name);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;