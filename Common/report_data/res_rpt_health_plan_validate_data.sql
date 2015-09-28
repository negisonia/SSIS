CREATE OR REPLACE FUNCTION res_rpt_health_plan_validate_data(report_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_health_plan_output VARCHAR;
BEGIN

--VALIDATE RPT HEALTH PLAN
SELECT  array_to_json(array_agg(row_to_json(t))) from (select provider_name, health_plan_name, formulary_url, health_plan_type_name, lives, drug_name, tierfid, preferred_brand_tier_id, has_quantity_limit, has_prior_authorization, has_step_therapy, has_other_restriction, has_medical, reason_code_code, reason_code_desc from rpt_health_plan(report_id) order by provider_name, health_plan_name,drug_name,tierfid) t INTO rpt_health_plan_output;

IF rpt_health_plan_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_health_plan_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('res_rpt_health_plan_validate_data : REPORT HEALTH PLAN OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;