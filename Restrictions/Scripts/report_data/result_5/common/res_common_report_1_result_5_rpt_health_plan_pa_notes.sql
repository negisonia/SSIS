CREATE OR REPLACE FUNCTION res_common_report_1_result_5_rpt_health_plan_pa_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_1_id INTEGER;
provider_11_id INTEGER;
commercial_plan_type_id INTEGER;
medicare_hpt INTEGER;
dim_restriction_type_id INTEGER;
drug_1_id INTEGER;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

dim_restriction_type_id = 1;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','medicare_ma') INTO medicare_hpt;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;
SELECT common_get_table_id_by_name('providers','provider_11') INTO provider_11_id;


--DRUG1 MEDICARE_MA PROVIDER 11
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":"notes 1234"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"notes"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_lab_3","note_position":1,"notes":"notes 3456"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_11_id, medicare_hpt, drug_1_id, dim_restriction_type_id, expected_output);

--DRUG2 COMMERCIAL PROVIDER 1
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"Criteria Unspecified","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_1_id, commercial_plan_type_id, drug_2_id, dim_restriction_type_id, expected_output);

--DRUG2 MEDICARE_MA PROVIDER 11
expected_output= null;
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_11_id, medicare_hpt, drug_2_id, dim_restriction_type_id, expected_output);


success=true;
return success;
END
$$ LANGUAGE plpgsql;