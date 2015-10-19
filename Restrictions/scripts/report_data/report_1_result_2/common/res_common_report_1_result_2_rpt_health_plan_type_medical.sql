CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_health_plan_type_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_medical_summary_table_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_medical_summary_table_output= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","restriction_name":"Diagnosis","criteria_restriction_name":"Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","restriction_name":"Age","criteria_restriction_name":"Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","health_plan_type_name":"commercial","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1},'||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","restriction_name":"ST - Single","criteria_restriction_name":"ST - Single - custom_option_2","criteria_restriction_short_name":"custom_option_2","health_plan_type_name":"hix","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":1}'||
']';

PERFORM res_rpt_health_plan_type_validate_data(report_id, medical_view, expected_medical_summary_table_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;