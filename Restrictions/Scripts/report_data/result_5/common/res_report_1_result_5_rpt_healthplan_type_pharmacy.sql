CREATE OR REPLACE FUNCTION res_report_1_result_5_rpt_healthplan_type_pharmacy(report_id INTEGER) --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT FALSE;
expected_output varchar;
pharmacy_benefit_type INTEGER := 1;

BEGIN

expected_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Unspecified","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","health_plan_type_name":"commercial","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Diagnosis","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","health_plan_type_name":"medicare_ma","drug_name":"drug_1","lives":200,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Labs","criteria_restriction_name":"PA - Labs - criteria_lab_3","criteria_restriction_short_name":"criteria_lab_3","health_plan_type_name":"medicare_ma","drug_name":"drug_1","lives":200,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA - Age","criteria_restriction_name":"PA - Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","health_plan_type_name":"medicare_ma","drug_name":"drug_1","lives":200,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"QL","criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","health_plan_type_name":"commercial","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"ST - Double","criteria_restriction_name":"ST - Double - drug_3 and custom_option_1","criteria_restriction_short_name":"drug_3 and custom_option_1","health_plan_type_name":"medicare_ma","drug_name":"drug_2","lives":200,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']';
PERFORM res_rpt_health_plan_type_validate_data(report_id, pharmacy_benefit_type, expected_output);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;