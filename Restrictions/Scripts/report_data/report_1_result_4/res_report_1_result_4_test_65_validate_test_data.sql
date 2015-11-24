CREATE OR REPLACE FUNCTION res_report_1_result_4_test_65_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;
BEGIN

--CREATE CRITERIA REPORT
SELECT res_create_report_1_result_4_criteria_report() INTO criteria_report_id;
PERFORM res_common_report_1_result_4_rpt_health_plan_details(criteria_report_id);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;