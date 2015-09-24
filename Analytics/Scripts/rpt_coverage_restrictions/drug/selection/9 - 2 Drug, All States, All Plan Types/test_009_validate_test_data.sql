CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_9_test_009_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_002';
  qualifier varchar := 'QL';
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":20.00,"lis_lives":0,"total_lis_lives":0,"lives":100,"total_lives":1341,"health_plan_count":1,"total_health_plan_count":20}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_9_test_01_11_validate_data(expected_value,'009', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
