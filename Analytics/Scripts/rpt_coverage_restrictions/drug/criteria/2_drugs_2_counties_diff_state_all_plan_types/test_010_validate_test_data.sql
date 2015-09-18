CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drug_county_diff_state_test_010_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"No Restrictions","avg_copay":null,"lis_lives":0,"total_lis_lives":0,"lives":75,"total_lives":480,"health_plan_count":2,"total_health_plan_count":6}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'010', 'DRUG_003', 'No Restrictions');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
