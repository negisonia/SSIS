CREATE OR REPLACE FUNCTION res_ca_etl_test_3_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
  expected_summary_pharmacy_table_output VARCHAR;
  expected_summary_medical_table_output VARCHAR;
  pharmacy_view CONSTANT integer:=1;
  medical_view CONSTANT integer:=2;
BEGIN

-- Create Criteria Report Id
SELECT res_ca_etl_test_create_report_1_criteria_report_data() INTO criteria_report_id;

expected_summary_pharmacy_table_output= format('['||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"PA","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":300,"health_plan_count":2,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","lives":300,"total_pharmacy_lives":300,"health_plan_count":3,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_1","benefit_restriction_name":"QL","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"PA","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":300,"health_plan_count":2,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","lives":300,"total_pharmacy_lives":300,"health_plan_count":3,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"QL","benefit_name":"Pharmacy","lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"ST","benefit_name":"Pharmacy","lives":200,"total_pharmacy_lives":300,"health_plan_count":2,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"drug_name":null,"benefit_restriction_name":null,"benefit_name":"Pharmacy","lives":null,"total_pharmacy_lives":300,"health_plan_count":null,"total_health_plan_count":3,"total_medical_lives":null,"provider_count":null,"total_provider_count":null}]',criteria_report_id);

PERFORM res_rpt_summary_table_validate_data(criteria_report_id,expected_summary_pharmacy_table_output,pharmacy_view);

expected_summary_medical_table_output= format('['||
'{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"Medical","benefit_name":"Medical","lives":200,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":200,"provider_count":2,"total_provider_count":2},
{"criteria_report_id":%1$s,"drug_name":"drug_2","benefit_restriction_name":"ST","benefit_name":"Medical","lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":200,"provider_count":1,"total_provider_count":2},
{"criteria_report_id":%1$s,"drug_name":null,"benefit_restriction_name":null,"benefit_name":"Medical","lives":null,"total_pharmacy_lives":null,"health_plan_count":null,"total_health_plan_count":null,"total_medical_lives":200,"provider_count":null,"total_provider_count":2}]',criteria_report_id);


PERFORM res_rpt_summary_table_validate_data(criteria_report_id,expected_summary_medical_table_output,medical_view);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;