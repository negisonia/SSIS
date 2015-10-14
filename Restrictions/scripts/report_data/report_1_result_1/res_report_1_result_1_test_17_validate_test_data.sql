CREATE OR REPLACE FUNCTION res_report_1_result_1_test_17_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
fe_report_1 INTEGER;
pharmacy_view CONSTANT integer:=1;
medical_view CONSTANT integer:=2;
expected_pharmacy_summary_table_output VARCHAR;
expected_medical_summary_table_output VARCHAR;

BEGIN

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

--VALIDATE SUMMARY TABLE
expected_pharmacy_summary_table_output= format('['||
    '{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"PA","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":300,"health_plan_count":2,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","lives":300,"total_pharmacy_lives":300,"health_plan_count":3,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"QL","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"PA","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":300,"health_plan_count":2,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","lives":300,"total_pharmacy_lives":300,"health_plan_count":3,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"QL","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"ST","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":300,"health_plan_count":2,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"drug_name":null,"benefit_restriction_name":null,"benefit_name":"Pharmacy","lives":null,"total_pharmacy_lives":300,"health_plan_count":null,"total_health_plan_count":3,"total_medical_lives":null,"provider_count":null,"total_provider_count":null}'||
    ']',fe_report_1);

PERFORM res_rpt_summary_table_validate_data(fe_report_1,expected_pharmacy_summary_table_output,pharmacy_view);

expected_medical_summary_table_output= format('['||
    '{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"Medical","benefit_name":"Medical","lives":300,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":300,"provider_count":2,"total_provider_count":2},'||
    '{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"ST","benefit_name":"Medical","lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":300,"provider_count":1,"total_provider_count":2},'||
    '{"criteria_report_id":%1$s,"drug_name":null,"benefit_restriction_name":null,"benefit_name":"Medical","lives":null,"total_pharmacy_lives":null,"health_plan_count":null,"total_health_plan_count":null,"total_medical_lives":300,"provider_count":null,"total_provider_count":2}'||
    ']',fe_report_1);

PERFORM res_rpt_summary_table_validate_data(fe_report_1,expected_medical_summary_table_output,medical_view);

success=true;
return success;
END
$$ LANGUAGE plpgsql;