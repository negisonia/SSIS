CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_provider_notes(criteria_report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
indication_1 INTEGER;
drug_1  INTEGER;
drug_2  INTEGER;
provider_1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;
ind1_med_diagnosis_3 INTEGER;
ind1_med_age_1 INTEGER;
ind1_med_st_custom_option_2 INTEGER;

expected_provider_notes VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Diagnosis','criteria_diagnosis_3') INTO ind1_med_diagnosis_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Age','criteria_age_1') INTO ind1_med_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_med_st_custom_option_2;

expected_provider_notes= '['||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"notes"}'||
    ']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, hix_hpt, drug_2, ind1_med_diagnosis_3, expected_provider_notes);

expected_provider_notes= '['||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_2, ind1_med_age_1, expected_provider_notes);

expected_provider_notes= '['||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Single - custom_option_2^1 ","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, hix_hpt, drug_2, ind1_med_st_custom_option_2, expected_provider_notes);

success=true;
return success;
END
$$ LANGUAGE plpgsql;