CREATE OR REPLACE FUNCTION res_ca_result_6_test_72_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
  success BOOLEAN DEFAULT FALSE;
  criteria_report_id INTEGER;
BEGIN
--REPORT#1
SELECT get_report_id_by_criteria_report_id(res_ca_create_result_6_criteria_report()) INTO criteria_report_id;
PERFORM res_common_result_6_rpt_health_plan_st_notes(criteria_report_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;