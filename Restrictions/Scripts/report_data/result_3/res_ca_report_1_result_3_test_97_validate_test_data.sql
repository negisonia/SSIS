CREATE OR REPLACE FUNCTION res_ca_report_1_result_3_test_97_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
criteria_report_id INTEGER;
BEGIN
-- Create Criteria Report Id
SELECT res_ca_create_report_1_result_3_criteria_report() INTO criteria_report_id;
PERFORM res_common_report_1_result_3_rpt_geo_pharmacy(criteria_report_id);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;