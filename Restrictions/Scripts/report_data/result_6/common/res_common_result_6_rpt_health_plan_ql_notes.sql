CREATE OR REPLACE FUNCTION res_common_result_6_rpt_health_plan_ql_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_1_id INTEGER;
commercial_plan_type_id INTEGER;
dim_restriction_type_id INTEGER:=4;
drug_1_id INTEGER;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;

--COMMERCIAL DRUG 1
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"2 tabs per 1 week"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_1_id, commercial_plan_type_id, drug_1_id, dim_restriction_type_id, expected_output);

--COMMERCIAL DRUG 2
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_1_id, commercial_plan_type_id, drug_2_id, dim_restriction_type_id, expected_output);


success=true;
return success;
END
$$ LANGUAGE plpgsql;