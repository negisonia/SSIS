CREATE OR REPLACE FUNCTION res_common_result_6_rpt_health_plan_medical_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_1_id INTEGER;
provider_11_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
dim_restriction_type_id INTEGER:=2;
drug_1_id INTEGER;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;


--MEDICAL DRUG 2 COMMERCIAL
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_1_id, commercial_plan_type_id, drug_2_id, dim_restriction_type_id, expected_output);

--MEDICAL DRUG 2 HIX
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"notes"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Single - custom_option_2^1 ","note_position":1,"notes":""}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_1_id, hix_plan_type_id, drug_2_id, dim_restriction_type_id, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;

