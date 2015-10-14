CREATE OR REPLACE FUNCTION res_ca_etl_test_9_validate_test_data() --FRONT END
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
-- QL
dim_restriction_type_id = 4;

-- Drug 02, Commercial
  expected_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"}'||
    ']';

  SELECT common_get_table_id_by_name(drugs,'drug_2') INTO drug_id;
  SELECT common_get_table_id_by_name(health_plan_types,'commercial') INTO plan_type_id;
  PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);

-- Drug 01, Commercial
  expected_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"2 tabs per 10 week"}'||
    ']';  

  SELECT common_get_table_id_by_name(drugs,'drug_1') INTO drug_id;
  SELECT common_get_table_id_by_name(health_plan_types,'commercial') INTO plan_type_id;
  PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;