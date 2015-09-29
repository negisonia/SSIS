CREATE OR REPLACE FUNCTION restrictions_test_026_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
fe_report_1 INTEGER;
expected_provider_notes VARCHAR;

provider_1 INTEGER;

commercial_hpt INTEGER;

indication_1 INTEGER;

drug_1  INTEGER;
drug_2  INTEGER;

ind1_pa_diagnosis_1 INTEGER;

BEGIN

--RETRIEVE DATA

SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;

SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;

SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_1') INTO ind1_pa_diagnosis_1;

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;
expected_provider_notes = '['||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_1","note_position":1,"notes":""}'||
    ']';
PERFORM res_rpt_provider_notes_validate_data(fe_report_1, provider_1, commercial_hpt, drug_1, ind1_pa_diagnosis_1, expected_provider_notes);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;