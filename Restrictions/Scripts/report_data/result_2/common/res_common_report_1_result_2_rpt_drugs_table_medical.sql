CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_drugs_table_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_rpt_drug_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_rpt_drug_output= format('['||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Medical","criteria_restriction_name":"Age - criteria_age_1","restriction_name":"Age","dim_restriction_type_id":2,"lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":200,"provider_count":1,"total_provider_count":2},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Medical","criteria_restriction_name":"Diagnosis - criteria_diagnosis_3","restriction_name":"Diagnosis","dim_restriction_type_id":2,"lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":200,"provider_count":1,"total_provider_count":2},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Medical","criteria_restriction_name":"ST - Single - custom_option_2","restriction_name":"ST - Single","dim_restriction_type_id":2,"lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":200,"provider_count":1,"total_provider_count":2}'||
']',report_id);

PERFORM res_rpt_drug_validate_data(report_id, medical_view ,expected_rpt_drug_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;