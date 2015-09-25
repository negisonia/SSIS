CREATE OR REPLACE FUNCTION res_rpt_summary_table_validate_data(report_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
summary_table_output VARCHAR DEFAULT FALSE;
BEGIN

--VALIDATE SUMMARY TABLE
SELECT  array_to_json(array_agg(row_to_json(t))) from (select criteria_report_id, drug_name, benefit_restriction_name, benefit_name, lives, total_pharmacy_lives, health_plan_count, total_health_plan_count, total_medical_lives, provider_count, total_provider_count from rpt_summary_table(report_id)) t INTO summary_table_output;
IF summary_table_output IS DISTINCT FROM expected_json THEN
 RAISE NOTICE 'res_rpt_summary_table_validate_data  Actual output: %s', summary_table_output;
 RAISE NOTICE 'res_rpt_summary_table_validate_data  Expected output: %s', expected_json;

 SELECT throw_error('Res_rpt_summary_table_validate_data : SUMMARY  TABLE  OUTPUT  MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;