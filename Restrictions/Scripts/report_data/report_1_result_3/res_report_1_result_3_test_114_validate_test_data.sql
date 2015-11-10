CREATE OR REPLACE FUNCTION res_report_1_result_3_test_114_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;
BEGIN

--CREATE CRITERIA REPORT
SELECT res_create_report_1_result_3_criteria_report() INTO criteria_report_id;
PERFORM res_report_1_result_3_geo_medical_drill(criteria_report_id);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;