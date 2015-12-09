CREATE OR REPLACE FUNCTION res_report_1_result_4_rpt_healthplan_type_medical(report_id INTEGER) --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  fe_report_1 INTEGER;
  medical_benefit_type INTEGER := 2;
BEGIN

expected_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","restriction_name":"ST - Single","criteria_restriction_name":"ST - Single - custom_option_2","criteria_restriction_short_name":"custom_option_2","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1}'||
']';
PERFORM res_rpt_health_plan_type_validate_data(report_id, medical_benefit_type, expected_output);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;