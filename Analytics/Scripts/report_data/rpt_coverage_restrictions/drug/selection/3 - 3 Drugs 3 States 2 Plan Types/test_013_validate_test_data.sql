CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_3_test_013_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_003';
  qualifier varchar := 'Any';
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":33.33,"lis_lives":0,"total_lis_lives":0,"lives":275,"total_lives":1041,"health_plan_count":4,"total_health_plan_count":17}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_3_test_01_14_validate_data(expected_value,'013', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
