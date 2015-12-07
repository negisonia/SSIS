CREATE OR REPLACE FUNCTION res_common_report_1_result_5_rpt_health_plan_details(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_plan_details_output VARCHAR;
BEGIN

--VALIDATE HEALTH PLAN DETAILS
expected_plan_details_output= '['||
'{"provider_name":"provider_1","health_plan_name":"health_plan_comm_1","formulary_url":"https://health_plan_comm_1/test.pdf","health_plan_type_name":"commercial","lives":100,"drug_name":"drug_1","tierfid":1,"preferred_brand_tier_id":null,"has_quantity_limit":false,"has_prior_authorization":false,"has_step_therapy":false,"has_other_restriction":false,"has_medical":false,"reason_code_code":null,"reason_code_desc":null},'||
'{"provider_name":"provider_1","health_plan_name":"health_plan_comm_1","formulary_url":"https://health_plan_comm_1/test.pdf","health_plan_type_name":"commercial","lives":100,"drug_name":"drug_2","tierfid":2,"preferred_brand_tier_id":null,"has_quantity_limit":true,"has_prior_authorization":true,"has_step_therapy":true,"has_other_restriction":false,"has_medical":false,"reason_code_code":null,"reason_code_desc":null}'||
']';
PERFORM res_rpt_health_plan_validate_data(report_id,expected_plan_details_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;