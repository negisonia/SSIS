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
expected_output= '';
PERFORM res_rpt_health_plan_notes_validate_data(report_id, provider_id, hix_hpt, drug_2_id, st_dim_criterion_type, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;