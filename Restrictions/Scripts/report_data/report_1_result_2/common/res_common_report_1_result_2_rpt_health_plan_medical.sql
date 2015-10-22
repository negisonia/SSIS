CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_health_plan_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_plan_details_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_plan_details_output= '['||
    '{"provider_name":"provider_1","health_plan_name":"health_plan_comm","formulary_url":"https://health_plan_comm/test.pdf","health_plan_type_name":"commercial","lives":100,"drug_name":"drug_2","tierfid":3,"preferred_brand_tier_id":null,"has_quantity_limit":false,"has_prior_authorization":false,"has_step_therapy":false,"has_other_restriction":false,"has_medical":true,"reason_code_code":"42","reason_code_desc":"Non-preferred under medical benefit."},'||
    '{"provider_name":"provider_1","health_plan_name":"health_plan_hix","formulary_url":"https://health_plan_hix/test.pdf","health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","tierfid":2,"preferred_brand_tier_id":3,"has_quantity_limit":false,"has_prior_authorization":true,"has_step_therapy":true,"has_other_restriction":false,"has_medical":true,"reason_code_code":"40","reason_code_desc":"Covered under medical benefit."}'||
    ']';
PERFORM res_rpt_health_plan_validate_data(report_id,expected_plan_details_output);


success=true;
return success;
END
$$ LANGUAGE plpgsql;