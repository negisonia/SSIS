CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_4_test_002_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
    drug_name varchar := 'DRUG_002';
  
    dim_tier_name varchar := 'Tier 2';
  
    is_tier_preferred varchar := 'false';
  
BEGIN

expected_value =  format('[{"drug_name":"%s","dim_tier_name":"%s","is_tier_preferred":%s,"dim_tier_id":2,"dim_tier_type_id":1,"avg_copay":20.00,"lis_lives":0,"total_lis_lives":0,"lives":150,"total_lives":250,"health_plan_count":2,"total_health_plan_count":3}]', drug_name, dim_tier_name, is_tier_preferred);

PERFORM ana_rpt_cov_tier_drg_selection_4_test_01_02_validate_data(expected_value,'002', drug_name, dim_tier_name, is_tier_preferred);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;