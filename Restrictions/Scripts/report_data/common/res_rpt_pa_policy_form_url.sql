CREATE OR REPLACE FUNCTION res_rpt_pa_policy_form_url(new_report_id INTEGER, new_health_plan_type_id INTEGER, new_provider_id INTEGER, drugs VARCHAR, expected_json VARCHAR) --REPORT DATA
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_pa_policy_form_url_output VARCHAR;
BEGIN

--VALIDATE RPT HEALTH PLAN
SELECT  array_to_json(array_agg(row_to_json(t))) from (select * from pa_policy_form_url(new_report_id,new_health_plan_type_id,new_provider_id,drugs) ORDER BY drug_id , pa_policy_form_url ) t INTO rpt_pa_policy_form_url_output;

IF rpt_pa_policy_form_url_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_pa_policy_form_url_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('rpt_pa_policy_form_url_output : REPORT PA POLICY FORM OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;
