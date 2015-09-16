CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_012_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_003","qualifier_name":"PA","avg_copay":60.00,"lis_lives":0,"total_lis_lives":0,"lives":105,"total_lives":1140,"health_plan_count":2,"total_health_plan_count":13}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'012', 'DRUG_003', 'PA','ana_rpt_coverage_restrictions_drug_test_001_017_create_fe_data');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
