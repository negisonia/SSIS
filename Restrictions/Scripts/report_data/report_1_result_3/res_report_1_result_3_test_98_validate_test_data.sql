CREATE OR REPLACE FUNCTION res_report_1_result_3_test_98_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;
BEGIN
--REPORT#1
SELECT res_create_report_1_result_3_criteria_report() INTO criteria_report_id;
PERFORM res_common_report_1_result_3_rpt_summary_table_pharmacy(criteria_report_id);
PERFORM res_common_report_1_result_3_rpt_summary_table_medical(criteria_report_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;