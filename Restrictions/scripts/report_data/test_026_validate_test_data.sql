CREATE OR REPLACE FUNCTION restrictions_test_026_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
fe_report_1 INTEGER;
expected_provider_notes VARCHAR;
provider_1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;
indication_1 INTEGER;
drug_1  INTEGER;
drug_2  INTEGER;
ind1_pa_diagnosis_1 INTEGER;
ind1_pa_diagnosis_3 INTEGER;
ind1_pa_age_1 INTEGER;
ind1_pa_clinical_1 INTEGER;
ind1_pa_past_custom_option_1 INTEGER;
ind1_pa_unspecified INTEGER;
ind1_m_age_1 INTEGER;
ind1_m_unspecified INTEGER;
ind1_m_criteria_diagnosis_3 INTEGER;
ind1_m_st_custom_option_2 INTEGER;
ind1_pa_st_double_co_1_co_2 INTEGER;
ind1_pa_ql INTEGER;

BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_1') INTO ind1_pa_diagnosis_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_3') INTO ind1_pa_diagnosis_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Age','criteria_age_1') INTO ind1_pa_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Clinical','criteria_clinical_1') INTO ind1_pa_clinical_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Unspecified','Criteria Unspecified') INTO ind1_pa_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Age','criteria_age_1') INTO ind1_m_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Unspecified','Criteria Unspecified') INTO ind1_m_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Diagnosis','criteria_diagnosis_3') INTO ind1_m_criteria_diagnosis_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','QL','criteria_ql_1') INTO ind1_pa_ql;

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":""}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_1, ind1_pa_diagnosis_1, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":"age restriction"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_1, ind1_pa_age_1, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"long message 100 characters"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_1, ind1_pa_diagnosis_3, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_clinical_1","note_position":1,"notes":"long message 500 characters"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_1, ind1_pa_clinical_1, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: long message 500 characters"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_1, ind1_pa_past_custom_option_1, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":"Notes"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, hix_hpt, drug_1, ind1_pa_unspecified, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":"message"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, hix_hpt, drug_2, ind1_pa_diagnosis_1, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":""}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_2, ind1_m_age_1, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":"additional notes"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_2, ind1_m_unspecified, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"notes"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, hix_hpt, drug_2, ind1_m_criteria_diagnosis_3, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Single - custom_option_2^1 ","note_position":1,"notes":""}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, hix_hpt, drug_2, ind1_m_st_custom_option_2, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":1,"notes":"Drug1 notes: notes for drug 1"},{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":2,"notes":"Drug2 notes: notes for drug 1"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, hix_hpt, drug_2, ind1_pa_st_double_co_1_co_2, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_2, ind1_pa_ql, expected_provider_notes);

expected_provider_notes = '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"2 tabs per 10 week"}]';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_1, ind1_pa_ql, expected_provider_notes);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;