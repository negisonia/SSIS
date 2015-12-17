CREATE OR REPLACE FUNCTION res_common_result_6_rpt_provider_notes(criteria_report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_provider_notes VARCHAR;
provider_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
drug_1_id INTEGER;
drug_2_id INTEGER;
indication_1 INTEGER;

ind1_pa_diagnosis_1 INTEGER;
ind1_pa_diagnosis_3 INTEGER;
ind1_pa_clinical_1 INTEGER;
ind1_pa_unspecified INTEGER;
ind1_pa_ql INTEGER;
ind1_pa_age_1 INTEGER;
ind1_pa_past_co_1_co_2 INTEGER;
ind1_pa_past_custom_option_1 INTEGER;
ind1_pa_st_custom_option_1 INTEGER;
ind1_pa_st_double_co_1_co_2 INTEGER;
ind1_m_unspecified INTEGER;
ind1_m_criteria_diagnosis_3 INTEGER;
ind1_m_age_1 INTEGER;
ind1_m_st_custom_option_2 INTEGER;

BEGIN


--RETRIEVE DATA
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_1') INTO ind1_pa_diagnosis_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_3') INTO ind1_pa_diagnosis_3;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Clinical','criteria_clinical_1') INTO ind1_pa_clinical_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Unspecified','Criteria Unspecified') INTO ind1_pa_unspecified;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','QL','criteria_ql_1') INTO ind1_pa_ql;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Age','criteria_age_1') INTO ind1_pa_age_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA/ST - Single','Fail any one: custom_option_1, custom_option_2') INTO ind1_pa_past_co_1_co_2;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','ST - Single','custom_option_1') INTO ind1_pa_st_custom_option_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_co_1_co_2;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Unspecified','Criteria Unspecified') INTO ind1_m_unspecified;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Diagnosis','criteria_diagnosis_3') INTO ind1_m_criteria_diagnosis_3;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Age','criteria_age_1') INTO ind1_m_age_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;

--drug: Drug_1 provider: provider_1 plan type:commercial Criteria: Criteria_diagnosis_1 benefit: pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":""}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_1_id, ind1_pa_diagnosis_1, expected_provider_notes);

--drug: Drug_1 provider: provider_1 plan type: commercial Criteria: Criteria_age_1 benefit: pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":"age restriction"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_1_id, ind1_pa_age_1, expected_provider_notes);

--drug: Drug_1 provider: provider_1 plan type: commercial Criteria: Criteria_diagnosis_3 benefit: pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"long message 100 characters"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_1_id, ind1_pa_diagnosis_3, expected_provider_notes);

--drug: Drug_1  provider: provider_1  plan type: commercial  Criteria: criteria_clinical_1  benefit: pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_clinical_1","note_position":1,"notes":"long message 500 characters"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_1_id, ind1_pa_clinical_1, expected_provider_notes);

--drug: Drug_1 provider: provider_1 plan type: commercial Criteria: PA/ST - Single - Single: Custom_Option_1 benefit: pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: long message 500 characters"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_1_id, ind1_pa_past_custom_option_1, expected_provider_notes);

--drug: Drug_1 provider: provider_1 plan type: Commercial Criteria: Criteria_QL benefit: Pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"2 tabs per 1 week"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_1_id, ind1_pa_ql, expected_provider_notes);

--drug: Drug_1 provider: provider_1 plan type: HIX Criteria: PA - Unspecified -criteria_unspecified benefit: pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":"Notes"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, hix_plan_type_id, drug_1_id, ind1_pa_unspecified, expected_provider_notes);

--drug: Drug_2 provider: provider_1 plan type: HIX Criteria: PA - Diagnosis-Criteria_diagnosis_1 benefit: pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":"message"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, hix_plan_type_id, drug_2_id, ind1_pa_diagnosis_1, expected_provider_notes);


--MEDICAL CRITERIAS

--drug: Drug_2 provider: provider_1 plan type: Commercial Criteria: Age -criteria_age_1 benefit: Medical
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":""}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_2_id, ind1_m_age_1, expected_provider_notes);

--drug: Drug_2 provider: provider_1 plan type: HIX Criteria: Diagnosis -Criteria_diagnosis_3 benefit: Medical
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"notes"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, hix_plan_type_id, drug_2_id, ind1_m_criteria_diagnosis_3, expected_provider_notes);

--drug: Drug_2 provider: provider_1 plan type: HIX Criteria: Single: Custom_Option_2 benefit: Medical
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Single - custom_option_2^1 ","note_position":1,"notes":""}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, hix_plan_type_id, drug_2_id, ind1_m_st_custom_option_2, expected_provider_notes);

--drug: Drug_2 provider: provider_1 plan type: HIX Criteria: Double: Custom_Option_1 and Custom_Option_2 benefit: Medical
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":1,"notes":"Drug1 notes: notes for drug 1"},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":2,"notes":"Drug2 notes: notes for drug 2"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, hix_plan_type_id, drug_2_id, ind1_pa_st_double_co_1_co_2, expected_provider_notes);

--drug: Drug_2 provider: provider_1 plan type: Commercial Criteria: Double: Criteria_QL benefit: Pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_id, commercial_plan_type_id, drug_2_id, ind1_pa_ql, expected_provider_notes);

success=true;
return success;
END
$$ LANGUAGE plpgsql;