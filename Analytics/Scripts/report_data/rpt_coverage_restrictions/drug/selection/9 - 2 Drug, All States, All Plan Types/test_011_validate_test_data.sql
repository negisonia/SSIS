CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_9_test_011_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_003';
  qualifier varchar := 'No Restrictions';
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":336,"total_lives":1041,"health_plan_count":7,"total_health_plan_count":16}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_9_test_01_11_validate_data(expected_value,'011', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
