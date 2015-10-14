CREATE OR REPLACE FUNCTION res_ca_etl_test_5_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
  expected_drug_output varchar;

  medical_view CONSTANT integer:=2;
BEGIN

-- Create Criteria Report Id
SELECT res_ca_etl_test_create_report_1_criteria_report_data() INTO criteria_report_id;

expected_drug_output= format('['||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Medical","criteria_restriction_name":"Age - criteria_age_1","restriction_name":"Age","dim_restriction_type_id":2,"lives":200,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":300,"provider_count":1,"total_provider_count":2},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Medical","criteria_restriction_name":"Diagnosis - criteria_diagnosis_3","restriction_name":"Diagnosis","dim_restriction_type_id":2,"lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":300,"provider_count":1,"total_provider_count":2},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Medical","criteria_restriction_name":"ST - Single - custom_option_2","restriction_name":"ST - Single","dim_restriction_type_id":2,"lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":300,"provider_count":1,"total_provider_count":2}'||
']',criteria_report_id);

  PERFORM res_rpt_drug_validate_data(criteria_report_id, medical_view, expected_drug_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
