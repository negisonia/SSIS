CREATE OR REPLACE FUNCTION res_common_result_7_rpt_health_plan_ql_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_id INTEGER;
commercial_hpt INTEGER;
employer_hpt INTEGER;
hix_hpt INTEGER;
dim_restriction_type_id INTEGER:=4;
drug_1_id INTEGER;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;

--RETRIEVE HEALTH PLAN TYPE
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','employer') INTO employer_hpt;

SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;

--COMMERCIAL DRUG 2 QL
expected_output= '[{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"1 tabs per 10 days\\n\\nql message"}]';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, commercial_hpt, drug_2_id, dim_restriction_type_id, expected_output);

--COMMERCIAL DRUG 1 QL
expected_output= '[{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_ql_1","note_position":1,"notes":"2 tabs per 1 week"}]';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, commercial_hpt, drug_1_id, dim_restriction_type_id, expected_output);

--EMPLOYER DRUG 2 QL
expected_output= null;
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, employer_hpt, drug_2_id, dim_restriction_type_id, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;