CREATE OR REPLACE FUNCTION res_rpt_drug_validate_data(report_id INTEGER, rpt_type INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_drug_output VARCHAR DEFAULT FALSE;
BEGIN

IF (rpt_type IS DISTINCT FROM 1) AND (rpt_type IS DISTINCT FROM 2) THEN
    SELECT throw_error(format('TYPE: %s PASSED AS ARGUMENT IS INVALID', rpt_type));
END IF;

--VALIDATE RPT DRUG
SELECT  array_to_json(array_agg(row_to_json(t))) from (SELECT q.criteria_report_id, q.indication_name,  q.drug_name, q.benefit_name, q.criteria_restriction_name, q.restriction_name, q.dim_restriction_type_id, q.lives, q.total_pharmacy_lives, q.health_plan_count, q.total_health_plan_count, q.total_medical_lives, q.provider_count, q.total_provider_count FROM (select *  from rpt_drug(report_id, rpt_type) order by indication_name,dim_criteria_restriction_id,drug_name, criteria_restriction_name) q) t INTO rpt_drug_output;

IF rpt_drug_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_drug_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('res_rpt_drug_validate_data : REPORT  DRUG  OUTPUT  MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;
