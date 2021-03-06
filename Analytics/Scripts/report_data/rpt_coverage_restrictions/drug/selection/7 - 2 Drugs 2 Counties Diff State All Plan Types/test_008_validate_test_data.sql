CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_selection_7_test_008_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
  drug varchar := 'DRUG_003';
  qualifier varchar := 'QL';
BEGIN

expected_value = format('[{"drug_name":"%s","qualifier_name":"%s","avg_copay":20.00,"lis_lives":0,"total_lis_lives":0,"lives":255,"total_lives":480,"health_plan_count":3,"total_health_plan_count":6}]', drug, qualifier);

PERFORM ana_rpt_cov_restr_drg_selection_7_test_01_10_validate_data(expected_value,'008', drug, qualifier);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
