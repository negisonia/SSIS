CREATE OR REPLACE FUNCTION res_common_result_7_rpt_summary_table_pharmacy(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
pharmacy_view CONSTANT integer:=1;
expected_pharmacy_summary_table_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_pharmacy_summary_table_output= format('['||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"PA","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":500,"health_plan_count":2,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","lives":300,"total_pharmacy_lives":500,"health_plan_count":3,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"QL","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"PA","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":500,"health_plan_count":2,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","lives":300,"total_pharmacy_lives":500,"health_plan_count":3,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"QL","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"ST","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":500,"health_plan_count":2,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":null,"benefit_restriction_name":null,"benefit_name":"Pharmacy","lives":null,"total_pharmacy_lives":500,"health_plan_count":null,"total_health_plan_count":5,"total_medical_lives":null,"provider_count":null,"total_provider_count":null}'||
']',report_id);
PERFORM res_rpt_summary_table_validate_data(report_id,expected_pharmacy_summary_table_output,pharmacy_view);

success=true;
return success;
END
$$ LANGUAGE plpgsql;