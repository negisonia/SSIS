CREATE OR REPLACE FUNCTION res_ca_report_1_result_1_test_10_validate_test_data() --FRONT END
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
SELECT get_report_id_by_criteria_report_id(res_ca_create_report_1_result_1_criteria_report()) INTO report_id;
-- Get parameter values
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;
-- ST
dim_restriction_type_id = 3;

-- Drug 02, Hix
  expected_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":1,"notes":"Drug1 notes: notes for drug 1"},'||
    '{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":2,"notes":"Drug2 notes: notes for drug 2"}'||
    ']';  
  SELECT common_get_table_id_by_name(drugs,'drug_2') INTO drug_id;
  SELECT common_get_table_id_by_name(health_plan_types,'hix') INTO plan_type_id;
  PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;