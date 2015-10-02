CREATE OR REPLACE FUNCTION res_rpt_provider_source_comments_validate_data(report_id INTEGER, provider_id INTEGER,health_plan_type_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_provider_source_comments_output VARCHAR;
BEGIN

--VALIDATE RPT HEALTH PLAN
SELECT  array_to_json(array_agg(row_to_json(t))) from (select distinct source_comments from rpt_provider_source_comments(report_id,provider_id,health_plan_type_id)) t INTO rpt_provider_source_comments_output;

IF rpt_provider_source_comments_output IS DISTINCT FROM expected_json THEN
--RAISE NOTICE 'ACTUAL: %s' , rpt_provider_source_comments_output;
--RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('res_rpt_provider_source_comments : REPORT PROVIDER SOURCE COMMENTS OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;
