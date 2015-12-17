CREATE OR REPLACE FUNCTION res_ca_report_1_result_1_test_16_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  report_id INTEGER;
  drugs VARCHAR:='drugs';
  drug_1 INTEGER;
  drug_2 INTEGER;
  pharmacy_benefit_type INTEGER := 1;
  state_market_type INTEGER := 2;  
BEGIN

-- Create Report Id
SELECT res_ca_create_report_1_result_1_criteria_report() INTO report_id;

-- Get parameter values
SELECT common_get_table_id_by_name(drugs,'drug_1') INTO drug_1;
SELECT common_get_table_id_by_name(drugs,'drug_2') INTO drug_2;

--MEDICAL FORMS
expected_output=format('['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Clinical - criteria_clinical_1","criteria_restriction_short_name":"criteria_clinical_1","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_name":"Connecticut","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%1$s,"criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_name":"Connecticut","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","drug_id":%2$s,"criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","criteria_restriction_short_name":"custom_option_1 AND  custom_option_2","market_name":"Massachusetts","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']',drug_1,drug_2);


PERFORM res_rpt_geo_validate_data(report_id, pharmacy_benefit_type, state_market_type, expected_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;