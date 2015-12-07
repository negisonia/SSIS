CREATE OR REPLACE FUNCTION res_common_report_1_result_5_rpt_health_plan_st_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_1_id INTEGER;
provider_11_id INTEGER;
medicare_hpt INTEGER;
commercial_plan_type_id INTEGER;
dim_restriction_type_id INTEGER:=3;
drug_1_id INTEGER;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','medicare_ma') INTO medicare_hpt;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;
SELECT common_get_table_id_by_name('providers','provider_11') INTO provider_11_id;

--ST COMMERCIAL DRUG 2
expected_output= '['||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - drug_3^1 AND CustomOption1^2","note_position":1,"notes":"Drug_2 notes: notes for custom option 1"},'||
'{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Double - drug_3^1 AND CustomOption1^2","note_position":1,"notes":"Drug_1 notes: notes for drug 3"}'||
']';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_11_id, medicare_hpt, drug_2_id, dim_restriction_type_id, expected_output);


success=true;
return success;
END
$$ LANGUAGE plpgsql;