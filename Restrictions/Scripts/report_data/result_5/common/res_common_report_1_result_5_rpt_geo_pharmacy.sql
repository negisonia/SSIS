CREATE OR REPLACE FUNCTION res_common_report_1_result_5_rpt_geo_pharmacy(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

market_type INTEGER := 3;
pharmacy_benefit_type INTEGER := 1;
expected_output VARCHAR;
drug_1_id INTEGER;
drug_2_id INTEGER;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
--MARKET TYPES : 1 COUNTIES , 2 STATES , 3 MSA

--MEDICAL GEO
expected_output= format('['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Hartford-West Hartford-East Hartford, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Norwich-New London, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_name":"Hartford-West Hartford-East Hartford, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_name":"Norwich-New London, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Labs - criteria_lab_3","criteria_restriction_short_name":"criteria_lab_3","market_name":"Hartford-West Hartford-East Hartford, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Labs - criteria_lab_3","criteria_restriction_short_name":"criteria_lab_3","market_name":"Norwich-New London, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_name":"Hartford-West Hartford-East Hartford, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_name":"Hartford-West Hartford-East Hartford, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"ST - Double - drug_3 and custom_option_1","criteria_restriction_short_name":"drug_3 and custom_option_1","market_name":"Hartford-West Hartford-East Hartford, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"ST - Double - drug_3 and custom_option_1","criteria_restriction_short_name":"drug_3 and custom_option_1","market_name":"Norwich-New London, CT","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']',drug_1_id,drug_2_id);
PERFORM res_rpt_geo_validate_data(report_id, pharmacy_benefit_type, market_type, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;