CREATE OR REPLACE FUNCTION res_rpt_geo_drill_state_validate_data(_report_id INTEGER, _benefit_type INTEGER, _result_market_id INTEGER, _dim_criteria_restriction_id INTEGER, _drug_id INTEGER,  _market_type_id INTEGER, _market_id INTEGER, expected_json VARCHAR) --REPORT DATA
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_geo_output VARCHAR DEFAULT FALSE;
BEGIN

IF (_benefit_type IS DISTINCT FROM 1) AND (_benefit_type IS DISTINCT FROM 2) THEN
    SELECT throw_error(format('TYPE: %s PASSED AS ARGUMENT IS INVALID', benefit_type));
END IF;

IF (_market_type_id IS DISTINCT FROM 1) AND (_market_type_id IS DISTINCT FROM 2) AND (_market_type_id IS DISTINCT FROM 3) AND (_market_type_id IS DISTINCT FROM 4) THEN
    SELECT throw_error(format('MARKET TYPE: %s PASSED AS ARGUMENT IS INVALID', _market_type_id));
END IF;

--VALIDATE RPT DRUG
SELECT  array_to_json(array_agg(row_to_json(t))) from (SELECT q.indication_name, q.indication_abbre, q.drug_name, q.lives, q.health_plan_count, q.provider_count, q.total_pharmacy_lives, q.total_medical_lives, q.total_health_plan_count, q.total_provider_count, q.benefit_name, q.criteria_restriction_name, q.criteria_restriction_short_name, q.market_name from (SELECT * FROM rpt_geo(_report_id, _benefit_type, _result_market_id, _dim_criteria_restriction_id, _drug_id, _market_type_id, _market_id) order by dim_criteria_restriction_id, drug_id) q) t INTO rpt_geo_output;

IF rpt_geo_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_geo_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('rpt_geo_output : REPORT  GEO  OUTPUT  MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;
