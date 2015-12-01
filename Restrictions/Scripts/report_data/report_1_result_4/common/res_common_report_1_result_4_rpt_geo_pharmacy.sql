CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_geo_pharmacy(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

state_market_type INTEGER := 1;
pharmacy_benefit_type INTEGER := 1;
expected_output VARCHAR;
drug_1_id INTEGER;
drug_2_id INTEGER;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;

--MEDICAL GEO
expected_output= format('['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_name":"Middlesex","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_name":"Middlesex","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","criteria_restriction_short_name":"custom_option_1 AND  custom_option_2","market_name":"Middlesex","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']',drug_1_id,drug_2_id);
PERFORM res_rpt_geo_validate_data(report_id, pharmacy_benefit_type, state_market_type, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;