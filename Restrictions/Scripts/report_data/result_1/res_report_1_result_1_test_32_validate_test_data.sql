CREATE OR REPLACE FUNCTION res_report_1_result_1_test_32_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_rpt_geo_output VARCHAR;
fe_report_1 INTEGER;
drug_2 INTEGER;
medical_benefit_type INTEGER := 2;
state_market_type INTEGER := 2;
BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;


--REPORT#1
SELECT res_create_report_1_result_1_criteria_report() INTO fe_report_1;

expected_rpt_geo_output=format('['||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Connecticut","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Massachusetts","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_name":"Massachusetts","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"ST - Single - custom_option_2","criteria_restriction_short_name":"custom_option_2","market_name":"Massachusetts","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
    ']',drug_2);

PERFORM res_rpt_geo_validate_data(fe_report_1, medical_benefit_type, state_market_type, expected_rpt_geo_output);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;