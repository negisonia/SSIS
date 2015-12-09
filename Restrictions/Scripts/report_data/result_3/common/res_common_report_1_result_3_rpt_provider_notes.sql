CREATE OR REPLACE FUNCTION res_common_report_1_result_3_rpt_provider_notes(criteria_report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
indication_1 INTEGER;
drug_1  INTEGER;
drug_2  INTEGER;
provider_1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;
rep_1_group_1_pa INTEGER;
rep_1_group_3_pa INTEGER;
rep_1_group_1_m INTEGER;
rep_1_group_3_m INTEGER;

expected_provider_notes VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;
SELECT common_get_custom_dim_criteria(indication_1, 'Pharmacy', 'rep_1_group_1', 'rep_1_group_1',6,3) INTO rep_1_group_1_pa;
SELECT common_get_custom_dim_criteria(indication_1, 'Pharmacy', 'rep_1_group_3', 'rep_1_group_3',6,3) INTO rep_1_group_3_pa;
SELECT common_get_custom_dim_criteria(indication_1, 'Medical', 'rep_1_group_1', 'rep_1_group_1',2,3) INTO rep_1_group_1_m;
SELECT common_get_custom_dim_criteria(indication_1, 'Medical', 'rep_1_group_3', 'rep_1_group_3',2,3) INTO rep_1_group_3_m;

--PROVIDER 1 COMMERCIAL PHARMACY DRUG 1 REP_1_GROUP_1
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":"age restriction: l:10 up:30 "},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_clinical_1","note_position":1,"notes":"long message 500 characters"},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":""},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"long message 100 characters"},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"2 tabs per 10 week"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_1, rep_1_group_1_pa, expected_provider_notes);

--PROVIDER 1 COMMERCIAL PHARMACY DRUG 2 REP_1_GROUP_1
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_2, rep_1_group_1_pa, expected_provider_notes);

--PROVIDER 1 HIX PHARMACY DRUG 2 REP_1_GROUP_1
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":"message"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, hix_hpt, drug_2, rep_1_group_1_pa, expected_provider_notes);

--PROVIDER 1 HIX PHARMACY DRUG 1 REP_1_GROUP_1
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":"Notes"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, hix_hpt, drug_1, rep_1_group_1_pa, expected_provider_notes);

--PROVIDER 1 COMMERCIAL MEDICAL DRUG 2 REP_1_GROUP_1
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_2, rep_1_group_1_m, expected_provider_notes);

--PROVIDER 1 COMMERCIAL PHARMACY DRUG 1 REP_1_GROUP_3
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":"age restriction  l:10 up:30 "},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"2 tabs per 10 week"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_1, rep_1_group_3_pa, expected_provider_notes);

--PROVIDER 1 COMMERCIAL PHARMACY DRUG 2 REP_1_GROUP_3
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_2, rep_1_group_3_pa, expected_provider_notes);

--PROVIDER 1 COMMERCIAL MEDICAL DRUG 2 REP_1_GROUP_3
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_2, rep_1_group_3_m, expected_provider_notes);



success=true;
return success;
END
$$ LANGUAGE plpgsql;