CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_014_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"No Restrictions","avg_copay":,"lis_lives":0,"total_lis_lives":0,"lives":336,"total_lives":1041,"health_plan_count":7,"total_health_plan_count":17}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'014', 'DRUG_003', 'No Restrictions','ana_rpt_coverage_restrictions_drug_test_001_014_create_fe_data');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
