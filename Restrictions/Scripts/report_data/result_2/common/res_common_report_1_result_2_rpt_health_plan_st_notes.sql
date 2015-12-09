CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_health_plan_st_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_id INTEGER;
hix_hpt INTEGER;
st_dim_criterion_type INTEGER := 3;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;

--ST HIX DRUG 2
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":1,"notes":"Drug1 notes: notes for drug 1"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":2,"notes":"Drug2 notes: notes for drug 2"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, hix_hpt, drug_2_id, st_dim_criterion_type, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;