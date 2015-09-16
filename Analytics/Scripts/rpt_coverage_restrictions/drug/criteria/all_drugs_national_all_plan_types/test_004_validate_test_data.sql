CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_all_national_test_004_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_001","qualifier_name":"Any","avg_copay":30.00,"lis_lives":0,"total_lis_lives":0,"lives":150,"total_lives":1340,"health_plan_count":2,"total_health_plan_count":20}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'004', 'DRUG_001', 'Any');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
