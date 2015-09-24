CREATE OR REPLACE FUNCTION res_rpt_provider_details_validate_data(report_id INTEGER, benefit_type_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_provider_detail_output VARCHAR;
BEGIN

--VALIDATE RPT PROVIDER DETAILS
SELECT  array_to_json(array_agg(row_to_json(t))) from (select  r.provider_id, r.benefit_name, r.health_plan_type_id,r.health_plan_type_name, r.lives, r.drug_name, r.criteria_restriction_name from rpt_provider_detail(1697,1) r )t  INTO rpt_provider_detail_output;

IF rpt_provider_detail_output DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_provider_detail_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('rpt_provider_detail_output_data : REPORT PROVIDER DETAIL OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;