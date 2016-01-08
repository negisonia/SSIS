CREATE OR REPLACE FUNCTION res_common_result_7_rpt_health_plan_st_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_1_id INTEGER;
provider_11_id INTEGER;
hix_hpt INTEGER;
medicare_ma_hpt INTEGER;
commercial_hpt INTEGER;
dim_restriction_type_id INTEGER:=3;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;

--RETRIEVE HEALTH PLAN TYPE
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;
SELECT common_get_table_id_by_name('health_plan_types','medicare_ma') INTO medicare_ma_hpt;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;

SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;
SELECT common_get_table_id_by_name('providers','provider_11') INTO provider_11_id;

--DRUG 2 HIX
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":1,"notes":"Drug1 notes: notes for drug 1"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - custom_option_1^1 AND custom_option_2^2","note_position":2,"notes":"Drug2 notes: notes for drug 2"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_1_id, hix_hpt, drug_2_id, dim_restriction_type_id, expected_output);

--DRUG 2 MEDICARE MA
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - drug_3^1 AND CustomOption1^2","note_position":1,"notes":"Drug_2 notes: notes for custom option 1"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - drug_3^1 AND CustomOption1^2","note_position":1,"notes":"Drug_1 notes: notes for drug 3"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_11_id, medicare_ma_hpt, drug_2_id, dim_restriction_type_id, expected_output);

--DRUG 2 COMMERCIAL
expected_output= null;
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_1_id, commercial_hpt, drug_2_id, dim_restriction_type_id, expected_output);


success=true;
return success;
END
$$ LANGUAGE plpgsql;