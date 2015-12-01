CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_summary_table_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_medical_summary_table_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_medical_summary_table_output= format('['||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"Medical","benefit_name":"Medical","lives":300,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":300,"provider_count":2,"total_provider_count":2},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"ST","benefit_name":"Medical","lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":300,"provider_count":1,"total_provider_count":2},'||
'{"criteria_report_id":%1$s,"drug_name":null,"benefit_restriction_name":null,"benefit_name":"Medical","lives":null,"total_pharmacy_lives":null,"health_plan_count":null,"total_health_plan_count":null,"total_medical_lives":300,"provider_count":null,"total_provider_count":2}'||
']',report_id);

PERFORM res_rpt_summary_table_validate_data(report_id,expected_medical_summary_table_output,medical_view);

success=true;
return success;
END
$$ LANGUAGE plpgsql;