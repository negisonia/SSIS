CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_011_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '[{"drug_name":"DRUG_002","qualifier_name":"None","avg_copay":20.00,"lis_lives":0,"total_lis_lives":0,"lives":50,"total_lives":1140,"health_plan_count":1,"total_health_plan_count":13}]';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'011', 'DRUG_002', 'None','ana_rpt_coverage_restrictions_drug_test_001_017_create_fe_data');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
