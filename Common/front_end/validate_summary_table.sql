CREATE OR REPLACE FUNCTION validate_summary_table(report_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
summary_table_output VARCHAR DEFAULT FALSE;
BEGIN

--VALIDATE SUMMARY TABLE
SELECT  array_to_json(array_agg(row_to_json(t))) from rpt_summary_table(report_id) t  INTO summary_table_output;
IF summary_table_output!=expected_json THEN
 RAISE NOTICE 'ACTUAL %s', summary_table_output;
 RAISE NOTICE 'EXPECTED %s', expected_json;
 SELECT throw_error('SUMMARY TABLE OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;