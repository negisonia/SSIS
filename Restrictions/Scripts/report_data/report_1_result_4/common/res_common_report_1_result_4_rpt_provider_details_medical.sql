CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_provider_details_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_provider_details_table_output VARCHAR;

provider_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
BEGIN

SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;

expected_provider_details_table_output= '';
PERFORM res_rpt_provider_details_validate_data(report_id, medical_view, expected_provider_details_table_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;