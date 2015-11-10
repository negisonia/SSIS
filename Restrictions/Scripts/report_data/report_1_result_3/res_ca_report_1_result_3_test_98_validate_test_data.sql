CREATE OR REPLACE FUNCTION res_ca_report_1_result_3_test_98_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;
BEGIN
-- Create Criteria Report Id
SELECT res_ca_create_report_1_result_3_criteria_report() INTO criteria_report_id;
PERFORM res_report_1_result_3_geo_pharmacy_drill(criteria_report_id);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;