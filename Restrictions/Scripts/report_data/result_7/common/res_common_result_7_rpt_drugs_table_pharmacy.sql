CREATE OR REPLACE FUNCTION res_common_result_7_rpt_drugs_table_pharmacy(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
pharmacy_view CONSTANT INTEGER:=1;
expected_rpt_drug_output VARCHAR;
BEGIN

--VALIDATE RPT_DRUG pharmacy
expected_rpt_drug_output= format('['||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"Double - Double","restriction_name":"Double","dim_restriction_type_id":6,"lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"Double - Double","restriction_name":"Double","dim_restriction_type_id":3,"lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"Single - Single","restriction_name":"Single","dim_restriction_type_id":6,"lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"Single - Single","restriction_name":"Single","dim_restriction_type_id":6,"lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"Single - Single","restriction_name":"Single","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"Single - Single","restriction_name":"Single","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":500,"health_plan_count":1,"total_health_plan_count":5,"total_medical_lives":0,"provider_count":0,"total_provider_count":0}'||
']',report_id);
PERFORM res_rpt_drug_validate_data(report_id, pharmacy_view ,expected_rpt_drug_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;