CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_2_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_001';
  qualifier varchar := 'No Restrictions';
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":10.00,"lis_lives":0,"total_lis_lives":0,"lives":280,"total_lives":1036,"health_plan_count":4,"total_health_plan_count":14}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_2_test_01_12_validate_data(expected_value,'001', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
