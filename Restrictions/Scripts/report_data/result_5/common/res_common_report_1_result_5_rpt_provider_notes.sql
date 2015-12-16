CREATE OR REPLACE FUNCTION res_common_report_1_result_5_rpt_provider_notes(criteria_report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
indication_1 INTEGER;
drug_1_id  INTEGER;
drug_2_id  INTEGER;
provider_1_id INTEGER;
provider_11_id INTEGER;
commercial_plan_type_id INTEGER;
medicare_hpt INTEGER;

ind1_pa_diagnosis_1 INTEGER;
ind1_pa_diagnosis_3 INTEGER;
ind1_pa_clinical_1 INTEGER;
ind1_pa_unspecified INTEGER;
ind1_pa_ql INTEGER;
ind1_pa_age_1 INTEGER;
ind1_pa_past_single_c1 INTEGER;
ind1_pa_past_single_c1_c2 INTEGER;
ind1_pa_st_single_c1 INTEGER;
ind1_pa_st_double_c1_c2 INTEGER;
ind1_pa_criteria_lab_3 INTEGER;
ind1_pa_d3_c1 INTEGER;

expected_provider_notes VARCHAR;

BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','medicare_ma') INTO medicare_hpt;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;
SELECT common_get_table_id_by_name('providers','provider_11') INTO provider_11_id;

--RETRIEVE INDICATIONS
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_1') INTO ind1_pa_diagnosis_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_3') INTO ind1_pa_diagnosis_3;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Clinical','criteria_clinical_1') INTO ind1_pa_clinical_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Unspecified','Criteria Unspecified') INTO ind1_pa_unspecified;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','QL','criteria_ql_1') INTO ind1_pa_ql;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Age','criteria_age_1') INTO ind1_pa_age_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_single_c1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA/ST - Single','Fail any one: custom_option_1, custom_option_2') INTO ind1_pa_past_single_c1_c2;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','ST - Single','custom_option_1') INTO ind1_pa_st_single_c1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_c1_c2;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA - Labs','criteria_lab_3') INTO ind1_pa_criteria_lab_3;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','ST - Double','drug_3 and custom_option_1') INTO ind1_pa_d3_c1;

--DRUG 1 PROVIDER 11 MEDICARE MA pharmacy CRITERIA LAB 3
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_lab_3","note_position":1,"notes":"notes 3456"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_11_id, medicare_hpt, drug_1_id, ind1_pa_criteria_lab_3, expected_provider_notes);

--DRUG 1 PROVIDER 11 COMMERCIAL PHARMACY CRITERIA age 1
expected_provider_notes= null;
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_11_id, commercial_plan_type_id, drug_1_id, ind1_pa_age_1, expected_provider_notes);

--DRUG 1 PROVIDER 11 COMMERCIAL PHARMACY CRITERIA DIAGNOSIS 3
expected_provider_notes= null;
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_11_id, commercial_plan_type_id, drug_1_id, ind1_pa_diagnosis_3, expected_provider_notes);

--DRUG 2 PROVIDER 1 COMMERCIAL PHARMACY CRITERIA UNSPECIFIED
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1_id, commercial_plan_type_id, drug_2_id, ind1_pa_unspecified, expected_provider_notes);

--DRUG 2 PROVIDER 1 COMMERCIAL PHARMACY CRITERIA QL
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1_id, commercial_plan_type_id, drug_2_id, ind1_pa_ql, expected_provider_notes);

--DRUG 2 PROVIDER 11 MEDICARE MA PHARMACY drug 3 co1
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - drug_3^1 AND CustomOption1^2","note_position":1,"notes":"Drug_1 notes: notes for drug 3"},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - drug_3^1 AND CustomOption1^2","note_position":1,"notes":"Drug_2 notes: notes for custom option 1"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_11_id, medicare_hpt, drug_2_id, ind1_pa_d3_c1, expected_provider_notes);

success=true;
return success;
END
$$ LANGUAGE plpgsql;