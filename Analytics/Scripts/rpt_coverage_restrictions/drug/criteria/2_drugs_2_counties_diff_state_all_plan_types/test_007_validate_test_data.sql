CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_county_diff_state_test_007_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"PA or ST","avg_copay":10.00,"lis_lives":0,"total_lis_lives":0,"lives":170,"total_lives":480,"health_plan_count":2,"total_health_plan_count":6}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'007', 'DRUG_003', 'PA or ST');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
