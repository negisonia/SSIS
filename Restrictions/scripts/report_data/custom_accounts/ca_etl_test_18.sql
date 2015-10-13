CREATE OR REPLACE FUNCTION res_ca_etl_test_18_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  report_id INTEGER;
  drugs VARCHAR:='drugs';
  drug_2 INTEGER;
  medical_benefit_type INTEGER := 2;
  state_market_type INTEGER := 2;  
BEGIN

-- Create Report Id
SELECT res_ca_etl_test_create_report_1_criteria_report_data() INTO report_id;

-- Get parameter values
SELECT common_get_table_id_by_name(drugs,'drug_2') INTO drug_2;

--MEDICAL FORMS
expected_output=format('['||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Massachusetts","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Connecticut","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_name":"Massachusetts","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2},'||
    '{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","drug_id":%1$s,"criteria_restriction_name":"ST - Single - custom_option_2","criteria_restriction_short_name":"custom_option_2","market_name":"Massachusetts","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
    ']',drug_2);

PERFORM res_rpt_geo_validate_data(report_id, medical_benefit_type, state_market_type, expected_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;