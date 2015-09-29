CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_5_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_001';
  qualifier varchar := 'ST';
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":30.00,"lis_lives":0,"total_lis_lives":0,"lives":150,"total_lives":430,"health_plan_count":1,"total_health_plan_count":5}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_5_test_01_05_validate_data(expected_value,'001', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
