CREATE OR REPLACE FUNCTION res_ca_report_1_result_4_test_60_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;
BEGIN

--CREATE CRITERIA REPORT
SELECT res_ca_create_report_1_result_4_criteria_report() INTO criteria_report_id;
PERFORM res_common_report_1_result_4_rpt_medical_document(criteria_report_id);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;