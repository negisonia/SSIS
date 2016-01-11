CREATE OR REPLACE FUNCTION res_common_result_7_rpt_provider_details_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_provider_details_table_output VARCHAR;
provider_1_id INTEGER;
provider_11_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
medicare_ma_plan_type_id INTEGER;
BEGIN

SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;
SELECT common_get_table_id_by_name('providers','provider_11') INTO provider_11_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','medicare_ma') INTO medicare_ma_plan_type_id;

expected_provider_details_table_output= format('['||
'{"provider_id":%1$s,"benefit_name":"Medical","health_plan_type_id":%2$s,"health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","criteria_restriction_name":"Single - Single"},'||
'{"provider_id":%3$s,"benefit_name":"Medical","health_plan_type_id":%4$s,"health_plan_type_name":"medicare_ma","lives":100,"drug_name":"drug_1","criteria_restriction_name":"Single - Single"}]',provider_1_id,hix_plan_type_id,provider_11_id,medicare_ma_plan_type_id);
PERFORM res_rpt_provider_details_validate_data(report_id, medical_view, expected_provider_details_table_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;