CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_013_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"Any","avg_copay":33.33,"lis_lives":0,"total_lis_lives":0,"lives":275,"total_lives":1041,"health_plan_count":4,"total_health_plan_count":17}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'013', 'DRUG_003', 'Any','ana_rpt_coverage_restrictions_drug_test_001_014_create_fe_data','ana_rpt_coverage_restrictions_drug_test_001_017_create_fe_data');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
