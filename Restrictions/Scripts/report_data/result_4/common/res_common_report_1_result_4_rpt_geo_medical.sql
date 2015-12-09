CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_geo_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

state_market_type INTEGER := 1;
medical_benefit_type INTEGER := 2;
expected_output VARCHAR;
drug_2_id INTEGER;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;

--MEDICAL GEO
expected_output= format('['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"ST - Single - custom_option_2","criteria_restriction_short_name":"custom_option_2","market_name":"Middlesex","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
']',drug_2_id);
PERFORM res_rpt_geo_validate_data(report_id, medical_benefit_type, state_market_type, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;