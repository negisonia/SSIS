CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_county_diff_state_test_005_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"PA","avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":85,"total_lives":480,"health_plan_count":1,"total_health_plan_count":6}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'005', 'DRUG_003', 'PA');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
