CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_7_test_010_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_003';
  qualifier varchar := 'No Restrictions';
BEGIN

expected_value = format('[{"drug_name":"DRUG_003","qualifier_name":"No Restrictions","avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":75,"total_lives":480,"health_plan_count":2,"total_health_plan_count":6}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_7_test_01_10_validate_data(expected_value,'010', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
