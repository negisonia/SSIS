CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_provider_notes(criteria_report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
indication_1 INTEGER;
drug_1  INTEGER;
drug_2  INTEGER;
provider_1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;

ind1_pa_st_custom_option_1 INTEGER;
ind1_pa_past_co_1_co_2 INTEGER;
ind1_pa_past_custom_option_1 INTEGER;
ind1_pa_st_double_co_1_co_2 INTEGER;
ind1_m_st_custom_option_2 INTEGER;

expected_provider_notes VARCHAR;

BEGIN

SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;

--RETRIEVE RESTRICTIONS

SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Single','custom_option_1') INTO ind1_pa_st_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','Fail any one: custom_option_1, custom_option_2') INTO ind1_pa_past_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;

--DRUG 1 PROVIDER 1 COMMERCIAL CUSTOM OPTION 1 PHARMACY
expected_provider_notes= null;
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_1, ind1_pa_st_custom_option_1, expected_provider_notes);

--DRUG 2 PROVIDER 1 HIX CUSTOM OPTION 1 PHARMACY
expected_provider_notes= null;
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, hix_hpt, drug_2, ind1_pa_st_custom_option_1, expected_provider_notes);

--DRUG 2 PROVIDER 1 HIX DOUBLE CUSTOM OPTION 1  & 2 PHARMACY
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":1,"notes":"Drug1 notes: notes for drug 1"},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":2,"notes":"Drug2 notes: notes for drug 2"}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, hix_hpt, drug_2, ind1_pa_st_double_co_1_co_2, expected_provider_notes);

--DRUG 2 PROVIDER 1 HIX  CUSTOM OPTION  2 MEDICAL
expected_provider_notes= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"ST - Single - custom_option_2^1 ","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, hix_hpt, drug_2, ind1_m_st_custom_option_2, expected_provider_notes);

----DRUG 2 PROVIDER 1 COMMERCIAL  UNSPECIFIED PHARMACY  TODO this report does not contains a step unspecified record this is not a valid scenario
--expected_provider_notes= '';
--PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1, commercial_hpt, drug_2, ind1_m_st_custom_option_2, expected_provider_notes);


success=true;
return success;
END
$$ LANGUAGE plpgsql;