CREATE OR REPLACE FUNCTION res_report_1_result_1_test_20_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

fe_report_1 INTEGER;
summary_table_output VARCHAR;
expected_plan_details_output VARCHAR;

BEGIN

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

--VALIDATE SUMMARY TABLE
expected_plan_details_output= '['||
'{"provider_name":"provider_1","health_plan_name":"health_plan_comm","formulary_url":"https://health_plan_comm/test.pdf","health_plan_type_name":"commercial","lives":100,"drug_name":"drug_1","tierfid":1,"preferred_brand_tier_id":null,"has_quantity_limit":true,"has_prior_authorization":true,"has_step_therapy":false,"has_other_restriction":false,"has_medical":false,"reason_code_code":"92","reason_code_desc":"PA required if recommended dose duration exceeded."},'||
'{"provider_name":"provider_1","health_plan_name":"health_plan_comm","formulary_url":"https://health_plan_comm/test.pdf","health_plan_type_name":"commercial","lives":100,"drug_name":"drug_2","tierfid":3,"preferred_brand_tier_id":null,"has_quantity_limit":false,"has_prior_authorization":false,"has_step_therapy":false,"has_other_restriction":false,"has_medical":true,"reason_code_code":"42","reason_code_desc":"Non-preferred under medical benefit."},'||
'{"provider_name":"provider_1","health_plan_name":"health_plan_comm_1","formulary_url":"https://health_plan_comm_1/test.pdf","health_plan_type_name":"commercial","lives":100,"drug_name":"drug_1","tierfid":1,"preferred_brand_tier_id":null,"has_quantity_limit":false,"has_prior_authorization":false,"has_step_therapy":false,"has_other_restriction":false,"has_medical":false,"reason_code_code":null,"reason_code_desc":null},'||
'{"provider_name":"provider_1","health_plan_name":"health_plan_comm_1","formulary_url":"https://health_plan_comm_1/test.pdf","health_plan_type_name":"commercial","lives":100,"drug_name":"drug_2","tierfid":2,"preferred_brand_tier_id":null,"has_quantity_limit":true,"has_prior_authorization":true,"has_step_therapy":true,"has_other_restriction":false,"has_medical":false,"reason_code_code":null,"reason_code_desc":null},'||
'{"provider_name":"provider_1","health_plan_name":"health_plan_hix","formulary_url":"https://health_plan_hix/test.pdf","health_plan_type_name":"hix","lives":100,"drug_name":"drug_1","tierfid":3,"preferred_brand_tier_id":3,"has_quantity_limit":false,"has_prior_authorization":true,"has_step_therapy":false,"has_other_restriction":false,"has_medical":false,"reason_code_code":"90","reason_code_desc":"PA not required on initial fill."},'||
'{"provider_name":"provider_1","health_plan_name":"health_plan_hix","formulary_url":"https://health_plan_hix/test.pdf","health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","tierfid":2,"preferred_brand_tier_id":3,"has_quantity_limit":false,"has_prior_authorization":true,"has_step_therapy":true,"has_other_restriction":false,"has_medical":true,"reason_code_code":"40","reason_code_desc":"Covered under medical benefit."}'||
']';
PERFORM res_rpt_health_plan_validate_data(fe_report_1,expected_plan_details_output);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;