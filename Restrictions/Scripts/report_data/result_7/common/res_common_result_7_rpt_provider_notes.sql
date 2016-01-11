CREATE OR REPLACE FUNCTION res_common_result_7_rpt_provider_notes(criteria_report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_provider_notes VARCHAR;
provider_1_id INTEGER;
provider_11_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
medicare_ma_plan_type_id INTEGER;
employer_plan_type_id INTEGER;
drug_1_id INTEGER;
drug_2_id INTEGER;
indication_1 INTEGER;

ind1_pa_past_custom_option_1 INTEGER;
medical_criteria INTEGER;

BEGIN


--RETRIEVE DATA
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;
SELECT common_get_table_id_by_name('providers','provider_11') INTO provider_11_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','medicare_ma') INTO medicare_ma_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','employer') INTO employer_plan_type_id;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;

--drug: Drug_1 provider: provider_1  commercial hpt indication 1 pharmacy
expected_provider_notes= '[{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":2,"criterion_name":"PA/ST - Single - custom_option_1^1","note_position":1,"notes":"Drug1 notes: long message 500 characters"}]';
PERFORM res_rpt_provider_notes_validate_data(criteria_report_id, provider_1_id, commercial_plan_type_id, drug_1_id, ind1_pa_past_custom_option_1, expected_provider_notes);

success=true;
return success;
END
$$ LANGUAGE plpgsql;