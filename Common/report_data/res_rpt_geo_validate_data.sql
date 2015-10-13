CREATE OR REPLACE FUNCTION res_rpt_geo_validate_data(report_id INTEGER, benefit_type INTEGER, market_type INTEGER, expected_json VARCHAR) --REPORT DATA
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_geo_output VARCHAR DEFAULT FALSE;
BEGIN

IF (benefit_type IS DISTINCT FROM 1) AND (benefit_type IS DISTINCT FROM 2) THEN
    SELECT throw_error(format('TYPE: %s PASSED AS ARGUMENT IS INVALID', benefit_type));
END IF;

--VALIDATE RPT DRUG
SELECT  array_to_json(array_agg(row_to_json(t))) from (SELECT q.indication_name, q.indication_abbre, q.benefit_name, q.drug_id, q.criteria_restriction_name, q.criteria_restriction_short_name, q.market_name, q.lives, q.health_plan_count,  q.provider_count, q.total_pharmacy_lives, q.total_medical_lives, q.total_health_plan_count, q.total_provider_count  FROM (select * from rpt_geo(report_id,benefit_type,market_type) order by dim_criteria_restriction_id, drug_id, market_id,indication_name) q) t INTO rpt_geo_output;

IF rpt_geo_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_geo_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('rpt_geo_output : REPORT  DRUG  OUTPUT  MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;
