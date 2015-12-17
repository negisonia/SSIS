CREATE OR REPLACE FUNCTION res_common_result_7_rpt_drugs_table_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_rpt_drug_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_rpt_drug_output= format('['||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Medical","criteria_restriction_name":"Single - Single","restriction_name":"Single","dim_restriction_type_id":2,"lives":50,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":350,"provider_count":1,"total_provider_count":4},'||
'{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Medical","criteria_restriction_name":"Single - Single","restriction_name":"Single","dim_restriction_type_id":2,"lives":100,"total_pharmacy_lives":0,"health_plan_count":0,"total_health_plan_count":0,"total_medical_lives":350,"provider_count":1,"total_provider_count":4}'||
']',report_id);
PERFORM res_rpt_drug_validate_data(report_id, medical_view ,expected_rpt_drug_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;