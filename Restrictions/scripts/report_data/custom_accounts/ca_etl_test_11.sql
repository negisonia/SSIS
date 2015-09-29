CREATE OR REPLACE FUNCTION res_ca_etl_test_11_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  criteria_report_id INTEGER;

  provider_id INTEGER;
  plan_type_id INTEGER;
  dim_restriction_type_id INTEGER;
  drug_id INTEGER;
  providers VARCHAR:='providers';
  health_plan_types VARCHAR:='health_plan_types';

BEGIN

-- Create Report Id
SELECT res_ca_etl_test_create_report_1_criteria_report_data() INTO criteria_report_id;

SELECT common_get_table_id_by_name(providers,'provider_1') INTO provider_id
SELECT common_get_table_id_by_name(health_plan_types,'provider_1') INTO provider_id;
-- ST
dim_restriction_type_id = 3;

-- Drug 02, Hix
  expected_output= '['||
    '{"indication_name":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":1,"notes":"Drug1 notes: notes for drug 1"},'||
    '{"indication_name":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":2,"notes":"Drug2 notes: notes for drug 1"}'||
    ']';  
  SELECT common_get_table_id_by_name(drugs,'drug_2') INTO drug_id;
  SELECT common_get_table_id_by_name(health_plan_types,'hix') INTO plan_type_id;
  PERFORM validate_rpt_health_plan_notes(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;