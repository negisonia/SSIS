CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_3_test_011_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
  drug_name varchar := 'DRUG_003';
  
  dim_tier_name varchar := 'NC';
  
BEGIN

expected_value = format('[{"drug_name":"%s","dim_tier_name":"%s","dim_tier_id":8,"dim_tier_type_id":1,"is_tier_preferred":false,"avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":50,"total_lives":1041,"health_plan_count":1,"total_health_plan_count":17}]', drug_name, dim_tier_name);

PERFORM ana_rpt_cov_tier_drg_selection_3_test_01_11_validate_data(expected_value,'011', drug_name, dim_tier_name);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;