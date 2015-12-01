CREATE OR REPLACE FUNCTION res_report_1_result_4_rpt_healthplan_type_pharmacy(report_id INTEGER) --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT FALSE;
expected_output varchar;
pharmacy_benefit_type INTEGER := 1;

BEGIN

expected_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA/ST - Single","criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","health_plan_type_name":"commercial","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"PA/ST - Single","criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","restriction_name":"ST - Double","criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","criteria_restriction_short_name":"custom_option_1 AND  custom_option_2","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']';
PERFORM res_rpt_health_plan_type_validate_data(report_id, pharmacy_benefit_type, expected_output);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;