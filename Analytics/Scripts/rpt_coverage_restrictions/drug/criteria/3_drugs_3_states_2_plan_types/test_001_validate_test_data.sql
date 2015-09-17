CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_001","qualifier_name":"None","avg_copay":10.00,"lis_lives":0,"total_lis_lives":0,"lives":180,"total_lives":1041,"health_plan_count":3,"total_health_plan_count":17}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'001', 'DRUG_001', 'None','ana_rpt_coverage_restrictions_drug_test_001_014_create_fe_data');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
