CREATE OR REPLACE FUNCTION res_ca_etl_test_7_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  report_id INTEGER;
  provider_id INTEGER;
  plan_type_id INTEGER;
  dim_restriction_type_id INTEGER;
  drug_id INTEGER;
  drugs VARCHAR:='drugs';
  health_plan_types VARCHAR:='health_plan_types';

BEGIN

-- Create Report Id
SELECT get_report_id_by_criteria_report_id(res_ca_etl_test_create_report_1_criteria_report_data()) INTO report_id;
-- Get parameter values
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;
-- PA
dim_restriction_type_id = 1;

-- Drug 01, Plan Type comercial
  expected_output = '';
  SELECT common_get_table_id_by_name(drugs,'drug_1') INTO drug_id;
  SELECT common_get_table_id_by_name(health_plan_types,'commercial') INTO plan_type_id;
  PERFORM validate_rpt_health_plan_notes(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);

-- Drug 01, Plan Type Hix 
  expected_output = '';
  SELECT common_get_table_id_by_name(health_plan_types,'hix') INTO plan_type_id;
  PERFORM validate_rpt_health_plan_notes(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);

-- Drug 02, Plan Type Hix 
  expected_output = '';
  SELECT common_get_table_id_by_name(drugs,'drug_2') INTO drug_id;
  PERFORM validate_rpt_health_plan_notes(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;