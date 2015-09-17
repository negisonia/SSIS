CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_all_national_test_015_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"QL","avg_copay":20.00,"lis_lives":0,"total_lis_lives":0,"lives":255,"total_lives":1341,"health_plan_count":3,"total_health_plan_count":20}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'015', 'DRUG_003', 'QL');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
