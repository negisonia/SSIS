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
SELECT  array_to_json(array_agg(row_to_json(t))) from (select criteria_report_id, indication_name, drug_name, benefit_name, criteria_restriction_name, restriction_name, dim_restriction_type_id, lives, total_pharmacy_lives, health_plan_count, total_health_plan_count, total_medical_lives, provider_count, total_provider_count from rpt_drug(report_id, rpt_type)) t INTO rpt_drug_output;

IF rpt_drug_output IS DISTINCT FROM  expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_drug_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('res_rpt_drug_validate_data : REPORT  DRUG  OUTPUT  MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;