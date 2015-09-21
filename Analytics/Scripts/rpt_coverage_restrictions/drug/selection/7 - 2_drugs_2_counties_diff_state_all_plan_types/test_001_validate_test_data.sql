CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_7_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_001';
  qualifier varchar := 'ST';
BEGIN

expected_value = format('[{"drug_name":"DRUG_001","qualifier_name":"ST","avg_copay":30.00,"lis_lives":0,"total_lis_lives":0,"lives":150,"total_lives":480,"health_plan_count":1,"total_health_plan_count":6}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_7_test_01_10_validate_data(expected_value,'001', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
