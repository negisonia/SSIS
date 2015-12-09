CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_health_plan_pa_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_id INTEGER;
plan_type_id INTEGER;
dim_restriction_type_id INTEGER;
drug_id INTEGER;
expected_output VARCHAR;
BEGIN

dim_restriction_type_id = 1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO plan_type_id;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;


expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":"message"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: notes for drug 1"}'||
']';

PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, plan_type_id, drug_id, dim_restriction_type_id, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;