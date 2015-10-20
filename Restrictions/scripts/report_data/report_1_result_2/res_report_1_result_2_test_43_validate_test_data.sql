CREATE OR REPLACE FUNCTION res_report_1_result_2_test_43_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;

BEGIN
--REPORT#1
SELECT res_create_report_1_result_2_criteria_report() INTO criteria_report_id;
PERFORM res_common_report_1_result_2_rpt_provider_notes(criteria_report_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;