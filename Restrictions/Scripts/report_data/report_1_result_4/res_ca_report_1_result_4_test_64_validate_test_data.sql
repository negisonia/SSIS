CREATE OR REPLACE FUNCTION res_ca_report_1_result_4_test_64_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;
BEGIN

--CREATE CRITERIA REPORT
SELECT res_ca_create_report_1_result_4_criteria_report() INTO criteria_report_id;
PERFORM res_report_1_result_4_rpt_healthplan_type_medical(criteria_report_id);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;