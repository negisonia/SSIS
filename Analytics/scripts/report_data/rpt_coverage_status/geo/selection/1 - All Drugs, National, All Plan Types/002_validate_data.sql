CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drg_selection_1_test_002_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  
  drug_name varchar := 'DRUG_002';
  
  qualifier_name varchar := 'QL';
  
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":30.00,"lis_lives":0,"total_lis_lives":0,"lives":150,"total_lives":1341,"health_plan_count":1,"total_health_plan_count":20}]', drug_name, qualifier_name);

PERFORM ana_rpt_cov_restr_drg_selection_1_test_01_02_validate_data(expected_value,'002', drug_name, qualifier_name);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;