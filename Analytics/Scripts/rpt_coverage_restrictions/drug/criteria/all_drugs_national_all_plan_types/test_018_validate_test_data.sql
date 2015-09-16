CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_all_national_test_018_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"PA","avg_copay":0.00,"lis_lives":0,"total_lis_lives":0,"lives":50,"total_lives":1340,"health_plan_count":1,"total_health_plan_count":20}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'018', 'DRUG_004', 'PA');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
