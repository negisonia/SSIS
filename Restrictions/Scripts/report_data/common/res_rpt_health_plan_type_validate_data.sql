CREATE OR REPLACE FUNCTION res_rpt_health_plan_type_validate_data(report_id INTEGER, benefit_type_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_health_plan_type_output VARCHAR;
BEGIN

--VALIDATE RPT HEALTH PLAN
SELECT  array_to_json(array_agg(row_to_json(t))) from (select q.indication_name, q.indication_abbre, q.benefit_name, q.restriction_name, q.criteria_restriction_name, q.criteria_restriction_short_name, q.health_plan_type_name, q.drug_name, q.lives, q.health_plan_count, 
q.provider_count, q.total_pharmacy_lives, q.total_medical_lives, q.total_health_plan_count, q.total_provider_count from (select * from rpt_health_plan_type(report_id , benefit_type_id) order by dim_criterion_id, health_plan_type_name, drug_name ) q) t INTO rpt_health_plan_type_output;

IF rpt_health_plan_type_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_health_plan_type_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('res_rpt_health_plan_type_validate_data : REPORT HEALTH PLAN TYPE OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;
