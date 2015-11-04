CREATE OR REPLACE FUNCTION res_common_report_1_result_3_rpt_summary_table_pharmacy(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
pharmacy_view CONSTANT integer:=1;
expected_pharmacy_summary_table_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_pharmacy_summary_table_output= format('',report_id);
PERFORM res_rpt_summary_table_validate_data(report_id,expected_pharmacy_summary_table_output,pharmacy_view);

success=true;
return success;
END
$$ LANGUAGE plpgsql;