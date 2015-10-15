CREATE OR REPLACE FUNCTION res_report_1_result_1_test_34_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  fe_report_1 INTEGER;
  pharmacy_benefit_type INTEGER := 1;
BEGIN

-- Create Report Id
SELECT res_create_report_1_result_1_criteria_report() INTO fe_report_1;

expected_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Diagnosis","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","health_plan_type_name":"commercial","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Diagnosis","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Unspecified","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","health_plan_type_name":"commercial","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Unspecified","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","health_plan_type_name":"hix","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Diagnosis","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","health_plan_type_name":"commercial","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Clinical","criteria_restriction_name":"PA - Clinical - criteria_clinical_1","criteria_restriction_short_name":"criteria_clinical_1","health_plan_type_name":"commercial","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Age","criteria_restriction_name":"PA - Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","health_plan_type_name":"commercial","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"QL","criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","health_plan_type_name":"commercial","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"QL","criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","health_plan_type_name":"commercial","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA/ST - Single","criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","health_plan_type_name":"commercial","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA/ST - Single","criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"ST - Double","criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","criteria_restriction_short_name":"custom_option_1 AND  custom_option_2","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']';

PERFORM res_rpt_health_plan_type_validate_data(fe_report_1, pharmacy_benefit_type, expected_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;