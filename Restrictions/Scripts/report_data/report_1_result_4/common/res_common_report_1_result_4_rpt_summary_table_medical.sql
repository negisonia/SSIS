CREATE OR REPLACE FUNCTION res_common_report_1_result_4_rpt_summary_table_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_medical_summary_table_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_medical_summary_table_output= format('%1$s',report_id);

PERFORM res_rpt_summary_table_validate_data(report_id,expected_medical_summary_table_output,medical_view);

success=true;
return success;
END
$$ LANGUAGE plpgsql;