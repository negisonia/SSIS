CREATE OR REPLACE FUNCTION res_report_1_result_1_test_21_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

admin_report_1 INTEGER;
health_plan_notes_output VARCHAR;
expected_health_plan_notes_output VARCHAR;

provider_1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;
drug_1 INTEGER;
drug_2 INTEGER;
pa_dim_criterion_type INTEGER := 1;

BEGIN

--RETRIEVE DRUG_ID
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;

--RETRIEVE PROVIDER ID
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;
--RETRIEVE HEALTH PLAN TYPE
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;

--RETRIVE REPORT ID
SELECT  crr.report_id INTO admin_report_1 FROM criteria_restriction_reports crr WHERE crr.report_name='report_1';

--VALIDATE NOTES (DRUG 1, PA, commercial)
expected_health_plan_notes_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":"age restriction"},'||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_clinical_1","note_position":1,"notes":"long message 500 characters"},'||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":""},'||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"long message 100 characters"},'||
    '{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: long message 500 characters"}'||
    ']';
PERFORM res_rpt_health_plan_notes_validate_data(admin_report_1, provider_1, commercial_hpt, drug_1, pa_dim_criterion_type, expected_health_plan_notes_output);

--VALIDATE NOTES (DRUG 1, PA, hix)
expected_health_plan_notes_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":"Notes"}'||
    ']';
PERFORM res_rpt_health_plan_notes_validate_data(admin_report_1, provider_1, hix_hpt, drug_1, pa_dim_criterion_type, expected_health_plan_notes_output);

--VALIDATE NOTES (DRUG 2, PA, hix)
expected_health_plan_notes_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":"message"},'||
    '{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: notes for drug 1"}'||
    ']';
PERFORM res_rpt_health_plan_notes_validate_data(admin_report_1, provider_1, hix_hpt, drug_2, pa_dim_criterion_type, expected_health_plan_notes_output);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;