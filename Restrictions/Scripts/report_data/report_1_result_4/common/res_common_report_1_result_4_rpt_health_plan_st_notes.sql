CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_health_plan_st_notes(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_id INTEGER;
hix_hpt INTEGER;
commercial_hpt INTEGER;
dim_restriction_type_id INTEGER:=3;
drug_2_id INTEGER;
expected_output VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;

--RETRIEVE HEALTH PLAN TYPE
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;

SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;

--ST COMMERCIAL DRUG 2
expected_output= '';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, commercial_hpt, drug_2_id, dim_restriction_type_id, expected_output);

--ST HIX DRUG 2
--expected_output= '';
--PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, hix_hpt, drug_2_id, dim_restriction_type_id, expected_output);


success=true;
return success;
END
$$ LANGUAGE plpgsql;