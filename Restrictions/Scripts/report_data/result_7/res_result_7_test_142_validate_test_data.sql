CREATE OR REPLACE FUNCTION res_result_7_test_142_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
  success BOOLEAN DEFAULT FALSE;
  criteria_report_id INTEGER;
BEGIN
--REPORT#1
SELECT res_create_result_7_criteria_report() INTO criteria_report_id;
PERFORM res_common_result_7_rpt_provider_details_pa(criteria_report_id);
PERFORM res_common_result_7_rpt_provider_details_medical(criteria_report_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;