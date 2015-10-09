CREATE OR REPLACE FUNCTION restrictions_test_030_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_rpt_geo_output VARCHAR;
fe_report_1 INTEGER;
drug_1 INTEGER;
drug_2 INTEGER;
pharmacy_benefit_type INTEGER := 1;
state_market_type INTEGER := 2;
BEGIN

--RETRIEVE DATA

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;


--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

expected_rpt_geo_output=format('['||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Clinical - criteria_clinical_1","criteria_restriction_short_name":"criteria_clinical_1","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_id":5,"market_name":"Connecticut","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_id":5,"market_name":"Connecticut","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","criteria_restriction_short_name":"custom_option_1 AND  custom_option_2","market_id":4,"market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
    ']',drug_1,drug_2);

PERFORM res_rpt_geo_validate_data(fe_report_1, pharmacy_benefit_type, state_market_type, expected_rpt_geo_output);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;