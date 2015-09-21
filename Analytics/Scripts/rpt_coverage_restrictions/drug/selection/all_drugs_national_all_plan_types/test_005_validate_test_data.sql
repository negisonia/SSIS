CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_all_national_test_005_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_001","qualifier_name":"No Restrictions","avg_copay":10.00,"lis_lives":0,"total_lis_lives":0,"lives":280,"total_lives":1341,"health_plan_count":4,"total_health_plan_count":20}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'005', 'DRUG_001', 'No Restrictions');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
