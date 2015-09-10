CREATE OR REPLACE FUNCTION res_ca_etl_test_4_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
  expected_drug_output varchar;
BEGIN

-- Create Criteria Report Id
SELECT res_ca_etl_test_create_report_1_criteria_report_data() INTO criteria_report_id;

expected_drug_output= format(
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"PA/ST - Single - custom_option_1","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA/ST - Single - custom_option_1","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","dim_restriction_type_id":3,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Age - criteria_age_1","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Clinical - criteria_clinical_1","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"QL - criteria_ql_1","dim_restriction_type_id":4,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"QL - criteria_ql_1","dim_restriction_type_id":4,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"Ind1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0}'||
']',fe_report_1);

  PERFORM validate_rpt_drug(criteria_report_id, 1, expected_drug_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
