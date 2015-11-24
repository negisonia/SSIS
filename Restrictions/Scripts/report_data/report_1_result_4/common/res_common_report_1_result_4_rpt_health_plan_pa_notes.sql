CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_health_plan_pa_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
dim_restriction_type_id INTEGER;
drug_1_id INTEGER;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

dim_restriction_type_id = 1;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;


--DRUG1 COMMERCIAL
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":"age restriction"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_clinical_1","note_position":1,"notes":"long message 500 characters"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":""},'||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"long message 100 characters"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: long message 500 characters"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, commercial_plan_type_id, drug_1_id, dim_restriction_type_id, expected_output);

--DRUG2 HIX
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":"message"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: notes for drug 1"}'
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, hix_plan_type_id, drug_2_id, dim_restriction_type_id, expected_output);




success=true;
return success;
END
$$ LANGUAGE plpgsql;