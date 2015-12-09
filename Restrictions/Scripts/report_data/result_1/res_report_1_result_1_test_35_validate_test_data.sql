CREATE OR REPLACE FUNCTION res_report_1_result_1_test_35_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  fe_report_1 INTEGER;
  medical_benefit_type INTEGER := 2;
BEGIN

-- Create Report Id
SELECT res_create_report_1_result_1_criteria_report() INTO fe_report_1;

expected_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","restriction_name":"Diagnosis","criteria_restriction_name":"Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","restriction_name":"Age","criteria_restriction_name":"Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","health_plan_type_name":"commercial","drug_name":"drug_2","lives":200,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":1},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","restriction_name":"ST - Single","criteria_restriction_name":"ST - Single - custom_option_2","criteria_restriction_short_name":"custom_option_2","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1}'||
']';

PERFORM res_rpt_health_plan_type_validate_data(fe_report_1, medical_benefit_type, expected_output);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;