CREATE OR REPLACE FUNCTION res_rpt_summary_table_validate_data(report_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
summary_table_output VARCHAR DEFAULT FALSE;
BEGIN

--VALIDATE SUMMARY TABLE
SELECT  array_to_json(array_agg(row_to_json(t))) from rpt_summary_table(report_id) t  INTO summary_table_output;
IF summary_table_output!=expected_json THEN
 SELECT throw_error(format('Res_rpt_summary_table_validate_data : SUMMARY  TABLE  OUTPUT  MISMATCH  expected value:  %s  actual value : %s', summary_table_output, expected_json));
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;