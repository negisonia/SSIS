CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_msa_diff_state_test_011_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_002","qualifier_name":"Any","avg_copay":30.00,"lis_lives":0,"total_lis_lives":0,"lives":110,"total_lives":780,"health_plan_count":1,"total_health_plan_count":9}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'011', 'DRUG_002', 'Any');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
