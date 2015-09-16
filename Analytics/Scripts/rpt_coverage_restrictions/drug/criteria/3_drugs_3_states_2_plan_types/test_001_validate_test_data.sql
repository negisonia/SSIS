CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_001","qualifier_name":"ST","avg_copay":30.00,"lis_lives":0,"total_lis_lives":0,"lives":150,"total_lives":1040,"health_plan_count":1,"total_health_plan_count":13}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'001', 'DRUG_001', 'ST','ana_rpt_coverage_restrictions_drug_test_001_017_create_fe_data');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
